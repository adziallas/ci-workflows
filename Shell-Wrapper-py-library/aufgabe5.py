import sh

filename = 'sample.txt'

try:
    # Versuche, die Datei zu löschen
    sh.rm(filename)
except sh.ErrorReturnCode as e:
    # Ausgabe eines Fehlerhinweises, wenn die Datei nicht existiert
    print(f"Fehler: {filename} existiert nicht. Ausnahme: {e}")
