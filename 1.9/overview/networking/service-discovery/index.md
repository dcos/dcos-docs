---
post_title: Service Discovery in DC/OS
nav_title: Service Discovery
menu_order: 2
---

DC/OS comes with a highly available, distributed, DNS-based service discovery. There are two main components to the service discovery mechanism in DC/OS. A centralized component called [mesos-dns][4], which runs on every master, and a distributed component called [spartan][6] that runs on every agent. 

Mesos-dns is a centralized, replicated, DNS server that runs on every Master. Every instance of mesos-dns polls the leading Mesos master and generates an FQDN for every service running in DC/OS with the domain `*.mesos`. Since there is a mesos-dns running on each master, this leads to a replicated, highly available DNS service on each of the masters. The high availability of the DNS service is achieved through spartan which acts as a DNS masquerade for mesos-dns on each agent. The spartan on each agent is configured to listen to three different local interfaces on the agent, and the nameservers on the agent is set to these three interfaces. This allows containers to perform upto three re-tries on a DNS request. For each request, spartan forwards it to a different mesos-dns running on each master allowing for a highly available DNS service.

Apart from acting as a DNS masquerade, to make mesos-dns highly available, the spartan on each agent also acts a DNS server for any service that is load-balanced using the DC/OS internal load balancer called [minuteman][1]. Any service that is load balanced by minuteman gets a [virtual-ip-address (VIP)][1] and an FQDN in the "*.l4lb.thisdcos.directory" domain. The FQDN allocated to a load-balanced service is then stored in spartan. All spartans running in the cluster exchange the records they have learn locally from minuteman using GOSSIP, resulting in a highly available distributed DNS service for any task that is load balanced by minteuman.

The [mesos-dns][4] and [spartan][6] sections provide further details about the usage, design and architecture of these services.

[1]: /docs/1.9/usage/service-discovery/load-balancing-vips/virtual-ip-addresses/
[2]: /docs/1.9/usage/service-discovery/load-balancing-vips/
[3]: /docs/1.9/usage/service-discovery/marathon-lb/
[4]: /docs/1.9/usage/service-discovery/mesos-dns/
[5]: /docs/1.9/usage/service-discovery/mesos-dns/service-naming/
[6]: /docs/1.9/usage/service-discovery/spartan/
