# Define the URL and the path to the hosts file
$url = "https://a.dove.isdumb.one/list.txt"
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

# Download the contents from the URL
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
