# Department Information Service

## 1. Project Overview

The Department Information Service is a small internal web application developed as part of the DevOps and System Administration project.

It provides department service information and a health endpoint for monitoring application availability.

The project demonstrates Linux system administration, Docker containerization, automated testing, CI/CD, deployment, monitoring, and recovery procedures.

## 2. Application Features

- Displays department service information.
- Shows support contact details.
- Displays service working hours.
- Displays the current application version.
- Provides a health endpoint at `/health`.
- Returns JSON health information for monitoring.

## 3. Technology Stack

- Python 3.14
- Flask
- Gunicorn
- Docker
- Docker Compose
- Git and GitHub
- GitHub Actions
- Pytest
- Flake8
- Ubuntu Linux

## 4. Project Structure

```text
devops-project/
├── app/
│   ├── __init__.py
│   └── app.py
├── tests/
│   └── test_app.py
├── scripts/
│   ├── monitor.sh
│   └── rollback.sh
├── docs/
│   ├── ci-cd-pipeline.md
│   ├── deployment-checklist.md
│   ├── evidence-index.md
│   └── testing-guide.md
├── records/
│   ├── change-records.md
│   ├── incident-record.md
│   ├── individual-contributions-adeel.md
│   ├── risk-register.md
│   └── task-plan.md
├── .github/
│   └── workflows/
│       └── ci.yml
├── Dockerfile
├── compose.yaml
├── requirements.txt
├── .gitignore
└── README.md
```

## 5. Application Endpoints

| Endpoint | Description |
|---|---|
| `/` | Displays department service information |
| `/health` | Returns application health status and version |
| `/info` | Returns runtime metadata, uptime, and contact details |

Example health response:

```json
{
  "status": "healthy",
  "version": "1.1.0"
}
```

Example info response:

```json
{
  "app_name": "Department Information Portal",
  "environment": "production",
  "status": "operational",
  "support_contact": "support@example.com",
  "uptime_seconds": 120,
  "version": "1.1.0"
}
```

## 6. Installation and Local Testing

### Requirements

- Python 3.14 or compatible version.
- Git.
- Docker (for container deployment).

### Clone the repository

```bash
git clone https://github.com/keitakeitala75-arch/devops-system-service.git
cd devops-system-service
```

### Create a virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### Install dependencies

```bash
pip install -r requirements.txt
```

### Run application tests

```bash
python -m pytest -v
```

For detailed test suite documentation and assertion criteria, see [Application Testing Guide](docs/testing-guide.md).

### Run code quality checks

```bash
flake8 app tests
```

## 7. Docker Deployment

### Build the Docker image

```bash
docker build -t devops-service:local .
```

### Run the container

```bash
docker run -d \
  --name devops-container \
  -p 5000:5000 \
  --restart unless-stopped \
  devops-service:local
```

### Check container status

```bash
docker ps
```

### View application logs

```bash
docker logs devops-container
```

### Verify application health

```bash
curl -i http://localhost:5000/health
```

The application should return HTTP 200 when healthy.

**Security:** The Dockerfile creates a dedicated `appuser` account and runs Gunicorn without root privileges.

## 8. Docker Compose

The project includes a `compose.yaml` file defining:

- Application service: `web`
- Container name: `devops-container`
- Port mapping: `5000:5000`
- Restart policy: `unless-stopped`
- External Docker volume: `devops-data`

The external volume must exist before deployment.

Create it if necessary:

```bash
docker volume create devops-data
```

Validate the Compose configuration:

```bash
docker compose config
```

Deploy the application on a suitable clean environment:

```bash
docker compose up -d --build
```

Check service status:

```bash
docker compose ps
```

View application logs:

```bash
docker compose logs -f web
```

Stop the Compose deployment:

```bash
docker compose down
```

**Important:** The current application does not use `/app/data`. The external volume is configured but is not currently used by application code. Also, avoid running the Compose deployment on a host where another container already uses the name `devops-container` and port 5000 until the deployment transition has been planned.

## 9. CI/CD Pipeline

The project uses GitHub Actions.

The workflow is located at:

`.github/workflows/ci.yml`

The pipeline performs the following operations:

1. Checks out the repository.
2. Sets up Python.
3. Installs project dependencies.
4. Runs automated tests using Pytest.
5. Checks code quality using Flake8.
6. Builds a Docker image.
7. Saves the image as a compressed archive.
8. Uploads the Docker artifact to GitHub Actions.

The pipeline runs for pull requests targeting `main` and pushes to `main`.

For in-depth architectural details, quality gate enforcement, and artifact traceability mapping, refer to:
- [CI/CD Pipeline Architecture & Operational Guide](docs/ci-cd-pipeline.md)
- [Consolidated Evidence Index](docs/evidence-index.md)

## 10. Release Versions

The project maintains two application releases:

| Release | Application version | Docker image |
|---|---|---|
| Initial release | v1.0.0 | `devops-service:ffc8ce2` |
| Updated release | v1.1.0 | `devops-service:8ed5534` |

The v1.1.0 release includes the updated application version.

Docker image identifiers and CI artifact information should be recorded in the project's deployment evidence.

## 11. Monitoring

The project provides an automated monitoring script that checks the `/health` and `/info` endpoints, container runtime status, real-time Docker CPU/memory utilization, and host disk space:

```bash
chmod +x scripts/monitor.sh
./scripts/monitor.sh http://localhost:5000
```

Individual monitoring commands:

### Container status

```bash
sudo docker ps -a
```

### Application logs

```bash
sudo docker logs --tail 20 devops-container
```

### Container resource usage

```bash
sudo docker stats --no-stream devops-container
```

### Docker service status

```bash
systemctl status docker --no-pager
```

### Application health

```bash
curl -i http://localhost:5000/health
```

## 12. Rollback

The project retains the previous v1.0.0 Docker image for rollback.

### Automated Rollback

An automated rollback script is provided to stop the running container, launch the target rollback image, and poll the health check endpoint until recovery is verified:

```bash
chmod +x scripts/rollback.sh
./scripts/rollback.sh devops-service:ffc8ce2
```

### Manual Rollback Procedure

The manual rollback procedure is:

1. Identify the currently deployed version.
2. Verify that the previous Docker image is available.
3. Stop and remove the current application container.
4. Start a new container using the previous image.
5. Verify the application health endpoint.
6. Confirm that the application reports version 1.0.0.
7. Record the rollback time and verification results.

Example rollback commands (execute only during an approved rollback):

```bash
sudo docker stop devops-container
sudo docker rm devops-container

sudo docker run -d \
  --name devops-container \
  -p 5000:5000 \
  --restart unless-stopped \
  devops-service:ffc8ce2
```

Verify the rollback:

```bash
curl -i http://localhost:5000/health
```

The expected version is `1.0.0`.

## 13. Project Objectives

The project demonstrates practical experience in:

- Linux user and permission management.
- Shared team project access.
- Docker image creation and container management.
- Docker Compose configuration.
- Automated testing and code quality checks.
- GitHub collaboration and pull requests.
- Continuous Integration and Docker artifact creation.
- Application deployment and monitoring.
- Service recovery and rollback.

## 14. Important Notes

- Use synthetic application information only.
- Do not commit passwords, access tokens, or other secrets.
- Use separate Git branches for development work.
- Review changes before merging into `main`.
- Preserve release artifacts and deployment evidence.
- Record actual test, deployment, recovery, and rollback results.

---

**Project:** Department Information Service
**Repository:** https://github.com/keitakeitala75-arch/devops-system-service
