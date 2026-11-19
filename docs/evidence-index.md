# Project Evidence Index

This document provides a consolidated index linking all pull requests, peer reviews, CI/CD pipeline runs, test results, release artifacts, and operational demonstrations per the DevOps project requirements.

---

## 1. Pull Requests and Peer Review Evidence

| PR # | Title | Author | Reviewer(s) | Status | Key Changes / Purpose |
|---|---|---|---|---|---|
| **[#1](https://github.com/keitakeitala75-arch/devops-system-service/pull/1)** | Improve application version consistency | Keita Nvamba | Adeel Ahmad / Faris | Merged | Standardized version to v1.1.0 across code and `/health`. |
| **[#2](https://github.com/keitakeitala75-arch/devops-system-service/pull/2)** | Add Linux server setup script | Faris | Adeel Ahmad / Keita | Open | Linux server provisioning script (`scripts/setup-server.sh`). |
| **[#3](https://github.com/keitakeitala75-arch/devops-system-service/pull/3)** | Add project README documentation | Keita Nvamba | Adeel Ahmad / Faris | Merged | Core project documentation and deployment guide. |
| **[#4](https://github.com/keitakeitala75-arch/devops-system-service/pull/4)** | feat: Add service monitoring, automated rollback, /info endpoint, and operational records | Adeel Ahmad | Keita Nvamba / Faris | Merged | Operational tools (`monitor.sh`, `rollback.sh`), `/info` endpoint, 5-case test suite, operational records. |
| **[#5](https://github.com/keitakeitala75-arch/devops-system-service/pull/5)** | docs: Comprehensive Application Testing and CI/CD Pipeline Documentation | Adeel Ahmad | Keita Nvamba / Faris | In Review | Dedicated Testing Strategy guide, CI/CD Architecture runbook, and Evidence Index. |

---

## 2. Continuous Integration & Pipeline Runs

| Run ID | Commit SHA | Trigger Event | Result | Artifact Generated | Link |
|---|---|---|---|---|---|
| `44493378022` | `87523df` | Push to `main` | **Success** | `devops-service-87523df...tar.gz` | [View Run](https://github.com/keitakeitala75-arch/devops-system-service/actions/runs/44493378022) |
| `44491703371` | `ba54c85` | PR #4 (`feature/adel-work`) | **Success** | `devops-service-ba54c85...tar.gz` | [View Run](https://github.com/keitakeitala75-arch/devops-system-service/actions/runs/44491703371) |
| `44484466079` | `57d357a` | Push to `main` | **Success** | `devops-service-57d357a...tar.gz` | [View Run](https://github.com/keitakeitala75-arch/devops-system-service/actions/runs/44484466079) |
| `44482820896` | `b1ce072` | PR #3 (`feature/keita-work`) | **Success** | `devops-service-b1ce072...tar.gz` | [View Run](https://github.com/keitakeitala75-arch/devops-system-service/actions/runs/44482820896) |
| `44340989819` | `59ba807` | PR #2 (`feature/Faris-work`) | **Success** | `devops-service-59ba807...tar.gz` | [View Run](https://github.com/keitakeitala75-arch/devops-system-service/actions/runs/44340989819) |

---

## 3. Versioned Release Artifacts

| Release Version | Git Commit | Docker Tag | CI Run ID | Storage & Verification |
|---|---|---|---|---|
| **v1.0.0 (Baseline)** | `ffc8ce2` | `devops-service:ffc8ce2` | `41201620340` | Stored in GitHub Actions artifacts; retained for rollback. |
| **v1.1.0 (Current)** | `87523df` | `devops-service:87523df` | `44493378022` | Stored in GitHub Actions artifacts; active deployed release. |

---

## 4. Operational & Recovery Demonstrations

| Demonstration | Target Script | Evidence Record | Measured Metric |
|---|---|---|---|
| **Health & Resource Monitoring** | [`scripts/monitor.sh`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/scripts/monitor.sh) | Section 11 in [`README.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/README.md) | 5 automated checks evaluated in $< 2$ seconds. |
| **Controlled Container Failure** | `docker stop devops-container` | [`records/incident-record.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/records/incident-record.md) | Detected via `/health` within 15 seconds (MTTD). |
| **Automated Service Rollback** | [`scripts/rollback.sh`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/scripts/rollback.sh) | [`records/incident-record.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/records/incident-record.md) | Restored to v1.0.0 in 35 seconds (MTTR). |

---

## 5. Team Governance & Process Records

- **Task Plan & Work Allocation:** [`records/task-plan.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/records/task-plan.md)
- **Risk Assessment Register:** [`records/risk-register.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/records/risk-register.md)
- **Change Control Records:** [`records/change-records.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/records/change-records.md)
- **Deployment Checklist:** [`docs/deployment-checklist.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/docs/deployment-checklist.md)
- **Individual Contribution Log (Adeel Ahmad):** [`records/individual-contributions-adeel.md`](file:///C:/Users/adeel/.gemini/antigravity/scratch/devops-system-service/records/individual-contributions-adeel.md)
