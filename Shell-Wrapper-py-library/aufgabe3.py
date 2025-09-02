import sh

# 1. Erstelle ein Verzeichnis
sh.mkdir('multi_commands')

# 2. Füge die erste Datei hinzu
sh.echo('Datei 1') > 'multi_commands/file1.txt'

# 3. Füge die zweite Datei hinzu
sh.echo('Datei 2') > 'multi_commands/file2.txt'

# 4. Liste alle Dateien im Verzeichnis auf und gib aus
files = sh.ls('multi_commands')
print(files)
