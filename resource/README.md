# Resource CLI Guide

This folder contains the Docker setup for the MERN Todo application:

- `docker-compose.yml`: development stack with hot reload and Mongo Express.
- `docker-compose.prod.yml`: production stack using production Dockerfiles.
- `makefile`: CLI wrapper for common Docker Compose commands.
- `.env`: local runtime configuration for ports, MongoDB, JWT, and frontend API URL.

## Requirements

Install these tools before running the CLI:

- Docker
- Docker Compose v2, available as `docker compose`
- Make

Check them with:

```sh
docker --version
docker compose version
make --version
```

## First Time Setup

Go to the `resource` folder:

```sh
cd /Users/kiennguyen/Learning/DevOps/sources/final-project/resource
```

Create `.env` if it does not exist:

```sh
cp .env.example .env
```

Review the important values in `.env`:

```env
EXTERNAL_BACKEND_PORT=8111
INTERNAL_BACKEND_PORT=8111
EXTERNAL_FRONTEND_PORT=3111
REACT_APP_API_URL=https://api-final-project.nguyentrungkien.net/api
```

For an all-local development stack, set `REACT_APP_API_URL=http://localhost:8111/api`.

## Basic Commands

Show all Makefile commands:

```sh
make help
```

Validate both Docker Compose files:

```sh
make validate
```

Print configured local URLs:

```sh
make urls
```

Show container status for both environments:

```sh
make status
```

Stop both environments:

```sh
make down
```

## Run Development Environment

Start the development stack:

```sh
make dev
```

Development uses:

- `docker-compose.yml`
- `backend/Dockerfile.dev`
- `frontend/Dockerfile.dev`
- Backend hot reload with `node --watch`
- Frontend hot reload with React development server
- Mongo Express on port `8081`

Default local URLs from `.env`:

```text
Frontend:          http://localhost:3111
Backend API:       http://localhost:8111/api
Mongo Express DEV: http://localhost:8081
```

Follow all DEV logs:

```sh
make dev-logs
```

Follow one DEV service log:

```sh
make dev-logs SERVICE=backend
make dev-logs SERVICE=frontend
make dev-logs SERVICE=mongodb
make dev-logs SERVICE=mongo-express
```

Restart one DEV service:

```sh
make dev-restart SERVICE=backend
```

Open a shell in a DEV container:

```sh
make dev-backend-shell
make dev-frontend-shell
```

Stop DEV:

```sh
make dev-down
```

## Run Production Environment

Start the production stack:

```sh
make prod
```

Production uses:

- `docker-compose.prod.yml`
- `backend/Dockerfile`
- `frontend/Dockerfile`
- React production build served by `serve`
- MongoDB

Follow all PROD logs:

```sh
make prod-logs
```

Follow one PROD service log:

```sh
make prod-logs SERVICE=backend
make prod-logs SERVICE=frontend
make prod-logs SERVICE=mongodb
```

Restart one PROD service:

```sh
make prod-restart SERVICE=frontend
```

Open a shell in a PROD container:

```sh
make prod-backend-shell
make prod-frontend-shell
```

Stop PROD:

```sh
make prod-down
```

## Switch Environments

The DEV and PROD stacks use the same host ports from `.env`, so run only one stack at a time.

Switch from PROD to DEV:

```sh
make switch-dev
```

Switch from DEV to PROD:

```sh
make switch-prod
```

## Build Commands

Build DEV images:

```sh
make dev-build
```

Build PROD images:

```sh
make prod-build
```

Rebuild DEV images without cache:

```sh
make dev-rebuild
```

Rebuild PROD images without cache:

```sh
make prod-rebuild
```

## Reset Commands

Stop and remove DEV containers, networks, and volumes:

```sh
make dev-reset
```

Stop and remove PROD containers, networks, and volumes:

```sh
make prod-reset
```

Reset both environments:

```sh
make reset
```

Warning: reset commands remove Docker volumes, including MongoDB data.

## Useful Overrides

Use a different Compose command:

```sh
make COMPOSE="docker compose" dev
```

Use a different Docker Compose project name:

```sh
make PROJECT=my-todo dev
```

Use a different env file:

```sh
make ENV_FILE=/path/to/.env.prod prod
```

Run Makefile commands from another directory:

```sh
make -f /Users/kiennguyen/Learning/DevOps/sources/final-project/resource/makefile dev
```

## Troubleshooting

If ports are already in use, change these values in `.env`:

```env
EXTERNAL_BACKEND_PORT=8111
EXTERNAL_FRONTEND_PORT=3111
```

Then restart the stack:

```sh
make down
make dev
```

If containers fail to start, inspect logs:

```sh
make logs
make logs SERVICE=backend
```

If Docker images are stale, rebuild without cache:

```sh
make dev-rebuild
make dev
```
