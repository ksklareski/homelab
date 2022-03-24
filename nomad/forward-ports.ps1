# forward_ports.ps1
Param (
    [String]
    $wsl_host,

    [string[]]
    $ports
)

# $wsl_host = $args[0]
# $ports = $args[1]
echo "Args: $($args)"
echo "Hostname: $wsl_host"
echo "Ports: $ports"

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

$remoteport = wsl -d $wsl_host -u root bash -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if ($found) {
    $remoteport = $matches[0];
}
else {
    Write-Output "IP address could not be found" >> C:\temp\portlog.txt;
    $host.SetShouldExit(1);
    exit 1;
}

$ports = $ports;

Invoke-Expression "netsh interface portproxy reset";

for ($i = 0; $i -lt $ports.length; $i++) {
    $port = $ports[$i];
    Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$remoteport";
    Invoke-Expression "netsh advfirewall firewall add rule name=$port dir=in action=allow protocol=TCP localport=$port";
}

Invoke-Expression "netsh interface portproxy show v4tov4";