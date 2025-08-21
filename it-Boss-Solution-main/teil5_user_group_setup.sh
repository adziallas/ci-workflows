#!/bin/bash
# Erstellt einen neuen Datei mit dem Namen "user und gruppen und speichert sie in das Verzeichnis "/mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution
# Erstellt Benutzer und Gruppen für Zugriffskontrolle

mkdir -p /mnt/c/Users/User/Kurs/andrea/IT-Boss-Solution/user_and_group_setup
echo ">>> Benutzer und Gruppen werden erstellt..."

sudo groupadd webgroup                          # hier erstelle ich die Gruppe 
sudo useradd -m -G webgroup webadmin            # hier erstelle ich zwei Benutzer 
sudo useradd -m -G webgroup webuser             # die beide Mitglieder der Gruppe sind 
                                                # # hier vergebe ich die Besitz und Zugrifsrechte webadmin die lese, schreib und ausführungsrechte auf das Verzeichnis
sudo chown -R webadmin:webgroup /var/www/html   # Gruppe (inkl. webuser) darf lesen und ausführen
sudo chmod -R 750 "/mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/user_and_group_setup"    # nur Gruppe darf Schreiben
sudo chmod +x "/mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/user_and_group_setup

echo "Zugriffsrechte gesetzt: webadmin (Schreibzugriff), webuser (Leserechte über Gruppe)."
