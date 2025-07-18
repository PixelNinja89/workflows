# generate-blocklist.ps1

$url = "https://raw.githubusercontent.com/AdguardTeam/HostlistsRegistry/refs/heads/main/filters/other/filter_39_DandelionSprouts_AntiPushNotifications/filter.txt"
$outputFile = "pihole_blocklist.txt"
$content = Invoke-WebRequest -Uri $url -UseBasicParsing | Select-Object -ExpandProperty Content

$domainPattern = '^\|\|?([a-z0-9.-]+\.[a-z]{2,})(\^)?$'
$domains = @{}

foreach ($line in $content -split "`n") {
    $trimmed = $line.Trim()
    if ($trimmed -match $domainPattern) {
        $domain = $matches[1].ToLower()
        $domains[$domain] = $true
    }
}

$domains.Keys | Sort-Object | Out-File -FilePath $outputFile -Encoding ASCII
