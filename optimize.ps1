Write-Host "=== Starting PC Cleanup & Optimization ===" -ForegroundColor Cyan

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

# 4. Clear Prefetch Files
Write-Host "Clearing Prefetch files..." -ForegroundColor Yellow
Remove-Item "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

# 5. Disable Startup Apps
Write-Host "Disabling common startup apps..." -ForegroundColor Yellow
Get-CimInstance Win32_StartupCommand | ForEach-Object {
    Write-Host " Disabling: $($_.Name)"
    $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    Remove-ItemProperty -Path $path -Name $_.Name -ErrorAction SilentlyContinue
}

# 6. Clear Thumbnail Cache
Write-Host "Clearing Thumbnail Cache..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

# 7. Optimize Drives (Defrag / TRIM)
Write-Host "Optimizing drives..." -ForegroundColor Yellow
Get-Volume | Where-Object DriveType -eq 'Fixed' | ForEach-Object {
    Optimize-Volume -DriveLetter $_.DriveLetter -ReTrim -ErrorAction SilentlyContinue
}

# 8. Clear Old Windows Error Reports
Write-Host "Clearing Error Reports..." -ForegroundColor Yellow
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue

# 9. Disable Game DVR & Xbox Game Bar (Performance boost)
Write-Host "Disabling Xbox Game Bar & DVR..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "GamePanelStartupTipIndex" -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0

# 10. Flush DNS Cache
Write-Host "Flushing DNS Cache..." -ForegroundColor Yellow
Clear-DnsClientCache

Write-Host "=== Optimization Complete! Restart recommended. ===" -ForegroundColor Green
