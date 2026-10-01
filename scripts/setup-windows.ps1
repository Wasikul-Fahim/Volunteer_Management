$ErrorActionPreference = "Stop"

function Assert-CommandSucceeded([string]$Message) {
    if ($LASTEXITCODE -ne 0) {
        throw $Message
    }
}

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "Setting up the Volunteer NGO Platform for local Windows development..." -ForegroundColor Cyan

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env from .env.example"
} else {
    Write-Host ".env already exists; leaving it unchanged."
}

if (-not (Test-Path ".venv\Scripts\python.exe")) {
    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 -m venv .venv
        Assert-CommandSucceeded "Could not create the Python virtual environment."
    } elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python -m venv .venv
        Assert-CommandSucceeded "Could not create the Python virtual environment."
    } else {
        throw "Python 3.11+ was not found. Install Python from https://www.python.org/downloads/windows/ and try again."
    }
}

$Python = Join-Path $Root ".venv\Scripts\python.exe"
& $Python -c "import sys; assert sys.version_info >= (3, 11), 'Python 3.11 or newer is required'"
Assert-CommandSucceeded "Python 3.11 or newer is required."
& $Python -m pip install --upgrade pip
Assert-CommandSucceeded "Could not upgrade pip."
& $Python -m pip install -r "backend\requirements-dev.txt"
Assert-CommandSucceeded "Could not install the backend dependencies."

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "Node.js/npm was not found. Install Node.js 22 LTS from https://nodejs.org/ and try again."
}

Push-Location (Join-Path $Root "frontend")
try {
    & npm install
    Assert-CommandSucceeded "Could not install the frontend dependencies."
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host "Open two PowerShell windows and run:"
Write-Host "  .\scripts\run-backend-windows.ps1"
Write-Host "  .\scripts\run-frontend-windows.ps1"
