<#
	.Synopsis
		Gets GEO location information for a given IP address or domain name
	.Description
		Gets GEO location information for a given IP address or domain name
	.Example
		Get-LocationInfo 172.0.01
	.Example
		Get-LocationInfo example.com
#>

$TargetURI = "https://tools.keycdn.com/geo.json?host=" + $Args[0]

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$Response = Invoke-RestMethod -Uri $TargetURI
echo $Response.data.geo