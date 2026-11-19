# Change Control Records

## Change Record 001: Initial Service Deployment (v1.0.0)

- **Change ID:** CR-001
- **Date:** 2026-10-31
- **Author:** Keita Nvamba
- **Reviewed By:** Adeel Ahmad & Faris
- **Target Release:** v1.0.0
- **Docker Image:** `devops-service:ffc8ce2`
- **Description:** Initial deployment of Flask service using Gunicorn and Docker containerization.
- **Pre-deployment Verification:** Automated Pytest suite passed (3 tests); Flake8 passed; Docker image built.
- **Rollback Plan:** Stop container and fall back to local service execution.
- **Outcome:** Successfully deployed and verified via `/health`.

---

## Change Record 002: Version Consistency & Documentation Upgrade (v1.1.0)

- **Change ID:** CR-002
- **Date:** 2026-11-19
- **Author:** Keita Nvamba
- **Reviewed By:** Adeel Ahmad
- **Target Release:** v1.1.0
- **Docker Image:** `devops-service:8ed5534`
- **Description:** Standardized application version to `1.1.0` across codebase, synced `/health` endpoint, and added comprehensive documentation.
- **Pre-deployment Verification:** Unit tests updated and verified in GitHub Actions CI; Flake8 linting passed.
- **Rollback Plan:** Re-deploy previous v1.0.0 image (`devops-service:ffc8ce2`).
- **Outcome:** Successfully merged and deployed.

---

## Change Record 003: Operational Monitoring, Rollback Automation & Service Enhancements

- **Change ID:** CR-003
- **Date:** 2026-11-19
- **Author:** Adeel Ahmad (Registration: 443057803)
- **Branch:** `feature/adel-work`
- **Reviewed By:** Keita Nvamba / Faris
- **Target Release:** v1.2.0-rc1
- **Description:**
  1. Added automated monitoring script (`scripts/monitor.sh`) to audit `/health`, `/info`, container status, and host resources.
  2. Added automated rollback script (`scripts/rollback.sh`) with health verification retries.
  3. Added `/info` endpoint in `app/app.py` returning uptime, environment, and contact info.
  4. Expanded test suite in `tests/test_app.py` to 5 test cases including error/edge testing.
  5. Added operational project records and deployment checklist.
- **Pre-deployment Verification:** 5 automated tests passing; Flake8 compliance verified; scripts validated with strict bash safety flags (`set -euo pipefail`).
- **Rollback Plan:** Execute `scripts/rollback.sh devops-service:8ed5534` to revert to previous image.
- **Outcome:** Ready for peer review and merge into `main`.
