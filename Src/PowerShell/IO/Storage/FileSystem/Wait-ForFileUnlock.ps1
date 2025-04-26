function Wait-ForFileUnlock {
    param (
        [string]$FilePath,
        [int]$TimeoutSeconds = 10
    )

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
        try {
            $stream = [System.IO.File]::Open($FilePath, 'Open', 'ReadWrite', 'None')
            if ($stream) {
                $stream.Close()
                return $true
            }
        } catch {
            Start-Sleep -Milliseconds 200
        }
    }

    Write-Host "Timeout reached. File is still locked: $FilePath" -ForegroundColor Yellow
    return $false
}
