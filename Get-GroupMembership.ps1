param([string] $Name = "", [string] $OutputFile = "None",[string] $AccountType = "User")

if ($AccountType -eq "User"){
	$groups = Get-ADPrincipalGroupMembership -Identity $Name | sort-object
}
elseif ($AccountType -eq "Computer"){
	$groups = Get-AdComputer $Name | Get-ADPrincipalGroupMembership | sort-object
}
else {
	throw "Please provide a valid AccountType (User or Computer)"
}

if ($OutputFile -ne "None"){
	if (Test-Path -Path $OutputFile){
		Remove-item $OutputFile
	}
}

if ($Name -eq ""){
	throw "Please provide a valid User or Computer name"
}

foreach($group in $groups) {
    $output = $group.Name
	
	if ($OutputFile -ne "None"){
		add-content $OutputFile $output;
	}
	echo $output
}