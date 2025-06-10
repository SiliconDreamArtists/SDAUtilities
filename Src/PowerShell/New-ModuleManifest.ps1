$root = "$PSScriptRoot"
if ($root -ne (Get-Location).Path) {
    Set-Location $root
}

New-ModuleManifest -Path ./SDA.BDDB.Utilities.psd1 `
  -RootModule 'SDA.BDDB.Utilities.psm1' `
  -ModuleVersion '1.0.0' `
  -Author 'Silicon Dream Artists' `
  -CompanyName 'Silicon Dream Artists' `
  -Description 'Native PowerShell implementation for the local processing loop for SDAFusion based on SovereignTrust Router and SovereignTrust Executor.' `
  -Tags "'SDA.BDDB.Utilities' 'SovereignTrust' 'Public' 'MediaProcesses'" `
  -LicenseUri 'https://opensource.org/licenses/MIT' `
  -ProjectUri 'https://github.com/SiliconDreamArtists/SDA.BDDB.Utilities' `
  -CompatiblePSEditions 'Core' `
  -PowerShellVersion '5.1'

  Invoke-GenerateModuleFile -OutputFile 'SDA.BDDB.Utilities.psm1' -Root $PSScriptRoot
  

#  Invoke-SplitFileIntoFiles -InputFile 'C:\GitHub\SiliconDreamArtists\SDA.BDDB.SovereignTrust.ATProtocol\Src\PowerShell\NodeJS\Invokes.ps1' -OutputFolder 'C:\GitHub\SiliconDreamArtists\SDA.BDDB.SovereignTrust.ATProtocol\Src\PowerShell\NodeJS'

