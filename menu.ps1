function Show-Menu {
    Clear-Host
    Write-Host "Select an option:"
    Write-Host "1. Check host file write status"
    Write-Host "2. Backup Current hostfile to c:\Temp\hosts.bak"
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
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
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
    write-host "menu not ready"
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
