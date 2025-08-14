Write-Host "=== Reverting All Optimizations to Windows Defaults ===" -ForegroundColor Cyan

# 1. Re-enable SysMain (Superfetch)
Write-Host "Re-enabling SysMain..." -ForegroundColor Yellow
Set-Service SysMain -StartupType Automatic
Start-Service SysMain

# 2. Re-enable Windows Search
Write-Host "Re-enabling Windows Search..." -ForegroundColor Yellow
Set-Service WSearch -StartupType Automatic
Start-Service WSearch

# 3. Re-enable Windows Error Reporting
Write-Host "Re-enabling Windows Error Reporting Service..." -ForegroundColor Yellow
Set-Service "WerSvc" -StartupType Manual
Start-Service "WerSvc"

# 4. Restore Xbox Game Bar & Game DVR
Write-Host "Restoring Xbox Game Bar & Game DVR..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "GamePanelStartupTipIndex" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -ErrorAction SilentlyContinue

# 5. Restore Notifications & Tips
Write-Host "Restoring Windows Tips & Notifications..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 0 -Type DWord -Force
Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue

# 6. Restore TCP Network Settings
Write-Host "Restoring TCP network settings..." -ForegroundColor Yellow
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Tcp1323Opts" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -ErrorAction SilentlyContinue

# 7. Restore Automatic Restart after Updates
Write-Host "Restoring automatic restart after updates..." -ForegroundColor Yellow
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -ErrorAction SilentlyContinue

# 8. Restore Sticky Keys default
Write-Host "Restoring Sticky Keys prompt..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value 510

# 9. Restore Windows animations
Write-Host "Restoring Windows animations..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 1

# 10. Restore menu show delay default
Write-Host "Restoring default menu delay..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 400

# 11. Restore File Explorer Hide Extensions (default)
Write-Host "Hiding file extensions in File Explorer (default)..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 1

# 12. Restore ClearType defaults
Write-Host "Restoring ClearType settings..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothingType" -Value 2

# 13. Restore Telemetry defaults
Write-Host "Restoring Windows Feedback & Telemetry..." -ForegroundColor Yellow
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf" -Name "ConsentPromptBehaviorOverride" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf" -Name "UECConsent" -ErrorAction SilentlyContinue

Write-Host "=== Reversion Complete! A restart is recommended. ===" -ForegroundColor Green
