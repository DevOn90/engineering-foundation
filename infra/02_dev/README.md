# DEV Environment - Docker & Test Orchestration

This folder contains the DEV environment for the `name` service, including:

- **Docker Compose** setup (`docker-compose.yml`)
- **DEV deployment & test orchestration** (`deploy-DEV.sh`)
- **Test scripts** under `./tests` for smoke, health, API sanity, and black-box tests
- **Logs** stored under `./logs/<test-type>/` with timestamped filenames

---

## Prerequisites

- Docker & Docker Compose installed
- Docker daemon running
- `.env` file in the root of this folder with at least:
    - see **.env.example**
- Docker Hub credentials configured if you plan to promote images (`docker login`).

> ⚠️ `IMAGE_TAG` **must not** be `ci-latest` or `latest`. Only immutable CI-produced tags are allowed.

---

## Usage

Run the deployment & test orchestrator:

```bash
cd infra/02_dev
./deploy-DEV.sh
```

## The script will:
1. Validate the `.env` file and `IMAGE_TAG`
2. Verify that the Docker image exists in Docker Hub and is the latest produced by CI
3. `Pull & Build` the DEV environment via Docker Compose 
4. Run tests in this order (currently placeholders only):
    - Smoke tests
    - Health tests
    - API sanity tests
    - Black-box tests
5. Collect logs under `./logs/<test-type>/` with timestamped filenames
6. Promote the tested Docker image to `dev-approved-<IMAGE_TAG>` and `dev-approved-latest` tags in Docker Hub
7. Kill all related docker containers

## Logs

After each run, logs are stored in:
```bash
./logs/
├── smoke/
├── health/
├── sanity/
└── black-box/
```
Each log filename includes a timestamp:
```bash
smoke-YYYYMMDD-HHMMSS.log
```
---

## Promotion
If all tests pass:
- The image can be tagged as `dev-approved-<IMAGE_TAG>` (immutable)
- The rolling tag `dev-approved-latest` is updated

This ensures a **DEV-approved gate** before promoting to **TEST or PROD** environments.

---

## Notes
- The script is **idempotent**: re-running it will not overwrite dev-approved tags if the same image is already promoted.
- Test logs provide **evidence of DEV approval**.
- Future tests can be added under `./tests/` and integrated into the orchestrator.

---

