from app.app import app


def test_homepage():
    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    assert b"Department Information Service" in response.data
    assert b"support@example.com" in response.data
    assert b"Application Version:</strong> 1.1.0" in response.data


def test_health():
    client = app.test_client()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "healthy"
    assert response.json["version"] == "1.1.0"


def test_info():
    client = app.test_client()
    response = client.get("/info")

    assert response.status_code == 200
    assert response.json["status"] == "operational"
    assert response.json["version"] == "1.1.0"
    assert response.json["app_name"] == "Department Information Portal"
    assert response.json["environment"] == "production"
    assert response.json["support_contact"] == "support@example.com"
    assert isinstance(response.json["uptime_seconds"], int)
    assert response.json["uptime_seconds"] >= 0


def test_unknown_page():
    client = app.test_client()
    response = client.get("/unknown")

    assert response.status_code == 404


def test_method_not_allowed():
    client = app.test_client()
    response = client.post("/health")

    assert response.status_code == 405
