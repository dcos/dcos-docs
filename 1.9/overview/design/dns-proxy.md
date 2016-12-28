---
post_title: >
    Design: Distributed DNS
nav_title: Distributed DNS
menu_order: 3
---

## Background
Tasks move around frequently in DC/OS, resources must be dynamically resolved by an application protocol, and they are referred to by name. This means that DNS is an integral part of DC/OS. Rather than implementing a ZooKeeper or Mesos client in every project, we've chosen DNS as the lingua franca for discovery amongst all of our components in DC/OS.

This is implemented by using Mesos-DNS, which runs on each of the DC/OS masters. In the client systems, we put each of the masters into the `/etc/resolv.conf`. If a master goes down, DNS queries to that master will time out. Distributed DNS Proxy solves this problem by dual-dispatching DNS queries to multiple masters and returning the first result.

To further alleviate risk, Distributed DNS Proxy routes queries to nodes that it determines are most optimal to do a query. Specifically, if a domain ends in `mesos`, it will dispatch queries to the Mesos masters. If it doesn't end in `mesos`, it will send the query to 2 of the configured upstream nodes.

# Implementation
Distributed DNS Proxy itself is very simple. It has dual-dispatch logic and hosts a domain `spartan` which has only one record -- `ready.spartan`. The purpose of this record is to investigate the availability of Distributed DNS Proxy. Many services, including ICMP, ping this address prior to starting.

Distributed DNS Proxy learns its information from Exhibitor. For this reason, it is critical that Exhibitor is [configured correctly][1] on the masters. Alternatively, if the cluster is configured using static masters, it will load them from the static configuration file.

## ZooKeeper
Distributed DNS Proxy also enables high availability of ZooKeepers. You can always use the addresses `zk-1.zk`, `zk-2.zk`, `zk-3.zk`, `zk-4.zk`, `zk-5.zk`. If there are fewer than 5 ZooKeepers, Distributed DNS Proxy will point multiple records at a single ZooKeeper.

## Watchdog
Since DNS is such a specialized, sensitive subsystem we've chosen to protect it with a watchdog. There is a service installed on each node that runs every 5 minutes and checks whether or not it can query `ready.spartan`. To avoid harmonic effects, it sleeps for 1 minute past its initial start time to avoid racing spartan. You can monitor the system health of the watchdog as DNS Dispatcher Watchdog in the system health [dashboard][2].

In addition to this watchdog, we also run genresolv, which checks whether or not Distributed DNS Proxy is alive to generate the resolv.conf. If it believes Distributed DNS Proxy not to be alive, it then rewrites the resolv.conf with the upstream resolvers that you've configured into your DC/OS cluster.

## Distributed DNS Proxy Interface
Distributed DNS Proxy creates its own network interface. This interface is actually a dummy device called `spartan`. This device hosts 3 IPs, `198.51.100.1/32`, `198.51.100.2/32`, `198.51.100.3/32`. You can monitor the system health of the DNS Proxy as the DNS Dispatcher component in the system health [dashboard][2].

[1]: /docs/1.9/administration/installing/custom/configuration-parameters/
[2]: /docs/1.9/administration/monitoring/
