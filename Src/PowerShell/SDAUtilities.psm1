# Load all utility functions
. "$PSScriptRoot/New-ModuleManifest.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Wait-ForFileUnlock.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonFile.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonObjectProperty.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonProperty.ps1"
. "$PSScriptRoot/Json/Add-JsonPropertyValue.ps1"
. "$PSScriptRoot/Json/Convert-JsonToHashtable.ps1"
. "$PSScriptRoot/Json/Get-DictionaryValue.ps1"
. "$PSScriptRoot/Json/Load-JsonObjectFromFile.ps1"
. "$PSScriptRoot/Json/Set-DictionaryValue.ps1"
. "$PSScriptRoot/Tooling/Install-DotNetLibrary.ps1"
. "$PSScriptRoot/Tooling/Invoke-GenerateModuleFile.ps1"
. "$PSScriptRoot/Transform/Format-TemplateFromObject.ps1"
. "$PSScriptRoot/Transform/Merge-Dictionaries.ps1"
. "$PSScriptRoot/Transform/Deprecated/Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject.ps1"
. "$PSScriptRoot/Transform/Deprecated/Invoke-ReplaceTemplatePlaceholdersFromFile.ps1"
. "$PSScriptRoot/Xml/Get-XmlValueFromXPath.ps1"

# Export utility functions
Export-ModuleMember -Function New-ModuleManifest
Export-ModuleMember -Function Wait-ForFileUnlock
Export-ModuleMember -Function Write-JsonFile
Export-ModuleMember -Function Write-JsonObjectProperty
Export-ModuleMember -Function Write-JsonProperty
Export-ModuleMember -Function Add-JsonPropertyValue
Export-ModuleMember -Function Convert-JsonToHashtable
Export-ModuleMember -Function Get-DictionaryValue
Export-ModuleMember -Function Load-JsonObjectFromFile
Export-ModuleMember -Function Set-DictionaryValue
Export-ModuleMember -Function Install-DotNetLibrary
Export-ModuleMember -Function Invoke-GenerateModuleFile
Export-ModuleMember -Function Format-TemplateFromObject
Export-ModuleMember -Function Merge-Dictionaries
Export-ModuleMember -Function Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject
Export-ModuleMember -Function Invoke-ReplaceTemplatePlaceholdersFromFile
Export-ModuleMember -Function Get-XmlValueFromXPath
