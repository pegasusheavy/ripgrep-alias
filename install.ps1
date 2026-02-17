# Install ripgrep GNU grep -E compatibility wrapper.
# Usage:
#   irm https://raw.githubusercontent.com/pegasusheavy/ripgrep-alias/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'

$Repo     = 'pegasusheavy/ripgrep-alias'
$Branch   = 'main'
$RawUrl   = "https://raw.githubusercontent.com/$Repo/$Branch/rg.ps1"
$InstallDir = Join-Path $HOME '.local/share/ripgrep-alias'
$InstallFile = Join-Path $InstallDir 'rg.ps1'

# --- preflight ----------------------------------------------------------------

$rgExe = Get-Command rg -CommandType Application -ErrorAction SilentlyContinue
if (-not $rgExe) {
    Write-Error "ripgrep (rg) is not installed. Install it first."
    return
}

# --- download -----------------------------------------------------------------

New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Write-Host "  > Downloading rg.ps1 to $InstallDir" -ForegroundColor Cyan
Invoke-WebRequest -Uri $RawUrl -OutFile $InstallFile -UseBasicParsing

# --- detect profile -----------------------------------------------------------

$ProfilePath = $PROFILE.CurrentUserCurrentHost
$ProfileDir  = Split-Path $ProfilePath -Parent

if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
}
if (-not (Test-Path $ProfilePath)) {
    New-Item -ItemType File -Path $ProfilePath -Force | Out-Null
}

$SourceLine = ". `"$InstallFile`""

# --- patch profile ------------------------------------------------------------

$Content = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
if ($Content -and $Content.Contains('ripgrep-alias')) {
    Write-Host "  > Already present in $ProfilePath, skipping." -ForegroundColor Cyan
} else {
    Add-Content -Path $ProfilePath -Value @"

# ripgrep: consume GNU grep -E so it behaves like --extended-regexp
$SourceLine
"@
    Write-Host "  > Added source line to $ProfilePath" -ForegroundColor Green
}

# --- done ---------------------------------------------------------------------

Write-Host "  > Installed." -ForegroundColor Green
Write-Host "  > Restart PowerShell or run:  . $ProfilePath" -ForegroundColor Cyan
