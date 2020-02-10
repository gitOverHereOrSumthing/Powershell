<#
	.Synopsis
		Gets the boot time of the target computer
	.Description
		Gets the boot time of the target computer.  It does this by getting both a specific event (id 30) that shows up when a machine boots and by using
		win32_operatingsystem.  win32_operatingsystem doesn't always show the true boot up date/time due to a problem caused by the Fast Start up setting.
		This is a known issue https://social.technet.microsoft.com/Forums/en-US/b2cb5a29-8317-4c1a-a555-99ac79bebe7c/windows-10-lastbootuptime-not-updating?forum=win10itprogeneral
	.Example
		Get-BootTime "abc123"
#>

$ComputerName = $args[0]

$Events = Get-WinEvent -FilterHashtable @{LogName='System';ID='30'} -MaxEvents 1 -ComputerName $ComputerName

foreach ($Event in $Events){
	$outputLine = "Boot time according to event ID 30: " + $Event.TimeCreated.ToString('yyyy-MM-dd HH:mm:ss')
    echo $outputLine
}

$BootTime = (Get-CimInstance -ClassName win32_operatingsystem).lastbootuptime
$outputLine = "Boot time according to CIM Instance: " + $BootTime.ToString('yyyy-MM-dd HH:mm:ss')
echo $outputLine