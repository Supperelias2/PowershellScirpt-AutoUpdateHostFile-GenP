# Define variables for easy configuration
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$backupPath = "$scriptpath\HostfileBackup\"
$logpath = "$scriptpath\LOGS\"
$url = "https://a.dove.isdumb.one/list.txt"

function LogMessage {
    param (
        [string]$message
    )
     # Ensure that the LOGS directory exists
     if (-not (Test-Path -Path $logpath)) {
        try {
            New-Item -Path $logpath -ItemType Directory -Force
        } catch {
            Write-Error "Failed to create LOGS directory: $_"
            return
        }
    }

    # Set the full path to the log file
    $logfile = Join-Path -Path $logpath -ChildPath "log.txt"

    # Get the current date and time
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Construct the log entry
    $logEntry = "$timestamp - $message"

    # Append the log entry to the log file with error handling
    try {
        Add-Content -Path $logfile -Value $logEntry
    } catch {
        Write-Error "Failed to write to log file: $_"
    }
    
}
function Test-AdministratorRight {
    # check if the script is run as admin
    LogMessage "Checking if you are admin"
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        # the script is not run as admin
        LogMessage "Script not running as asdmin - Restarting Script as Admin"
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs

        # Stop the current script
        Exit
    }
}

function Show-Menu {
    Clear-Host
    LogMessage "Displaying menu options to the user."

    Write-Host "Select an option:"
    Write-host ""
    Write-Host "1. Check host file write status"
    Write-Host "2. Backup Current hostfile in c:\Temp\hostsbackup\"
    Write-Host "3. Update and overwrite host file with new GenP entries"
    Write-Host ""
    Write-Host "0. Exit script" 
    Write-Host ""
    $choice = Read-Host "Enter a menu option (0-3)"

    LogMessage "User selected menu option: $choice"

    switch ($choice) {
        1 { 
            LogMessage "User selected to check host file write status."
            Test-HostFileWriteStatus 
        }
        2 { 
            LogMessage "User selected to backup the current host file."
            Backup-CurrentHostFile 
        }
        3 { 
            LogMessage "User selected to update and overwrite the host file with new entries."
            Update-HostFile 
        }
        0 { 
            LogMessage "User selected to exit the script."
            Exit-Script 
        }
        Default { 
            LogMessage "User selected an invalid option: $choice"
            Clear-host
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
            Pause
            Show-Menu
        }
    }
}


function Test-HostFileWriteStatus {
    Clear-Host
    LogMessage "Starting to check host file write status."

    Write-Host "Checking host file write status..."
    $hostFilePath = "C:\Windows\System32\drivers\etc\hosts"

    if (Test-Path -Path $hostFilePath -PathType Leaf) {
        LogMessage "Host file found at path: $hostFilePath"
        $fileInfo = Get-Item $hostFilePath

        if ($fileInfo.IsReadOnly) {
            LogMessage "Host file is read-only. User needs to change permissions to write to it."
            Write-Host "The host file is read-only. You need to change permissions to write to it." -ForegroundColor Red
        } else {
            LogMessage "Host file is writable."
            Write-Host "The host file is writable." -ForegroundColor Green
        }
    } else {
        LogMessage "Host file not found at path: $hostFilePath"
        Write-Host "Host file not found." -ForegroundColor Red
    }

    Write-Host ""
    LogMessage "Completed checking host file write status."
    Pause
    Show-Menu
}


function Backup-CurrentHostFile {
    Clear-host
    try {
        # Ensure the backup directory exists
        $backupDir = [System.IO.Path]::GetDirectoryName($backupPath)
        if (-not (Test-Path -Path $backupDir)) {
            New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
        }

        # Create a timestamped backup file name without extension
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backupFileName = "Hosts-$timestamp"
        $backupFullPath = Join-Path -Path $backupDir -ChildPath $backupFileName

        # Copy the hosts file to the backup location
        Copy-Item -Path $hostsPath -Destination $backupFullPath -Force
        Write-Host "Backup of the hosts file created at $backupFullPath." -ForegroundColor Green
    } catch {
        Write-Host "Failed to create a backup of the hosts file: $_" -ForegroundColor Red
        Read-Host "Press any key to return to the menu"
    }

    Pause
    Show-Menu
}

function Update-HostFile {
    clear-host
    # Check if the hosts file is writable
    if ((Get-Item $hostsPath).IsReadOnly -eq $false) {
        try {
            # Download content from the specified URL
            $content = Invoke-WebRequest -Uri $url -UseBasicParsing
            if ($content.StatusCode -eq 200) {
                # Overwrite the hosts file with the downloaded content
                $content.Content | Out-File -FilePath $hostsPath -Encoding ASCII
                Write-Host "The hosts file has been successfully overwritten." -ForegroundColor Green
            } else {
                Write-Host "Failed to download content. Status Code: $($content.StatusCode)" -ForegroundColor Red
            }
        } catch {
            Write-Host "An error occurred: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "The hosts file is not writable by the current user. Please make sure the user that currently runs the script has write access to the hosts file." -ForegroundColor Red
    }
    Read-Host "Press Enter to return to the menu"
    Show-Menu
}

function Exit-Script {
    write-host ""
    Write-Host "Exiting script."
    Exit
}

# start van het script
Test-AdministratorRight
# Start het menu
Show-Menu