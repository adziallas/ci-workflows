#!/bin/bash
# Erstellt einen neuen Ordner im Verzeichnis "/mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution" mit dem Namen "/var/www/html/backups".
# Speichert den aktuellen Inhalt von "/var/www/html" als komprimiertes Archiv im neu erstellten Ordner.

BACKUP_DIR="/mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/var/www/html/backups"  # Pfad zum Backup-Verzeichnis
BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S).tar.gz"  # erstellt einen eindeutigen Dateinamen mit aktuellem Datum und Uhrzeit

echo ">>> Backup wird erstellt..."

sudo mkdir -p "$BACKUP_DIR"  # hier wird das Backup-Verzeichnis angelegt, falls es nicht vorhanden ist.
sudo tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C /var/www/html .  # hier wird die komprimierte Archive erstellt.

echo "Backup gespeichert unter: $BACKUP_DIR/$BACKUP_NAME"