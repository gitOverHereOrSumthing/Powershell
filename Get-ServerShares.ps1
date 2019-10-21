<#
	.Synopsis
		Lists all of the shares on a server
	.Description
		Lists all of the shares on a server
	.Example
		Get-ServerShares -ComputerName "SVR123"
	.Example
		Get-ServerShares -ComputerName "SVR123" -OutputFile "c:\temp\output.csv"
#>

[CmdletBinding()]
Param(
	# The name of the server to check
	[Parameter(mandatory=$true)]
	[string] $ComputerName = "", 
	# The output file name if required
	[string] $OutputFile = ""
	)

# Body of script
if ($OutputFile -ne ""){
	if (Test-Path -Path $OutputFile){
		Remove-item $OutputFile
	}
}

$cim = New-CimSession -ComputerName $ComputerName
$shares = Get-SmbShare -CimSession $cim

$output = "ShareName,Path,ComputerName"
add-content $OutputFile $output;

foreach($share in $shares) {
	$output = $share.Name + "," + $share.Path + "," + $share.PSComputerName 
	
	if ($OutputFile -ne ""){
		add-content $OutputFile $output;
	}
	echo $share
}

Remove-CimSession -CimSession $cim