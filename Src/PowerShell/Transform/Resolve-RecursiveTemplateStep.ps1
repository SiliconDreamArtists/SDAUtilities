function Resolve-RecursiveTemplateStep {
    param (
        [Parameter(Mandatory)] $Template,
        [Parameter(Mandatory)] $Environment
    )

    $maxDepth = 10
    $depth = 0
    $current = $Template

    while ($true) {
        $depth++
        if ($depth -gt $maxDepth) {
            throw "[agent] Template recursion exceeded max depth ($maxDepth)."
        }

        $templateType  = Get-DictionaryValue -Object $current -Key "TemplateType"
        $templatePath  = Get-DictionaryValue -Object $current -Key "TemplatePath"
        $templateXPath = Get-DictionaryValue -Object $current -Key "TemplateXPath"

        # No path? Use the inline Template value
        if ([string]::IsNullOrWhiteSpace($templatePath)) {
            Write-Host "[agent] TemplatePath is not defined — returning provided Template object as-is." -ForegroundColor DarkGray
            return $Template
        }
        
        if ($templateType -eq "Json") {
            Write-Host "[agent] Resolving nested Json template at $templatePath" -ForegroundColor Cyan

            $raw = Get-XmlValueFromXPath `
                -RootPath $Environment.ContentStorageRoot `
                -VirtualPath $templatePath `
                -XPath $templateXPath

            $json = $null
            try {
                $json = $raw | ConvertFrom-Json -Depth 20
            }
            catch {
                throw "[agent] Failed to parse JSON content from $templatePath ($templateXPath)"
            }

            $nextTemplatePath = Get-DictionaryValue -Object $json -Key "TemplatePath"
            if ($null -ne $nextTemplatePath) {
                $current = $json
                continue
            }

            return $json
        }
        else {
            # Handle string resolution
            Write-Host "[agent] Resolved terminal template at $templatePath" -ForegroundColor Green

            $resolved = Get-XmlValueFromXPath `
                -RootPath $Environment.ContentStorageRoot `
                -VirtualPath $templatePath `
                -XPath $templateXPath

            Set-DictionaryValue -Object ([ref]$current) -Key "Template" -Value $resolved
            Set-DictionaryValue -Object ([ref]$current) -Key "TemplatePath" -Value ""
            Set-DictionaryValue -Object ([ref]$current) -Key "TemplateXPath" -Value ""
            Set-DictionaryValue -Object ([ref]$current) -Key "TemplateType" -Value "String"

            return $current
        }
    }
}
