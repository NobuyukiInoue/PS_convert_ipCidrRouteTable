# PS_convert_ipCidrRouteTable

It is a script that outputs ipCidrRouteTable(.1.3.6.1.2.1.4.24.4)<br>
after converting it to a table format On PowerShell.

## Requirement

* Net-SNMP(http://www.net-snmp.org/)
* PowerShell 5.1 or Later

## Usage

```
> snmpwalk -On -v 2c -c <community> <target_ip> .1.3.6.1.2.1.4.24.4 | ./convert_ipCidrRouteTable.ps1
```

## Execution example(Sample Data)

```
PS D:\PS_convert_ipCidrRouteTable> Get-Content .\sample\sample1.txt  
.1.3.6.1.2.1.4.24.4.1.1.10.1.15.0.255.255.255.0.0.0.0.0.0 = IpAddress: 10.1.15.0
.1.3.6.1.2.1.4.24.4.1.1.10.1.15.254.255.255.255.255.0.0.0.0.0 = IpAddress: 10.1.15.254
.1.3.6.1.2.1.4.24.4.1.1.10.15.0.0.255.255.255.0.0.0.0.0.0 = IpAddress: 10.15.0.0
.1.3.6.1.2.1.4.24.4.1.1.10.15.0.254.255.255.255.255.0.0.0.0.0 = IpAddress: 10.15.0.254
.1.3.6.1.2.1.4.24.4.1.1.10.15.10.0.255.255.255.0.0.0.0.0.0 = IpAddress: 10.15.10.0
  ...
  ...
PS D:\PS_convert_ipCidrRouteTable> Get-Content .\sample\sample1.txt | .\PS_convert_ipCidrRouteTable.ps1
Destination         Netmask             NextHop             ifIndex   Type      Proto     Tos
10.1.15.0           255.255.255.0       0.0.0.0             99        3         2         0
10.1.15.254         255.255.255.255     0.0.0.0             99        3         2         0
10.15.0.0           255.255.255.0       0.0.0.0             99        3         2         0
10.15.0.254         255.255.255.255     0.0.0.0             99        3         2         0
10.15.10.0          255.255.255.0       0.0.0.0             99        3         2         0
10.15.10.254        255.255.255.255     0.0.0.0             99        3         2         0
10.20.25.0          255.255.255.0       0.0.0.0             10501     4         13        0
10.20.25.254        255.255.255.255     0.0.0.0             20567     3         2         0
10.16.0.0           255.255.255.0       0.0.0.0             99        3         2         0
10.16.0.254         255.255.255.255     0.0.0.0             99        3         2         0
PS D:\PS_convert_ipCidrRouteTable>
```

## Licence

[MIT](https://github.com/NobuyukiInoue/PS_convert_ipCidrRouteTable/blob/master/LICENSE)

## Author

[Nobuyuki Inoue](https://github.com/NobuyukiInoue/)
