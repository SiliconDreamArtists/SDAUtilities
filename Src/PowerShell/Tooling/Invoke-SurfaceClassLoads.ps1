function Invoke-SurfaceClassLoads {
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputFile,

        [Parameter()]
        [string]$Root = (Get-Location)
    )

    $RootPath = Resolve-Path -Path $Root | Select-Object -ExpandProperty Path
    $OutputFilePath = Join-Path -Path $RootPath -ChildPath $OutputFile

    if (!(Test-Path -Path $OutputFilePath)) {
        throw "Output file '$OutputFilePath' does not exist."
    }

    $fileContent = Get-Content -Path $OutputFilePath -Raw

    # Identify and strip existing class load block
    $marker = '############################CLASS_LOADS############'
    $markerIndex = $fileContent.IndexOf($marker)

    if ($markerIndex -ge 0) {
        $fileContent = $fileContent.Substring(0, $markerIndex).TrimEnd()
    }

    # Find all *.ps1 files containing a PowerShell 'class' keyword
    $classFiles = Get-ChildItem -Path $RootPath -Recurse -Include '*.ps1' | Where-Object {
        ($_ | Get-Content -Raw) -match 'class\s+[a-zA-Z0-9_]+'
    }

    # Generate new class load block
    $classLoadBlock = @()
    $classLoadBlock += ""
    $classLoadBlock += "############################CLASS_LOADS############"
    foreach ($classFile in $classFiles) {
        # Normalize to path relative to Root
        $relativePath = $classFile.FullName.Replace($RootPath, '').TrimStart('\','/')
        $relativePath = $relativePath -replace '\\', '/'
        $classLoadBlock += ". './$relativePath'"
    }
    $classLoadBlock += ""

    # Merge and write new content
    $newContent = $fileContent.TrimEnd() + "`n" + ($classLoadBlock -join "`n") + "`n"
    Set-Content -Path $OutputFilePath -Value $newContent -Encoding UTF8

    Write-Host "✅ Surface class load block updated in $OutputFilePath" -ForegroundColor Green
}
