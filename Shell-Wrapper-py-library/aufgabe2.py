import sh

# 1. Erstelle ein Verzeichnis
sh.mkdir('test_directory')

# 2. Erstelle eine Datei und füge Text hinzu
sh.echo('Das ist die Datei, die verschoben werden soll.') > 'file_to_move.txt'

# 3. Verschiebe die Datei in das Verzeichnis
sh.mv('file_to_move.txt', 'test_directory/')
