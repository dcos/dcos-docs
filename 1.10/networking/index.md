---
post_title: Networking
menu_order: 070
---

DC/OS provides a number of tools out of the box for service discovery and load balancing. 

# IP Per Container
Allows containers to run on any type of IP-based virtual networks, which each container having its own network namespace.

# DNS-Based Service Discovery
DC/OS includes highly available, distributed, DNS-based service discovery. The service discovery mechanism in DC/OS contains these components:

- A centralized component called [Mesos DNS](/docs/1.10/overview/networking/service-discovery/mesos-dns/), which runs on every master.
- A distributed component called [Spartan](/docs/1.10/overview/networking/service-discovery/spartan/) that runs on every agent. 

## Mesos DNS
Mesos DNS is a centralized, replicated, DNS server that runs on every master. Every task started by DC/OS gets a well known DNS name. This provides a replicated, highly available DNS service on each of the masters. Every instance of Mesos DNS polls the leading Mesos master and generates a fully qualified domain name (FQDN) for every service running in DC/OS with the domain `*.mesos`.  

## DNS Forwarder (Spartan)
Spartan acts as a DNS masquerade for Mesos DNS on each agent. The Spartan instance on each agent is configured to listen to three different local interfaces on the agent and the nameservers on the agent are set to these three interfaces. This allows containers to perform up to three retries on a DNS request. To provide a highly available DNS service, Spartan forwards each request it receives to the different Mesos DNS instances which are running on each master.

- Scale-out DNS Server on DC/OS masters with replication
- DNS server Proxy with links to all Active/Active DNS server daemons
- DNS server cache service for local services


The Spartan instance on each agent also acts a DNS server for any service that is load-balanced using the DC/OS internal load balancer called [minuteman](/docs/1.10/overview/networking/service-discovery/mesos-dns/). Any service that is load balanced by minuteman gets a [virtual-ip-address (VIP)](/docs/1.10/overview/networking/service-discovery/mesos-dns/) and an FQDN in the `"*.l4lb.thisdcos.directory"` domain. The FQDN allocated to a load-balanced service is then stored in Spartan. All Spartans instances exchange the records they have discovered locally from minuteman by using GOSSIP. This provides a highly available distributed DNS service for any task that is load balanced by minuteman.

# Load Balancing
East-west load balancing is provided by the Minuteman component. North-south load balancing is provided by Marathon LB.

## Minuteman
Minuteman is a distributed layer 4 virtual IP east-west load balancer that is installed by default. It provides:

- Distributed load balancing of applications
- Fast converging distributed load balancer support for variety of L4 LB algorithms
- Highly available LB with no single choke point
- Highly scalable and tolerant to large # of host failures.


## Marathon LB
Marathon LB is based on HAProxy, a rapid proxy and north-south load balancer. HAProxy provides proxying and load balancing for TCP and HTTP based applications, with features such as SSL support, HTTP compression, health checking, Lua scripting and more. Marathon LB subscribes to Marathon’s event bus and updates the HAProxy configuration in real time. Here are common Marathon LB use cases:

- Use Marathon LB as your edge load balancer (LB) and service discovery mechanism.
- Use Marathon LB as an internal LB and service discovery mechanism, with a separate HA load balancer for routing public traffic in.


(/docs/1.10/overview/networking/service-discovery/mesos-dns/): /docs/1.10/networking/load-balancing-vips/virtual-ip-addresses/
(/docs/1.10/overview/networking/service-discovery/spartan/): /docs/1.10/networking/load-balancing-vips/
[3]: /docs/1.10/networking/Marathon LB/
[4]: /docs/1.10/networking/mesos-dns/
[5]: /docs/1.10/networking/mesos-dns/service-naming/
