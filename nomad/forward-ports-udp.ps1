Param (
    [String]
    $sleepsec,

    [String]
    $ip,

    [string[]]
    $port
)

echo "Sleeping for $sleepsec seconds";
echo $ip
echo $port
# sleep $sleepsec;

# echo "Creating port forward";
# start-job -scriptblock { $dnsmasq_pid = (start-process -filepath "C:/Program Files/socat/socat.exe" -argumentlist "UDP4-RECVFROM:$port,fork UDP4-SENDTO:$ip:$port" -NoNewWindow -passthru).id; [System.Environment]::SetEnvironmentVariable("DNSPID",$dnsmasq_pid,[System.EnvironmentVariableTarget]::Machine) };

# echo "Opening firewall";
# netsh advfirewall firewall add rule name=$port dir=in action=allow protocol=UDP localport=$port;

# sleep 2