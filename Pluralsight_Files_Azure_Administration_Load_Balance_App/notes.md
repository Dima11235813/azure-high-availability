# Azure Load Balancer

Aspects of Load Balancing
* Front and Back end
* [Layer 4 (transport)](https://en.wikipedia.org/wiki/OSI_model#Layer_4:_Transport_Layer) rules
* [Network Address Translation](https://www.wikiwand.com/en/Network_address_translation) (NAT) rules
  * Essential tool in conserving global address space in the face of IPv4 address exhaustion. One Internet-routable IP address of a NAT gateway can be used for an entire private network.
* [Basic and standard SKUs](https://docs.microsoft.com/en-us/azure/load-balancer/concepts-limitations#skus)
  * Standard Load Balancer required for HTTPS health probes
* [Health Probes](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview)
  * Determine if a service instance can handle requests

## External vs Internal Load Balancer

External load balancers map public IP address and ports to internal targets
* Applies load balancing rules
* Users [Port Address Translation](https://infra.engineer/azure/47-azure-nat-and-pat-through-load-balancer) (PAT)
* 




