<#
.SYNOPSIS
    Grant permission for the supplied principal (AD Group) to have VM Console Rights to the supplied VMs.
#>

param([string[]] $VM, [string] $Principal)

Get-VM -Name $VM | New-VIPermission -Principal $Principal -Role "VM Console Access"
