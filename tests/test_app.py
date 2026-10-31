from app.app import app


def test_homepage():
    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    assert b"Department Information Service" in response.data
    assert b"support@example.com" in response.data


def test_health():
    client = app.test_client()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "healthy"
    assert response.json["version"] == "1.0.0"


def test_unknown_page():
    client = app.test_client()
    response = client.get("/unknown")

    assert response.status_code == 404
