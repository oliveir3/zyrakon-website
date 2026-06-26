# ============================================================================
# ZYRAKON - CLOUDFLARE PAGES BUILD SCRIPT
# Run locally or via Cloudflare Pages CI
# ============================================================================

$ErrorActionPreference = "Stop"
$ZYRAKON_ROOT = "C:\Projects\zyrakon"
$BUILD_DIR = "$ZYRAKON_ROOT\dist-cloudflare"

Write-Host "Zyrakon Cloudflare Pages Build" -ForegroundColor Cyan

# Clean
if (Test-Path $BUILD_DIR) { Remove-Item -Recurse -Force $BUILD_DIR }
New-Item -ItemType Directory -Force -Path $BUILD_DIR | Out-Null

# Copy all content
$CopyItems = @(
    "index.html",
    "pages",
    "assets",
    "components",
    "data",
    "robots.txt",
    "sitemap.xml",
    "llms.txt",
    "llms-full.txt",
    ".well-known",
    "_headers",
    "_redirects"
)

foreach ($Item in $CopyItems) {
    $Source = Join-Path $ZYRAKON_ROOT $Item
    if (Test-Path $Source) {
        $Dest = Join-Path $BUILD_DIR $Item
        Copy-Item -Path $Source -Destination $Dest -Recurse -Force
        Write-Host "  ✓ $Item"
    }
}

# Remove dev files
@("pages/responsive-test.html", "pages/animation-demo.html", "test-styled.html") | ForEach-Object {
    $Path = Join-Path $BUILD_DIR $_
    if (Test-Path $Path) { Remove-Item $Path -Force }
}

# Create 404 page
@"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Not Found | Zyrakon</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:'Inter',Arial,sans-serif;background:#0A1628;color:#fff;display:flex;align-items:center;justify-content:center;min-height:100vh;text-align:center}
        h1{font-size:6rem;color:#FF6B2B;margin-bottom:1rem}
        p{color:#94A3B8;margin-bottom:2rem;font-size:1.2rem}
        a{color:#FF6B2B;text-decoration:none;font-weight:600;font-size:1.1rem}
        a:hover{color:#FF8C42}
    </style>
</head>
<body>
    <div>
        <h1>404</h1>
        <p>The page you're looking for doesn't exist—yet.</p>
        <p style="font-size:0.9rem;margin-bottom:2rem">Maybe it's still being built. That's what foundations are for.</p>
        <a href="/">← Return to Zyrakon</a>
    </div>
</body>
</html>
"@ | Set-Content -Path "$BUILD_DIR\404.html" -Encoding UTF8

Write-Host ""
Write-Host "Build complete: $BUILD_DIR" -ForegroundColor Green
Write-Host "Deploy to Cloudflare Pages with: npx wrangler pages deploy dist-cloudflare" -ForegroundColor Yellow
