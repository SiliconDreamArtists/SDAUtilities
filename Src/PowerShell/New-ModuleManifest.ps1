$root = "$PSScriptRoot"
if ($root -ne (Get-Location).Path) {
    Set-Location $root
}

New-ModuleManifest -Path ./SDAUtilities.psd1 `
  -RootModule 'SDAUtilities.psm1' `
  -ModuleVersion '1.0.0' `
  -Author 'Silicon Dream Artists' `
  -CompanyName 'Silicon Dream Artists' `
  -Description 'Native PowerShell implementation for the local processing loop for SDAFusion based on SovereignTrust Router and SovereignTrust Executor.' `
  -Tags "'SDAUtilities' 'SovereignTrust' 'Public' 'MediaProcesses'" `
  -LicenseUri 'https://opensource.org/licenses/MIT' `
  -ProjectUri 'https://github.com/SiliconDreamArtists/SDAUtilities' `
  -CompatiblePSEditions 'Core' `
  -PowerShellVersion '5.1'

  Invoke-GenerateModuleFile -OutputFile 'SDAUtilities.psm1'

  