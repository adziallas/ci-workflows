#!/bin/bash

# Log-Verzeichnis und Log-Datei definieren
LOG_DIR="/mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/var/log"
LOG_FILE="$LOG_DIR/teil7_log_script.log"

# Erstelle den Log-Ordner, falls er noch nicht existiert
mkdir -p "$LOG_DIR"

# Funktion zum Protokollieren von Aktivitäten
log_activity() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Beispielprotokollierung
log_activity "Server gestartet."
log_activity "Backup erstellt."

# Fehlerprotokollierung Beispiel
if command -v systemctl &> /dev/null; then
    if ! systemctl status apache2 | grep -q 'running'; then
        log_activity "Fehler: Der Webserver läuft nicht."
    fi
else
    log_activity "Hinweis: systemctl ist nicht verfügbar."
fi

# Letzte 5 Logeinträge anzeigen
echo "Letzte 5 Logeinträge:"
tail -n 5 "$LOG_FILE"