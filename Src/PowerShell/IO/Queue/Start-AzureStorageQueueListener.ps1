
function Start-AzureStorageQueueListener {
    param (
        $Environment,

        [Parameter(Mandatory = $true)]
        [string]$SasUrl,

        [float]$PollIntervalSeconds = 3,
        [int]$MaxMessages = 16
    )

    try {
        $queueClient = [Azure.Storage.Queues.QueueClient]::new($SasUrl)
        if (-not $queueClient) {
            throw "QueueClient creation returned null."
        }
        Write-Host "✅ QueueClient initialized."
    }
    catch {
        Write-Host "❌ Exception: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "🎧 Listening to queue: $($queueClient.Name)" -ForegroundColor Cyan

    while ($true) {
        try {
            $messages = $queueClient.ReceiveMessages($MaxMessages, [TimeSpan]::FromSeconds($PollIntervalSeconds))

            foreach ($msg in $messages.Value) {

                # Decode Base64 message
                $decoded = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($msg.MessageText))

                # Optional: Convert JSON to object
                $signal = $null
                try {
                    $signal = $decoded | ConvertFrom-Json
                }
                catch {
                    Write-Warning "Could not parse JSON, printing raw string."
                }

                # Print nicely
                if ($signal) {
                    Write-Host "📩 Received JSON message (id: $($signal.Result.id)):" -ForegroundColor Yellow
                    Write-Host ($signal | ConvertTo-Json -Depth 10 | Out-String) -ForegroundColor Gray
                }
                else {
                    Write-Host "📩 Received raw message: $decoded" -ForegroundColor Yellow
                }
                
                $commandName = $signal.Result.data.name

                if ($commandName -eq "open") {
                    $command = Get-VirtualValueFromJson -JsonObject $signal.Result -RootPath "data.options" -VirtualPath "path.value"

                    $command = ($command -replace '"', '')

                    $virtualPath = ($command -split ' ')[-1]
                    $nodes = Initialize-SDAHierarchy `
                        -VirtualPath $virtualPath `
                        -RootPath "$($Environment.MediaStorageRoot)-Meta" `
                        -Environment $Environment

                }

                $token = $signal.Result.token      # from payload
                $appId = $signal.Result.application_id          # from payload
                $reply = @{
                    content = "✅ Loaded $($nodes[-1].Name)"
                }

                $headers = @{ "Content-Type" = "application/json" }
                $body = $reply | ConvertTo-Json -Depth 5

                if ($true) {
                    try {

                        Invoke-RestMethod `
                            -Uri "https://discord.com/api/v10/webhooks/$appId/$token" `
                            -Method POST `
                            -Headers $headers `
                            -Body $body

                    }
                    catch {
                        Write-Host "❌ Error during callback: $_" -ForegroundColor Red
                    }
            
                    if ($false)
                    {
                    [string[]]$InfoOutput = @()
                
                
                    Invoke-SelectFilteredCommandStep `
                        -Phase $null `
                        -AutomationLevel 0 `
                        -Item $nodes[-1] `
                        -Environment $Environment `
                        -Context $nodes  `
                        -InfoOutput $infoOutput
                    #    -RootPath "$($Environment.MediaStorageRoot)-Meta"
            
                    
                    #$infoOutput
                    $reply = @{
                        content = $InfoOutput
                    }
  
                    $headers = @{ "Content-Type" = "application/json" }
                    $body = $reply | ConvertTo-Json -Depth 5

                    try {

                        Invoke-RestMethod `
                            -Uri "https://discord.com/api/v10/webhooks/$appId/$token" `
                            -Method POST `
                            -Headers $headers `
                            -Body $body

                    }
                    catch {
                        Write-Host "❌ Error during callback: $_" -ForegroundColor Red
                    }
                }
                }

        
                # Delete the message after processing
                $queueClient.DeleteMessage($msg.MessageId, $msg.PopReceipt)
                Write-Host "✅ Message deleted." -ForegroundColor Green
            }

            Start-Sleep -Seconds 1
            #break
        }
        catch {
            Write-Host "❌ Error outside of call back: $_" -ForegroundColor Red
            Start-Sleep -Seconds 5
        }
    }
}
