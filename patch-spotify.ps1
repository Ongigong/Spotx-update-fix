# SpotX Compatibility Fix for New Spotify (xpui folder -> xpui.spa)
# Run this script as Administrator in PowerShell

$appsPath = "$env:APPDATA\Spotify\Apps"
$xpuiFolder = "$appsPath\xpui"
$xpuiSpa = "$appsPath\xpui.spa"
$backupFolder = "$appsPath\xpui.backup"

Write-Host "`n[1/5] Checking Spotify install..." -ForegroundColor Cyan

if (-not (Test-Path $xpuiFolder)) {
    Write-Host "ERROR: xpui folder not found at $xpuiFolder" -ForegroundColor Red
    Write-Host "Make sure Spotify (standalone, not Store version) is installed." -ForegroundColor Yellow
    pause; exit 1
}

# Close Spotify if running
$spotify = Get-Process -Name "Spotify" -ErrorAction SilentlyContinue
if ($spotify) {
    Write-Host "[*] Closing Spotify..." -ForegroundColor Yellow
    Stop-Process -Name "Spotify" -Force
    Start-Sleep -Seconds 2
}

Write-Host "[2/5] Backing up xpui folder..." -ForegroundColor Cyan
if (Test-Path $backupFolder) { Remove-Item $backupFolder -Recurse -Force }
Copy-Item $xpuiFolder $backupFolder -Recurse
Write-Host "    Backup saved to $backupFolder" -ForegroundColor Green

Write-Host "[3/5] Creating xpui.spa from xpui folder..." -ForegroundColor Cyan
if (Test-Path $xpuiSpa) { Remove-Item $xpuiSpa -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($xpuiFolder, $xpuiSpa)
Write-Host "    Created xpui.spa ($([Math]::Round((Get-Item $xpuiSpa).Length / 1MB, 2)) MB)" -ForegroundColor Green

Write-Host "[4/5] Running SpotX..." -ForegroundColor Cyan
iex "& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') }"

Write-Host "[5/5] Extracting patched xpui.spa back to xpui folder..." -ForegroundColor Cyan
if (Test-Path $xpuiFolder) { Remove-Item $xpuiFolder -Recurse -Force }
[System.IO.Compression.ZipFile]::ExtractToDirectory($xpuiSpa, $xpuiFolder)
Remove-Item $xpuiSpa -Force
Write-Host "    Done! Extracted patched files back to xpui folder." -ForegroundColor Green

Write-Host "`nAll done! Launch Spotify." -ForegroundColor Green
pause
