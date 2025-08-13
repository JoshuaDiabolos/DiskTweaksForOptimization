Write-Host "=== Starting Extended PC Cleanup & Optimization ===" -ForegroundColor Cyan

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

# 5. Disable Common Startup Apps (Current User)
Write-Host "Disabling common startup apps..." -ForegroundColor Yellow
$runPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty -Path $runPath | ForEach-Object {
    $_.PSObject.Properties | Where-Object {
        $_.Name -ne "PSPath" -and $_.Name -ne "PSParentPath" -and $_.Name -ne "PSChildName" -and $_.Name -ne "PSDrive" -and $_.Name -ne "PSProvider"
    } | ForEach-Object {
        Write-Host " Disabling startup app: $($_.Name)"
        Remove-ItemProperty -Path $runPath -Name $_.Name -ErrorAction SilentlyContinue
    }
}

# 6. Clear Thumbnail Cache
Write-Host "Clearing Thumbnail Cache..." -ForegroundColor Yellow
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
Start-Process explorer.exe

# 7. Optimize Drives (ReTrim & Defrag SSD/HDD)
Write-Host "Optimizing drives..." -ForegroundColor Yellow
Get-Volume | Where-Object DriveType -eq 'Fixed' | ForEach-Object {
    Optimize-Volume -DriveLetter $_.DriveLetter -ReTrim -Defrag -ErrorAction SilentlyContinue
}

# 8. Clear Old Windows Error Reports
Write-Host "Clearing Windows Error Reporting files..." -ForegroundColor Yellow
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue

# 9. Flush DNS Cache
Write-Host "Flushing DNS Cache..." -ForegroundColor Yellow
Clear-DnsClientCache

# 10. Disable Xbox Game Bar & Game DVR (Performance boost)
Write-Host "Disabling Xbox Game Bar & Game DVR..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "GamePanelStartupTipIndex" -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue

# 11. Set Power Plan to High Performance (Current User)
Write-Host "Setting Power Plan to High Performance..." -ForegroundColor Yellow
powercfg -setactive SCHEME_MIN

# 12. Disable Windows Tips & Notifications
Write-Host "Disabling Windows Tips & Notifications..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 0 -ErrorAction SilentlyContinue

# 13. Disable SysMain (Superfetch) Service (can improve SSD performance)
Write-Host "Disabling SysMain service..." -ForegroundColor Yellow
Stop-Service SysMain -Force -ErrorAction SilentlyContinue
Set-Service SysMain -StartupType Disabled

# 14. Disable Windows Search Indexing (if you don’t use Search often)
Write-Host "Disabling Windows Search service..." -ForegroundColor Yellow
Stop-Service WSearch -Force -ErrorAction SilentlyContinue
Set-Service WSearch -StartupType Disabled

# 15. Increase Network Throughput (TCP Optimizations)
Write-Host "Optimizing TCP network settings..." -ForegroundColor Yellow
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Tcp1323Opts" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -PropertyType DWord -Value 1 -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -PropertyType DWord -Value 1 -Force | Out-Null

# 16. Disable Windows Feedback & Telemetry
Write-Host "Disabling Windows Feedback & Telemetry..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf" -Name "ConsentPromptBehaviorOverride" -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf" -Name "UECConsent" -Value 0 -ErrorAction SilentlyContinue

# 17. Set File Explorer to Show File Extensions
Write-Host "Showing file extensions in File Explorer..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# 18. Disable Sticky Keys Prompt
Write-Host "Disabling Sticky Keys prompt..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value 506

# 19. Disable Windows Tips at Login Screen
Write-Host "Disabling tips at login screen..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord -Force

# 20. Remove Old Windows Update Files (winsxs)
Write-Host "Cleaning up WinSxS Component Store (this can take a while depending on disk space, usually 5-30 min, but its worth it!)..." -ForegroundColor Yellow
Dism.exe /online /Cleanup-Image /StartComponentCleanup /Quiet /NoRestart

# 21. Disable Animations for Faster UI
Write-Host "Disabling Windows animations..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0

# 22. Increase Menu Show Delay Speed
Write-Host "Speeding up menu show delay..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 100

# 23. Disable Automatic Restart after Updates
Write-Host "Disabling automatic restart after updates..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord -Force

# 24. Clear DNS Resolver Cache
Write-Host "Clearing DNS Resolver Cache..." -ForegroundColor Yellow
ipconfig /flushdns | Out-Null

# 25. Disable Windows Error Reporting Service
Write-Host "Disabling Windows Error Reporting Service..." -ForegroundColor Yellow
Stop-Service "WerSvc" -Force -ErrorAction SilentlyContinue
Set-Service "WerSvc" -StartupType Disabled

# 26. Clear Event Logs
Write-Host "Clearing Event Logs..." -ForegroundColor Yellow
wevtutil el | Foreach-Object {wevtutil cl $_}

# 27. Disable Notification Center (Action Center)
Write-Host "Disabling Notification Center..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Value 1 -Type DWord -Force

# 28. Clear Windows Defender Cache (if enabled)
Write-Host "Clearing Windows Defender cache..." -ForegroundColor Yellow
Remove-Item "$env:ProgramData\Microsoft\Windows Defender\Scans\History\*" -Recurse -Force -ErrorAction SilentlyContinue

# 29. Enable ClearType for better font rendering
Write-Host "Enabling ClearType font smoothing..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothingType" -Value 2

# 30. Final message
Write-Host "=== Extended Optimization Complete! Restart recommended. ===" -ForegroundColor Green
