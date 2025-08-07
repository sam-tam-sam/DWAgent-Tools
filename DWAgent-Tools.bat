powershell -Command "
# Display instructions and purpose
Write-Host '======================================================' -ForegroundColor Cyan
Write-Host 'DWAgent Tools Installation Script' -ForegroundColor Cyan
Write-Host '======================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'This script will:' -ForegroundColor Yellow
Write-Host '1. Download and create the DWAgent-Tools.bat file' -ForegroundColor Yellow
Write-Host '2. Execute the script with administrator privileges' -ForegroundColor Yellow
Write-Host '3. The script will configure DWAgent settings' -ForegroundColor Yellow
Write-Host '4. Automatically clean up after completion' -ForegroundColor Yellow
Write-Host ''
Write-Host 'Do you want to continue? (Y/N)' -ForegroundColor Magenta
$choice = Read-Host

if ($choice -eq 'Y' -or $choice -eq 'y') {
    try {
        # Create the batch file content
        $batchContent = @'
@echo off
:: DWAgent Configuration Script
:: This script configures DWAgent settings

echo ======================================================
echo DWAgent Configuration Script
echo ======================================================
echo.
echo This script will configure DWAgent settings on your system.
echo.

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script requires administrator privileges.
    echo Please run this script as administrator.
    pause
    exit /b 1
)

echo [INFO] Running with administrator privileges...
echo.

:: Add your DWAgent configuration commands here
echo [INFO] Configuring DWAgent settings...

:: Example configuration commands (replace with your actual commands)
:: echo [INFO] Setting up DWAgent service...
:: sc config DWAgent start= auto
:: echo [INFO] Starting DWAgent service...
:: net start DWAgent

:: Simulate configuration process
echo [INFO] Applying configuration settings...
timeout /t 2 /nobreak >nul
echo [INFO] Configuration step 1 completed...
timeout /t 2 /nobreak >nul
echo [INFO] Configuration step 2 completed...
timeout /t 2 /nobreak >nul
echo [INFO] Configuration step 3 completed...
timeout /t 2 /nobreak >nul

echo.
echo [SUCCESS] DWAgent configuration completed successfully!
echo.

:: Return success exit code
exit /b 0
'@

        Write-Host 'Creating DWAgent-Tools.bat...' -ForegroundColor Green
        $tempFile = '$env:temp\DWAgent-Tools.bat'
        $batchContent | Out-File -FilePath $tempFile -Encoding ASCII
        Write-Host 'File created successfully.' -ForegroundColor Green
        
        Write-Host 'Executing DWAgent-Tools.bat with administrator privileges...' -ForegroundColor Green
        $process = Start-Process -FilePath $tempFile -Verb RunAs -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host 'DWAgent-Tools.bat executed successfully.' -ForegroundColor Green
        } else {
            Write-Host 'DWAgent-Tools.bat completed with exit code: ' $process.ExitCode -ForegroundColor Yellow
        }
        
        Write-Host 'Cleaning up temporary files...' -ForegroundColor Green
        Remove-Item $tempFile -ErrorAction SilentlyContinue
        Write-Host 'Temporary files cleaned up successfully.' -ForegroundColor Green
        
        Write-Host 'Operation completed successfully!' -ForegroundColor Green
    } catch {
        Write-Host 'An error occurred:' -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        
        Write-Host 'Attempting to clean up temporary files...' -ForegroundColor Yellow
        Remove-Item '$env:temp\DWAgent-Tools.bat' -ErrorAction SilentlyContinue
    }
} else {
    Write-Host 'Operation cancelled by user.' -ForegroundColor Yellow
}

Read-Host 'Press Enter to exit'
"
