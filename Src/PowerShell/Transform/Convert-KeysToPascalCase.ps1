function Convert-KeysToPascalCase {
    param (
        [Parameter(Mandatory)][object]$InputObject
    )

    $result = @{}

    if ($InputObject -is [hashtable]) {
        foreach ($key in $InputObject.Keys) {
            $pascalKey = ($key.Substring(0,1).ToUpper() + $key.Substring(1))
            $result[$pascalKey] = $InputObject[$key]
        }
    } elseif ($InputObject -is [pscustomobject]) {
        foreach ($prop in $InputObject.PSObject.Properties) {
            $pascalKey = ($prop.Name.Substring(0,1).ToUpper() + $prop.Name.Substring(1))
            $result[$pascalKey] = $prop.Value
        }
    } else {
        throw \"Unsupported input type: $($InputObject.GetType().Name)\"
    }

    return [pscustomobject]$result
}
