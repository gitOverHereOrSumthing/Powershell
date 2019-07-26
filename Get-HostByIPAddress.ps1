$ComputerName = $args[0]
[System.Net.Dns]::GetHostByAddress($ComputerName)