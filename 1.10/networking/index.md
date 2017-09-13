---
post_title: Networking
menu_order: 070
---

DC/OS provides a number of tools out-of-the-box, ranging from basic network connectivity between containers to more advanced features, such as load balancing and service discovery. 

# IP Per Container
Allows containers to run on any type of IP-based virtual networks, with each container having its own network namespace.

DC/OS supports IP per container for the Universal container runtime (UCR) by using the Container network interface (CNI). DC/OS supports IP per container for the Docker container runtime by using the Container network model (CNM).

DC/OS provides an out-of-the box virtual networking solution for IP per container called DC/OS overlay that works both with UCR and Docker container runtimes. The DC/OS overlay uses the CNI/CNM support in Mesos to provide IP per container.For more information, see the [Containerizer documentation](/docs/1.10/deploying-services/containerizers/).

# DNS-Based Service Discovery
DC/OS includes highly available, distributed, DNS-based service discovery. The service discovery mechanism in DC/OS contains these components:

- A centralized component called Mesos DNS, which runs on every master.
- A distributed component called Spartan that runs on every agent.

## Mesos DNS
Mesos DNS is a centralized, replicated, DNS server that runs on every master. Every task started by DC/OS gets a well-known DNS name. This provides a replicated highly available DNS service on each of the masters. Every instance of Mesos DNS polls the leading Mesos master and generates a fully qualified domain name (FQDN) for every service running in DC/OS with the domain `*.mesos`.  For more information, see the [Mesos DNS documentation](/docs/1.10/networking/mesos-dns/).

## DNS Forwarder (Spartan)
Spartan acts as a DNS masquerade for Mesos DNS on each agent. The Spartan instance on each agent is configured to listen to three different local interfaces on the agent and the nameservers on the agent are set to these three interfaces. This allows containers to perform up to three retries on a DNS request. To provide a highly available DNS service, Spartan forwards each request it receives to the different Mesos DNS instances which are running on each master.

- Scale-out DNS Server on DC/OS masters with replication.
- DNS server Proxy with links to all Active/Active DNS server daemons.
- DNS server cache service for local services.

The Spartan instance on each agent also acts as a DNS server for any service that is load balanced using the DC/OS internal load balancer called [Minuteman](/docs/1.10/networking/load-balancing-vips/). Any service that is load balanced by Minuteman gets a [virtual-ip-address (VIP)](/docs/1.10/networking/mesos-dns/) and an FQDN in the `"*.l4lb.thisdcos.directory"` domain. The FQDN allocated to a load-balanced service is then stored in Spartan. All Spartans instances exchange the records they have discovered locally from Minuteman by using GOSSIP. This provides a highly available distributed DNS service for any task that is load balanced by Minuteman. For more information, see the [Spartan repository](https://github.com/dcos/spartan).

# Load Balancing

DC/OS offers three load balancing options out-of-the-box:
[Minuteman](/docs/1.10/networking/load-balancing-vips/),
[Edge-LB](https://docs.mesosphere.com/docs/1.10/networking/edge-lb/),
and [Marathon-LB](/docs/1.10/networking/marathon-lb/).


|                                    | Minuteman | Edge-LB | Marathon-LB |
|-----                               |-----------|---------|---|
| Open Source                        |     X     |         |      X      |
| Enterprise                         |     X     |    X    |      X      |
| North-South (External to Internal) |           |    X    |      X      |
| East-West (Internal to Interal)    |     X     |    X    |      X      |
| Layer 4 (Transport Layer)          |     X     |    X    |      X      |
| Layer 7 (Application Layer)        |           |    X    |      X      |
| Marathon Services                  |     X     |    X    |      X      |
| Non-Marathon Service Tasks         |     X     |    X    |             |
| 0 hop load balancing               |     X     |         |             |
| No single point of failure         |     X     |         |             |

## Minuteman
Minuteman is a distributed layer 4 virtual IP east-west load balancer that is installed by default.
It's highly scalable and highly available, offering 0 hop load balancing, no single choke point,
and tolerance to host failures.


## Edge-LB
Edge-LB builds upon on HAProxy. HAProxy provides base functionality such as load balancing for TCP and HTTP-based applications, SSL support, and health checking. In addition, Edge-LB provides first class support for zero downtime service deployment strategies, such as blue/green deployment. Edge-LB subscribes to Mesos and updates HAProxy configuration in real time.

Edge-LB proxies and load balances traffic to all services that run on DC/OS. In contrast, Marathon-LB can only work with Marathon tasks. For example, if you are using Cassandra, Edge-LB can load balance the tasks launched by Cassandra.


## Marathon-LB
Marathon-LB is based on HAProxy, a rapid proxy and north-south load balancer. HAProxy provides proxying and load balancing for TCP and HTTP based applications, with features such as SSL support, HTTP compression, health checking, Lua scripting and more. Marathon-LB subscribes to Marathon’s event bus and updates the HAProxy configuration in real time.
