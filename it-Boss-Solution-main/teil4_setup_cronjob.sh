#!/bin/bash
# Cronjob um tägliches Backup um 06:00 Uhr einzurichten

CRON_JOB="0 6 * * * /mnt/c/Users/Dzial/Projekte Andrea/it-Boss-Solution-main/teil4_setup_cronjob.sh" # hier wird der Cronjob automatisch eingerichtet das er 
echo ">>> Cronjob wird eingerichtet..."                                                    # täglich um 6 Uhr das Script ausführt

( crontab -l 2>/dev/null; echo "$CRON_JOB" ) | crontab -                                # hier füge ich den Job in crontab dem aktuellen benutzers ein.

echo "Cronjob hinzugefügt."