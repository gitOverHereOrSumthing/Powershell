$ComputerName = $args[0]

function get-localadmins {  
	param ($strcomputer)  
	  
	$admins = Gwmi win32_groupuser –computer $strcomputer   
	$admins = $admins |? {$_.groupcomponent –like '*"Administrators"'}  
	  
	$admins |% {  
		$_.partcomponent –match “.+Domain\=(.+)\,Name\=(.+)$” > $nul  
		$matches[1].trim('"') + “\” + $matches[2].trim('"')  
	}  
}

Get-LocalAdmin $ComputerName

Get-WmiObject -Class Win32_UserAccount -Filter  "Name='Administrator'" -ComputerName $ComputerName | Select PSComputername, Name, Status, Disabled, AccountType, Lockout, PasswordRequired, PasswordChangeable, SID 