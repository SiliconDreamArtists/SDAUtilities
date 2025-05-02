function Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject {
    param (
        [string]$TemplateRootPath,    # Root directory for templates
        [string]$TemplateVirtualPath, # Virtual path of the template file (relative to root)
        [string]$Template, # Virtual path of the template file (relative to root)
        [string]$XPath = $null, # Virtual path of the template file (relative to root)
        $JsonObject                   # JSON object to use for replacements
    )

    $result = (@{})

    # Construct full template path
    $TemplateFullPath = Join-Path -Path $TemplateRootPath -ChildPath $TemplateVirtualPath

    # Ensure the template file exists
    if (-Not (Test-Path -Path $TemplateFullPath -PathType Leaf)) {
        Write-Host "Error: Template file '$TemplateFullPath' does not exist." -ForegroundColor Red
        return $null
    }

    # If XPath isn't null, then we will try to read an xml file and get the value from it, otherwise we'll treat it as a simple text file source.
    if ($null -ne $XPath) {
        $innerXml = Get-XmlValueFromXPath -RootPath $TemplateRootPath -VirtualPath $TemplateVirtualPath -XPath $XPath

        $promptObject = $innerXml | ConvertFrom-Json -Depth 20
        
        if ($null -ne $promptObject.Answers) {
            Add-PathToDictionary -Dictionary $result -Path "Answers" -Value $promptObject.Answers
        }

        if (-not [string]::IsNullOrWhiteSpace($promptObject.PromptTemplatePath)) {
            $TemplateFullPath = Join-Path -Path $TemplateRootPath -ChildPath $promptObject.PromptTemplatePath
        
            # Ensure the template file exists   
            if (-Not (Test-Path -Path $TemplateFullPath -PathType Leaf)) {
                Write-Host "Error: Template file '$TemplateFullPath' does not exist." -ForegroundColor Red
                return $null
            }
            # Read the template file content
            $templateContent = Get-Content -Path $TemplateFullPath -Raw -Encoding UTF8
        }
        else {
            $templateContent = $promptObject.PromptTemplate
        }

    }
    else {
        # Read the template file content
        $templateContent = Get-Content -Path $TemplateFullPath -Raw -Encoding UTF8
    }

    # Perform replacements
    if ($null -ne $JsonObject) {
        #$value = ReplaceTemplate -TemplateContent $templateContent -JsonObject $JsonObject
        $value = Format-TemplateFromObject -TemplateContent $templateContent -JsonObject $JsonObject
    } else {
        $value = $templateContent
    }

    Add-PathToDictionary -Dictionary $result -Path "Content" -Value $value
    return $result
}
