$appGw = Get-AzApplicationGateway -Name "PS-AppGW"

$appGw | Add-AzApplicationGatewayProbeConfig -Name "probe1" -Protocol Http `
    -PickHostNameFromBackendHttpSettings -Path "/" -UnhealthyThreshold 5 -Interval 60 -Timeout 60

$appGw | Set-AzApplicationGatewaySku -Name Standard_v2 -Tier Standard_v2
$appGw | Set-AzApplicationGatewayAutoscaleConfiguration -MinCapacity 3 -MaxCapacity 15

$appGw | Set-AzApplicationGateway