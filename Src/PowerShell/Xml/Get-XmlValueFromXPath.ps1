

function Get-XmlValueFromXPath {
    param (
        [Parameter(Mandatory)]
        [string]$RootPath,

        [Parameter(Mandatory)]
        [string]$VirtualPath,

        [string]$XPath
    )

    $fullPath = Join-Path -Path $RootPath -ChildPath $VirtualPath

    if (-not (Test-Path $fullPath)) {
        throw "[agent] File not found: $fullPath"
    }

    # If no XPath is provided, treat it as plain text
    if ([string]::IsNullOrWhiteSpace($XPath)) {
        Write-Host "[agent] Loading raw content from: $VirtualPath" -ForegroundColor DarkGray
        return Get-Content -Path $fullPath -Raw -Encoding UTF8
    }

    # XPath provided — treat as XML
    Write-Host "[agent] Loading XML from: $VirtualPath → XPath: $XPath" -ForegroundColor DarkGray

    try {
        [xml]$xmlDoc = Get-Content -Path $fullPath -Raw -Encoding UTF8
        $result = $xmlDoc.SelectSingleNode($XPath)

        if ($null -eq $result) {
            throw "[agent] XPath '$XPath' returned no result in file '$VirtualPath'"
        }

        return $result.InnerText.Trim()
    }
    catch {
        throw "[agent] Failed to parse XML or evaluate XPath in: $VirtualPath → $XPath. $($_.Exception.Message)"
    }
}
