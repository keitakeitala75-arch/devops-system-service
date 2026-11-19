# Controlled Failure and Recovery Record (Incident Simulation)

## Incident Overview

- **Incident ID:** INC-2026-001
- **Service Affected:** Department Information Service
- **Simulation Type:** Controlled Container Crash & Rapid Recovery
- **Conducted By:** Adeel Ahmad (Registration: 443057803)
- **Date & Time:** 2026-11-19 11:30:00 UTC

## Timeline and Action Sequence

| Timestamp | Phase | Action / Event | Observed Symptoms / Output |
|---|---|---|---|
| **11:30:00 UTC** | Normal State | Baseline health check executed via `scripts/monitor.sh`. | HTTP 200 OK, container `devops-container` running. |
| **11:31:00 UTC** | Failure Injection | Controlled stop of application container (`docker stop devops-container`). | Container status transitioned to `Exited (0)`. |
| **11:31:15 UTC** | Detection | Automated check against `http://localhost:5000/health`. | `curl` returned error: Connection refused (exit code 7). |
| **11:31:30 UTC** | Diagnosis | Inspected container status via `docker ps -a --filter name=devops-container`. | Identified container in stopped state; host system resources healthy. |
| **11:32:00 UTC** | Recovery Initiation | Executed automated recovery / rollback script: `scripts/rollback.sh devops-service:8ed5534`. | Container stopped, removed, and recreated from known-good image. |
| **11:32:05 UTC** | Health Verification | Script polled `/health` endpoint on retry attempt 1. | HTTP 200 OK returned: `{"status": "healthy", "version": "1.1.0"}`. |
| **11:32:15 UTC** | Normalization | Full monitoring script `scripts/monitor.sh` executed. | All 5 checks passed; service restored to full operational state. |

## Key Metrics

- **Mean Time to Detect (MTTD):** 15 seconds
- **Mean Time to Recover (MTTR):** 35 seconds
- **Total Service Interruption:** 50 seconds
- **Data Loss:** 0% (stateless application layer)

## Lessons Learned & Improvements

1. Automated health checks rapidly distinguish application-level down events from network connectivity failures.
2. The scripted rollback procedure (`scripts/rollback.sh`) reduced manual recovery steps from 5 terminal commands to a single deterministic command, eliminating human command-line errors during incidents.
