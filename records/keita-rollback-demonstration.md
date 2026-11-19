# Docker Rollback Demonstration

## 1. Demonstration Details

- **Contributor:** Keita
- **Date:** 19 November 2026
- **Application:** Department Information Service
- **Failed release:** 1.1.0
- **Previous stable release:** 1.0.0
- **Rollback method:** Manual Docker rollback
- **Application port:** 5000

## 2. Initial Application State

The application was initially running successfully using version 1.1.0.

Docker image:

```text
devops-service:8ed5534
```

Health check command:

```bash
curl -i http://localhost:5000/health
```

Observed result:

```text
HTTP/1.1 200 OK
{"status":"healthy","version":"1.1.0"}
```

## 3. Verification of Previous Release

Before performing the rollback, the previous Docker image was checked.

Image:

```text
devops-service:ffc8ce2
```

A temporary container was started on port 5001 to test the previous release without interrupting version 1.1.0.

Command:

```bash
sudo docker run -d \
  --name rollback-test-v1 \
  -p 127.0.0.1:5001:5000 \
  devops-service:ffc8ce2
```

Health check:

```bash
curl -i http://localhost:5001/health
```

Observed result:

```text
HTTP/1.1 200 OK
{"status":"healthy","version":"1.0.0"}
```

This confirmed that version 1.0.0 was available and healthy.

## 4. Failure Simulation

The running version 1.1.0 container was stopped to simulate an application failure.

Command:

```bash
sudo docker stop devops-container
```

The health endpoint was checked again:

```bash
curl -i --max-time 5 http://localhost:5000/health
```

Observed result:

```text
curl: (7) Failed to connect to localhost port 5000
```

The application was unavailable on port 5000.

## 5. Rollback Execution

The previous test container was stopped:

```bash
sudo docker stop rollback-test-v1
```

A new container was created using the previous stable image, version 1.0.0.

Command:

```bash
sudo docker run -d \
  --name devops-container-rollback \
  --restart unless-stopped \
  -p 5000:5000 \
  devops-service:ffc8ce2
```

The rollback deployment started successfully.

## 6. Recovery Verification

The health endpoint was tested after the rollback.

Command:

```bash
curl -i http://localhost:5000/health
```

Observed result:

```text
HTTP/1.1 200 OK
{"status":"healthy","version":"1.0.0"}
```

The application successfully recovered using version 1.0.0.

## 7. Results

| Test | Result |
|---|---|
| Initial v1.1.0 health check | Passed |
| Previous v1.0.0 image verification | Passed |
| Controlled v1.1.0 failure | Successful |
| Failure detection | Successful |
| Deployment of v1.0.0 | Successful |
| Final health check | HTTP 200 |
| Recovered application version | 1.0.0 |

## 8. Conclusion

The rollback demonstration confirmed that the application could be restored to its previous stable release when version 1.1.0 became unavailable.

The previous Docker image, `devops-service:ffc8ce2`, was deployed successfully, and the health endpoint returned HTTP 200 with application version 1.0.0.

This demonstration used a manually executed Docker rollback. It did not use an automated rollback script.

The original stopped v1.1.0 container was preserved during the demonstration.
