# Local Development Setup (macOS, Docker-free)

This guide runs the current VolunteerSync dashboard without Docker. The local
backend uses SQLite for the Phase 0 scaffold, and the frontend uses Vite.

## Prerequisites

Install:

- Git
- Python 3.11+
- Node.js 22.12+ (or a newer supported LTS release)

The commands below use the existing project location on this Mac. If you
cloned the repository elsewhere, replace the `cd` paths with your own.

## First-time setup

Open Terminal and move to the project root:

```sh
cd /Users/wasikulfahim/Codes/Projects/Volunteer_management
```

Create the local environment file if it does not exist:

```sh
test -f .env || cp .env.example .env
```

Create and activate a Python virtual environment:

```sh
python3 -m venv .venv
source .venv/bin/activate
```

Install backend dependencies:

```sh
python -m pip install -r backend/requirements-dev.txt
```

Install frontend dependencies:

```sh
npm --prefix frontend install
```

## Start the backend

Use **Terminal 1**. From the project root, run:

```sh
cd /Users/wasikulfahim/Codes/Projects/Volunteer_management
source .venv/bin/activate
DB_URL=sqlite:///./phase0.db \
CORS_ORIGINS=http://localhost:5173 \
python -m uvicorn app.main:app --app-dir backend --reload --port 8000
```

Leave this terminal running.

Verify the backend in a browser or with curl:

```sh
curl http://localhost:8000/api/v1/health
```

Expected response:

```json
{"status":"ok","db":"up"}
```

API documentation is available at <http://localhost:8000/docs>.

## Start the frontend

Use **Terminal 2**:

```sh
cd /Users/wasikulfahim/Codes/Projects/Volunteer_management
VITE_API_URL=http://localhost:8000 npm --prefix frontend run dev
```

Open the website at <http://localhost:5173>.

The VolunteerSync dashboard should load. On wide screens, the top navigation
shows **API connected** when the health request succeeds. That indicator only
confirms that the API responds; check the health response's `db` value to
confirm the database connection.

## What the backend currently supports

- `GET /` responds with the API's hello-world message.
- `GET /api/v1/health` actually checks a database connection.
- `/docs` and `/openapi.json` expose the API documentation and schema.
- CORS permits the frontend at `http://localhost:5173` with the settings above.

The six VolunteerSync dashboard pages currently use frontend demo data.
Authentication, business models, and real applications, task updates, and
donations are **not implemented in the backend yet**. SQLite verifies the
scaffold without Docker; it does not verify the optional MySQL environment.

## Stop the services

Press `Ctrl+C` in both terminal windows.

## Run checks

From the project root:

```sh
.venv/bin/python -m pytest backend/app/tests -q
.venv/bin/python -m ruff check backend/app
npm --prefix frontend run build
```

## Troubleshooting

### Backend says the port is already in use

Check which process is listening (a second backend may already be running):

```sh
lsof -nP -iTCP:8000 -sTCP:LISTEN
curl http://localhost:8000/api/v1/health
```

If it is your previous backend, press `Ctrl+C` in its terminal before restarting.
Do not stop an unfamiliar service. Alternatively, use another port and update
the frontend API URL accordingly (activate `.venv` first):

```sh
DB_URL=sqlite:///./phase0.db \
CORS_ORIGINS=http://localhost:5173 \
python -m uvicorn app.main:app --app-dir backend --reload --port 8001
```

Then start the frontend with:

```sh
VITE_API_URL=http://localhost:8001 npm --prefix frontend run dev
```

### Health returns `"db":"down"`

The API process is running, but it cannot connect to its configured database.
An HTTP 200 response or **API connected** label alone does not mean the database
is up. Stop your old backend with `Ctrl+C` and restart it with the explicit
`DB_URL=sqlite:///./phase0.db` command above, then check health again.

The example `.env` targets a MySQL host named `mysql` inside Docker Compose.
The inline `DB_URL` override takes precedence without changing `.env`.

### Frontend shows Preview mode

Make sure Terminal 1 is still running and that this URL returns a response:

<http://localhost:8000/api/v1/health>

### Docker

Docker is not required for this local Phase 0 workflow. Docker Compose remains
available as an optional MySQL-based environment for later integration work.
