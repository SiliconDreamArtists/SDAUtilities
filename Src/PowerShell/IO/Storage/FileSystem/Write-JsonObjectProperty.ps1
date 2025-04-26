function Write-JsonObjectProperty {
    param (
        [string]$JsonFilePath,
        [string]$PropertyName,  # e.g., "Counts.GroupEntries"
        [object]$PropertyValue
    )

    # Determine write target
    $writePath = $JsonFilePath
    if ($PropertyName -like 'Working*') {
        $basePath = [System.IO.Path]::GetFileNameWithoutExtension($JsonFilePath)
        $dirPath = [System.IO.Path]::GetDirectoryName($JsonFilePath)
        $writePath = Join-Path $dirPath ($basePath + '_Working.json')
    }

#    $PropertyValue = Convert-JsonToHashtable -parsed $PropertyValue

    # Ensure file exists with valid UTF-8 structure
    if (-not (Test-Path $writePath)) {
        Write-Host "File not found. Creating default JSON: $writePath"
        '{}' | Set-Content -Path $writePath -Encoding UTF8
    }

    # Skip writing null values
    if ($null -eq $PropertyValue) {
        return
    }

    # Read file in UTF-8-safe mode
    $rawJson = Get-Content -Raw -Path $writePath -Encoding UTF8

    # Defensive parse
    try {
        $json = $rawJson | ConvertFrom-Json -Depth 20 -ErrorAction Stop
    } catch {
        throw "Failed to parse existing JSON at $writePath : $($_.Exception.Message)"
    }

    # Navigate and set nested property
    $parts = $PropertyName -split '\.'
    $ref = $json
    for ($i = 0; $i -lt $parts.Length - 1; $i++) {
        $part = $parts[$i]
        if (-not $ref.PSObject.Properties[$part]) {
            $ref | Add-Member -MemberType NoteProperty -Name $part -Value ([pscustomobject]@{})
        }
        $ref = $ref.$part
    }

    # Set the final property
    $final = $parts[-1]
    if ($ref.PSObject.Properties[$final]) {
        $ref.$final = $PropertyValue
    } else {
        $ref | Add-Member -MemberType NoteProperty -Name $final -Value $PropertyValue
    }

    # Serialize and write in UTF-8 with no BOM issues
    $json | ConvertTo-Json -Depth 20 | Set-Content -Encoding UTF8 -Path $writePath
}