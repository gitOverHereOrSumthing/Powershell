Import-Module ActiveDirectory

echo "Domain Controllers"
echo "------------------"

$DomainControllers = Get-ADDomainController -Filter * | Select-Object Name, Site

foreach($DomainController in $DomainControllers) {
    echo $DomainController
}

echo ""
echo "GC Servers"
echo "----------"

$GCServers = Get-ADForest | Select-Object -ExpandProperty GlobalCatalogs

foreach($GCServer in $GCServers) {
    echo $GCServer
}

echo ""
echo "Roles"
echo "-----"

$Roles =  Get-ADDomain | Select-Object InfrastructureMaster,PDCEmulator,RIDMaster
$PDCEmulator =  Get-ADDomain | Select-Object PDCEmulator
$RIDMaster =  Get-ADDomain | Select-Object RIDMaster

echo "Infrastructure Master: " $Roles.InfrastructureMaster
echo "PDC Emulator: " $Roles.PDCEmulator
echo "RID Master: " $Roles.RIDMaster