Param (
    [String]
    $VMName
)

if ((get-vm -name $VMName).state -ne 'Running') {
     echo "$VMName is not running. Starting machine." 
    Start-Vm -Name $VMName
    # TODO: Set some sort of timeout
    while ((get-vm -name $VMName).state -ne 'Running') { 
        sleep 1
    }
}

echo "$VMname is running. Monitoring status."
while ((get-vm -name $VMName).state -eq 'Running') { 
    sleep 30
}