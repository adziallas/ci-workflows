#!/bin/bash
# Erstellt einen neuen Ordner im Verzeichnis "/mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution" mit dem namen "/var/www/html"
# Kopiert index.html und style.css in das neue Verzeichnis

mkdir -p "/mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution/var/www/html"  # erstellt das Zielverzeichnis, falls es nicht existiert
SOURCE_DIR="/mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution"  # Pfad zum Quellverzeichnis
TARGET_DIR="/mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution/var/www/html"   # Pfad zum Zielverzeichnis

echo ">>> Webseite wird bereitgestellt..."

sudo cp "$SOURCE_DIR/index.html" "$TARGET_DIR/"        # kopiert die Html Datei vom Windows-Verzeichnis ins Apache-Webverzeichnis
sudo cp "$SOURCE_DIR/style.css" "$TARGET_DIR/"         # kopiert die CSS Datei vom Windows-Verzeichnis ins Apache-Webverzeichnis

echo "Dateien erfolgreich nach $TARGET_DIR kopiert."

exit 0
# Starte den Apache-Server neu, um die Änderungen zu übernehmen.
   sudo systemctl restart apache2.service
   echo ">>> Apache wurde erfolgreich neu gestartet."
   echo ">>> Die Webseite sollte jetzt unter http://localhost:80 oder http://<IP-Adresse>:80 verfügbar sein."
   exit 0

