param([string] $Group = "Domain Admins", [string] $OutputFile = "None", [string] $Recursive = "false")

if ($Recursive -eq "false"){
	$users = get-adgroupmember -Identity $Group  | sort-object
} Else {
	$users = get-adgroupmember -Identity $Group -Recursive  | sort-object
}

if ($OutputFile -ne "None"){
	if (Test-Path -Path $OutputFile){
		Remove-item $OutputFile
	}
}

foreach($user in $users) {
    $output = $user.Name
	
	if ($OutputFile -ne "None"){
		add-content $OutputFile $output;
	}
	echo $output
}