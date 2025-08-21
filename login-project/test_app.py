from app import login

def test_login_success(monkeypatch):
    monkeypatch.setattr("app.load_credentials", lambda: {"username": "myusername", "password": "mypassword"})
    assert login("myusername", "mypassword") is True

def test_login_failure(monkeypatch):
    monkeypatch.setattr("app.load_credentials", lambda: {"username": "myusername", "password": "mypassword"})
    assert login("myusername", "wrongpassword") is False