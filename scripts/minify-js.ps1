# Zyrakon JavaScript Minifier
# Basic minification for production deployment

param(
    [string]$InputFile = "C:\Projects\zyrakon\assets\js\main.js",
    [string]$OutputFile = "C:\Projects\zyrakon\assets\js\main.min.js"
)

Write-Host "Zyrakon JavaScript Minifier" -ForegroundColor Cyan

if (-not (Test-Path $InputFile)) {
    Write-Host "Error: Input file not found: $InputFile" -ForegroundColor Red
    exit 1
}

$JS = Get-Content $InputFile -Raw

$OriginalSize = $JS.Length

# Remove multi-line comments (but keep /*! comments)
$JS = $JS -replace '(?<!\/)\/\*[^*]*\*+(?:[^/*][^*]*\*+)*\/', ''

# Remove single-line comments (but not URLs)
$JS = $JS -replace '(?<!http:)\/\/.*$', ''

# Remove leading whitespace
$lines = $JS -split "`n"
$minified = @()
foreach ($line in $lines) {
    $trimmed = $line.Trim()
    if ($trimmed) {
        $minified += $trimmed
    }
}
$JS = $minified -join "`n"

# Basic whitespace removal (preserving some readability)
$JS = $JS -replace '\s+', ' '
$JS = $JS -replace '\s*\{\s*', '{'
$JS = $JS -replace '\s*\}\s*', '}'
$JS = $JS -replace '\s*\(\s*', '('
$JS = $JS -replace '\s*\)\s*', ')'
$JS = $JS -replace '\s*;\s*', ';'
$JS = $JS -replace '\s*=\s*', '='
$JS = $JS -replace '\s*\+\s*', '+'
$JS = $JS -replace '\s*,\s*', ','

$JS = $JS.Trim()

$NewSize = $JS.Length
$Saved = $OriginalSize - $NewSize
$Percent = [math]::Round(($Saved / $OriginalSize) * 100, 1)

Set-Content -Path $OutputFile -Value $JS -Encoding UTF8 -NoNewline

Write-Host "Original: $OriginalSize bytes" -ForegroundColor White
Write-Host "Minified: $NewSize bytes" -ForegroundColor White
Write-Host "Saved:    $Saved bytes ($Percent%)" -ForegroundColor Green
Write-Host "Output:   $OutputFile" -ForegroundColor White
