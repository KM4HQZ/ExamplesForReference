param(
    [parameter(ParameterSetName="ByName",Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias("Computer","Computers")]
    [string[]] $Name,
    [string[]] $EmailTo = "your@email.address",
    [string] $EmailFrom = "VMwares@email.address",
    [string] $SnapshotName = "BeforeMaintenance",
    [int] $WaitMinutes = 60)

Get-VM $Name | Stop-VMGuest -Confirm:$false | Out-Null

$StopWaiting = (Get-Date).AddMinutes($WaitMinutes)
do {
    if ($StopWaiting -lt (Get-Date)) {
        # Throw error, send email, blow up, etc.
        $Body = Get-VM $Name | Out-String
        Send-MailMessage -To $EmailTo -From $EmailFrom -SmtpServer "smtp.email.address" `
                         -Subject "Snapshots - Failed: Timeout shutting down" `
                         -Body $Body
        Throw "Failed due to timeout shutting down."
    }
    Start-Sleep -Seconds 10
    $NotDone = Get-VM $Name | Where-Object PowerState -NotLike "PoweredOff"
} while ($NotDone)

Get-VM $Name | New-Snapshot -Name $SnapshotName -Confirm:$false | Out-Null

Start-Sleep -Seconds 10

Start-VM $Name | Out-Null

Start-Sleep -Seconds 10

$Body = Get-VM $Name | Select-Object Name, PowerState, @{n="Snapshots";e={ $_ | Get-Snapshot | Select-Object -ExpandProperty Name }} | Out-String

Send-MailMessage -To $EmailTo -From $EmailFrom -SmtpServer "smtp.email.address" `
                 -Subject "Snapshots - Success" `
                 -Body $Body

# Get-VM $Name | Get-Snapshot -Name $SnapshotName | Remove-Snapshot -Confirm:$false
