# Docker Deployment and Monitoring Guide

This guide explains how the Department Information Service is packaged, deployed and monitored with Docker. It is based on the project's `Dockerfile` and `compose.yaml`.

## 1. Introduction

Docker packages the application with its Python version and dependencies into one image. The same image runs the same way on any machine with Docker, which keeps the deployment consistent and easy to repeat or roll back.

## 2. Dockerfile

| Instruction | Purpose |
|---|---|
| `FROM python:3.14-slim` | Uses a small official Python 3.14 base image |
| `WORKDIR /app` | Sets `/app` as the working directory inside the container |
| `RUN useradd --create-home appuser` | Creates a non-root user called `appuser` |
| `COPY requirements.txt .` | Copies the dependency list into the image |
| `RUN pip install --no-cache-dir -r requirements.txt` | Installs Flask, Gunicorn, pytest and flake8 without keeping the pip cache |
| `COPY app/ ./app/` | Copies the application code |
| `RUN chown -R appuser:appuser /app` | Gives `appuser` ownership of the application files |
| `USER appuser` | Runs the container as `appuser` instead of root |
| `EXPOSE 5000` | Documents that the application listens on port 5000 |
| `CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.app:app"]` | Starts the app with the Gunicorn production server on port 5000 |

## 3. Building the image

```bash
docker build -t devops-service:local .
```

- `-t devops-service:local` gives the image a name and tag.
- `.` tells Docker to use the `Dockerfile` in the current folder.

The CI pipeline also builds the image on every pull request, tagged with the short commit SHA (for example `devops-service:<sha>`).

List local images:

```bash
docker images devops-service
```

## 4. Running the container

```bash
docker run -d \
  --name devops-container \
  -p 5000:5000 \
  --restart unless-stopped \
  devops-service:local
```

| Option | Meaning |
|---|---|
| `-d` | Runs the container in the background |
| `--name devops-container` | Gives the container a fixed name |
| `-p 5000:5000` | Maps host port 5000 to container port 5000 |
| `--restart unless-stopped` | Restarts the container automatically unless it was stopped manually |

Stop and remove the container:

```bash
docker stop devops-container
docker rm devops-container
```

## 5. Port mapping

The mapping `5000:5000` means `host port : container port`.

- Gunicorn listens on port 5000 inside the container.
- Docker forwards host port 5000 to it.
- The service is reached at `http://localhost:5000` on the server.

The host firewall (UFW) must allow port 5000 for other machines to reach it.

## 6. Non-root user

The container runs as `appuser`, not root. If the application is ever compromised, the attacker only gets the limited rights of `appuser` inside the container, which reduces the damage. This follows the principle of least privilege.

Check the user inside the running container:

```bash
docker exec devops-container whoami
```

Expected output: `appuser`

## 7. Container status

```bash
docker ps
docker ps -a
docker inspect devops-container --format '{{.State.Status}}'
docker stats --no-stream devops-container
```

- `docker ps` shows running containers. The status should be `Up`.
- `docker ps -a` also shows stopped containers.
- `docker inspect` shows the exact state, for example `running` or `exited`.
- `docker stats` shows CPU and memory usage.

## 8. Application logs

```bash
docker logs devops-container
docker logs --tail 25 devops-container
docker logs -f devops-container
```

- `--tail 25` shows the last 25 lines.
- `-f` follows new log lines live (press Ctrl + C to stop).

Gunicorn startup messages and request errors appear here.

## 9. Health monitoring

The application provides two monitoring endpoints:

```bash
curl -i http://localhost:5000/health
curl -s http://localhost:5000/info
```

`/health` returns HTTP 200 with:

```json
{"status": "healthy", "version": "1.1.0"}
```

`/info` returns the application name, environment, status, support contact, uptime in seconds and version.

The project script `scripts/monitor.sh` can also be used:

```bash
./scripts/monitor.sh http://localhost:5000
```

## 10. Docker Compose

The project's `compose.yaml`:

```yaml
services:
  web:
    build: .
    container_name: devops-container
    ports:
      - "5000:5000"
    volumes:
      - devops-data:/app/data
    restart: unless-stopped

volumes:
  devops-data:
    external: true
```

| Setting | Meaning |
|---|---|
| `web` | Name of the service |
| `build: .` | Builds the image from the local `Dockerfile` |
| `container_name: devops-container` | Same container name as the manual `docker run` |
| `ports: "5000:5000"` | Same port mapping as above |
| `volumes: devops-data:/app/data` | Mounts the named volume `devops-data` at `/app/data` |
| `external: true` | The volume must already exist; Compose will not create it |

The application does not currently store any data in `/app/data`. The volume is prepared for future use.

Because the volume is external, create it once before the first start:

```bash
docker volume create devops-data
```

Start, check and stop with Compose:

```bash
docker compose up -d --build
docker compose ps
docker compose logs --tail 25
docker compose down
```

## 11. Restart policy

`unless-stopped` means:

- If the application crashes, Docker restarts it.
- If the server reboots, Docker starts the container again.
- If an administrator stops it with `docker stop`, it stays stopped.

Check the policy:

```bash
docker inspect devops-container --format '{{.HostConfig.RestartPolicy.Name}}'
```

Expected output: `unless-stopped`

## 12. Troubleshooting

| Problem | Likely cause | Solution |
|---|---|---|
| `port is already allocated` | Another container or program uses port 5000 | `docker ps` to find it, then stop it, or use another host port such as `-p 5001:5000` |
| `Conflict. The container name "/devops-container" is already in use` | An old container with the same name exists | `docker rm -f devops-container`, then run again |
| `external volume "devops-data" not found` | The external volume was not created | `docker volume create devops-data` |
| Container status is `Exited` | The application failed at startup | `docker logs devops-container` to read the error |
| `curl` cannot connect | Container not running, or wrong port | Check `docker ps` and the port mapping |
| Works locally but not from another machine | Firewall blocks port 5000 | Check `sudo ufw status` and allow port 5000 for the allowed network |
| `permission denied` when running Docker | User is not in the `docker` group | Use `sudo`, or add the user to the `docker` group |

Note: the commands in this guide describe the deployment procedure. The actual deployment outputs (container name, image tag and health check result) are recorded by the team member who performed the deployment.
