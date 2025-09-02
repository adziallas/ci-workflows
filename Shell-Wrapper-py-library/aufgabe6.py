import sh

# 1. Erstelle die Datei
sh.touch('test.txt')

# 2. Schreibe in die Datei
sh.echo('Dies ist eine einfache Textdatei.') > 'test.txt'

# 3. Lies die Datei und zeige den Inhalt an
test_content = sh.cat('test.txt')
print(test_content)
