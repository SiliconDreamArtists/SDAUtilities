# Load all files (functions + classes)
. "$PSScriptRoot/IO/Queue/Start-AzureStorageQueueListener.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Wait-ForFileUnlock.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonFile.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonObjectProperty.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonProperty.ps1"
. "$PSScriptRoot/Tooling/Invoke-GenerateModuleFile.ps1"
. "$PSScriptRoot/Tooling/Invoke-SplitFileIntoFiles.ps1"
. "$PSScriptRoot/Tooling/Invoke-SurfaceClassLoads.ps1"
. "$PSScriptRoot/Tooling/Invoke-SurfaceFunctionExports.ps1"
. "$PSScriptRoot/Tooling/Deprecated/Install-DotNetLibrary.ps1"
. "$PSScriptRoot/Transform/Convert-KeysToPascalCase.ps1"
. "$PSScriptRoot/Transform/Format-TemplateFromObject.ps1"
. "$PSScriptRoot/Transform/Merge-Dictionaries.ps1"
. "$PSScriptRoot/Transform/Resolve-RecursiveTemplateStep.ps1"
. "$PSScriptRoot/Transform/Deprecated/Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject.ps1"
. "$PSScriptRoot/Transform/Deprecated/Invoke-ReplaceTemplatePlaceholdersFromFile.ps1"
. "$PSScriptRoot/Xml/Get-XmlValueFromXPath.ps1"

# Export public utility functions
Export-ModuleMember -Function Start-AzureStorageQueueListener
Export-ModuleMember -Function Wait-ForFileUnlock
Export-ModuleMember -Function Write-JsonFile
Export-ModuleMember -Function Write-JsonObjectProperty
Export-ModuleMember -Function Write-JsonProperty
Export-ModuleMember -Function Invoke-GenerateModuleFile
Export-ModuleMember -Function Invoke-SplitFileIntoFiles
Export-ModuleMember -Function Invoke-SurfaceClassLoads
Export-ModuleMember -Function Invoke-SurfaceFunctionExports
Export-ModuleMember -Function Install-DotNetLibrary
Export-ModuleMember -Function Convert-KeysToPascalCase
Export-ModuleMember -Function Format-TemplateFromObject
Export-ModuleMember -Function Merge-Dictionaries
Export-ModuleMember -Function Resolve-RecursiveTemplateStep
Export-ModuleMember -Function Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject
Export-ModuleMember -Function Invoke-ReplaceTemplatePlaceholdersFromFile
Export-ModuleMember -Function Get-XmlValueFromXPath
