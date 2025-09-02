import sh

# 1. Erstelle ein Verzeichnis
sh.mkdir('complex_operations')

# 2. Erstelle mehrere Textdateien
sh.echo('Inhalt der Datei 1.') > 'complex_operations/file1.txt'
sh.echo('Inhalt der Datei 2.') > 'complex_operations/file2.txt'

# 3. Kombiniere die Inhalte und leite sie um
sh.cat('complex_operations/file1.txt', 'complex_operations/file2.txt') > 'complex_operations/combined.txt'

# 4. Zeige den Inhalt von combined.txt an
combined_content = sh.cat('complex_operations/combined.txt')
print(combined_content)
