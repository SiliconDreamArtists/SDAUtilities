function Write-JsonProperty {
    param (
        [string]$JsonFilePath,
        [string]$Path,  # e.g., "Counts.GroupEntries"
        [object]$PropertyValue
    )

    $writePath = $JsonFilePath

    if ($Path -like 'Working*') {
        $basePath = [System.IO.Path]::GetFileNameWithoutExtension($JsonFilePath)
        $dirPath = [System.IO.Path]::GetDirectoryName($JsonFilePath)
        $writePath = Join-Path $dirPath ($basePath + '_Working.json')
    }

    if (-not (Test-Path $writePath)) {
        Write-Host "File not found. Creating default JSON: $writePath"
        Set-Content -Path $writePath -Value "{}" -Encoding UTF8
    }
    
    # Read file in UTF-8-safe mode
    $rawJson = Get-Content -Raw -Path $writePath -Encoding UTF8

    # Defensive parse
    try {
        $json = $rawJson | ConvertFrom-Json -Depth 20 -ErrorAction Stop
    } catch {
        throw "Failed to parse existing JSON at $writePath : $($_.Exception.Message)"
    }
    
#    $json = Get-Content -Raw -Path $writePath | ConvertFrom-Json -Depth 20

    $parts = $Path -split '\.'
    $ref = $json
    for ($i = 0; $i -lt $parts.Length - 1; $i++) {
        $part = $parts[$i]
        if (-not $ref.PSObject.Properties[$part]) {
            $ref | Add-Member -MemberType NoteProperty -Name $part -Value ([pscustomobject]@{})
        }
        $ref = $ref.$part
    }

    $final = $parts[-1]
    if ($ref.PSObject.Properties[$final]) {
        $ref.$final = $PropertyValue
    } else {
        $ref | Add-Member -MemberType NoteProperty -Name $final -Value $PropertyValue
    }

    Finalize-JsonWriteback -JsonObject $json -JsonPath $writePath -Modified $true
}
