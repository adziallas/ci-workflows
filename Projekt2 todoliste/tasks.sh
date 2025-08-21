#!/bin/bash

# --- Konfiguration ---
DATA_DIR="data"
TASKS_FILE="$DATA_DIR/tasks.txt"

# --- Farben und Formatierung für die Kommandozeile ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Keine Farbe
STRIKETHROUGH='\033[9m' # Durchstreichen
RESET_STRIKETHROUGH='\033[29m' # Durchstreichen zurücksetzen (nicht immer vollständig unterstützt, NC ist sicherer)

# --- Sicherstellen, dass der Datenordner und die Datei existieren ---
mkdir -p "$DATA_DIR"
touch "$TASKS_FILE"

# --- Hilfsfunktionen ---

# Funktion zum Generieren einer eindeutigen ID (basierend auf Zeitstempel)
generate_id() {
    date +%s%N # Sekunden seit Epoch + Nanosekunden für hohe Einzigartigkeit
}

# Funktion zum Abrufen des aktuellen Benutzernamens
get_creator() {
    whoami
}

# Funktion zur Validierung des Datums- und Zeitformats (YYYY-MM-DD HH:MM)
validate_datetime() {
    local datetime_str="$1"
    # Regex für YYYY-MM-DD HH:MM
    if [[ "$datetime_str" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
        # Eine robustere Validierung könnte 'date -d "$datetime_str" >/dev/null 2>&1' verwenden,
        # um zu prüfen, ob das Datum gültig ist (z.B. 30. Februar).
        # Für diese einfache Implementierung reicht die Formatprüfung.
        return 0 # Gültig
    else
        return 1 # Ungültig
    fi
}

# --- Kernfunktionen ---

# Funktion: Neuen Termin hinzufügen
add_task() {
    echo -e "${CYAN}--- Neuen Termin hinzufügen ---${NC}"
    read -p "Beschreibung des Termins: " description
    if [[ -z "$description" ]]; then
        echo -e "${RED}Fehler: Beschreibung darf nicht leer sein.${NC}"
        return 1
    fi

    local datetime_input
    while true; do
        read -p "Datum und Uhrzeit (YYYY-MM-DD HH:MM): " datetime_input
        if validate_datetime "$datetime_input"; then
            break
        else
            echo -e "${RED}Ungültiges Format. Bitte verwenden Sie YYYY-MM-DD HH:MM.${NC}"
        fi
    done

    local id=$(generate_id)
    local creator=$(get_creator)
    local status="OPEN" # Standardstatus

    # Speichern im Format: ID|STATUS|ERSTELLER|DATUM_UHRZEIT|BESCHREIBUNG
    echo "$id|$status|$creator|$datetime_input|$description" >> "$TASKS_FILE"
    echo -e "${GREEN}Termin erfolgreich hinzugefügt (ID: $id).${NC}"
}

# Funktion: Alle Termine anzeigen (Dashboard)
list_tasks() {
    echo -e "${CYAN}--- Ihre Termine (Dashboard) ---${NC}"
    if [[ ! -s "$TASKS_FILE" ]]; then
        echo -e "${YELLOW}Keine Termine vorhanden.${NC}"
        return 0
    fi

    # Header für die Tabelle
    printf "%-15s %-12s %-15s %-18s %s\n" "ID" "Status" "Ersteller" "Datum/Uhrzeit" "Beschreibung"
    printf "%s\n" "---------------------------------------------------------------------------------------------------"

    # Lesen und Formatieren der Aufgaben
    while IFS='|' read -r id status creator datetime description; do
        local display_description="$description"
        local display_status="$status"
        local color="$NC"
        local strike=""

        case "$status" in
            "DONE")
                color="$GREEN"
                strike="$STRIKETHROUGH"
                display_status="✔ Erledigt" # Grüner Haken
                ;;
            "OPEN")
                color="$BLUE"
                display_status="Offen"
                ;;
            "POSTPONED")
                color="$YELLOW"
                display_status="Verschoben"
                ;;
            *)
                color="$NC" # Standard
                ;;
        esac
        
        # Ausgabe der formatierten Zeile
        echo -e "${color}${strike}$(printf "%-15s %-12s %-15s %-18s %s" "$id" "$display_status" "$creator" "$datetime" "$display_description")${RESET_STRIKETHROUGH}${NC}"
    done < "$TASKS_FILE"
    echo -e "${CYAN}---------------------------------------------------------------------------------------------------${NC}"
}

# Funktion: Termin löschen (nur Ersteller)
delete_task() {
    echo -e "${CYAN}--- Termin löschen ---${NC}"
    read -p "ID des zu löschenden Termins: " task_id
    if [[ -z "$task_id" ]]; then
        echo -e "${RED}Fehler: ID darf nicht leer sein.${NC}"
        return 1
    fi

    local temp_file=$(mktemp) # Temporäre Datei für die neuen Daten
    local found=0
    local deleted=0
    local current_user=$(get_creator)

    while IFS='|' read -r id status creator datetime description; do
        if [[ "$id" == "$task_id" ]]; then
            found=1
            if [[ "$creator" == "$current_user" ]]; then
                echo -e "${GREEN}Termin (ID: $id) von $creator erfolgreich gelöscht.${NC}"
                deleted=1
            else
                echo -e "${RED}Fehler: Sie sind nicht der Ersteller dieses Termins (Ersteller: $creator). Löschen nicht erlaubt.${NC}"
                echo "$id|$status|$creator|$datetime|$description" >> "$temp_file" # Zeile beibehalten
            fi
        else
            echo "$id|$status|$creator|$datetime|$description" >> "$temp_file"
        fi
    done < "$TASKS_FILE"

    if [[ "$found" -eq 0 ]]; then
        echo -e "${RED}Fehler: Termin mit ID '$task_id' nicht gefunden.${NC}"
        rm "$temp_file" # Temporäre Datei aufräumen
    elif [[ "$deleted" -eq 1 ]]; then
        mv "$temp_file" "$TASKS_FILE" # Originaldatei mit der neuen überschreiben
    else
        rm "$temp_file" # Temporäre Datei aufräumen, wenn nichts gelöscht wurde
    fi
}

# Funktion: Termin als 'Erledigt' markieren
mark_done() {
    echo -e "${CYAN}--- Termin als 'Erledigt' markieren ---${NC}"
    read -p "ID des zu markierenden Termins: " task_id
    if [[ -z "$task_id" ]]; then
        echo -e "${RED}Fehler: ID darf nicht leer sein.${NC}"
        return 1
    fi

    local temp_file=$(mktemp)
    local found=0

    while IFS='|' read -r id status creator datetime description; do
        if [[ "$id" == "$task_id" ]]; then
            found=1
            if [[ "$status" == "DONE" ]]; then
                echo -e "${YELLOW}Termin (ID: $id) ist bereits als 'Erledigt' markiert.${NC}"
                echo "$id|$status|$creator|$datetime|$description" >> "$temp_file"
            else
                echo "$id|DONE|$creator|$datetime|$description" >> "$temp_file"
                echo -e "${GREEN}Termin (ID: $id) als 'Erledigt' markiert.${NC}"
            fi
        else
            echo "$id|$status|$creator|$datetime|$description" >> "$temp_file"
        fi
    done < "$TASKS_FILE"

    if [[ "$found" -eq 0 ]]; then
        echo -e "${RED}Fehler: Termin mit ID '$task_id' nicht gefunden.${NC}"
        rm "$temp_file"
    else
        mv "$temp_file" "$TASKS_FILE"
    fi
}

# Funktion: Termin verschieben
postpone_task() {
    echo -e "${CYAN}--- Termin verschieben ---${NC}"
    read -p "ID des zu verschiebenden Termins: " task_id
    if [[ -z "$task_id" ]]; then
        echo -e "${RED}Fehler: ID darf nicht leer sein.${NC}"
        return 1
    fi

    local temp_file=$(mktemp)
    local found=0
    local new_datetime_input

    while IFS='|' read -r id status creator old_datetime description; do
        if [[ "$id" == "$task_id" ]]; then
            found=1
            echo -e "${YELLOW}Aktuelles Datum/Uhrzeit für Termin (ID: $id): $old_datetime${NC}"
            while true; do
                read -p "Neues Datum und Uhrzeit (YYYY-MM-DD HH:MM): " new_datetime_input
                if validate_datetime "$new_datetime_input"; then
                    break
                else
                    echo -e "${RED}Ungültiges Format. Bitte verwenden Sie YYYY-MM-DD HH:MM.${NC}"
                fi
            done
            # Status auf POSTPONED setzen, wenn verschoben
            echo "$id|POSTPONED|$creator|$new_datetime_input|$description" >> "$temp_file"
            echo -e "${GREEN}Termin (ID: $id) erfolgreich auf '$new_datetime_input' verschoben.${NC}"
        else
            echo "$id|$status|$creator|$old_datetime|$description" >> "$temp_file"
        fi
    done < "$TASKS_FILE"

    if [[ "$found" -eq 0 ]]; then
        echo -e "${RED}Fehler: Termin mit ID '$task_id' nicht gefunden.${NC}"
        rm "$temp_file"
    else
        mv "$temp_file" "$TASKS_FILE"
    fi
}

# Funktion: Hilfe anzeigen
show_help() {
    echo -e "${BLUE}Verwendung: $0 [Option]${NC}"
    echo -e "${BLUE}Optionen:${NC}"
    echo -e "  ${GREEN}add${NC}       : Neuen Termin hinzufügen (Text eingabe)"
    echo -e "  ${GREEN}list${NC}      : Alle Termine anzeigen (Dashboard)"
    echo -e "  ${GREEN}delete${NC}    : Termin löschen (Mülleimer - nur Ersteller)"
    echo -e "  ${GREEN}done${NC}      : Termin als 'Erledigt' markieren (Durchstreichen und grüner Haken)"
    echo -e "  ${GREEN}postpone${NC}  : Termin verschieben (Neues Datum/Uhrzeit)"
    echo -e "  ${GREEN}help${NC}      : Diese Hilfe anzeigen"
    echo ""
    echo -e "${YELLOW}Hinweis zur Web-Zugänglichkeit (Dashboard):${NC}"
    echo -e "  Dieses Skript ist primär für die Kommandozeile konzipiert."
    echo -e "  Um es über das Internet aufrufbar zu machen (z.B. als Dashboard),"
    echo -e "  könnte es als CGI-Skript auf einem Webserver (Apache, Nginx) ausgeführt werden."
    echo -e "  Dazu müsste die 'list' Funktion HTML ausgeben und der Webserver entsprechend konfiguriert sein."
    echo -e "  Die interaktiven Funktionen (add, delete, etc.) wären dann über Webformulare zu realisieren."
    echo ""
    echo -e "${YELLOW}Hinweis zur Erinnerungsfunktion:${NC}"
    echo -e "  Eine separate Datei 'reminder.sh' ist für die Erinnerungen vorgesehen."
    echo -e "  Diese sollte über einen Cronjob regelmäßig ausgeführt werden, z.B. alle 5 Minuten:"
    echo -e "  ${CYAN}crontab -e${NC}"
    echo -e "  ${CYAN}*/5 * * * * /path/to/your/task_manager/reminder.sh >> /tmp/reminder.log 2>&1${NC}"
}

# --- Hauptlogik (Argumente verarbeiten) ---
case "$1" in
    "add")
        add_task
        ;;
    "list")
        list_tasks
        ;;
    "delete")
        delete_task
        ;;
    "done")
        mark_done
        ;;
    "postpone")
        postpone_task
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}Ungültige Option: '$1'${NC}"
        show_help
        exit 1
        ;;
esac

exit 0
