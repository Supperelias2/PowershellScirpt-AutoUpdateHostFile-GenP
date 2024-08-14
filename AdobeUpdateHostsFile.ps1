function Test-HostsFileWritable {
    param (
        [string]$hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
    )

    try {
        $fileStream = [System.IO.File]::Open($hostsFilePath, 'Open', 'ReadWrite', 'None')
        $fileStream.Close()
        return $true
    } catch {
        return $false
    }
}

function Update-HostsFile {
    param (
        [string]$url = "https://a.dove.isdumb.one/list.txt",
        [string]$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    )

    # Check if the hosts file is writable
    if (Test-HostsFileWritable -hostsFilePath $hostsPath) {
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
        Write-Error "The hosts file is not writable by the current user."
    }
}

# Execute the function to update the hosts file
Update-HostsFile
