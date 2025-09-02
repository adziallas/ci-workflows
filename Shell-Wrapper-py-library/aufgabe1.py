import sh

# 1. Erstelle eine Textdatei
sh.touch('test.txt')

# 2. Füge Text zur Datei hinzu
sh.echo('Dies ist eine Testdatei.') > "test.txt"

# 3. Zeige den Inhalt der Datei an
content = sh.cat('test.txt')
print(content)
