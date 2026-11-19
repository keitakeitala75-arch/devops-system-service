# Operational Risk Register

## Risk Assessment Matrix

| Risk ID | Risk Description | Likelihood | Impact | Severity | Mitigation Strategy | Contingency / Recovery Plan |
|---|---|---|---|---|---|---|
| **RSK-01** | Application container crash or unhandled error | Medium | High | High | Container restart policy `unless-stopped` in Compose; automated `/health` endpoint. | Run `scripts/monitor.sh` to identify failure; execute `scripts/rollback.sh` to restore stable release. |
| **RSK-02** | Deployment of flawed code or broken dependency | Low | High | High | CI pipeline enforces automated Pytest tests and Flake8 linting before artifact packaging. | Revert Git commit or deploy previous verified Docker image (`devops-service:ffc8ce2`). |
| **RSK-03** | Unauthorized port or service access | Medium | Medium | Medium | Firewall restricted using `ufw` to allow only OpenSSH and port 5000; non-root user in container. | Audit firewall rules (`sudo ufw status verbose`) and enforce least-privilege accounts. |
| **RSK-04** | Container root privilege escalation | Low | High | Medium | Dedicated unprivileged user `appuser` created in Dockerfile; container runs with `USER appuser`. | Inspect container process credentials (`ps aux` / `docker top`). |
| **RSK-05** | Host disk or memory exhaustion | Low | Medium | Low | Monitoring script inspects storage and memory thresholds; Docker log rotation and artifact retention caps. | Automated log cleanup and container pruning (`docker system prune -f`). |
| **RSK-06** | Accidental credential leakage in repository | Low | High | High | Git repository strictly scanned; `.gitignore` configured for local environments, tokens, and temporary files. | Immediate token revocation, Git history cleaning, and instructor disclosure. |
