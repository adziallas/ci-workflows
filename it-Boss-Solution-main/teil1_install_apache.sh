#!/bin/bash

# 1. Installation des Apache-Webservers
echo "Installiere Apache-Webserver..."
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y apache2
elif command -v yum &> /dev/null; then
    sudo yum install -y httpd
else
    echo "Kein unterstütztes Paketmanagement-Tool gefunden. Bitte installieren Sie Apache manuell."
    exit 1
fi

# 2. Starten und Aktivieren des Webservers
echo "Starte und aktiviere den Apache-Webserver..."
if command -v systemctl &> /dev/null; then
    # Prüfe, ob ein anderer Webserver auf Port 80 läuft
    if sudo lsof -i :80 | grep -v apache2 | grep -v httpd > /dev/null; then
        echo "Warnung: Ein anderer Dienst nutzt bereits Port 80. Stoppe diesen Dienst..."
        if systemctl is-active --quiet nginx; then
            sudo systemctl stop nginx
            sudo systemctl disable nginx
        fi
    fi

    # Starte und aktiviere den Apache-Dienst je nach Distribution
    if systemctl list-unit-files | grep -q apache2; then
        sudo systemctl restart apache2
        sudo systemctl enable apache2
    elif systemctl list-unit-files | grep -q httpd; then
        sudo systemctl restart httpd
        sudo systemctl enable httpd
    fi

    # ----- Teil 1.3: Bereitstellung der Webseite -----
    WEB_DIR="/var/www/html"
    HTML_SRC="/mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/index.html"
    CSS_SRC="/mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/style.css"
    sudo mkdir -p "$WEB_DIR"

    echo "Kopiere HTML-Datei..."
    if [ -f "$HTML_SRC" ]; then
        sudo cp "$HTML_SRC" "$WEB_DIR/"
        echo "HTML-Datei erfolgreich kopiert."
    else
        echo "Fehler: HTML-Quelldatei nicht gefunden: $HTML_SRC"
        exit 1
    fi

    echo "Kopiere CSS-Datei..."
    if [ -f "$CSS_SRC" ]; then
        sudo cp "$CSS_SRC" "$WEB_DIR/"
        echo "CSS-Datei erfolgreich kopiert."
    else
        echo "Fehler: CSS-Quelldatei nicht gefunden: $CSS_SRC"
        exit 1
    fi

    sudo chmod 644 "$WEB_DIR/index.html"
    sudo chmod 644 "$WEB_DIR/style.css"
    sudo chown www-data:www-data "$WEB_DIR/index.html"
    sudo chown www-data:www-data "$WEB_DIR/style.css"

    echo "Überprüfe, ob der Apache-Webserver läuft..."
    if systemctl is-active --quiet apache2 || systemctl is-active --quiet httpd; then
        echo "Der Apache-Webserver läuft erfolgreich."
        echo "Überprüfe, ob die Webseite erreichbar ist..."
        sleep 2
        if curl -s http://localhost > /dev/null; then
            echo "Die Webseite ist erreichbar. Rufen Sie die Webseite unter http://localhost im Webbrowser auf."
        else
            echo "Warnung: Die Webseite scheint nicht erreichbar zu sein. Überprüfen Sie die Apache-Konfiguration."
            echo "Versuchen Sie, den Apache-Dienst manuell neu zu starten: sudo systemctl restart apache2"
        fi
    else
        echo "Fehler: Der Apache-Webserver läuft nicht oder konnte nicht gestartet werden."
        echo "Überprüfen Sie die Apache-Logs mit: sudo journalctl -u apache2"
        exit 1
    fi
else
    echo "Fehler: systemctl nicht gefunden. Der Apache-Webserver konnte nicht gestartet werden."
    exit 1
fi