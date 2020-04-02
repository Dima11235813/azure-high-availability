$vnet = Get-AzVirtualNetwork -Name "ScaleSet-Vnet" -ResourceGroupName "IIS-ScaleSet-RG"

$subnet = Get-AzVirtualNetworkSubnetConfig -Name "AppGW-subnet" -VirtualNetwork $vnet

$VMinterface1 = Get-AzNetworkInterface -ResourceGroupName "IIS-ScaleSet-RG" -Name "vm1-interface"
$VMinterface1IP = $VMinterface1.IpConfigurations[0].PrivateIpAddress

$VMinterface2 = Get-AzNetworkInterface -ResourceGroupName "IIS-ScaleSet-RG" -Name "vm2-interface"
$VMinterface2IP = $VMinterface2.IpConfigurations[0].PrivateIpAddress

##

$RG = New-AzResourceGroup -ResourceGroupName "AppGW-RG" -Location "WestUS"

$IP = New-AzPublicIpAddress -ResourceGroupName "AppGW-RG" -Location "WestUS" -Name "AppGW-PIP" -Sku Standard -AllocationMethod Static

$internalIP = New-AzApplicationGatewayIPConfiguration -Name "internalIP" -Subnet $subnet

$frontend = New-AzApplicationGatewayFrontendIPConfig -Name "Frontend1" -PublicIPAddress $IP

$frontendPort = New-AzApplicationGatewayFrontendPort -Name "FrontendPort1" -Port 80

$backend = New-AzApplicationGatewayBackendAddressPool -Name "Backend1" -BackendIPAddresses $VMinterface1IP, $VMinterface2IP

$backendSettings = New-AzApplicationGatewayBackendHttpSetting -Name "backend1Settings" `
    -Port 80 -Protocol Http -CookieBasedAffinity Disabled -RequestTimeout 60

$listener = New-AzApplicationGatewayHttpListener -Name "listener1" -Protocol HTTP `
    -FrontendIPConfiguration $frontend -FrontendPort $frontendPort

$frontendRule = New-AzApplicationGatewayRequestRoutingRule -Name "rule1" -RuleType Basic `
    -HttpListener $listener -BackendAddressPool $backend -BackendHttpSettings $backendSettings

##

$appGatewaySKU = New-AzApplicationGatewaySku -Name Standard_v2 -Tier Standard_v2 -Capacity 2

$appGateway = New-AzApplicationGateway -Name "PS-AppGW" -ResourceGroupName "AppGW-RG" -Location "WestUS" `
    -FrontEndIpConfiguration $frontEnd -FrontendPorts $frontendPort -RequestRoutingRules $frontendRule `
    -GatewayIPConfigurations $internalIP -BackendAddressPool $backEnd -HttpListeners $listener -Sku $appGatewaySKU