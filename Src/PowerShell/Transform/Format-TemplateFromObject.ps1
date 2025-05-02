function Format-TemplateFromObject {
    param (
        [string]$TemplateContent,  # Template content as a string
        $JsonObject,
        $Item                # JSON object (parsed from file or dynamically provided)
    )

    if ($null -eq $Item)
    {
        $merged = $JsonObject
    }
    else {
        $merged = Merge-Dictionaries -Primary $JsonObject -Secondary $Item
    }

    # Parallel processing of each placeholder
    $pattern = '@@([A-Za-z0-9_.-]+)'  # Supports dot, underscore, and dash
    $updatedContent = $TemplateContent

    $matches = [regex]::Matches($TemplateContent, $pattern)

    $matches | ForEach-Object -Parallel {
        $match = $_
        $placeholder = $match.Value        # e.g., @@Item.Title
        $path = $match.Groups[1].Value     # e.g., Item.Title

        $value = Resolve-PathFromDictionaryNoSignal -Dictionary $merged -Path $path

        if ($null -ne $value) {
            if ($value -is [System.Collections.IEnumerable] -and -not ($value -is [string])) {
                $replacement = $value | ConvertTo-Json -Depth 20 -Compress
            } else {
                $replacement = $value.ToString()
            }

            # Replace all instances of the placeholder with its resolved value
            $escapedPlaceholder = [regex]::Escape($placeholder)
            $updatedContent = $updatedContent -replace $escapedPlaceholder, $replacement
        }
        else {
            Write-Host "[agent] Warning: No value found for placeholder '$placeholder'. Leaving it unchanged." -ForegroundColor Yellow
        }
    }

    return $updatedContent    # Return the updated content with properly formatted replacements
}


function Format-TemplateFromObject-Original {
    param (
        [string]$TemplateContent,  # Template content as a string
        $JsonObject,
        $Item                # JSON object (parsed from file or dynamically provided)
    )

    if ($null -eq $Item)
    {
        $merged = $JsonObject
    }
    else {
        $merged = Merge-Dictionaries -Primary $JsonObject -Secondary $Item
    }

    $TemplateContent = Resolve-RegexPlaceholders -Merged $merged -Pattern '@@([A-Za-z0-9_.-]+)' -InputString $TemplateContent -WarnOnMissing $false
#    $TemplateContent = Resolve-RegexPlaceholders -Merged $merged -Pattern '\$\(([A-Za-z_][A-Za-z0-9_.]*)\)' -InputString $TemplateContent  -WarnOnMissing $false
#    $TemplateContent = Resolve-RegexPlaceholders -Merged $merged -Pattern '\$([A-Za-z_][A-Za-z0-9_.]*)' -InputString $TemplateContent -WarnOnMissing $false

    return $TemplateContent

    $pattern = '@@([A-Za-z0-9_.-]+)'  # Supports dot, underscore, and dash
    $updatedContent = $TemplateContent

    $matches = [regex]::Matches($TemplateContent, $pattern)

    foreach ($match in $matches) {
        $placeholder = $match.Value        # e.g., @@Item.Title
        $path = $match.Groups[1].Value     # e.g., Item.Title

        $value = Resolve-PathFromDictionaryNoSignal -Dictionary $merged -Path $path

        if ($null -ne $value) {
            if ($value -is [System.Collections.IEnumerable] -and -not ($value -is [string])) {
                $replacement = $value | ConvertTo-Json -Depth 20 -Compress
            } else {
                $replacement = $value.ToString()
            }

            # Replace all instances of the placeholder with its resolved value
            $escapedPlaceholder = [regex]::Escape($placeholder)
            $updatedContent = $updatedContent -replace $escapedPlaceholder, $replacement
        }
        else {
            Write-Host "[agent] Warning: No value found for placeholder '$placeholder'. Leaving it unchanged." -ForegroundColor Yellow
        }
    }

    return $updatedContent    # Return the updated content with properly formatted replacements
}
