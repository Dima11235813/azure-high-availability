# Creates a new resource group
$RG = New-AzResourceGroup -ResourceGroupName "LoadBalancer-RG" -Location "WestUS"

# Creates a public static ip address
$IP = New-AzPublicIpAddress -ResourceGroupName "LoadBalancer-RG" -Location "WestUS" -Name "LoadBalancerPubIP"

# Create a front end config using the new IP address just created
$frontEnd = New-AzLoadBalancerFrontendIpConfig -Name "FrontEnd1" -PublicIPAddress $IP

# Create a backend pool for the load balancer configuration
$backEnd = New-AzLoadBalancerBackendAddressPoolConfig -Name "BackEnd1"

# Create 1 health probes that checks services every 30 seconds
$healthProbe = New-AzLoadBalancerProbeConfig -Name "HTTP-Probe" -RequestPath "/" `
    -Protocol HTTP -Port 80 -IntervalInSeconds 30 -ProbeCount 2

# Create a load balancer rule between the front end prot 80 and the backend port 80 using the created health probes
$loadbBalancerRule = New-AzLoadBalancerRuleConfig -Name "LBRule1" `
    -FrontendIpConfiguration $frontEnd -BackendAddressPool $backEnd `
    -Protocol TCP -FrontendPort 80 -BackendPort 80 -Probe $healthProbe

# Finally create the load balancer itself - az load balancer command creates it related to the front end, backend, and health probe created earlier
$LoadBalancer = New-AzLoadBalancer -Name "PS-LoadBalancer" -ResourceGroupName "LoadBalancer-RG" -Location "WestUS" `
    -FrontEndIpConfiguration $frontEnd -BackendAddressPool $backEnd -Probe $healthProbe -LoadBalancingRule $loadbBalancerRule
