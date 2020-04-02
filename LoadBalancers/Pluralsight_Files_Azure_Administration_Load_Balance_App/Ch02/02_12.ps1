$appGw = Get-AzApplicationGateway -Name "PS-AppGW"

$appGw | Set-AzApplicationGatewaySku -Name WAF_v2 -Tier WAF_v2

Set-AzApplicationGatewayWebApplicationFirewallConfiguration -ApplicationGateway $appGw `
    -Enabled $true -FirewallMode "Detection" -RuleSetType "OWASP" -RuleSetVersion "3.0"

$appGw | Set-AzApplicationGateway