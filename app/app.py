from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = "1.1.0"


@app.route("/")
def home():
    return f"""
    <h1>Department Information Service</h1>

    <h2>Service Information</h2>

    <p><strong>Service:</strong> Department Information Portal</p>
    <p><strong>Support:</strong> support@example.com</p>
    <p><strong>Working Hours:</strong> Sunday - Thursday, 08:00 - 17:00</p>
    <p><strong>Application Version:</strong> {APP_VERSION}</p>
    <p><strong>Status:</strong> Running</p>
    """


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "version": APP_VERSION
    }), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
