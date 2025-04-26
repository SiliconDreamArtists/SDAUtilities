#This is not an exact replacement for the Merge Json Dictionary functionality in c#
function Merge-Dictionaries {
    param (
        [Parameter(Mandatory)] $Primary,   # Base dictionary (e.g., $JsonObject)
        [Parameter(Mandatory)] $Secondary  # Will be added under key like 'Item'
    )

    $merged = [ordered]@{}

    # Flatten $Primary into merged
    if ($Primary -is [System.Collections.IDictionary]) {
        foreach ($entry in $Primary.GetEnumerator()) {
            $merged[$entry.Key] = $entry.Value
        }
    }
    elseif ($Primary -is [pscustomobject]) {
        foreach ($prop in $Primary.PSObject.Properties) {
            $merged[$prop.Name] = $prop.Value
        }
    }

    # Add or override the 'Item' key
    $merged["Item"] = $Secondary

    return $merged
}
