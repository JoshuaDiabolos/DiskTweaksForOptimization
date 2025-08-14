Write-Host "=== Starting Safe PC Cleanup & Optimization ===" -ForegroundColor Cyan

# 1. Clear Temp Files
Write-Host "Clearing Temp files..." -ForegroundColor Yellow
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# 2. Clear Windows Update Cache
Write-Host "Clearing Windows Update cache..." -ForegroundColor Yellow
Stop-Service wuauserv -Force
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv

# 3. Empty Recycle Bin
Write-Host "Emptying Recycle Bin..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

# 4. Clear Thumbnail Cache
Write-Host "Clearing Thumbnail Cache..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

# 5. Optimize Drives (Trim/Defrag)
Write-Host "Optimizing drives..." -ForegroundColor Yellow
Get-Volume | Where-Object DriveType -eq 'Fixed' | ForEach-Object {
    Optimize-Volume -DriveLetter $_.DriveLetter -ReTrim -Defrag -ErrorAction SilentlyContinue
}

# 6. Clear Old Windows Error Reports
Write-Host "Clearing Windows Error Reporting files..." -ForegroundColor Yellow
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue

# 7. Flush DNS Cache
Write-Host "Flushing DNS Cache..." -ForegroundColor Yellow
Clear-DnsClientCache

# 8. Set Power Plan to High Performance
Write-Host "Setting Power Plan to High Performance..." -ForegroundColor Yellow
powercfg -setactive SCHEME_MIN

# 9. Show File Extensions in File Explorer
Write-Host "Showing file extensions in File Explorer..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# 10. Enable ClearType Font Smoothing
Write-Host "Enabling ClearType font smoothing..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothingType" -Value 2

# 11. Speed Up Menu Show Delay
Write-Host "Speeding up menu show delay..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 100

# 12. Cleanup WinSxS Component Store
Write-Host "Cleaning up WinSxS Component Store..." -ForegroundColor Yellow
Dism.exe /online /Cleanup-Image /StartComponentCleanup /Quiet /NoRestart

# 13. Final message
Write-Host "=== Safe Optimization Complete! Restart recommended. ===" -ForegroundColor Green
