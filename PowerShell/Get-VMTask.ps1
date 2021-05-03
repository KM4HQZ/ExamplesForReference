<#
.SYNOPSIS
    Display current VMware Tasks, including the Entity the task is being performed on
#>

param([switch] $Running, [switch] $Relocate)

if ($Running) { $Tasks = Get-Task -Status Running | Sort-Object StartTime -Descending }
else { $Tasks = Get-Task | Sort-Object StartTime -Descending }

if ($Relocate) { $Tasks = $Tasks | Where-Object { $_.Name -like "RelocateVM_Task" } }

$Tasks | Select-Object Name, State, @{ n="Comp" ; e={ $_.PercentComplete } },
    StartTime, FinishTime, @{ n="Entity" ; e={ $_.ExtensionData.Info.EntityName }},
    @{n="User"; e={$_.ExtensionData.Info.Reason.UserName.Split("\")[1] }} |
    Format-Table -AutoSize
