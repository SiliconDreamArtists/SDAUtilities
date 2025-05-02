# Load all utility functions
. "$PSScriptRoot/IO/Queue/Start-AzureStorageQueueListener.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Wait-ForFileUnlock.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonFile.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonObjectProperty.ps1"
. "$PSScriptRoot/IO/Storage/FileSystem/Write-JsonProperty.ps1"
. "$PSScriptRoot/Transform/Format-TemplateFromObject.ps1"
. "$PSScriptRoot/Transform/Merge-Dictionaries.ps1"
. "$PSScriptRoot/Transform/Resolve-RecursiveTemplateStep.ps1"
. "$PSScriptRoot/Transform/Deprecated/Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject.ps1"
. "$PSScriptRoot/Transform/Deprecated/Invoke-ReplaceTemplatePlaceholdersFromFile.ps1"
. "$PSScriptRoot/Xml/Get-XmlValueFromXPath.ps1"

# Export utility functions
Export-ModuleMember -Function Start-AzureStorageQueueListener
Export-ModuleMember -Function Wait-ForFileUnlock
Export-ModuleMember -Function Write-JsonFile
Export-ModuleMember -Function Write-JsonObjectProperty
Export-ModuleMember -Function Write-JsonProperty
Export-ModuleMember -Function Format-TemplateFromObject
Export-ModuleMember -Function Merge-Dictionaries
Export-ModuleMember -Function Resolve-RecursiveTemplateStep
Export-ModuleMember -Function Invoke-ReplaceTemplateFromFileWithPlaceholdersFromObject
Export-ModuleMember -Function Invoke-ReplaceTemplatePlaceholdersFromFile
Export-ModuleMember -Function Get-XmlValueFromXPath
