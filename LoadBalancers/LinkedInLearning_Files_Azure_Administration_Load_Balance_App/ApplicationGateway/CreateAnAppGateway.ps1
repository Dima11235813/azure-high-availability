# Create variable for the virtual new
$vnet = Get-AzVirtualNetwork -Name "ScaleSet-Vnet" -ResourceGroupName "IIS-ScaleSet-RG"

# Create variable for the sub-network
$subnet = Get-AzVirtualNetworkSubnetConfig -Name "AppGW-subnet" -VirtualNetwork $vnet

# Create variables for VM interfaces and their private ip
# VM1
$VMinterface1 = Get-AzNetworkInterface -ResourceGroupName "IIS-ScaleSet-RG" -Name "vm1-interface"
$VMinterface1IP = $VMinterface1.IpConfigurations[0].PrivateIpAddress

# to the same for VM2
$VMinterface2 = Get-AzNetworkInterface -ResourceGroupName "IIS-ScaleSet-RG" -Name "vm2-interface"
$VMinterface2IP = $VMinterface2.IpConfigurations[0].PrivateIpAddress

#Create assets for application gateway

# Create a resource group and save it in a variable
$RG = New-AzResourceGroup -ResourceGroupName "AppGW-RG" -Location "WestUS"

# Create a public IP and save it in a variable for the App Gateway
$IP = New-AzPublicIpAddress -ResourceGroupName "AppGW-RG" -Location "WestUS" -Name "AppGW-PIP" -Sku Standard -AllocationMethod Static

# Create configs before creating App Gateway

# Create an internal IP config which assigns the App gateway to the sub-network
$internalIP = New-AzApplicationGatewayIPConfiguration -Name "internalIP" -Subnet $subnet

# Assign front end to public ip created
$frontend = New-AzApplicationGatewayFrontendIPConfig -Name "Frontend1" -PublicIPAddress $IP

# Configure the port 
$frontendPort = New-AzApplicationGatewayFrontendPort -Name "FrontendPort1" -Port 80

# Create a backend pool containing the two vm interfaces
$backend = New-AzApplicationGatewayBackendAddressPool -Name "Backend1" -BackendIPAddresses $VMinterface1IP, $VMinterface2IP

# Connect port 80 with no cookie based affinity to the backend pool just created with a timeout of one minute
$backendSettings = New-AzApplicationGatewayBackendHttpSetting -Name "backend1Settings" `
    -Port 80 -Protocol Http -CookieBasedAffinity Disabled -RequestTimeout 60

# Create a listener that tells App Gateway to listen using the front end ip config created before on the front end port created before
$listener = New-AzApplicationGatewayHttpListener -Name "listener1" -Protocol HTTP `
    -FrontendIPConfiguration $frontend -FrontendPort $frontendPort

# Create a rule that connects everything together 
$frontendRule = New-AzApplicationGatewayRequestRoutingRule -Name "rule1" -RuleType Basic `
    -HttpListener $listener -BackendAddressPool $backend -BackendHttpSettings $backendSettings

# Specify the type of App Gateway to create
$appGatewaySKU = New-AzApplicationGatewaySku -Name Standard_v2 -Tier Standard_v2 -Capacity 2

# Finally create the actaul App Gateway
$appGateway = New-AzApplicationGateway -Name "PS-AppGW" -ResourceGroupName "AppGW-RG" -Location "WestUS" `
    -FrontEndIpConfiguration $frontEnd -FrontendPorts $frontendPort -RequestRoutingRules $frontendRule `
    -GatewayIPConfigurations $internalIP -BackendAddressPool $backEnd -HttpListeners $listener -Sku $appGatewaySKU