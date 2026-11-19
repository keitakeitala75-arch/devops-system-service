# Individual Contribution Log — Adeel Ahmad

- **Student Name:** Adeel Ahmad
- **Registration ID:** 443057803
- **GitHub Username:** `adeliusa486`
- **Branch:** `feature/adel-work`
- **Repository:** `https://github.com/keitakeitala75-arch/devops-system-service`

## Summary of Contributions

| Area | Contribution Details | Evidence Artifact |
|---|---|---|
| **Monitoring Tooling** | Authored `scripts/monitor.sh` with 5 automated checks: HTTP health probe, `/info` metadata, container status, real-time Docker CPU/memory stats, and host storage/RAM checks. | `scripts/monitor.sh` |
| **Recovery Automation** | Developed `scripts/rollback.sh` providing automated container tear-down, rollback deployment of target image, and polling health verification with retry logic. | `scripts/rollback.sh` |
| **Application Features** | Implemented `GET /info` endpoint in `app/app.py` returning service name, environment, operational status, support email, uptime in seconds, and version. Configured environment variables support. | `app/app.py` |
| **Testing & Quality** | Expanded automated Pytest suite in `tests/test_app.py` from 3 to 5 tests, covering the `/info` endpoint, header checks, and negative method testing (`POST /health` -> 405). Maintained 100% Flake8 compliance. | `tests/test_app.py` |
| **Operational Records** | Prepared `task-plan.md`, `risk-register.md`, `change-records.md`, `incident-record.md`, and `docs/deployment-checklist.md`. | `records/` and `docs/` |
| **Peer Review** | Created pull request from `feature/adel-work` into `main` with detailed summary, verification evidence, and rollback instructions for teammate review. | Pull Request (GitHub) |

## Personal Reflection

During this phase of the project, automating the monitoring and rollback operations was essential to reduce operational risk. Transitioning from manual terminal verification to scripted health audits (`scripts/monitor.sh` and `scripts/rollback.sh`) ensures consistent recovery and eliminates downtime caused by manual typos or configuration oversights during production incidents.
