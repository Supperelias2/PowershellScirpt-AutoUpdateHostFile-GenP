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
            Write-Host "Invalid option. Please try again." 
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
            Write-Host "The host file is read-only. You need to change permissions to write to it."
        } else {
            Write-Host "The host file is writable."
        }
    } else {
        Write-Host "Host file not found."
    }
    Pause
    Show-Menu
}

function Backup-CurrentHostFile {
    Write-Host "Backing up current host file..."
    $hostFilePath = "C:\Windows\System32\drivers\etc\hosts"
    $backupFilePath = "C:\Windows\System32\drivers\etc\hosts.bak"
    
    if (Test-Path -Path $hostFilePath -PathType Leaf) {
        Copy-Item -Path $hostFilePath -Destination $backupFilePath -Force
        Write-Host "Backup completed. Backup saved as hosts.bak."
    } else {
        Write-Host "Host file not found. Backup not created."
    }
    Pause
    Show-Menu
}

function Update-HostFile {
    Write-Host "Updating and overwriting host file with new GenP entries..."
    $hostFilePath = "C:\Windows\System32\drivers\etc\hosts"
    
    # Voeg hier de regels toe die je aan het hostbestand wilt toevoegen
    $genpEntries = @(
        "127.0.0.1 activation.adobe.com",
        "127.0.0.1 practivate.adobe.com",
        "127.0.0.1 lmlicenses.wip4.adobe.com",
        "127.0.0.1 lm.licenses.adobe.com"
    )
    
    # Voeg de regels toe aan het hostbestand
    foreach ($entry in $genpEntries) {
        Add-Content -Path $hostFilePath -Value $entry
    }
    
    Write-Host "Host file successfully updated with new GenP entries."
    Pause
    Show-Menu
}

function Exit-Script {
    Write-Host "Exiting script."
    Exit
}

# Start het menu
Show-Menu
