# Define variables for easy configuration
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$backupPath = "C:\Temp2\hosts.bak"
$url = "https://a.dove.isdumb.one/list.txt"


function Test-HostsFileWritable {
    param (
        [string]$hostsFilePath = $hostsPath
    )

    try {
        $fileStream = [System.IO.File]::Open($hostsFilePath, 'Open', 'ReadWrite', 'None')
        $fileStream.Close()
        return $true
    } catch {
        return $false
    }
}

function Backup-HostsFile {
    param (
        [string]$hostsPath = $hostsPath,
        [string]$backupPath = $backupPath
    )

    try {
        # Ensure the backup directory exists
        $backupDir = [System.IO.Path]::GetDirectoryName($backupPath)
        if (-not (Test-Path -Path $backupDir)) {
            New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
        }

        Copy-Item -Path $hostsPath -Destination $backupPath -Force
        Write-Output "Backup of the hosts file created at $backupPath."
    } catch {
        Write-Error "Failed to create a backup of the hosts file: $_"
    }
}

function Update-HostsFile {
    param (
        [string]$url = $url,
        [string]$hostsPath = $hostsPath,
        [string]$backupPath = $backupPath
    )

    # Check if the hosts file is writable
    if (Test-HostsFileWritable -hostsFilePath $hostsPath) {
        # Create a backup before updating
        Backup-HostsFile -hostsPath $hostsPath -backupPath $backupPath

        try {
            $content = Invoke-WebRequest -Uri $url -UseBasicParsing
            if ($content.StatusCode -eq 200) {
                # Overwrite the hosts file with the downloaded content
                $content.Content | Out-File -FilePath $hostsPath -Encoding ASCII
                Write-Output "The hosts file has been successfully overwritten."
            } else {
                Write-Error "Failed to download content. Status Code: $($content.StatusCode)"
            }
        } catch {
            Write-Error "An error occurred: $_"
        }
    } else {
        Write-Error "The hosts file is not writable by the current user. please make sure the user that currently runs the script has write access to the hosts file"
    }
}

# Execute the function to update the hosts file
Update-HostsFile
