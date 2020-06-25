##------------------------------------------------------------------------------------------------##
## It is a script that outputs ipCidrRouteTable(.1.3.6.1.2.1.4.24.4)
## after converting it to a table format.
##
## Usage)
## snmpwalk -On -v 2c -c <community> <target_ip> .1.3.6.1.2.1.4.24.4 | ./convert_ipCidrRouteTable.ps1
##------------------------------------------------------------------------------------------------##
param($IFS)

if (-Not($IFS)) {
    $IFS = ""
  # $IFS = "`t"
  # $IFS = ";"
}
else {
    $IFS = $IFS.Replace("\t", "`t")
    $IFS = $IFS.Replace("\r", "`r")
    $IFS = $IFS.Replace("\n", "`n")
}

class ifValues {
    [string] $OID
    [string] $OIDRegular
    [string] $Name
    [int]    $count

    Init($oid, $name) {
        $this.Name = $name
        $this.OID = $oid
        $this.OIDRegular = "^" + $this.OID.Replace("." ,"\.")
        $this.count = 0
    }
}

class RouteTable {
    [string] $ipCidrRouteOID
    [string] $ipCidrRouteDest
    [string] $ipCidrRouteMask
    [string] $ipCidrRouteTos
    [string] $ipCidrRouteNextHop
    [string] $ipCidrRouteIfIndex
    [string] $ipCidrRouteType
    [string] $ipCidrRouteProto
    [string] $ipCidrRouteAge
    [string] $ipCidrRouteInfo
    [string] $ipCidrRouteNextHopAS
    [string] $ipCidrRouteMetric2
    [string] $ipCidrRouteMetric3
    [string] $ipCidrRouteMetric4
    [string] $ipCidrRouteMetric5
    [string] $ipCidrRouteStatus
}

$ipCidrRouteOID = New-Object ifValues
$ipCidrRouteOID.Init(".1.3.6.1.2.1.4.24.4.", "ipCidrRouteOID")

$ipCidrRouteDest = New-Object ifValues
$ipCidrRouteDest.Init(".1.3.6.1.2.1.4.24.4.1.1.", "ipCidrRouteDest")

$ipCidrRouteMask = New-Object ifValues
$ipCidrRouteMask.Init(".1.3.6.1.2.1.4.24.4.1.2.", "ipCidrRouteMask")

$ipCidrRouteTos = New-Object ifValues
$ipCidrRouteTos.Init(".1.3.6.1.2.1.4.24.4.1.3.", "ipCidrRouteTos")

$ipCidrRouteNextHop = New-Object ifValues
$ipCidrRouteNextHop.Init(".1.3.6.1.2.1.4.24.4.1.4.", "ipCidrRouteNextHop")

$ipCidrRouteIfIndex = New-Object ifValues
$ipCidrRouteIfIndex.Init(".1.3.6.1.2.1.4.24.4.1.5.", "ipCidrRouteIfIndex")

$ipCidrRouteType = New-Object ifValues
$ipCidrRouteType.Init(".1.3.6.1.2.1.4.24.4.1.6.", "ipCidrRouteType")

$ipCidrRouteProto = New-Object ifValues
$ipCidrRouteProto.Init(".1.3.6.1.2.1.4.24.4.1.7.", "ipCidrRouteProto")

$ipCidrRouteAge = New-Object ifValues
$ipCidrRouteAge.Init(".1.3.6.1.2.1.4.24.4.1.8.", "ipCidrRouteAge")

$ipCidrRouteInfo = New-Object ifValues
$ipCidrRouteInfo.Init(".1.3.6.1.2.1.4.24.4.1.9.", "ipCidrRouteInfo")

$ipCidrRouteNextHopAS = New-Object ifValues
$ipCidrRouteNextHopAS.Init(".1.3.6.1.2.1.4.24.4.1.10.", "ipCidrRouteNextHopAS")

$ipCidrRouteMetric2 = New-Object ifValues
$ipCidrRouteMetric2.Init(".1.3.6.1.2.1.4.24.4.1.12.", "ipCidrRouteMetric2")

$ipCidrRouteMetric3 = New-Object ifValues
$ipCidrRouteMetric3.Init(".1.3.6.1.2.1.4.24.4.1.13.", "ipCidrRouteMetric3")

$ipCidrRouteMetric4 = New-Object ifValues
$ipCidrRouteMetric4.Init(".1.3.6.1.2.1.4.24.4.1.14.", "ipCidrRouteMetric4")

$ipCidrRouteMetric5 = New-Object ifValues
$ipCidrRouteMetric5.Init(".1.3.6.1.2.1.4.24.4.1.15.", "ipCidrRouteMetric5")

$ipCidrRouteStatus = New-Object ifValues
$ipCidrRouteStatus.Init(".1.3.6.1.2.1.4.24.4.1.16.", "ipCidrRouteStatus")

$resultTable = @()

foreach ($line in $input) {
 #  Write-Output $line
    switch -Regex ($line) {
        $ipCidrRouteDest.OIDRegular {
            $line = $line.Replace($ipCidrRouteDest.OID, "")
            $flds = $line -split " = "
            if ($flds.Length -ge 2) {
                $resultTable += New-Object RouteTable
                $resultTable[$resultTable.Lenght - 1].ipCidrRouteOID = $flds[0].Replace($ipCidrRouteDest.OID, "")
                $resultTable[$resultTable.Lenght - 1].ipCidrRouteDest = $flds[1].Replace("IpAddress: ", "")
            }
            else {
                Write-Output "$ipCidrRouteDest.OID Check Error"
                return
            }
            break
        }
        $ipCidrRouteMask.OIDRegular {
            $line = $line.Replace($ipCidrRouteMask.OID, "")
            $flds = $line -split " = "
            if (($flds.Length -ge 2) -And ($flds[0] -eq $resultTable[$ipCidrRouteMask.count].ipCidrRouteOID)) {
                $resultTable[$ipCidrRouteMask.count].ipCidrRouteMask = $flds[1].Replace("IpAddress: ", "")
                $ipCidrRouteMask.count++
            }
            else {
                Write-Output "$ipCidrRouteMask.OID Check Error"
                return
            }
            break
        }
        $ipCidrRouteTos.OIDRegular {
            $line = $line.Replace($ipCidrRouteTos.OID, "")
            $flds = $line -split " = "
            if (($flds.Length -ge 2) -And ($flds[0] -eq $resultTable[$ipCidrRouteTos.count].ipCidrRouteOID)) {
                $resultTable[$ipCidrRouteTos.count].ipCidrRouteTos = $flds[1].Replace("INTEGER: ", "")
                $ipCidrRouteTos.count++
            }
            break
        }
        $ipCidrRouteNextHop.OIDRegular {
            $line = $line.Replace($ipCidrRouteNextHop.OID, "")
            $flds = $line -split " = "
            if (($flds.Length -ge 2) -And ($flds[0] -eq $resultTable[$ipCidrRouteNextHop.count].ipCidrRouteOID)) {
                $resultTable[$ipCidrRouteNextHop.count].ipCidrRouteNextHop = $flds[1].Replace("IpAddress: ", "")
                $ipCidrRouteNextHop.count++
            }
            break
        }
        $ipCidrRouteIfIndex.OIDRegular {
            $line = $line.Replace($ipCidrRouteIfIndex.OID, "")
            $flds = $line -split " = "
            if (($flds.Length -ge 2) -And ($flds[0] -eq $resultTable[$ipCidrRouteIfIndex.count].ipCidrRouteOID)) {
                $resultTable[$ipCidrRouteIfIndex.count].ipCidrRouteIfIndex = $flds[1].Replace("INTEGER: ", "")
                $ipCidrRouteIfIndex.count++
            }
            break
        }
        $ipCidrRouteType.OIDRegular {
            $line = $line.Replace($ipCidrRouteType.OID, "")
            $flds = $line -split " = "
            if (($flds.Length -ge 2) -And ($flds[0] -eq $resultTable[$ipCidrRouteType.count].ipCidrRouteOID)) {
                $resultTable[$ipCidrRouteType.count].ipCidrRouteType = $flds[1].Replace("INTEGER: ", "")
                $ipCidrRouteType.count++
            }
            break
        }
        $ipCidrRouteProto.OIDRegular {
            $line = $line.Replace($ipCidrRouteProto.OID, "")
            $flds = $line -split " = "
            if (($flds.Length -ge 2) -And ($flds[0] -eq $resultTable[$ipCidrRouteProto.count].ipCidrRouteOID)) {
                $resultTable[$ipCidrRouteProto.count].ipCidrRouteProto = $flds[1].Replace("INTEGER: ", "")
                $ipCidrRouteProto.count++
            }
            break
        }
    }
}

if ($IFS -eq "") {
    $format = "{0,-20}{1,-20}{2,-20}{3,-10}{4,-10}{5,-10}{6,-10}"
}
else {
    $format = "{0}$IFS{1}$IFS{2}$IFS{3}$IFS{4}$IFS{5}$IFS{6}"
}


Write-Output ($format -f `
    "Destination" `
  , "Netmask" `
  , "NextHop" `
  , "ifIndex" `
  , "Type" `
  , "Proto" `
  , "Tos" `
#  , "Age" `
#  , "Info" `
)

for ($i = 0; $i -lt $resultTable.Length; $i++) {
    Write-Output ($format -f `
      $resultTable[$i].ipCidrRouteDest `
    , $resultTable[$i].ipCidrRouteMask `
    , $resultTable[$i].ipCidrRouteNextHop `
    , $resultTable[$i].ipCidrRouteIfIndex `
    , $resultTable[$i].ipCidrRouteType `
    , $resultTable[$i].ipCidrRouteProto `
    , $resultTable[$i].ipCidrRouteTos `
#    , $resultTable[$i].ipCidrRouteAge `
#    , $resultTable[$i].ipCidrRouteInfo `
    )
}
