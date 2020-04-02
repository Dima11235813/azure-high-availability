$loadBalancer = get-azloadbalancer -Name "PS-Loadbalancer"

$backend = Get-AzLoadBalancerBackendAddressPoolConfig -Name "BackEnd1" -LoadBalancer $loadBalancer

$loadBalancer | Add-AzLoadBalancerInboundNatRuleConfig -Name "RemoteDesktopVM1Rule" `
    -FrontendIpConfiguration $loadBalancer.FrontendIpConfigurations[0] -Protocol "Tcp" `
    -FrontendPort 33890 -BackendPort 3389

$availabilitySet = Get-AzAvailabilitySet -ResourceGroupName "IIS-ScaleSet-RG" -Name "Availability1"

ForEach ($vm in $availabilitySet.VirtualMachinesReferences) {

    $networkInterface = Get-AzNetworkInterface | Where-Object {$_.VirtualMachine.id -like $vm.id}
    $networkInterface.IpConfigurations[0].LoadBalancerBackendAddressPools = $backend

    Set-AzNetworkInterface -NetworkInterface $networkInterface   
}

$loadBalancer | Set-AzLoadBalancer

$loadBalancer | Remove-AzLoadBalancer