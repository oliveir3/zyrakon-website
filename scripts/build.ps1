# Zyrakon Production Build
$ZYRAKON_ROOT = "C:\Projects\zyrakon"
$BUILD_DIR = "$ZYRAKON_ROOT\dist"

Write-Host "Building Zyrakon for production..." -ForegroundColor Cyan

if (Test-Path $BUILD_DIR) { Remove-Item -Recurse -Force $BUILD_DIR }
New-Item -ItemType Directory -Force -Path $BUILD_DIR | Out-Null

# Copy core files
Copy-Item "$ZYRAKON_ROOT\index.html" $BUILD_DIR -Force
Copy-Item "$ZYRAKON_ROOT\robots.txt" $BUILD_DIR -Force -ErrorAction SilentlyContinue
Copy-Item "$ZYRAKON_ROOT\sitemap.xml" $BUILD_DIR -Force -ErrorAction SilentlyContinue
Copy-Item "$ZYRAKON_ROOT\llms.txt" $BUILD_DIR -Force -ErrorAction SilentlyContinue
Copy-Item "$ZYRAKON_ROOT\llms-full.txt" $BUILD_DIR -Force -ErrorAction SilentlyContinue
Copy-Item "$ZYRAKON_ROOT\_headers" $BUILD_DIR -Force -ErrorAction SilentlyContinue
Copy-Item "$ZYRAKON_ROOT\_redirects" $BUILD_DIR -Force -ErrorAction SilentlyContinue

# Copy directories
@("pages", "assets", "components", ".well-known") | ForEach-Object {
    $src = Join-Path $ZYRAKON_ROOT $_
    $dst = Join-Path $BUILD_DIR $_
    if (Test-Path $src) { Copy-Item $src $dst -Recurse -Force }
}

# Remove dev files
@("$BUILD_DIR\pages\responsive-test.html", "$BUILD_DIR\pages\animation-demo.html", "$BUILD_DIR\test-styled.html", "$BUILD_DIR\visual-test.html") | ForEach-Object {
    if (Test-Path $_) { Remove-Item $_ -Force }
}

# Count
$files = (Get-ChildItem $BUILD_DIR -Recurse -File).Count
Write-Host "Built $files files to dist/" -ForegroundColor Green
