# Define variables for easy configuration
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$backupPath = "C:\Temp\hostsbackup\"
$url = "https://a.dove.isdumb.one/list.txt"

function Check-AdministratorRights {
    # Controleer of het script als administrator wordt uitgevoerd
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        # Het script wordt niet als administrator uitgevoerd, dus start het opnieuw met verhoogde rechten
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs

        # Stop het huidige script
        Exit
    }
}


function Show-Menu {22
    Clear-Host
    Write-Host "Select an option:"
    Write-host ""
    Write-Host "1. Check host file write status"
    Write-Host "2. Backup Current hostfile in c:\Temp\hostsbackup\"
    Write-Host "3. Update and overwrite host file with new GenP entries"
    Write-Host ""
    Write-Host "0. Exit script" 
    Write-Host ""
    $choice = Read-Host "Enter a menu option (1-4)"

    switch ($choice) {
        1 { Check-HostFileWriteStatus }
        2 { Backup-CurrentHostFile }
        3 { Update-HostFile }
        0 { Exit-Script }
        Default { 
            Clear-host
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
            Pause
            Show-Menu
        }
    }
}

function Check-HostFileWriteStatus {
    clear-host
    Write-Host "Checking host file write status..."
    $hostFilePath = "C:\Windows\System32\drivers\etc\hosts"
    if (Test-Path -Path $hostFilePath -PathType Leaf) {
        $fileInfo = Get-Item $hostFilePath
        if ($fileInfo.IsReadOnly) {
            Write-Host "The host file is read-only. You need to change permissions to write to it." -ForegroundColor Red
        } else {
            Write-Host "The host file is writable." -ForegroundColor Green
        }
    } else {
        Write-Host "Host file not found." -ForegroundColor Red
    }
    Write-Host ""
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
Check-AdministratorRights
# Start het menu
Show-Menu
