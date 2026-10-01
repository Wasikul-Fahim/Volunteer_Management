# Volunteer & NGO Coordination Platform

Phase 0 contains the project scaffold and a running hello-world flow for the
FastAPI backend and React frontend. Business models, authentication, and
feature workflows are intentionally deferred to later phases.

## Setup

Prerequisites:

- Docker Desktop (with Docker Compose)
- Git
- Python 3.11+ and Node.js 22+ are useful for running checks outside Docker

Copy the example environment file, then start all services:

```sh
cp .env.example .env
docker compose up --build
```

The services are available at:

- Frontend: <http://localhost:5173>
- API docs: <http://localhost:8000/docs>
- Health endpoint: <http://localhost:8000/api/v1/health>

The landing page calls the health endpoint and displays the API/database
status. The database uses a named Docker volume with UTF-8 (`utf8mb4`) support.

## Checks and commands

```sh
make backend-test     # pytest
make lint             # Ruff
make migrate          # Alembic upgrade head (no migrations in Phase 0)
make seed             # placeholder until models exist
make down             # stop containers
```

`alembic current` can be run from `backend/` after the MySQL service is up.

## Decisions and scope

- The existing repository root is the `volunteer-ngo-platform` project root;
  the supplied `docs/PROJECT_SPEC.md` remains unchanged.
- Tailwind follows the current Vite plugin installation: `tailwindcss`,
  `@tailwindcss/vite`, and `@import "tailwindcss"`.
- Alembic is configured against `app.core.config.settings.db_url` and
  `app.models.Base.metadata`, but no domain models or migration are created in
  Phase 0.
- Authentication/security helpers, protected-route enforcement, and seed data
  are placeholders by design. Do not treat this scaffold as production-ready.

## Future deployment note

Production deployment (including Hostinger-specific process, environment, and
TLS configuration) belongs in the hardening/deployment phase after the
application features are implemented.
