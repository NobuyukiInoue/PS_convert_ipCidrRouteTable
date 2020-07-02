param($target, $community, $IFS)

if (-Not($target)) {
    Write-Host "Usage :"$MyInvocation.MyCommand.Name"<target> <community>"
    exit
}

if (-Not($community)) {
    $community = "public"
}

if (-Not($IFS)) {
    $IFS = ""
}


$OID = ".1.3.6.1.2.1.4.24.4"
$walkResult = snmpwalk -On -v 2c -c $community $target $OID

if ($walkResult -eq $NULL) {
    Write-Output $walkResult
    exit
}

$walkResult | ./PS_convert_ipCidrRouteTable.ps1 $IFS
