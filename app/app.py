import datetime
import os
from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = "1.1.0"
START_TIME = datetime.datetime.now(datetime.timezone.utc)

APP_NAME = os.getenv("APP_NAME", "Department Information Portal")
APP_ENV = os.getenv("APP_ENV", "production")
SUPPORT_EMAIL = os.getenv("SUPPORT_EMAIL", "support@example.com")
WORKING_HOURS = os.getenv(
    "WORKING_HOURS", "Sunday - Thursday, 08:00 - 17:00"
)


@app.route("/")
def home():
    return f"""
    <h1>Department Information Service</h1>

    <h2>Service Information</h2>

    <p><strong>Service:</strong> {APP_NAME}</p>
    <p><strong>Support:</strong> {SUPPORT_EMAIL}</p>
    <p><strong>Working Hours:</strong> {WORKING_HOURS}</p>
    <p><strong>Application Version:</strong> {APP_VERSION}</p>
    <p><strong>Status:</strong> Running</p>
    """


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "version": APP_VERSION
    }), 200


@app.route("/info")
def info():
    now = datetime.datetime.now(datetime.timezone.utc)
    uptime_seconds = int((now - START_TIME).total_seconds())
    return jsonify({
        "app_name": APP_NAME,
        "environment": APP_ENV,
        "status": "operational",
        "support_contact": SUPPORT_EMAIL,
        "uptime_seconds": uptime_seconds,
        "version": APP_VERSION
    }), 200


if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
