$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root
$Python = Join-Path $Root ".venv\Scripts\python.exe"

if (-not (Test-Path $Python)) {
    throw "The Python environment is missing. Run .\scripts\setup-windows.ps1 first."
}

# Phase 0 uses SQLite for a Docker-free local run. Docker Compose uses MySQL.
$env:DB_URL = "sqlite:///./phase0.db"
$env:CORS_ORIGINS = "http://localhost:5173"

Write-Host "Starting the backend at http://localhost:8000 ..." -ForegroundColor Cyan
& $Python -m uvicorn app.main:app --app-dir backend --reload --host 127.0.0.1 --port 8000
