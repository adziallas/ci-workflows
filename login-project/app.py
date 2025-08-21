import yaml
import os

def load_credentials():
    if not os.path.exists("secrets.yaml"):
        print("Fehler: secrets.yaml nicht gefunden!")
        return {}
    try:
        with open("secrets.yaml", "r") as file:
            return yaml.safe_load(file) or {}
    except Exception as e:
        print(f"Fehler beim Laden der secrets.yaml: {e}")
        return {}

def login(username, password):
    credentials = load_credentials()
    return (
        username == credentials.get("username") and
        password == credentials.get("password")
    )

if __name__ == "__main__":
    user = input("Username: ")
    pwd = input("Password: ")
    if login(user, pwd):
        print("Login erfolgreich!")
    else:
        print("Login fehlgeschlagen.")