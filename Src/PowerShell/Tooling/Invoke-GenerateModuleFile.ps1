function Invoke-GenerateModuleFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$OutputFile
    )

    $scriptRoot = "$PSScriptRoot"
    $ps1Files = Get-ChildItem -Path $scriptRoot -Recurse -Filter *.ps1 | Where-Object { $_.Name -ne (Split-Path $scriptRoot -Leaf) }

    $loadLines = @()
    $exportFunctions = @()

    foreach ($file in $ps1Files) {
        # Skip the output file itself if somehow caught
        $relativePath = $file.FullName.Replace($scriptRoot, '$PSScriptRoot').Replace('\\', '/').Replace('\', '/')
        $loadLines += '. "' + $relativePath + '"'

        # Guess the function name from the file name
        $functionName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $exportFunctions += $functionName
    }

    # Build content
    $content = @()

    $content += "# Load all utility functions"
    $content += $loadLines
    $content += ""
    $content += "# Export utility functions"
    foreach ($func in $exportFunctions) {
        $content += "Export-ModuleMember -Function $func"
    }

    # Save output
    $content | Set-Content -Path (Join-Path $scriptRoot $OutputFile) -Encoding UTF8

    Write-Host "✅ Generated module file: $OutputFile" -ForegroundColor Green
}

