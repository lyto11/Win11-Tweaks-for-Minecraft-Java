@echo off
setlocal enabledelayedexpansion
title Minecraft Win11 Optimizer v2.1.0
color 0B

:: ======================================================
:: VERSION HEADER & CHANGELOG
:: ======================================================
:: Version: 2.1.0
:: Date: 2023-11-22
:: Changelog:
:: - Implemented sophisticated backup system in Program Files with fallback to ProgramData.
:: - Added directory structure: Backups, Logs, Manifests, OldVersions.
:: - Added Maintenance menu for script updates and health checks.
:: - Enhanced logging and manifest tracking.
:: - Preserved all core "Keep List" features.
:: ======================================================

:: Admin Check & Auto-Elevation
:ADMIN_CHECK
fltmc >nul 2>&1 || (
    echo [INFO] Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

:: Setup Backup Directories
set "VERSION=2.1.0"
set "B_ROOT=C:\Program Files\Minecraft Win11 Backup"
mkdir "!B_ROOT!" >nul 2>&1
if !errorlevel! neq 0 (
    echo [WARNING] Could not write to Program Files. Falling back to ProgramData...
    set "B_ROOT=%ProgramData%\Minecraft Win11 Backup"
    mkdir "!B_ROOT!" >nul 2>&1
)

set "DIR_BACKUPS=!B_ROOT!\Backups"
set "DIR_LOGS=!B_ROOT!\Logs"
set "DIR_MANIFESTS=!B_ROOT!\Manifests"
set "DIR_OLD=!B_ROOT!\OldVersions"

for %%d in ("!DIR_BACKUPS!" "!DIR_LOGS!" "!DIR_MANIFESTS!" "!DIR_OLD!") do (
    if not exist %%d mkdir %%d
)

set "LOGFILE=!DIR_LOGS!\MC_Optimizer_Log.txt"
set "MANIFEST=!DIR_MANIFESTS!\MC_Optimizer_Manifest.txt"

if not exist "!MANIFEST!" (
    echo Version=!VERSION! > "!MANIFEST!"
    echo InstallDate=!DATE! !TIME! >> "!MANIFEST!"
)

echo [%DATE% %TIME%] --- Session Started (v!VERSION!) --- >> "!LOGFILE!"

:MAIN_MENU
cls
echo ======================================================
echo           MINECRAFT WIN11 OPTIMIZER v!VERSION!
echo ======================================================
echo  Backup Location: !B_ROOT!
echo ------------------------------------------------------
echo  0. RUN ALL OPTIMIZATIONS (Max Performance + Cleanup)
echo  1. Apply Recommended Minecraft Optimizations
echo  2. Apply Low-End PC Optimizations
echo  3. Apply Streaming + Minecraft Optimizations
echo  4. Run Deep System Cleanup ^& Network Reset
echo  5. Show Minecraft Tips ^& Java Arguments
echo  6. Maintenance ^& Updates
echo  7. Create System Restore Point (Optional)
echo  8. View Log
echo  9. Exit
echo ======================================================
set /p menu_choice="Select an option (0-9): "

if "%menu_choice%"=="0" goto RUN_ALL
if "%menu_choice%"=="1" goto RECOMMENDED
if "%menu_choice%"=="2" goto LOW_END
if "%menu_choice%"=="3" goto STREAMING
if "%menu_choice%"=="4" goto CLEANUP
if "%menu_choice%"=="5" goto TIPS
if "%menu_choice%"=="6" goto MAINTENANCE
if "%menu_choice%"=="7" goto RESTORE_POINT
if "%menu_choice%"=="8" start "" notepad "!LOGFILE!" & goto MAIN_MENU
if "%menu_choice%"=="9" exit /b
goto MAIN_MENU

:MAINTENANCE
cls
echo [MAINTENANCE ^& UPDATES]
echo 1. Check for Script Updates (Simulation)
echo 2. Backup Current Scripts to OldVersions
echo 3. Verify Backup Integrity
echo 4. Back to Main Menu
echo.
set /p maint_choice="Select (1-4): "
if "%maint_choice%"=="1" (
    echo Checking for updates...
    echo No updates found. Script is v!VERSION!.
    pause
    goto MAINTENANCE
)
if "%maint_choice%"=="2" (
    set "ts=%DATE:/=-%_%TIME::=-%"
    set "ts=!ts: =_!"
    echo Backing up scripts...
    copy "%~f0" "!DIR_OLD!\Optimizer_Backup_!ts!.bat" >nul
    copy "%~dp0Minecraft-Win11-Revert.bat" "!DIR_OLD!\Revert_Backup_!ts!.bat" >nul
    echo Scripts backed up to OldVersions.
    pause
    goto MAINTENANCE
)
if "%maint_choice%"=="3" (
    echo Verifying directory structure...
    for %%d in ("!DIR_BACKUPS!" "!DIR_LOGS!" "!DIR_MANIFESTS!" "!DIR_OLD!") do (
        if exist %%d (echo [OK] %%d) else (echo [FAIL] %%d)
    )
    pause
    goto MAINTENANCE
)
goto MAIN_MENU

:RUN_ALL
cls
echo [RUN ALL OPTIMIZATIONS]
echo Applies Recommended + Low-End tweaks and runs Cleanup.
echo.
set /p confirm="Are you sure? (Y/N): "
if /i "%confirm%" neq "Y" goto MAIN_MENU

echo [%DATE% %TIME%] --- FULL OPTIMIZATION STARTED --- >> "!LOGFILE!"

:: Backup everything first
call :BACKUP_REGISTRY

echo Applying optimizations...
call :RECOMMENDED_SILENT
call :LOW_END_SILENT
call :CLEANUP_SILENT

echo AppliedAll=True >> "!MANIFEST!"
echo [%DATE% %TIME%] --- FULL OPTIMIZATION COMPLETED --- >> "!LOGFILE!"
echo All optimizations applied successfully!
pause
goto MAIN_MENU

:BACKUP_REGISTRY
echo Exporting registry backups...
if exist "!DIR_BACKUPS!\GameBar_Backup.reg" (
    set /p ov="Backup exists. Overwrite? (Y/N): "
    if /i "!ov!" neq "Y" exit /b
)
reg export "HKCU\Software\Microsoft\GameBar" "!DIR_BACKUPS!\GameBar_Backup.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "!DIR_BACKUPS!\Themes_Backup.reg" /y >nul 2>&1
reg export "HKCU\Control Panel\Desktop" "!DIR_BACKUPS!\Desktop_Backup.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "!DIR_BACKUPS!\GameDVR_Backup.reg" /y >nul 2>&1
reg export "HKLM\Software\Policies\Microsoft\Windows\DeliveryOptimization" "!DIR_BACKUPS!\DeliveryOpt_Backup.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "!DIR_BACKUPS!\SystemProfile_Backup.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "!DIR_BACKUPS!\SystemProfileTasks_Backup.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "!DIR_BACKUPS!\PowerThrottling_Backup.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "!DIR_BACKUPS!\MemoryManagement_Backup.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "!DIR_BACKUPS!\VisualEffects_Backup.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "!DIR_BACKUPS!\ContentDelivery_Backup.reg" /y >nul 2>&1
reg export "HKCU\Control Panel\Mouse" "!DIR_BACKUPS!\Mouse_Backup.reg" /y >nul 2>&1
reg export "HKCU\System\GameConfigStore" "!DIR_BACKUPS!\GameConfigStore_Backup.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "!DIR_BACKUPS!\Telemetry_Backup.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" "!DIR_BACKUPS!\ErrorReporting_Backup.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "!DIR_BACKUPS!\BackgroundApps_Backup.reg" /y >nul 2>&1
reg export "HKLM\System\CurrentControlSet\Control\PriorityControl" "!DIR_BACKUPS!\PriorityControl_Backup.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" "!DIR_BACKUPS!\Maps_Backup.reg" /y >nul 2>&1
exit /b

:RECOMMENDED
cls
echo [RECOMMENDED OPTIMIZATIONS]
echo 1.  Enable Windows Game Mode.
echo 2.  Set High Performance Power Plan ^& Disable Core Parking.
echo 3.  Disable Transparency Effects.
echo 4.  Disable Game DVR ^& Background Recording.
echo 5.  Disable Windows Delivery Optimization.
echo 6.  Disable Network Throttling ^& Optimize Responsiveness.
echo 7.  Set High GPU ^& CPU Priority for Games (MMCSS).
echo 8.  Disable Global Power Throttling.
echo 9.  Optimize Memory Management (Large System Cache ^& IO Lock).
echo 10. Disable Global Fullscreen Optimizations (FSO).
echo 11. Optimize BCDEdit (Disable Dynamic Tick ^& Synthetic Timers).
echo.
set /p confirm="Apply all Recommended tweaks? (Y/N): "
if /i "%confirm%" neq "Y" goto MAIN_MENU
call :BACKUP_REGISTRY
call :RECOMMENDED_SILENT
pause
goto MAIN_MENU

:LOW_END
cls
echo [LOW-END PC OPTIMIZATIONS]
echo 1.  All Recommended tweaks.
echo 2.  Adjust Visual Effects for Maximum Performance.
echo 3.  Disable Startup App Suggestions.
echo 4.  Disable Mouse Acceleration (1:1 Precision).
echo 5.  Disable Hibernation (Saves GBs of Disk Space).
echo 6.  Disable Windows Telemetry ^& Background Data.
echo 7.  Disable Search Indexing (Reduces Background CPU).
echo 8.  Disable Windows Error Reporting.
echo 9.  Disable Background Apps Execution.
echo 10. Disable Maps ^& Location Telemetry.
echo 11. Increase Win32 Priority Separation (Foreground Priority).
echo.
set /p confirm="Apply all Low-End tweaks? (Y/N): "
if /i "%confirm%" neq "Y" goto MAIN_MENU
call :BACKUP_REGISTRY
call :LOW_END_SILENT
pause
goto MAIN_MENU

:RECOMMENDED_SILENT
echo Enabling Game Mode...
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul
echo Setting Power Plan ^& Disabling Core Parking...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg /setactive scheme_current
echo Disabling Transparency...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul
echo Disabling Game DVR...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "HistoricalCaptureEnabled" /t REG_DWORD /d 0 /f >nul
echo Disabling Delivery Optimization...
reg add "HKLM\Software\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul
echo Optimizing System Profile...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul
echo Setting Task Priority (MMCSS)...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
echo Disabling Power Throttling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f >nul
echo Optimizing Memory Management...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 983040 /f >nul
echo Disabling Fullscreen Optimizations...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d 2 /f >nul
echo Optimizing BCDEdit...
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set useplatformclock no >nul 2>&1
echo [%DATE% %TIME%] Recommended tweaks applied silent >> "!LOGFILE!"
exit /b

:LOW_END_SILENT
echo Adjusting Visual Effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul
echo Disabling Startup Suggestions...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f >nul
echo Disabling Mouse Acceleration...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d 0 /f >nul
echo Disabling Hibernation...
powercfg /hibernate off
echo Disabling Telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
echo Disabling Search Indexer...
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
echo Disabling Error Reporting...
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f >nul
echo Disabling Background Apps...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul
echo Disabling Map Telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d 0 /f >nul
echo Setting Priority Separation...
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul
echo [%DATE% %TIME%] Low-end tweaks applied silent >> "!LOGFILE!"
exit /b

:STREAMING
cls
echo [STREAMING MODE]
echo Opens HAGS settings for manual adjustment.
start ms-settings:display-advancedgraphics
pause
goto MAIN_MENU

:CLEANUP
cls
echo [SYSTEM CLEANUP]
set /p confirm="Run cleanup? (Y/N): "
if /i "%confirm%" neq "Y" goto MAIN_MENU
call :CLEANUP_SILENT
pause
goto MAIN_MENU

:CLEANUP_SILENT
del /q /s /f "%TEMP%\*.*" >nul 2>&1
del /q /s /f "C:\Windows\Temp\*.*" >nul 2>&1
powershell.exe -command "Clear-RecycleBin -Confirm:$false" >nul 2>&1
ipconfig /flushdns >nul 2>&1
netsh winsock reset >nul 2>&1
echo [%DATE% %TIME%] Cleanup completed >> "!LOGFILE!"
exit /b

:RESTORE_POINT
echo Creating restore point...
powershell.exe -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'Before_MC_Optimization' -RestorePointType 'MODIFY_SETTINGS'"
pause
goto MAIN_MENU

:TIPS
cls
echo [MINECRAFT TIPS]
echo - RAM: 2-4GB Vanilla, 6-8GB Mods.
echo - MODS: Install Sodium / Lithium.
echo - Fullscreen: Use Fullscreen (F11) for best performance.
pause
goto MAIN_MENU
