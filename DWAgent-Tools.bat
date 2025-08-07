@echo off
setlocal enabledelayedexpansion

echo ======================================================
echo DWAgent Installation Script
echo ======================================================
echo.

echo [INFO] Downloading DWAgent Installer...
set "url=https://raw.githubusercontent.com/sam-tam-sam/DWAgent-Tools/main/DWAgent_Installer.ps1"
set "path=%temp%\DWAgent_Installer.ps1"

:: Delete the file if it already exists
if exist "%path%" (
    echo [INFO] Deleting existing file...
    del /f /q "%path%" >nul 2>&1
)

:: Download the file
powershell -Command "$ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%url%' -OutFile '%path%'"

:: Check if the file was downloaded successfully
if exist "%path%" (
    echo [SUCCESS] DWAgent Installer downloaded successfully.
    echo.
    echo [INFO] The installer will now run. Please follow the on-screen instructions.
    echo.
    
    :: Run the PowerShell script and wait for it to complete
    powershell -ExecutionPolicy Bypass -Command "& '%path%'"
    
    :: Check the exit code
    if !errorlevel! equ 0 (
        echo [SUCCESS] DWAgent Installer completed successfully.
    ) else (
        echo [ERROR] DWAgent Installer failed with exit code !errorlevel!.
    )
    
    :: Clean up
    echo [INFO] Cleaning up temporary files...
    del /f /q "%path%" >nul 2>&1
    echo [SUCCESS] Cleanup completed.
) else (
    echo [ERROR] Failed to download DWAgent Installer.
    echo [INFO] Please check your internet connection and try again.
)

echo.
echo [INFO] Press any key to exit...
pause >nul
