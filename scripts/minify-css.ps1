# Zyrakon CSS Minifier
# Removes comments, whitespace, and optimizes CSS

param(
    [string]$InputFile = "C:\Projects\zyrakon\assets\css\design-system.css",
    [string]$OutputFile = "C:\Projects\zyrakon\assets\css\design-system.min.css"
)

Write-Host "Zyrakon CSS Minifier" -ForegroundColor Cyan

if (-not (Test-Path $InputFile)) {
    Write-Host "Error: Input file not found: $InputFile" -ForegroundColor Red
    exit 1
}

$CSS = Get-Content $InputFile -Raw

$OriginalSize = $CSS.Length

# Remove comments
$CSS = $CSS -replace '/\*[\s\S]*?\*/', ''

# Remove whitespace
$CSS = $CSS -replace '\s+', ' '
$CSS = $CSS -replace '\s*\{\s*', '{'
$CSS = $CSS -replace '\s*\}\s*', '}'
$CSS = $CSS -replace '\s*;\s*', ';'
$CSS = $CSS -replace '\s*:\s*', ':'
$CSS = $CSS -replace '\s*,\s*', ','
$CSS = $CSS -replace ';\}', '}'

# Remove last semicolon before closing brace
$CSS = $CSS -replace ';}', '}'

# Remove leading/trailing whitespace
$CSS = $CSS.Trim()

$NewSize = $CSS.Length
$Saved = $OriginalSize - $NewSize
$Percent = [math]::Round(($Saved / $OriginalSize) * 100, 1)

Set-Content -Path $OutputFile -Value $CSS -Encoding UTF8 -NoNewline

Write-Host "Original: $OriginalSize bytes" -ForegroundColor White
Write-Host "Minified: $NewSize bytes" -ForegroundColor White
Write-Host "Saved:    $Saved bytes ($Percent%)" -ForegroundColor Green
Write-Host "Output:   $OutputFile" -ForegroundColor White
