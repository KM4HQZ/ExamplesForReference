param(
    [parameter(ParameterSetName="ByName",Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias("Computer","Computers")]
    [string[]] $Name,
    [parameter(Mandatory=$true)]
    [string] $Destination,
    [int] $WaitMinutes = 30)

# Stop the VM Guest
Get-VM $Name | Stop-VMGuest

# Wait until it is Powered Off
$StopWaiting = (Get-Date).AddMinutes($WaitMinutes)
do {
    if ($StopWaiting -lt (Get-Date)) {
        # Throw error, send email, blow up, etc.
        Throw "Failed due to timeout shutting down."
    }
    Start-Sleep -Seconds 10
    $NotDone = Get-VM $Name | Where-Object PowerState -NotLike "PoweredOff"
} while ($NotDone)

# Remove any snapshots
Get-VM -Name $Name | Get-Snapshot | Remove-Snapshot -Confirm:$false
# Disconnect any ISOs
Get-VM -Name $Name | Get-CDDrive | Set-CDDrive -NoMedia -Confirm:$false
# Export the VM
Get-VM -Name $Name | Export-VApp -Destination $Destination -Format Ova
