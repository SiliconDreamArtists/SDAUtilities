function Write-JsonFile {
    param (
        [string]$JsonFilePath,   # Path to the JSON file
        $JsonObject   # Object to Store
    )

    Wait-ForFileUnlock -FilePath $JsonFilePath -TimeoutSeconds 10

    # Write the updated JSON back to file
    $JsonObject | ConvertTo-Json -Depth 20 | Set-Content -Path $JsonFilePath -Encoding UTF8

    Write-Host "Successfully saved object to '$JsonFilePath'." -ForegroundColor Green
}
