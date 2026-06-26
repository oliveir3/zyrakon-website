# Zyrakon Website - Cloudflare Pages Deployment Guide

## Architecture
- **Source Control:** GitHub (https://github.com/oliveir3/zyrakon-website)
- **Hosting:** Cloudflare Pages
- **Domain:** zyrakon.com (once approved)
- **CI/CD:** GitHub Actions → Cloudflare Pages

## Initial Setup (One-Time)

### 1. Install Wrangler CLI
`ash
npm install -g wrangler
`

### 2. Login to Cloudflare
`ash
wrangler login
`

### 3. Create Cloudflare Pages Project
`ash
wrangler pages project create zyrakon-website
`

### 4. Set GitHub Secrets
Add these to your GitHub repo (Settings → Secrets and variables → Actions):
- CLOUDFLARE_API_TOKEN - Your Cloudflare API token
- CLOUDFLARE_ACCOUNT_ID - Your Cloudflare account ID

## Deploy

### Manual Deploy (from local)
`powershell
.\scripts\build-cloudflare.ps1
npx wrangler pages deploy dist-cloudflare --project-name=zyrakon-website
`

### Automatic Deploy
Push to main branch → GitHub Actions deploys to Cloudflare Pages.

## Custom Domain (After Company Approval)
`ash
wrangler pages project set-domains zyrakon-website zyrakon.com
`

## DNS Setup (Cloudflare Dashboard)
1. Add CNAME record: @ → zyrakon-website.pages.dev
2. Add CNAME record: www → zyrakon-website.pages.dev
3. Enable proxy (orange cloud)
4. SSL/TLS: Full (strict)

## Cloudflare Features to Enable
- [ ] Auto Minify (CSS, JS, HTML)
- [ ] Brotli compression
- [ ] Early Hints
- [ ] Crawler Hints
- [ ] Automatic HTTPS rewrites
- [ ] Security Level: Medium
- [ ] Bot Fight Mode: On
- [ ] Email obfuscation

## Post-Deployment Checklist
- [ ] Site loads at zyrakon.com
- [ ] HTTPS works (automatic with Cloudflare)
- [ ] www redirects to apex
- [ ] 404 page works
- [ ] robots.txt accessible
- [ ] sitemap.xml accessible
- [ ] llms.txt accessible
- [ ] Run Lighthouse audit
