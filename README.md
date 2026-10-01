# Volunteer & NGO Coordination Platform

Phase 0 contains the project scaffold and a running hello-world flow for the
FastAPI backend and React frontend. Business models, authentication, and
feature workflows are intentionally deferred to later phases.

## Run locally without Docker

The easiest way for teammates to run the current Phase 0 site is **without
Docker**. The backend uses SQLite for this local scaffold, and the frontend
runs with Vite. Docker/MySQL remains available as an optional environment.

### Prerequisites

Install these tools first:

- Git: <https://git-scm.com/downloads>
- Python 3.11 or newer: <https://www.python.org/downloads/windows/>
- Node.js 22 LTS or newer: <https://nodejs.org/en/download>

On Windows, during Python installation, enable **Add Python to PATH**.

### Windows quick start

Clone the repository in PowerShell:

```powershell
git clone https://github.com/Wasikul-Fahim/Volunteer_Management.git
cd Volunteer_Management
```

If PowerShell blocks local scripts, allow scripts for the current PowerShell
window only:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Run the one-time setup script. It creates `.env`, creates a Python virtual
environment, installs backend dependencies, and installs frontend dependencies:

```powershell
.\scripts\setup-windows.ps1
```

Open **two PowerShell windows**, both in the project directory.

**PowerShell window 1 — backend:**

```powershell
.\scripts\run-backend-windows.ps1
```

**PowerShell window 2 — frontend:**

```powershell
.\scripts\run-frontend-windows.ps1
```

Open the website:

- Website: <http://localhost:5173>
- API documentation: <http://localhost:8000/docs>
- API health check: <http://localhost:8000/api/v1/health>

The landing page should display the backend status. The health endpoint should
return:

```json
{"status":"ok","db":"up"}
```

Leave both terminals running while using the site. Press `Ctrl+C` in each
terminal to stop the development servers.

### Windows manual setup

If you prefer not to use the helper scripts, run these commands instead.
From the project root, in PowerShell window 1:

```powershell
Copy-Item .env.example .env
py -3 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r backend\requirements-dev.txt
$env:DB_URL = "sqlite:///./phase0.db"
$env:CORS_ORIGINS = "http://localhost:5173"
python -m uvicorn app.main:app --app-dir backend --reload --port 8000
```

In PowerShell window 2:

```powershell
cd frontend
npm install
$env:VITE_API_URL = "http://localhost:8000"
npm run dev
```

### macOS/Linux manual setup

From the project root, in terminal 1:

```sh
cp .env.example .env
python3 -m venv .venv
source .venv/bin/activate
pip install -r backend/requirements-dev.txt
DB_URL=sqlite:///./phase0.db CORS_ORIGINS=http://localhost:5173 \
  python -m uvicorn app.main:app --app-dir backend --reload --port 8000
```

In terminal 2:

```sh
cd frontend
npm install
npm run dev
```

Then open <http://localhost:5173>.

### Why SQLite is used here

The Phase 0 health endpoint only needs a database connection, so SQLite keeps
the local setup simple and removes the need for Docker or MySQL. The Docker
Compose setup still uses MySQL and is the closer-to-production option. When
database models are introduced in later phases, the team should use the
project's agreed MySQL setup for development and integration testing.

## Optional Docker setup

Docker is not required for the current local site. If you already use Docker,
the complete three-service stack can be started with:

```sh
cp .env.example .env
docker compose up --build
```

The Docker services are:

| Service | URL |
| --- | --- |
| Website | <http://localhost:5173> |
| API documentation | <http://localhost:8000/docs> |
| API health check | <http://localhost:8000/api/v1/health> |

Useful Docker commands:

```sh
docker compose ps
docker compose logs -f
docker compose down
```

If Docker reports an error connecting to `docker.sock`, start Docker Desktop
and wait until its engine is running. Docker is intentionally optional for the
Phase 0 teammate workflow.

## Checks and commands

On Windows, run these from the project root after running the setup script:

```powershell
.\.venv\Scripts\python.exe -m pytest backend\app\tests -q
.\.venv\Scripts\python.exe -m ruff check backend\app
```

On macOS/Linux, activate `.venv` first and use:

```sh
make backend-test     # pytest
make lint             # Ruff
make migrate          # Alembic upgrade head (no migrations in Phase 0)
make seed             # placeholder until models exist
make down             # stop Docker services
```

The equivalent backend test command is:

```sh
cd backend
pytest
```

`alembic current` can be run from `backend/` when using the configured database.

## Troubleshooting

- **PowerShell says scripts are disabled:** run
  `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`, then rerun the
  script in that same window.
- **`py` or `python` is not recognized:** reinstall Python and enable **Add
  Python to PATH**, then open a new PowerShell window.
- **`npm` is not recognized:** install Node.js 22 LTS, then open a new terminal.
- **Frontend shows “Backend unavailable”:** make sure the backend terminal is
  still running and check <http://localhost:8000/api/v1/health>.
- **A port is already in use:** stop the process using port `8000` or `5173`,
  or change the port in the corresponding startup command.
- **Dependencies seem stale:** delete `frontend\node_modules` and `.venv`,
  then run the setup script again.

## Decisions and scope

- The repository root is the `Volunteer_Management` project root; the supplied
  `docs/PROJECT_SPEC.md` remains unchanged.
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
