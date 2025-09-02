#!/bin/bash

# Verzeichnisse definieren
SOURCE_DIR="./data"
BACKUP_DIR="./backups"

# Aktuelles Datum im Format YYYY-MM-DD
TIMESTAMP=$(date +"%Y-%m-%d")

# Erstelle das Backup-Archiv
zip "${BACKUP_DIR}/backup_${TIMESTAMP}.zip" -r "${SOURCE_DIR}"

echo "Backup erstellt: ${BACKUP_DIR}/backup_${TIMESTAMP}.zip"
