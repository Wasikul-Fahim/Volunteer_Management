$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location (Join-Path $Root "frontend")

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "Node.js/npm was not found. Install Node.js 22 LTS from https://nodejs.org/ and try again."
}

if (-not (Test-Path "node_modules")) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
    & npm install
}

$env:VITE_API_URL = "http://localhost:8000"
Write-Host "Starting the frontend at http://localhost:5173 ..." -ForegroundColor Cyan
& npm run dev -- --host 127.0.0.1
