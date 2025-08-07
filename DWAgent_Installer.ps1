# DWAgent Installation Script
# This script downloads and executes the DWAgent configuration tool

# Display instructions and purpose
Write-Host '======================================================' -ForegroundColor Cyan
Write-Host 'DWAgent Tools Installation Script' -ForegroundColor Cyan
Write-Host '======================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'This script will:' -ForegroundColor Yellow
Write-Host '1. Download the DWAgent-Tools.bat file from GitHub' -ForegroundColor Yellow
Write-Host '2. Execute the script with administrator privileges' -ForegroundColor Yellow
Write-Host '3. The script will configure DWAgent settings' -ForegroundColor Yellow
Write-Host '4. Automatically clean up after completion' -ForegroundColor Yellow
Write-Host ''
Write-Host 'Do you want to continue? (Y/N)' -ForegroundColor Magenta
$choice = Read-Host

if ($choice -eq 'Y' -or $choice -eq 'y') {
    try {
        Write-Host 'Downloading DWAgent-Tools.bat...' -ForegroundColor Green
        $tempFile = '$env:temp\DWAgent-Tools.bat'
        $batUrl = 'https://raw.githubusercontent.com/sam-tam-sam/DWAgent-Tools/main/DWAgent-Tools.bat'
        
        # Try to download the file with multiple attempts
        $maxAttempts = 3
        $attempt = 1
        $downloadSuccess = $false
        
        while ($attempt -le $maxAttempts -and -not $downloadSuccess) {
            try {
                Write-Host "Download attempt $attempt of $maxAttempts..." -ForegroundColor Yellow
                Invoke-WebRequest -Uri $batUrl -OutFile $tempFile -ErrorAction Stop
                $downloadSuccess = $true
                Write-Host 'File downloaded successfully.' -ForegroundColor Green
            } catch {
                Write-Host "Download attempt $attempt failed: $($_.Exception.Message)" -ForegroundColor Red
                $attempt++
                if ($attempt -le $maxAttempts) {
                    Write-Host "Waiting 3 seconds before next attempt..." -ForegroundColor Yellow
                    Start-Sleep -Seconds 3
                }
            }
        }
        
        if (-not $downloadSuccess) {
            throw "Failed to download the file after $maxAttempts attempts."
        }
        
        # Check if file was downloaded successfully
        if (-not (Test-Path $tempFile)) {
            throw "File was not downloaded successfully."
        }
        
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
