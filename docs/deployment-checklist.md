# Service Deployment and Verification Checklist

## 1. Pre-Deployment Stage
- [ ] Confirm all changes are committed to a feature branch (`feature/*`).
- [ ] Verify automated Pytest unit tests pass locally: `python -m pytest -v`.
- [ ] Verify static code analysis passes: `flake8 app tests`.
- [ ] Ensure pull request has been peer reviewed and approved by at least one teammate.
- [ ] Verify GitHub Actions CI pipeline passes with green check on the pull request.
- [ ] Confirm target Docker release image tag / commit SHA is recorded.

## 2. Server Environment Preparation
- [ ] Check host storage capacity: `df -h /` (minimum 2 GB available).
- [ ] Check host memory: `free -h` (minimum 512 MB free).
- [ ] Verify Docker daemon is running: `systemctl status docker --no-pager`.
- [ ] Ensure firewall rules allow port 5000: `sudo ufw status`.
- [ ] Confirm external Docker volume exists if using Compose: `docker volume inspect devops-data`.

## 3. Deployment Execution
- [ ] Pull or load target Docker image:
  ```bash
  docker pull <registry>/devops-service:<tag>
  # OR
  docker build -t devops-service:local .
  ```
- [ ] Launch container:
  ```bash
  docker run -d \
    --name devops-container \
    -p 5000:5000 \
    --restart unless-stopped \
    devops-service:local
  ```

## 4. Post-Deployment Verification
- [ ] Execute automated monitoring check:
  ```bash
  ./scripts/monitor.sh http://localhost:5000
  ```
- [ ] Verify HTTP 200 response on `/health`:
  ```bash
  curl -i http://localhost:5000/health
  ```
- [ ] Verify `/info` response:
  ```bash
  curl -s http://localhost:5000/info
  ```
- [ ] Inspect container logs for startup errors:
  ```bash
  docker logs --tail 25 devops-container
  ```

## 5. Rollback Procedure (If Verification Fails)
- [ ] If health check returns non-200 or container fails to stabilize:
  ```bash
  ./scripts/rollback.sh devops-service:ffc8ce2
  ```
- [ ] Confirm rollback health endpoint reports version `1.0.0` or `1.1.0`.
- [ ] Log incident details in `records/incident-record.md`.
