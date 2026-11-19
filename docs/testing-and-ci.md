# Application Testing and CI/CD Pipeline Guide

## 1. Introduction

Application testing is a critical DevOps practice that ensures software behaves reliably, predictably, and securely before it is deployed to production. In the Department Information Service project, automated testing validates that core service information is properly displayed, operational endpoints respond accurately, and edge cases or invalid requests are handled gracefully.

Automating these checks in a continuous delivery pipeline eliminates manual testing errors, prevents regressions when new features are added, and provides immediate feedback to developers during peer review.

---

## 2. Pytest

The project uses **Pytest** as its primary testing framework. Pytest is a mature, extensible Python testing tool that allows developers to write simple unit tests as well as complex functional tests.

### Key Advantages of Pytest:
- **Zero Boilerplate:** Uses standard Python `assert` statements rather than cumbersome assertion methods.
- **Detailed Failure Reports:** Clearly pinpoints differences between expected and actual values when assertions fail.
- **Flask Test Client Integration:** Seamlessly integrates with Flask's built-in `app.test_client()` to simulate HTTP requests without running an external HTTP server.

---

## 3. Test Cases

The application test suite is located in `tests/test_app.py` and contains five distinct test functions covering positive, operational, negative, and edge-case scenarios:

### Test Case Summary Table

| Test Function | Target Route | Expected HTTP Status | Validation Criteria |
|---|---|---|---|
| `test_homepage` | `GET /` | `200 OK` | Verifies service title, support email, and version string in rendered HTML. |
| `test_health` | `GET /health` | `200 OK` | Validates JSON keys: `"status": "healthy"` and `"version": "1.1.0"`. |
| `test_info` | `GET /info` | `200 OK` | Validates metadata (`app_name`, `environment`, `support_contact`, `version`) and integer `uptime_seconds >= 0`. |
| `test_unknown_page` | `GET /unknown` | `404 Not Found` | Verifies that unmapped routes return proper 404 status codes without leaking stack traces. |
| `test_method_not_allowed` | `POST /health` | `405 Method Not Allowed` | Validates that sending an unsupported HTTP method (`POST`) to a read-only endpoint is safely rejected. |

### Test Code Overview (`tests/test_app.py`)

```python
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
```

---

## 4. Running Tests

To run the automated tests locally:

1. **Activate the project virtual environment:**
   ```bash
   source .venv/bin/activate
   ```

2. **Ensure dependencies are installed:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Execute Pytest in verbose mode:**
   ```bash
   python -m pytest -v
   ```

### Expected Output:
```text
============================= test session starts =============================
platform ... pytest-8.4.2 ...
collected 5 items

tests/test_app.py::test_homepage PASSED                                  [ 20%]
tests/test_app.py::test_health PASSED                                    [ 40%]
tests/test_app.py::test_info PASSED                                      [ 60%]
tests/test_app.py::test_unknown_page PASSED                              [ 80%]
tests/test_app.py::test_method_not_allowed PASSED                        [100%]

============================== 5 passed in 0.16s ==============================
```

---

## 5. Flake8

**Flake8** is a static code-analysis tool for Python. Unlike Pytest, which executes code dynamically, Flake8 parses source code without running it to detect:
- **PEP 8 Compliance:** Enforces consistent indentation, spacing, and maximum line length (79 characters).
- **Syntax and Logic Errors:** Flags undefined variables, unimported functions, or shadowed variable names.
- **Dead Code:** Identifies unused imports or variables to keep the codebase clean and lean.

### Running Flake8 locally:
```bash
flake8 app tests
# Or:
python -m flake8 app tests
```

If no output is returned and the command exits with code `0`, the code fully complies with the project's quality standard.

---

## 6. GitHub Actions

The project uses **GitHub Actions** to implement Continuous Integration (CI). GitHub Actions is an automation platform built directly into GitHub that executes workflows in response to repository events.

The workflow definition is stored in:
`.github/workflows/ci.yml`

### Purpose of the CI Pipeline:
- Automatically validates every proposed change before it can be merged into `main`.
- Enforces consistent execution across an isolated, clean Ubuntu container.
- Acts as a gatekeeper: builds and saves Docker artifacts only when all tests and lint checks pass.

---

## 7. Workflow Triggers

The workflow triggers automatically on two specific events:

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

1. **`pull_request` on `main`:** Runs all verification stages when a contributor opens or updates a Pull Request. Teammates review the CI status directly in the GitHub PR interface before approving.
2. **`push` on `main`:** Runs all stages after a Pull Request is merged into the `main` branch, ensuring that the merged state remains functional and generating a production-ready artifact.

---

## 8. Automated Testing

The pipeline runs on `ubuntu-latest` and executes automated testing through eight sequential steps:

1. **Checkout source code:** Uses `actions/checkout@v4` to retrieve repository files at the target Git commit.
2. **Set up Python:** Uses `actions/setup-python@v5` configured with Python `3.14`.
3. **Install dependencies:** Upgrades `pip` and installs packages from `requirements.txt`.
4. **Run application tests:** Executes `python -m pytest -v`. If any test fails, the job terminates immediately with an error.
5. **Check code quality:** Executes `flake8 app tests`. If any style or syntax error exists, execution halts.

---

## 9. Docker Build

Only after automated testing and Flake8 pass successfully does the pipeline advance to the containerization stage:

```yaml
- name: Build Docker image
  run: |
    docker build -t devops-service:${GITHUB_SHA::7} .
```

- The Docker image is tagged with the first 7 characters of the commit SHA (e.g., `devops-service:ba54c85`).
- This guarantees that every image corresponds to an exact, immutable source revision.
- The build uses the project `Dockerfile`, running as an unprivileged user `appuser` with Gunicorn serving the application on port 5000.

---

## 10. Artifacts

Once the image is compiled, the pipeline exports and uploads it as a traceable build artifact:

```yaml
- name: Save Docker image
  run: |
    docker save devops-service:${GITHUB_SHA::7} | gzip > devops-service.tar.gz

- name: Upload Docker artifact
  uses: actions/upload-artifact@v4
  with:
    name: devops-service-${{ github.sha }}
    path: devops-service.tar.gz
    retention-days: 30
```

- **Export:** `docker save` extracts the complete container filesystem and layers, which is compressed using `gzip` into `devops-service.tar.gz`.
- **Upload & Retention:** `actions/upload-artifact@v4` stores the archive in GitHub Actions storage for **30 days**.
- **Traceability:** The artifact name includes the full commit SHA `${{ github.sha }}`, allowing any deployment to be audited and reproduced.

---

## 11. Failed Workflows

Understanding and resolving failed workflows is a core DevOps responsibility.

### How the Quality Gate Blocks Bad Code:
GitHub Actions executes steps in sequential order with fail-fast behavior:
- If a test assertion fails in step 4 (`Run application tests`), or a lint check fails in step 5 (`Check code quality`), the runner exits with code `1`.
- **Steps 6, 7, and 8 (Docker build, image save, artifact upload) are automatically skipped.**
- This ensures defective or untested code cannot generate a deployable Docker image.

### Investigating and Correcting Failures:
1. **View Logs:** Navigate to the **Actions** tab on GitHub, select the failed workflow run, and click on the failed step to read the exact traceback or Flake8 line error.
2. **Reproduce Locally:**
   - For test failures: run `python -m pytest -v -k <failed_test_name>`.
   - For linting issues: run `flake8 app tests` to see filename, line number, and error code.
3. **Correct and Push:**
   - Fix the code or test locally.
   - Verify that `python -m pytest -v` and `flake8 app tests` pass locally.
   - Commit and push the fix to the feature branch. GitHub Actions will automatically re-run the pipeline and display a green checkmark once resolved.
