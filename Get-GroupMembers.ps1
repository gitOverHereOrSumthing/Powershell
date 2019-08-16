<#
	.Synopsis
		Lists all of the members of a group
	.Description
		Lists all of the members of a group.  Use the Recursive switch to list the members of groups within the group.
	.Example
		Get-GroupMembers -Group "Domain Admins"
	.Example
		Get-GroupMembers -Recursive -Group "Domain Admins"
	.Example
		Get-GroupMembers -Group "Domain Admins" -OutputFile "c:\temp\output.txt"
#>

[CmdletBinding()]
Param(
	# The name of the Ad group to search
	[Parameter(mandatory=$true)]
	[string] $Group = "", 
	# The output file name if required
	[string] $OutputFile = "", 
	# Switch to list group members within the group you are searching
	[switch] $Recursive
	)

# Body of script
if ($Recursive -eq $false){
	$users = get-adgroupmember -Identity $Group  | sort-object
} Else {
	$users = get-adgroupmember -Identity $Group -Recursive  | sort-object
}

if ($OutputFile -ne ""){
	if (Test-Path -Path $OutputFile){
		Remove-item $OutputFile
	}
}

foreach($user in $users) {
    $output = $user.Name
	
	if ($OutputFile -ne ""){
		add-content $OutputFile $output;
	}
	echo $output
}