# Controlled Failure and Recovery Demonstration

## 1. Demonstration Details

- **Contributor:** Keita
- **Date:** 19 November 2026
- **Application:** Department Information Service
- **Docker container:** devops-container
- **Docker image:** devops-service:8ed5534
- **Application version:** 1.1.0
- **Test type:** Controlled failure and manual recovery

## 2. Initial Healthy State

The application was running successfully before the failure simulation.

Command:

```bash
curl -i http://localhost:5000/health
```

Observed result:

```text
HTTP/1.1 200 OK
{"status":"healthy","version":"1.1.0"}
```

## 3. Failure Simulation

The running container was deliberately stopped to simulate an application outage.

Command:

```bash
sudo docker stop devops-container
```

Observed container status:

```text
Exited (0)
```

The health check was then performed:

```bash
curl -i --max-time 5 http://localhost:5000/health
```

Observed result:

```text
curl: (7) Failed to connect to localhost port 5000
```

The application was unavailable.

## 4. Recovery Action

The existing Docker container was restarted.

Command:

```bash
sudo docker start devops-container
```

The container returned to running status.

## 5. Recovery Verification

The health endpoint was tested again.

Command:

```bash
curl -i http://localhost:5000/health
```

Observed result:

```text
HTTP/1.1 200 OK
{"status":"healthy","version":"1.1.0"}
```

The application successfully recovered.

## 6. Results

| Test | Result |
|---|---|
| Initial health check | Passed |
| Controlled container stop | Successful |
| Failure detection | Successful |
| Manual container restart | Successful |
| Final health check | Passed |
| Application version preserved | Yes |

## 7. Conclusion

The demonstration confirmed that stopping the Docker container caused the application to become unavailable. Restarting the existing container restored the service successfully.

No Docker image rebuild or container replacement was required.

This was a planned failure simulation. Recovery was performed manually using Docker commands. Automated rollback was not part of this demonstration.
