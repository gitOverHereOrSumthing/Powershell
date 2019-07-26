
# Getting the computer name from the command line
param(            
 [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]            
 [string[]]$ComputerName = $env:computername,
 [string] $IncludeUninstall = "False"
)            

# Connecting to the registry
begin {            
 $UninstallRegKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"             
}            



process {            
	foreach($Computer in $ComputerName) {            
		Write-Verbose "Working on $Computer"            
		if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) {            
			$HKLM   = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computer)            
			$UninstallRef  = $HKLM.OpenSubKey($UninstallRegKey)            
			$Applications = $UninstallRef.GetSubKeyNames() | sort-Object         

			# Array for storing the application objects
			$ApplicationObjects = @()

			foreach ($App in $Applications) {            
				$AppRegistryKey  = $UninstallRegKey + "\\" + $App            
				$AppDetails   = $HKLM.OpenSubKey($AppRegistryKey)            
				$AppGUID   = $App            
				
				if(!$($AppDetails.GetValue("DisplayName"))) { continue } # Ignores blank lines
					# Create a new object to store application details
					$applicationObject = New-Object -TypeName psobject

					# Adding properties to the applicationObject
					$applicationObject | Add-Member -NotePropertyName AppDisplayName -NotePropertyValue ($($AppDetails.GetValue("DisplayName"))).ToString()
					$applicationObject | Add-Member -NotePropertyName AppVersion -NotePropertyValue ($($AppDetails.GetValue("DisplayVersion"))).ToString()
					if (!$($AppDetails.GetValue("Publisher"))) {
						$AppPublisher = "Unknown"
					}
					else {
						$AppPublisher = $($AppDetails.GetValue("Publisher"))
					}
					$applicationObject | Add-Member -NotePropertyName AppPublisher -NotePropertyValue ($AppPublisher).ToString()
					if (!$($AppDetails.GetValue("InstallDate"))) {
						$AppInstalledDate = "Unknown"
					}
					else {
						$AppInstalledDate = $($AppDetails.GetValue("InstallDate"))
					}
					$applicationObject | Add-Member -NotePropertyName AppInstalledDate -NotePropertyValue ($AppInstalledDate).ToString()  
					$applicationObject | Add-Member -NotePropertyName AppUninstallString -NotePropertyValue ($($AppDetails.GetValue("UninstallString"))).ToString() 
					
					$ApplicationObjects += $applicationObject
			}
			
			if ($IncludeUninstall -eq "False"){
				$ApplicationObjects | sort-Object -Property AppDisplayName | Format-Table
			}
			else {
				$ApplicationObjects | sort-Object -Property AppDisplayName
			}
		}
	}            
}            

end {}