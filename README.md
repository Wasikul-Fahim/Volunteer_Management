# Volunteer & NGO Coordination Platform

Phase 0 contains the project scaffold and a running hello-world flow for the
FastAPI backend and React frontend. Business models, authentication, and
feature workflows are intentionally deferred to later phases.

## Run the site locally

The recommended setup uses Docker Compose. It starts MySQL, the FastAPI API,
and the Vite frontend together, so teammates do not need to install Python
packages or Node dependencies manually.

### Prerequisites

- Git
- Docker Desktop, including Docker Compose
- A free local copy of ports `3306`, `8000`, and `5173`

On macOS, Docker Desktop can be installed with Homebrew:

```sh
brew install --cask docker
open -a Docker
```

Wait until Docker Desktop reports that the engine is running. Verify it before
starting the project:

```sh
docker info
docker compose version
```

### First-time setup

Clone the repository and enter the project directory:

```sh
git clone https://github.com/Wasikul-Fahim/Volunteer_Management.git
cd Volunteer_Management
```

Create the local environment file. This file is ignored by Git and must not be
committed:

```sh
cp .env.example .env
```

Start the complete local stack:

```sh
docker compose up --build
```

The first build may take a few minutes. Leave this terminal running. Once the
containers are ready, open:

| Service | URL |
| --- | --- |
| Website | <http://localhost:5173> |
| API documentation | <http://localhost:8000/docs> |
| API health check | <http://localhost:8000/api/v1/health> |

The landing page calls the API health endpoint and displays the backend and
database status. A working response from the health endpoint is:

```json
{"status":"ok","db":"up"}
```

### Daily commands

Run these from the project root:

```sh
# Start services in the foreground
docker compose up

# Start in the background
docker compose up -d

# Follow all service logs
docker compose logs -f

# Follow only backend logs
docker compose logs -f backend

# Show service status
docker compose ps

# Stop services (keeps the MySQL data volume)
docker compose down
```

To rebuild after dependency or Dockerfile changes:

```sh
docker compose up --build
```

To remove the local database volume and start with a completely fresh database
(use this only when you are comfortable deleting local data):

```sh
docker compose down -v
docker compose up --build
```

### Troubleshooting

- **Cannot connect to `docker.sock`:** start Docker Desktop, wait for the
  engine to finish starting, then run `docker info` again.
- **Port already in use:** stop the process using port `5173`, `8000`, or
  `3306`, or change the host-side port mapping in `docker-compose.yml`.
- **Frontend says the backend is unavailable:** check
  `docker compose logs backend`, then confirm that
  <http://localhost:8000/api/v1/health> responds.
- **A stale container is running:** run `docker compose down`, then retry
  `docker compose up --build`.

### Running without Docker

Docker is the preferred option because the intended database is MySQL. For a
quick frontend/backend smoke test without Docker, use SQLite locally. In one
terminal, from the project root:

```sh
python3 -m venv .venv
source .venv/bin/activate
pip install -r backend/requirements-dev.txt
DB_URL=sqlite:///./phase0.db uvicorn app.main:app --app-dir backend --reload --port 8000
```

In a second terminal:

```sh
cd frontend
npm install
npm run dev
```

Then open <http://localhost:5173>. This fallback is only for the Phase 0
scaffold; the Docker setup remains the standard team workflow.

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

- The repository root is the `Volunteer_Management` project root;
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
