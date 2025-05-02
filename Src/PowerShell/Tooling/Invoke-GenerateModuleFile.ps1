function Invoke-GenerateModuleFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$OutputFile,
        [string]$Root
    )

    $scriptRoot = $Root
    $skipFiles = @(
        "New-ModuleManifest.ps1"
    )

    $ps1Files = Get-ChildItem -Path $scriptRoot -Recurse -Filter *.ps1 | Where-Dictionary {
        ($_.Name -notin $skipFiles) -and
        ($_.Name -ne $OutputFile)
    }

    $loadLines = @()
    $exportFunctions = @()

    foreach ($file in $ps1Files) {
        $relativePath = $file.FullName.Replace($scriptRoot, '$PSScriptRoot').Replace('\\', '/').Replace('\', '/')
        $loadLines += '. "' + $relativePath + '"'

        if ($file.FullName -notmatch '\\classes\\' -and $file.FullName -notmatch '/classes/') {
            # Only export function if NOT inside /classes/
            $functionName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
            $exportFunctions += $functionName
        }
    }

    # Build content
    $content = @()
    $content += "# Load all files (functions + classes)"
    $content += $loadLines
    $content += ""
    $content += "# Export public utility functions"
    foreach ($func in $exportFunctions) {
        $content += "Export-ModuleMember -Function $func"
    }

    # Save output
    $content | Set-Content -Path (Join-Path $scriptRoot $OutputFile) -Encoding UTF8

    Write-Host "✅ Generated module file: $OutputFile" -ForegroundColor Green
}
