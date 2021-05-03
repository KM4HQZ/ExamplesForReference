<#
.SYNOPSIS
    Create new volumes on a newly built VM. Use 0 as a volume size to skip creation of that volume.
#>

param(  [string] $Computer,
        [int] $DBSizeGB = 0,
        [int] $LogSizeGB = 0,
        [int] $RSizeGB = 0,
        [int] $TempDBSizeGB = 0)

$NewVM = Get-VM $Computer

$NewDisks = @(
    [PSCustomObject]@{ DriveLetter = "D"; DriveLabel = "Database"; DriveSize = $DBSizeGB},
    [PSCustomObject]@{ DriveLetter = "L"; DriveLabel = "Logs"; DriveSize = $LogSizeGB},
    [PSCustomObject]@{ DriveLetter = "R"; DriveLabel = "R"; DriveSize = $RSizeGB},
    [PSCustomObject]@{ DriveLetter = "T"; DriveLabel = "Temp"; DriveSize = $TempDBSizeGB}
)

$NewDisks | ForEach-Object {
    if ($_.DriveSize -gt 0) {
        New-HardDisk -VM $NewVM -CapacityGB $_.DriveSize -StorageFormat EagerZeroedThick
        $PSDriveNew = "Get-Disk |
            Where-Object PartitionStyle -eq 'raw' |
            Initialize-Disk -PartitionStyle MBR -PassThru |
            New-Partition -DriveLetter $($_.DriveLetter) -UseMaximumSize |
            Format-Volume -FileSystem NTFS -NewFileSystemLabel ""$($_.DriveLabel)"" -AllocationUnitSize 64kb -Confirm:`$false |
            Out-Null"
        Invoke-VMScript -VM $NewVM -ScriptText $PSDriveNew -ScriptType Powershell
    }
}
