#ipconfigImport CSV file
$Data=Import-Csv c:\IP\IP.csv
#Get ifIndex for active adapters
$Index = Get-NetAdapter | Select-Object ifIndex
#Check to see if there is a GW
$CheckGW = Get-NetIPConfiguration | Foreach IPv4DefaultGateway
#Check for static IP
$CheckIP = Get-WMIObject Win32_NetworkAdapterConfiguration | where{$_.IPEnambled -eq "TRUE"}

#Set IP
#if (!$CheckIP.DHCPEnabled){
New-NetIPAddress -InterfaceIndex $Index.ifIndex -IPAddress $Data.IPAddress -PrefixLength 24 #-DefaultGateway $Data.Gateway
#}
#Set DNS
Set-DnsClientServerAddress -InterfaceIndex $Index.ifIndex -ServerAddresses $Data.DNSServers

# Pause for 10 seconds
Start-Sleep -s 10

#Is there a GW
#if (!$CheckGW) {
New-NetRoute -interfaceindex $Index.ifIndex -NextHop $Data.Gateway -destinationprefix “0.0.0.0/0”
#}