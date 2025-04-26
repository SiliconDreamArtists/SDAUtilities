function Resolve-PathFromDictionary {
    param (
        $Dictionary,
        [string]$Path,
        [bool]$IgnoreJsonObject = $false
    )

    $parts = $Path -split '\.'
    $current = $Dictionary

    foreach ($part in $parts) {
        if ($null -eq $current) { return $null }

        if (-not $IgnoreJsonObject) {
            # Step 1: Dive into _JsonObject if present
            if ($current -is [hashtable] -and $current.Contains("_JsonObject")) {
                $current = $current["_JsonObject"]
            }
            elseif ($current -is [pscustomobject] -and $current.PSObject.Properties.Name -contains "_JsonObject") {
                $current = $current._JsonObject
            }
        }

        # Step 2: Access next key
        if ($current -is [System.Collections.IDictionary] -and $current.Contains($part)) {
            $current = $current[$part]
        }
        elseif ($current -is [hashtable]) {
            if ($current.Contains($part)) {
                $current = $current[$part]
            }
            else {
                return $null
            }
        }
        elseif ($current -is [pscustomobject]) {
            if ($current.PSObject.Properties.Name -contains $part) {
                $current = $current.$part
            }
            else {
                return $null
            }
        }
        else {
            return $null
        }
    }

    return $current
}

function Resolve-RegexPlaceholders {
    param (
        [Parameter(Mandatory)] $Merged,
        [Parameter(Mandatory)][string] $Pattern,
        [Parameter(Mandatory)][string] $InputString,
        [Parameter(Mandatory)][bool] $WarnOnMissing
    )

    $output = $InputString
    $Patternmatches = [regex]::Matches($InputString, $Pattern)

    foreach ($match in $Patternmatches) {
        $placeholder = $match.Value        # e.g., @@Item.Title
        $path = $match.Groups[1].Value     # e.g., Item.Title

        $value = Resolve-PathFromDictionary -Dictionary $Merged -Path $path

        if ($null -ne $value) {
            if ($value -is [System.Collections.IEnumerable] -and -not ($value -is [string])) {
                $replacement = $value | ConvertTo-Json -Depth 20 -Compress
            }
            else {
                $replacement = $value.ToString()
            }

            $escaped = [regex]::Escape($placeholder)
            $output = $output -replace $escaped, $replacement
        }
        else {
            if ($WarnOnMissing) {
                Write-Host "[agent] Warning: No value found for placeholder '$placeholder'. Leaving it unchanged." -ForegroundColor Yellow
            }
        }
    }

    return $output
}
