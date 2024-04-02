Import-Module ./Crescendo/SNMP.psd1 -Force
#region printer demo things

#Drum Unit life
$remaining = '.1.3.6.1.2.1.43.11.1.1.9.1.2'
$capacity = '.1.3.6.1.2.1.43.11.1.1.8.1.2'

$lifeRemaining = (Start-Snmpwalk -Version 1 -Community public -Target 192.168.1.20 -Oid $remaining)
$totalCapacity = (Start-Snmpwalk -Version 1 -Community public -Target 192.168.1.20 -oid $capacity)

([Math]::Round(($lifeRemaining.Value / $totalCapacity.value),2)) * 100
#endregion

#region server uptime
$serverUptime = snmpwalk -v1 -c public 172.16.115.144 1.3.6.1.2.1.1.3.0
#endregion