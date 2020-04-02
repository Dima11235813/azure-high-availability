# Create a variable for the loadbalancer
$loadBalancer = get-azloadbalancer -Name "PS-Loadbalancer"

# Create a varaible for the backend
$backend = Get-AzLoadBalancerBackendAddressPoolConfig -Name "BackEnd1" -LoadBalancer $loadBalancer

# Create an inbound NAT rule for RDP on for port 3389
$loadBalancer | Add-AzLoadBalancerInboundNatRuleConfig -Name "RemoteDesktopVM1Rule" `
    -FrontendIpConfiguration $loadBalancer.FrontendIpConfigurations[0] -Protocol "Tcp" `
    -FrontendPort 33890 -BackendPort 3389

# Create a variable for the availablility set
$availabilitySet = Get-AzAvailabilitySet -ResourceGroupName "IIS-ScaleSet-RG" -Name "Availability1"

# Check every VM in the availability set and add them to the backend pool
ForEach ($vm in $availabilitySet.VirtualMachinesReferences) {

    # Set the Network Interface to be configured to the backend address pool in the load balancer
    $networkInterface = Get-AzNetworkInterface | Where-Object {$_.VirtualMachine.id -like $vm.id}
    $networkInterface.IpConfigurations[0].LoadBalancerBackendAddressPools = $backend
    
    Set-AzNetworkInterface -NetworkInterface $networkInterface   
}

$loadBalancer | Set-AzLoadBalancer

$loadBalancer | Remove-AzLoadBalancer