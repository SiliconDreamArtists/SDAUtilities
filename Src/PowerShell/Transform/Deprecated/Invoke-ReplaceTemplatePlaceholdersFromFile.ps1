#May be obsolete
function Invoke-ReplaceTemplatePlaceholdersFromFile {
    param (
        [string]$TemplateRootPath,    # Root directory for templates
        [string]$TemplateVirtualPath, # Virtual path of the template file (relative to root)
        [string]$JsonFullPath         # Path to a single JSON file or a comma-separated list of JSON files
    )

    # Construct full template path
    $TemplateFullPath = Join-Path -Path $TemplateRootPath -ChildPath $TemplateVirtualPath

    # Ensure the template file exists
    if (-Not (Test-Path -Path $TemplateFullPath -PathType Leaf)) {
        Write-Host "Error: Template file '$TemplateFullPath' does not exist." -ForegroundColor Red
        return $null
    }

    # Read the template file content
    $templateContent = Get-Content -Path $TemplateFullPath -Raw -Encoding UTF8

    # Process multiple JSON files if provided as a comma-separated list
    $jsonFilePaths = $JsonFullPath -split "," | ForEach-Object { $_.Trim() }

    foreach ($jsonPath in $jsonFilePaths) {
        # Ensure the JSON file exists
        if (-Not (Test-Path -Path $jsonPath -PathType Leaf)) {
            Write-Host "Warning: JSON file '$jsonPath' does not exist. Skipping..." -ForegroundColor Yellow
            continue
        }

        # Read and parse the JSON file
        $jsonContent = Get-Content -Path $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json -Depth 20

        # Ensure JSON content is valid
        if (-Not $jsonContent) {
            Write-Host "Warning: JSON file '$jsonPath' is empty or invalid. Skipping..." -ForegroundColor Yellow
            continue
        }

        # Apply replacements
        $templateContent = Format-TemplateFromObject -TemplateContent $templateContent -JsonObject $jsonContent
    }

    return $templateContent
}
