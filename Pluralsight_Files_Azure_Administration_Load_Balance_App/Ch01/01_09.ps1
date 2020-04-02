$RG = New-AzResourceGroup -ResourceGroupName "LoadBalancer-RG" -Location "WestUS"

$IP = New-AzPublicIpAddress -ResourceGroupName "LoadBalancer-RG" -Location "WestUS" -Name "LoadBalancerPubIP"

$frontEnd = New-AzLoadBalancerFrontendIpConfig -Name "FrontEnd1" -PublicIPAddress $IP

$backEnd = New-AzLoadBalancerBackendAddressPoolConfig -Name "BackEnd1"

$healthProbe = New-AzLoadBalancerProbeConfig -Name "HTTP-Probe" -RequestPath "/" `
    -Protocol HTTP -Port 80 -IntervalInSeconds 30 -ProbeCount 2

$loadbBalancerRule = New-AzLoadBalancerRuleConfig -Name "LBRule1" `
    -FrontendIpConfiguration $frontEnd -BackendAddressPool $backEnd `
    -Protocol TCP -FrontendPort 80 -BackendPort 80 -Probe $healthProbe

$LoadBalancer = New-AzLoadBalancer -Name "PS-LoadBalancer" -ResourceGroupName "LoadBalancer-RG" -Location "WestUS" `
    -FrontEndIpConfiguration $frontEnd -BackendAddressPool $backEnd -Probe $healthProbe -LoadBalancingRule $loadbBalancerRule
