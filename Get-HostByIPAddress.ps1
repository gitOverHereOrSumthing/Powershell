<#
	.Synopsis
		Searches DNS for the name of the computer with the passed IP address
	.Description
		Searches DNS for the name of the computer with the passed IP address
	.Example
		Get-HostByIPAddress 172.16.0.1
#>

[CmdletBinding()]
Param (
	# The IP address of the computer you want to search for
	$IPAddress
)

# Body of script
[System.Net.Dns]::GetHostByAddress($IPAddress)