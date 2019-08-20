<#
	.Synopsis
		Lists all of the groups an account is a member of
	.Description
		Lists all of the groups an account is a member of. 
	.Example
		Get-GroupMembership -Name "bsmith"
	.Example
		Get-GroupMembers -Name "bsmith" -OutputFile "c:\temp\output.txt"
	.Example
		Get-GroupMembers -Name "bsmith" -AccountType "computer"
#>

[CmdletBinding()]
Param(
	# The name of the account to check
	[Parameter(mandatory=$true)]
	[string] $Name = "", 
	# The output file name if required
	[string] $OutputFile = "", 
	# The type of AD account to check
	[string] $AccountType = "User" 
	)

# Body of script
if ($AccountType -eq "User"){
	$groups = Get-ADPrincipalGroupMembership -Identity $Name | sort-object
}
elseif ($AccountType -eq "Computer"){
	$groups = Get-AdComputer $Name | Get-ADPrincipalGroupMembership | sort-object
}
else {
	throw "Please provide a valid AccountType (User or Computer)"
}

if ($OutputFile -ne ""){
	if (Test-Path -Path $OutputFile){
		Remove-item $OutputFile
	}
}

if ($Name -eq ""){
	throw "Please provide a valid User or Computer name"
}

foreach($group in $groups) {
    $output = $group.Name
	
	if ($OutputFile -ne ""){
		add-content $OutputFile $output;
	}
	echo $output
}