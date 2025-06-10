function Invoke-SplitFileIntoFiles {
param (
    [Parameter(Mandatory)]
    [string]$InputFile,

    [Parameter(Mandatory)]
    [string]$OutputFolder
)

if (-not (Test-Path $InputFile)) {
    throw "❌ Input file not found: $InputFile"
}

if (-not (Test-Path $OutputFolder)) {
    Write-Host "📁 Output folder does not exist. Creating: $OutputFolder"
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

$lines = Get-Content -Path $InputFile
$currentBuffer = @()
$currentFunction = $null
$braceCount = 0
$insideFunction = $false

foreach ($line in $lines) {
    if ($line -match '^\s*function\s+([A-Za-z0-9_-]+)\s*\{?') {
        # Flush the previous function
        if ($insideFunction -and $currentFunction) {
            $filePath = Join-Path $OutputFolder "$currentFunction.ps1"
            $currentBuffer | Set-Content -Path $filePath -Encoding UTF8
            Write-Host "✅ Wrote: $filePath"
        }

        # Start tracking new function
        $currentFunction = $Matches[1]
        $currentBuffer = @($line)
        $braceCount = ($line -split '{').Count - ($line -split '}').Count
        $insideFunction = $true
        continue
    }

    if ($insideFunction) {
        $currentBuffer += $line
        $braceCount += ($line -split '{').Count - ($line -split '}').Count

        if ($braceCount -eq 0) {
            $filePath = Join-Path $OutputFolder "$currentFunction.ps1"
            $currentBuffer | Set-Content -Path $filePath -Encoding UTF8
            Write-Host "✅ Wrote: $filePath"
            $currentFunction = $null
            $currentBuffer = @()
            $insideFunction = $false
        }
    }
}

# Final flush

}