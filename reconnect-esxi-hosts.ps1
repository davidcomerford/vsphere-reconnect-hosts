#requires -version 2
<#
.SYNOPSIS
  Reconnects disconnected ESXi hosts

.DESCRIPTION
  This is useful if all of your ESXi hosts are in a disconnected state.
  For me it came in handy after changing the SSL cert on the vCenter server

.INPUTS 
  Mandatory. passwords.txt is a CSV file for the ESXi hosts and their passwords

.OUTPUTS
  Some success information 

.NOTES
  Author:         David Comerford
  Github:         https://github.com/davidcomerford/
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------


#----------------------------------------------------------[Declarations]----------------------------------------------------------

$passwordfile = ".\passwords.txt"

$debug = $true

# The reconnect tasks doesn't wait for completion so I like to add a sleep so vCenter isn't flooding with tasks.
$sleepytime = 0

$passwordcount = 0
$vmhostcount = 0

# initialise the hashtable
$table=@{}
#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Load the list of host passwords
Import-Csv $passwordfile | ForEach-Object {
  $table[$_.hostname] = $_.'password'
}
$passwordcount = $table.Count

Write-Host -ForegroundColor Yellow "Loaded $passwordcount credentials from $passwordfile "
$hosts =Get-VMHost | where { $_.ConnectionState -eq "Disconnected" }

foreach ($h in $hosts) {
	$view = get-view $h
	$arg = new-object VMware.Vim.HostConnectSpec
	$arg.userName = "root"
	$password = $table["$h"]
	if ($debug) { write-host $h':'$password }
	$arg.password = $password
	$arg.force = $true
	
	$view.ReconnectHost_Task($arg,$null)
	Start-Sleep $sleepytime
	}
	