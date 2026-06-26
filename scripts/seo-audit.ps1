# Zyrakon SEO Audit Script
# Run to check all pages for SEO completeness

$ZYRAKON_ROOT = "C:\Projects\zyrakon"
$Issues = @()

Write-Host "Zyrakon SEO Audit" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan

$Files = Get-ChildItem -Path $ZYRAKON_ROOT -Recurse -Filter "*.html" -File

foreach ($File in $Files) {
    $Content = Get-Content $File.FullName -Raw
    
    # Check title
    if ($Content -notmatch '<title>') {
        $Issues += "$($File.Name): Missing <title>"
    }
    
    # Check meta description
    if ($Content -notmatch '<meta name="description"') {
        $Issues += "$($File.Name): Missing meta description"
    }
    
    # Check viewport
    if ($Content -notmatch 'viewport') {
        $Issues += "$($File.Name): Missing viewport meta"
    }
    
    # Check OG tags
    if ($Content -notmatch 'og:title') {
        $Issues += "$($File.Name): Missing Open Graph tags"
    }
    
    # Check canonical
    if ($Content -notmatch 'canonical') {
        $Issues += "$($File.Name): Missing canonical URL"
    }
    
    # Check alt text on images
    $Images = [regex]::Matches($Content, '<img[^>]*>')
    foreach ($Img in $Images) {
        if ($Img.Value -notmatch 'alt=') {
            $Issues += "$($File.Name): Image missing alt text: $($Img.Value.Substring(0, [Math]::Min(80, $Img.Value.Length)))"
        }
    }
    
    # Check heading hierarchy
    if ($Content -notmatch '<h1') {
        $Issues += "$($File.Name): Missing H1 tag"
    }
}

Write-Host "`nFound $($Issues.Count) issues:" -ForegroundColor Yellow
$Issues | ForEach-Object { Write-Host "  $_" -ForegroundColor White }

Write-Host "`nChecked $($Files.Count) HTML files" -ForegroundColor Green
