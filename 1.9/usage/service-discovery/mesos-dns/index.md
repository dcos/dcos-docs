---
post_title: Mesos-DNS
menu_order: 200
---

[Mesos-DNS][1] provides service discovery within DC/OS clusters. It is fully integrated into DC/OS and allows applications and services on the cluster to find each other through the [domain name system (DNS)][2], similar to how services discover each other throughout the Internet.

Applications launched by [Marathon][3] are assigned names such as `search.marathon.mesos` or `log-aggregator.marathon.mesos`. Mesos-DNS resolves names to both the IP address of the node and the ports that the application is using. DC/OS applications and services discover the IP addresses and ports of other applications by making DNS queries or by making HTTP requests through a REST API.

# Design

Mesos-DNS is designed for reliability and simplicity. It requires little configuration and is automatically pointed to the DC/OS master nodes at launch. Mesos-DNS periodically queries the masters (every 30 seconds by default) to retrieve the state of all running tasks from all running services, and to generate A and SRV DNS records for these tasks. As tasks start, finish, fail, or restart on the DC/OS cluster, Mesos-DNS updates the DNS records to reflect the latest state.

If the Mesos-DNS process fails, `systemd` automatically restarts it. Mesos-DNS then retrieves the latest state from the DC/OS masters and begins serving DNS requests without additional coordination. Mesos-DNS does not require consensus mechanisms, persistent storage, or a replicated log because it does not implement heartbeats, health monitoring, or lifetime management for applications; this functionality is already built in to the DC/OS masters, agents, and services.

You can load balance DNS requests in clusters with large numbers of agents by adding additional master nodes; no additional configuration is necessary.

![Mesos-DNS](img/mesos-dns.png)

As shown in the diagram, Mesos-DNS optionally integrates with your existing DNS infrastructure. Mesos-DNS replies directly to lookup requests from agent nodes for applications and services within your DC/OS cluster. If an agent node makes a DNS request for a hostname that is outside your DC/OS cluster, Mesos-DNS queries an external nameserver. External nameservers are only required if DC/OS cluster nodes must resolve hostnames for systems elsewhere on your network or on the Internet.

 [1]: https://github.com/mesosphere/mesos-dns
 [2]: http://en.wikipedia.org/wiki/Domain_Name_System
 [3]: https://github.com/mesosphere/marathon
