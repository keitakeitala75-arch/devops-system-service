# Team Task Plan & Work Allocation

## Project Overview

- **Service Name:** Department Information Service
- **Repository:** `https://github.com/keitakeitala75-arch/devops-system-service`
- **Team Size:** 3 Members

## Team Members & Role Distribution

| Team Member | Primary Focus Area | Key Responsibilities |
|---|---|---|
| **Keita Nvamba** | Service Architecture & Base CI/CD | Flask application core, Dockerfile containerization, GitHub Actions CI workflow, base documentation. |
| **Faris** | Linux Environment & Provisioning | Linux system administration, service user creation, permissions, firewall rules (`scripts/setup-server.sh`). |
| **Adeel Ahmad** | Application Testing & CI/CD Documentation | Automated Pytest suite design (positive, negative, edge cases), Flake8 static code quality enforcement, GitHub Actions CI verification, artifact traceability, and CI/CD technical documentation. |

## 5-Week Milestone Timeline

```
Week 1: Plan & Environment Setup (Linux VM, named accounts, security boundaries)
Week 2: Working Service & Containerization (Flask app, tests, Dockerfile, peer-reviewed PRs)
Week 3: Automated Delivery & CI (GitHub Actions pipeline, linting, tests, versioned artifacts)
Week 4: Operations & Recovery (v1.0.0 and v1.1.0 releases, monitoring, failure simulation, rollback)
Week 5: Quality Improvements, Documentation & Handover (verification, final report, demonstration)
```

## Milestone Deliverables

### Week 1 — Plan and Environment
- [x] Repository initialized with `.gitignore` and base structure.
- [x] Linux environment setup script (`scripts/setup-server.sh`).
- [x] Initial task allocation and risk register created.

### Week 2 — Working Service
- [x] Flask service implementation (`app/app.py`).
- [x] Non-root Dockerfile packaging.
- [x] Initial test suite with Pytest.
- [x] Peer review process established via GitHub pull requests.

### Week 3 — Automated Delivery
- [x] GitHub Actions CI pipeline running Pytest and Flake8 on pull requests and pushes to `main`.
- [x] Automated Docker image build and artifact retention in CI.
- [x] Negative and edge-case testing implemented.

### Week 4 — Operation and Recovery
- [x] Deployment of release `v1.0.0` and update `v1.1.0`.
- [x] Operational monitoring script (`scripts/monitor.sh`).
- [x] Automated rollback script (`scripts/rollback.sh`).
- [x] Controlled failure test and recovery execution documented (`records/incident-record.md`).

### Week 5 — Improvements & Handover
- [x] Enhanced `/info` operational endpoint with uptime tracking.
- [x] Complete deployment checklist (`docs/deployment-checklist.md`).
- [x] Individual contribution logs and change records completed.
