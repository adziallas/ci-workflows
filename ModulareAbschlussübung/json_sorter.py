import json

# Lade die Daten aus data.json
with open('data.json', 'r') as file:
    data = json.load(file)

# Sortiere die Daten nach dem Feld "name"
sorted_data = sorted(data, key=lambda x: x['name'])

# Speichere das Ergebnis in sorted.json
with open('sorted.json', 'w') as file:
    json.dump(sorted_data, file, indent=4)

print("Daten sortiert und in sorted.json gespeichert.")
