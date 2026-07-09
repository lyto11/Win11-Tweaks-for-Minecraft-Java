@echo off
setlocal enabledelayedexpansion
title Minecraft Win11 Revert v2.1.0
color 0B

:: Admin Check ^& Auto-Elevation
:ADMIN_CHECK
fltmc >nul 2>&1 || (
    echo [INFO] Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

:: Find Backup Directory
set "B_ROOT=C:\Program Files\Minecraft Win11 Backup"
if not exist "!B_ROOT!" (
    set "B_ROOT=%ProgramData%\Minecraft Win11 Backup"
)

if not exist "!B_ROOT!" (
    echo [ERROR] No backup directory found.
    pause
    exit /b
)

set "DIR_BACKUPS=!B_ROOT!\Backups"
set "LOGFILE=!B_ROOT!\Logs\MC_Optimizer_Log.txt"

echo ======================================================
echo           MINECRAFT WIN11 REVERT TOOL v2.1.0
echo ======================================================
echo  Backup Location: !B_ROOT!
echo ------------------------------------------------------
set /p confirm="Revert all changes? (Y/N): "
if /i "%confirm%" neq "Y" exit /b

echo [%DATE% %TIME%] --- REVERT STARTED --- >> "!LOGFILE!"

:: Restore Power Plan ^& Core Parking
echo Restoring Power Plan...
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg /setacvalueindex scheme_current sub_processor CPMINCORES 0
powercfg /setactive scheme_current

:: Re-enable Search Indexer
echo Re-enabling Search Indexer...
sc config WSearch start= delayed-auto >nul 2>&1
sc start WSearch >nul 2>&1

:: Re-enable Hibernation
echo Re-enabling Hibernation...
powercfg /hibernate on >nul 2>&1

:: BCDEdit Defaults
echo Restoring BCDEdit Defaults...
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1

:: Multimedia Profile Defaults
echo Restoring Multimedia Defaults...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul 2>&1

:: Import registry backups
if exist "!DIR_BACKUPS!" (
    echo Importing registry backups...
    for %%f in ("!DIR_BACKUPS!\*.reg") do (
        echo Importing %%~nxf...
        reg import "%%f" >nul 2>&1
    )
)

:: Hardcode restore core UI defaults
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 2 /f >nul 2>&1

echo.
echo ======================================================
echo                REVERT COMPLETE
echo ======================================================
echo [%DATE% %TIME%] --- REVERT COMPLETED --- >> "!LOGFILE!"
pause
