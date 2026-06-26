# Zyrakon Local Dev Server
# Usage: .\scripts\serve.ps1
# Opens browser to http://localhost:3000

$Port = 3000
$Root = "C:\Projects\zyrakon"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Zyrakon Local Dev Server" -ForegroundColor Cyan
Write-Host " http://localhost:$Port" -ForegroundColor Green
Write-Host " Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

# Try Python first
$python = Get-Command python -ErrorAction SilentlyContinue
if ($python) {
    Write-Host "Using Python server..." -ForegroundColor White
    Set-Location $Root
    python -m http.server $Port
} else {
    Write-Host "Python not found. Install Python or use VS Code Live Server." -ForegroundColor Red
    Write-Host "Download: https://www.python.org/downloads/" -ForegroundColor Yellow
}
