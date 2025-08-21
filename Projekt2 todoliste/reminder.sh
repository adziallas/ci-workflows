#!/bin/bash

# --- Konfiguration ---
# Pfad zum Datenverzeichnis relativ zum Skript
DATA_DIR="$(dirname "$0")/data" 
TASKS_FILE="$DATA_DIR/tasks.txt"
REMINDER_THRESHOLD_MINUTES=10 # Erinnerung 10 Minuten vor dem Termin
LOG_FILE="/tmp/task_reminder.log" # Log-Datei für Cron-Ausgaben

# --- Farben (für Konsolenausgabe, falls manuell ausgeführt) ---
YELLOW='\033[0;33m'
NC='\033[0m' # Keine Farbe

# --- Sicherstellen, dass die Aufgaben-Datei existiert ---
if [[ ! -f "$TASKS_FILE" ]]; then
    echo "$(date): Fehler: Aufgaben-Datei nicht gefunden unter $TASKS_FILE" >> "$LOG_FILE"
    exit 1
fi

# Funktion zum Senden einer Desktop-Benachrichtigung (falls 'notify-send' verfügbar ist)
send_notification() {
    local title="$1"
    local message="$2"
    if command -v notify-send &> /dev/null; then
        # 'notify-send' ist ein gängiges Tool für Desktop-Benachrichtigungen unter Linux
        notify-send -i appointment "$title" "$message"
        echo "$(date): Benachrichtigung gesendet: $title - $message" >> "$LOG_FILE"
    else
        # Fallback für Systeme ohne 'notify-send' (z.B. Server, oder einfach Ausgabe auf stderr)
        echo -e "${YELLOW}$(date): Erinnerung: $title - $message${NC}" >&2
        echo "$(date): notify-send nicht gefunden, Ausgabe auf stderr: $title - $message" >> "$LOG_FILE"
    fi
}

# Aktuelle Zeit in Sekunden seit der Epoche
current_time_epoch=$(date +%s)

# Aufgaben lesen und auf Erinnerungen prüfen
while IFS='|' read -r id status creator datetime description; do
    # Nur offene oder verschobene Termine prüfen
    if [[ "$status" == "OPEN" || "$status" == "POSTPONED" ]]; then
        # Termin-Datum und -Uhrzeit in Sekunden seit der Epoche umwandeln
        # 'date -d' ist sehr nützlich für die Datumsberechnung
        task_time_epoch=$(date -d "$datetime" +%s 2>/dev/null)

        if [[ -z "$task_time_epoch" ]]; then
            echo "$(date): Warnung: Datum/Uhrzeit '$datetime' für Termin ID $id konnte nicht geparst werden. Überspringe." >> "$LOG_FILE"
            continue
        fi

        # Zeitdifferenz in Sekunden berechnen
        time_diff_seconds=$((task_time_epoch - current_time_epoch))
        time_diff_minutes=$((time_diff_seconds / 60))

        # Prüfen, ob der Termin innerhalb des Erinnerungsschwellenwerts liegt und in der Zukunft ist
        if [[ "$time_diff_minutes" -gt 0 && "$time_diff_minutes" -le "$REMINDER_THRESHOLD_MINUTES" ]]; then
            send_notification "Termin Erinnerung!" "In $time_diff_minutes Min: $description (ID: $id) um $datetime"
        fi
    fi
done < "$TASKS_FILE"

exit 0
