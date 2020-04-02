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

Internal Load Balancers
* Direct traffic only between internal resources
  * No outgoing IP address translation
  * There's no public IP, all comms is done with private IPs 
* Typical use
  * connections between virtual machins in the same vnet (virtual network)
  * multitier applications

## Configure a Load Balancer Front-End

Frontend IP Config
* Public IP or Internal IP that the load balancer will respond to
  * Add 2 different front ends for load balancer

## Configure a Backend Pool

Backend Pools
* name, ipv4 or ipv6 and assocation:
  * availability set
  * single virtual machine
  * vm scale set
    * IISScaleSet one which was created previously
  * upgrade instances of scale sets
    * upgrade to use the backend pool with load balancer

## Create a Health Probe

Used to check if backend pools are working correctly.

Add
* Name, Protocol (TCP, HTTP), PORT(HTTP), 
* Path (/)
* Interval (how often the services are checked) 
* Unhealthy threshold
  * failure more than this number indicates that this service will no longer receive requests

## Configure Load Balancing Rules

Connect front to back end
* Load Balancing Rules > Add
  * Name, IP Version, IP Address, Protocol, 
  * Port
  * Backend Port
  * Backend pool
  * Health Probe
  * Session persistence
  * Idle timeout
  * Floating IP (direct server return ) disabled - enabled - sql always on uses floating ips

End result is that the same IP will be routed to some service available in the backend pool.

## Configure NAT port-forwarding rules

Add inbound NAT rule
* Name - Remote desktop rule vm1
* Frontend IP address
* IP
* Service
* Protocol
* Port 3389
  * redirect it to VM1 - Network Ip 10.0.0.5
  * Port mapping - default - or custom

End result is that requests for RDP on the public IP get routed to VM1

## Load Balancer Using Powershell








