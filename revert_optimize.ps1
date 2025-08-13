Write-Host "=== Starting Revert of PC Cleanup & Optimization ===" -ForegroundColor Cyan

# 1. Re-enable SysMain (Superfetch) Service
Write-Host "Re-enabling SysMain service..." -ForegroundColor Yellow
Set-Service SysMain -StartupType Automatic
Start-Service SysMain -ErrorAction SilentlyContinue

# 2. Re-enable Windows Search Service
Write-Host "Re-enabling Windows Search service..." -ForegroundColor Yellow
Set-Service WSearch -StartupType Automatic
Start-Service WSearch -ErrorAction SilentlyContinue

# 3. Re-enable Windows Error Reporting Service (WerSvc)
Write-Host "Re-enabling Windows Error Reporting service..." -ForegroundColor Yellow
Set-Service WerSvc -StartupType Manual
Start-Service WerSvc -ErrorAction SilentlyContinue

# 4. Set Power Plan back to Balanced
Write-Host "Setting Power Plan back to Balanced..." -ForegroundColor Yellow
powercfg -setactive SCHEME_BALANCED

# 5. Enable Xbox Game Bar & Game DVR
Write-Host "Enabling Xbox Game Bar & Game DVR..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\GameBar" -Name "GamePanelStartupTipIndex" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -ErrorAction SilentlyContinue

# 6. Enable Windows Tips & Notifications
Write-Host "Enabling Windows Tips & Notifications..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 1 -ErrorAction SilentlyContinue

# 7. Enable Windows Feedback & Telemetry
Write-Host "Enabling Windows Feedback & Telemetry..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf" -Name "ConsentPromptBehaviorOverride" -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf" -Name "UECConsent" -Value 1 -ErrorAction SilentlyContinue

# 8. Set File Explorer to Hide File Extensions (default)
Write-Host "Hiding file extensions in File Explorer..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 1

# 9. Enable Sticky Keys Prompt
Write-Host "Enabling Sticky Keys prompt..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value 510

# 10. Enable Windows Tips at Login Screen
Write-Host "Enabling tips at login screen..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 0 -Type DWord -Force

# 11. Enable Windows Animations
Write-Host "Enabling Windows animations..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 1

# 12. Set Menu Show Delay Speed to default (400 ms)
Write-Host "Resetting menu show delay to default..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 400

# 13. Enable Notification Center (Action Center)
Write-Host "Enabling Notification Center..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Value 0 -Type DWord -Force

# 14. Revert TCP network tweaks (delete keys)
Write-Host "Removing TCP network tweaks..." -ForegroundColor Yellow
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "Tcp1323Opts" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -ErrorAction SilentlyContinue

Write-Host "=== Revert Complete! A restart is recommended. ===" -ForegroundColor Green
