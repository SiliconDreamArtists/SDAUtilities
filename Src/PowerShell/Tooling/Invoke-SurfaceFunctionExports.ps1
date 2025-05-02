function Invoke-SurfaceFunctionExports {
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputFile,

        [Parameter(Mandatory = $false)]
        [string]$Root = (Get-Location)
    )

    $OutputFilePath = Join-Path -Path $Root -ChildPath $OutputFile

    if (!(Test-Path $OutputFilePath)) {
        throw "Output file '$OutputFilePath' does not exist."
    }

    $fileContent = Get-Content -Path $OutputFilePath -Raw

    # Identify existing export block if it exists
    $markerPattern = '############################(.+?)############'
    $markerMatch = [regex]::Match($fileContent, $markerPattern)

    if ($markerMatch.Success) {
        # Chop off the old export block
        $fileContent = $fileContent.Substring(0, $markerMatch.Index).TrimEnd()
    }

    # Find all function names
    $functionNames = @()
    $functionPattern = '(?m)^function\s+([a-zA-Z0-9\-_]+)\s*\{'  
    foreach ($match in [regex]::Matches($fileContent, $functionPattern)) {
        $functionNames += $match.Groups[1].Value
    }

    # Generate export block
    $exportBlock = @()
    $exportBlock += ""
    $exportBlock += "############################$($OutputFile)############"
    foreach ($fn in $functionNames) {
        $exportBlock += "Export-ModuleMember -Function '$fn'"
    }
    $exportBlock += ""

    # Write back the file
    $newContent = $fileContent.TrimEnd() + "`n" + ($exportBlock -join "`n")
    Set-Content -Path $OutputFilePath -Value $newContent -Encoding UTF8

    Write-Host "✅ Surface export block updated in $OutputFilePath"
}