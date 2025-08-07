# DWAgent Stealth Configuration Tool

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)
![Version](https://img.shields.io/badge/version-1.0-green.svg)

A powerful batch script that configures [DWService](https://www.dwservice.net/en/home.html) for stealth operation, hiding it from system views while maintaining full functionality.

## About DWService

DWService is a free remote management service that allows you to securely access and control remote computers through any browser. It provides features like:

- Remote desktop control
- File transfer
- Command shell access
- System monitoring
- Process management

This script enhances DWService by making it virtually invisible on the target system.

## Features

### 🔒 Configuration Updates
- Modifies DWAgent configuration to disable tray icons
- Sets desktop notifications to "autohide" mode
- Applies custom configuration settings for optimal stealth operation

### 🕵️ Stealth Capabilities
- Hides DWAgent from the uninstall programs list
- Removes DWAgent shortcuts from the Start Menu
- Hides desktop shortcuts while preserving functionality
- Makes the service completely invisible to casual system inspection

### 🛡️ Safety Features
- Creates automatic backups before making changes
- Checks for administrator privileges before execution
- Verifies existing configurations to avoid unnecessary changes
- Only restarts services when absolutely necessary

## Requirements

- Windows operating system
- DWAgent installed (from https://www.dwservice.net/)
- Administrator privileges to run the script

## Installation & Usage

1. Download the latest DWAgent from [DWService.net](https://www.dwservice.net/)
2. Install DWAgent on your target system
3. Download `DWAgent-Tools.bat`
4. Right-click on the script and select "Run as administrator"
5. Follow the on-screen instructions

The script will automatically:
- Check if it is running with administrator privileges
- Verify that DWAgent is installed
- Create a backup of existing configuration files
- Apply stealth configurations
- Hide DWAgent from system views
- Restart the service if needed

## How It Works

### Configuration Modification
The script modifies two key files:

1. **config.json**: Updates the configuration to:
   - Disable tray icons (`"monitor_tray_icon": false`)
   - Set desktop notifications to none (`"monitor_desktop_notification": "none"`)
   - Apply custom connection settings

2. **monitor.py**: Changes the notification behavior to "autohide" for additional stealth

### System Integration
The script makes several system changes to hide DWAgent:

1. **Registry Modification**: Adds the `SystemComponent` flag to the uninstall registry entry
2. **Start Menu Cleanup**: Removes all DWAgent shortcuts and folders
3. **Desktop Shortcut Hiding**: Sets the hidden attribute on any desktop shortcuts

### Backup System
Before making any changes, the script creates a timestamped backup folder at `C:\DWAgent_Backup_YYYYMMDD_HHMM` containing:
- Original config.json (if modified)
- Original monitor.py (if modified)

## Technical Details

### File Locations
- DWAgent Directory: `C:\Program Files\DWAgent`
- Configuration File: `C:\Program Files\DWAgent\config.json`
- Monitor File: `C:\Program Files\DWAgent\ui\monitor.py`

### Registry Changes
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DWAgent
SystemComponent = 1 (DWORD)
```

## Troubleshooting

### "Please run this script as administrator!"
The script requires administrator privileges to modify system files and registry settings. Right-click the script and select "Run as administrator".

### "DWAgent directory not found"
Ensure that DWAgent is properly installed on your system before running this script.

### Service fails to restart
If the DWAgent service fails to restart after configuration changes, you can manually restart it:
1. Open Services (services.msc)
2. Find "DWAgent" in the list
3. Right-click and select "Restart"

## Legal Disclaimer

This tool is provided for educational and legitimate administrative purposes only. The user is responsible for complying with all applicable laws and regulations. The author is not responsible for any misuse of this software.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please open an issue on the GitHub repository.
