# Server Setup Script – Test Plan and Expected Results

Script: `scripts/setup-server.sh`
Environment: separate Ubuntu VM (not the main project VM)

## 1. Static checks

| Command | Expected result |
|---|---|
| `bash -n scripts/setup-server.sh` | No output (no syntax errors) |
| `shellcheck scripts/setup-server.sh` | No output (no warnings) |

## 2. Safety checks

| Test | Expected result |
|---|---|
| Run without `ALLOWED_SUBNET` | `ERROR: Set ALLOWED_SUBNET before running this script.` and exit code 1 |
| Run when the `devops` group does not exist | `ERROR: Group devops does not exist.` and exit code 1 |

## 3. Normal run

```bash
sudo groupadd devops
ALLOWED_SUBNET=192.168.56.0/24 bash scripts/setup-server.sh
```

| Check | Command | Expected result |
|---|---|---|
| Service user | `id devops-service` | User exists, group is `devops` |
| Login shell | `getent passwd devops-service` | Shell is `/usr/sbin/nologin` |
| App directory | `ls -ld /opt/devops-system-service` | `drwxr-x---` owned by `devops-service devops` |
| Firewall | `sudo ufw status` | `Status: active`, OpenSSH allowed, `5000/tcp` allowed only from `192.168.56.0/24` |
| SSH access | Open a new SSH session | Connection still works |

## 4. Repeat run

Running the script a second time should finish without errors and should not create the user again.

## 5. Actual results

To be completed after running the tests on the Ubuntu VM.
