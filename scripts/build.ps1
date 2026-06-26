# ============================================================================
# ZYRAKON WEBSITE - PRODUCTION BUILD SCRIPT
# Usage: .\scripts\build.ps1
# ============================================================================

param(
    [switch]$Minify = $true,
    [switch]$OptimizeImages = $false,
    [switch]$GenerateSitemap = $true
)

$ErrorActionPreference = "Stop"
$ZYRAKON_ROOT = "C:\Projects\zyrakon"
$BUILD_DIR = "$ZYRAKON_ROOT\dist"
$StartTime = Get-Date

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ZYRAKON PRODUCTION BUILD" -ForegroundColor Cyan
Write-Host " The Foundation of Intelligent Technology" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------------------------------------------
# Step 1: Clean build directory
# ----------------------------------------------------------------------------
Write-Host "[1/6] Cleaning build directory..." -ForegroundColor Yellow
if (Test-Path $BUILD_DIR) {
    Remove-Item -Recurse -Force $BUILD_DIR
}
New-Item -ItemType Directory -Force -Path $BUILD_DIR | Out-Null
Write-Host "  ✓ Build directory cleaned" -ForegroundColor Green

# ----------------------------------------------------------------------------
# Step 2: Copy source files
# ----------------------------------------------------------------------------
Write-Host "[2/6] Copying source files..." -ForegroundColor Yellow

$CopyDirs = @(
    "pages",
    "assets\images",
    "assets\fonts",
    "assets\documents",
    "components",
    ".well-known"
)

foreach ($Dir in $CopyDirs) {
    $Source = Join-Path $ZYRAKON_ROOT $Dir
    $Dest = Join-Path $BUILD_DIR $Dir
    if (Test-Path $Source) {
        Copy-Item -Path $Source -Destination $Dest -Recurse -Force
        Write-Host "  ✓ Copied: $Dir"
    }
}

# Copy root files
$RootFiles = @("index.html", "robots.txt", "sitemap.xml", "llms.txt", "llms-full.txt")
foreach ($File in $RootFiles) {
    $Source = Join-Path $ZYRAKON_ROOT $File
    if (Test-Path $Source) {
        Copy-Item -Path $Source -Destination $BUILD_DIR -Force
    }
}

# Copy CSS and JS separately (we'll minify them)
New-Item -ItemType Directory -Force -Path "$BUILD_DIR\assets\css" | Out-Null
New-Item -ItemType Directory -Force -Path "$BUILD_DIR\assets\js" | Out-Null

Write-Host "  ✓ Source files copied" -ForegroundColor Green

# ----------------------------------------------------------------------------
# Step 3: Minify CSS
# ----------------------------------------------------------------------------
Write-Host "[3/6] Minifying CSS..." -ForegroundColor Yellow

if ($Minify) {
    # Copy original
    Copy-Item "$ZYRAKON_ROOT\assets\css\design-system.css" "$BUILD_DIR\assets\css\design-system.css" -Force
    
    # Run minifier
    & "$ZYRAKON_ROOT\scripts\minify-css.ps1" `
        -InputFile "$ZYRAKON_ROOT\assets\css\design-system.css" `
        -OutputFile "$BUILD_DIR\assets\css\design-system.min.css"
    
    # Update HTML files to use minified version
    $HtmlFiles = Get-ChildItem -Path $BUILD_DIR -Recurse -Filter "*.html" -File
    foreach ($File in $HtmlFiles) {
        $Content = Get-Content $File.FullName -Raw
        $Content = $Content -replace 'design-system\.css', 'design-system.min.css'
        Set-Content -Path $File.FullName -Value $Content -Encoding UTF8 -NoNewline
    }
    Write-Host "  ✓ CSS minified and HTML references updated" -ForegroundColor Green
} else {
    Copy-Item "$ZYRAKON_ROOT\assets\css\design-system.css" "$BUILD_DIR\assets\css\design-system.css" -Force
    Write-Host "  ✓ CSS copied (no minification)" -ForegroundColor Green
}

# ----------------------------------------------------------------------------
# Step 4: Minify JavaScript
# ----------------------------------------------------------------------------
Write-Host "[4/6] Minifying JavaScript..." -ForegroundColor Yellow

if ($Minify) {
    Copy-Item "$ZYRAKON_ROOT\assets\js\main.js" "$BUILD_DIR\assets\js\main.js" -Force
    
    & "$ZYRAKON_ROOT\scripts\minify-js.ps1" `
        -InputFile "$ZYRAKON_ROOT\assets\js\main.js" `
        -OutputFile "$BUILD_DIR\assets\js\main.min.js"
    
    $HtmlFiles = Get-ChildItem -Path $BUILD_DIR -Recurse -Filter "*.html" -File
    foreach ($File in $HtmlFiles) {
        $Content = Get-Content $File.FullName -Raw
        $Content = $Content -replace 'main\.js', 'main.min.js'
        Set-Content -Path $File.FullName -Value $Content -Encoding UTF8 -NoNewline
    }
    Write-Host "  ✓ JavaScript minified and HTML references updated" -ForegroundColor Green
} else {
    Copy-Item "$ZYRAKON_ROOT\assets\js\main.js" "$BUILD_DIR\assets\js\main.js" -Force
    Write-Host "  ✓ JavaScript copied (no minification)" -ForegroundColor Green
}

# ----------------------------------------------------------------------------
# Step 5: Remove dev files from build
# ----------------------------------------------------------------------------
Write-Host "[5/6] Cleaning dev files from build..." -ForegroundColor Yellow

$DevFiles = @(
    "$BUILD_DIR\pages\responsive-test.html",
    "$BUILD_DIR\pages\animation-demo.html",
    "$BUILD_DIR\test-styled.html"
)

foreach ($File in $DevFiles) {
    if (Test-Path $File) {
        Remove-Item $File -Force
        Write-Host "  ✓ Removed: $(Split-Path $File -Leaf)"
    }
}

Write-Host "  ✓ Dev files cleaned" -ForegroundColor Green

# ----------------------------------------------------------------------------
# Step 6: Build summary
# ----------------------------------------------------------------------------
Write-Host "[6/6] Generating build summary..." -ForegroundColor Yellow

$EndTime = Get-Date
$Duration = $EndTime - $StartTime

# Count files
$TotalFiles = (Get-ChildItem -Path $BUILD_DIR -Recurse -File).Count
$TotalSize = (Get-ChildItem -Path $BUILD_DIR -Recurse -File | Measure-Object -Property Length -Sum).Sum
$TotalSizeMB = [math]::Round($TotalSize / 1MB, 2)

# Create build info
$BuildInfo = @"
Build Date: $($EndTime.ToString('yyyy-MM-dd HH:mm:ss'))
Build Duration: $([math]::Round($Duration.TotalSeconds, 1))s
Total Files: $TotalFiles
Total Size: $TotalSizeMB MB
Minification: $Minify
"@
Set-Content -Path "$BUILD_DIR\build-info.txt" -Value $BuildInfo -Encoding UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host " BUILD COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Duration:    $([math]::Round($Duration.TotalSeconds, 1))s" -ForegroundColor White
Write-Host "Files:       $TotalFiles" -ForegroundColor White
Write-Host "Size:        $TotalSizeMB MB" -ForegroundColor White
Write-Host "Output:      $BUILD_DIR" -ForegroundColor White
Write-Host "Minified:    $Minify" -ForegroundColor White
Write-Host ""
Write-Host "Deploy the 'dist' folder to your web server." -ForegroundColor Yellow
