# Define variables for easy configuration
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$backupPath = "C:\Temp\hostsbackup\"
$url = "https://a.dove.isdumb.one/list.txt"

function Show-Menu {22
    Clear-Host
    Write-Host "Select an option:"
    Write-host ""
    Write-Host "1. Check host file write status"
    Write-Host "2. Backup Current hostfile in c:\Temp\hostsbackup\"
    Write-Host "3. Update and overwrite host file with new GenP entries"
    Write-Host "4. Exit script" 
    Write-Host ""
    $choice = Read-Host "Enter a menu option (1-4)"

    switch ($choice) {
        1 { Check-HostFileWriteStatus }
        2 { Backup-CurrentHostFile }
        3 { Update-HostFile }
        4 { Exit-Script }
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
    write-host "menu not ready"
    Pause
    Show-Menu
}

function Exit-Script {
    write-host ""
    Write-Host "Exiting script."
    Exit
}

# Start het menu
Show-Menu
