---
post_title: High-Availibility
feature_maturity: preview
menu_order: 3.1
---

This document discusses the high availability (HA) features in DC/OS and best practices for building HA applications on DC/OS.

# Terminology

## Zone
A zone is a failure domain that has isolated power, networking, and connectivity. Typically, a zone is a single data center or independent fault domain on-premise, or managed by a cloud provider. For example, AWS Availability Zones or GCP Zones. Servers within a zone are connected via high bandwidth (e.g. 1-10+ Gbps), low latency (up to 1 ms), and low cost links.

## Region
A region is a geographical region, such as a metro area, that consists of one or more zones. Zones within a region are connected via high bandwidth (e.g. [1-4 Gbps](https://blog.serverdensity.com/network-performance-aws-google-rackspace-softlayer/)), low latency (up to 10 ms), low cost links. Regions are typically connected through public internet via variable bandwidth (e.g. [10-100 Mbps](https://cloudharmony.com/speedtest-for-aws)) and latency ([100-500 ms](https://www.concurrencylabs.com/blog/choose-your-aws-region-wisely/)) links.

## Rack
A rack is typically composed of a set of servers (nodes). A rack has its own power supply and switch (or switches), all attached to the same frame. On public cloud platforms such as AWS, there is no equivalent concept of a rack.

# General Recommendations

## Latency
DC/OS master nodes should be connected to each other via highly available and low latency network links. This is required because some of the coordinating components running on these nodes use quorum writes for high availability. For example, Mesos masters, Marathon schedulers, and ZooKeeper use quorum writes.

Similarly, most DC/OS services use ZooKeeper (or etcd, consul, etc) for scheduler leader election and state storage. For this to be effective, service schedulers must be connected to the ZooKeeper ensemble via a highly available, low latency network link.

## Routing
DC/OS networking requires a unique address space. Cluster entities cannot share the same IP address. For example, apps and DC/OS agents must have unique IP addresses.

All IP addresses should be routable within the cluster.

## Leader/Follower Architecture

A common pattern in HA systems is the leader/follower concept. This is also sometimes referred to as: master/slave, primary/replica, or some combination thereof. This architecture is used when you have one authoritative process, with N standby processes. In some systems, the standby processes might also be capable of serving requests or performing other operations. For example, when running a database like MySQL with a master and replica, the replica is able to serve read-only requests, but it cannot accept writes (only the master will accept writes).

In DC/OS, a number of components follow the leader/follower pattern. We'll discuss some of them here and how they work.

#### Mesos

Mesos can be run in high availability mode, which requires running 3 or 5 masters. When run in HA mode, one master is elected as the leader, while the other masters are followers. Each master has a replicated log which contains some state about the cluster. The leading master is elected by using ZooKeeper to perform leader election. For more detail on this, see the [Mesos HA documentation](https://mesos.apache.org/documentation/latest/high-availability/).

#### Marathon

Marathon can be run in HA mode, which allows running multiple Marathon instances (at least 2 for HA), with one elected leader. Marathon uses ZooKeeper for leader election. The followers do not accept writes or API requests, instead the followers proxy all API requests to the leading Marathon instance.

#### ZooKeeper

ZooKeeper is used by numerous services in DC/OS to provide consistency. ZooKeeper can be used as a distributed locking service, a state store, and a messaging system. ZooKeeper uses [Paxos-like](https://en.wikipedia.org/wiki/Paxos_(computer_science&#41;) log replication and a leader/follower architecture to maintain consistency across multiple ZooKeeper instances. For a more detailed explanation of how ZooKeeper works, check out the [ZooKeeper internals document](https://zookeeper.apache.org/doc/r3.4.8/zookeeperInternals.html).

## Fault Domain Isolation
Fault domain isolation is an important part of building HA systems. To correctly handle failure scenarios, systems must be distributed across fault domains to survive outages. There are different types of fault domains, a few examples of which are:

 * Physical domains: this includes machine, rack, datacenter, region, and availability zone.
 * Network domains: machines within the same network may be subject to network partitions. For example, a shared network switch may fail or have invalid configuration.

With DC/OS, you can distribute masters across racks for HA, or across regions. Agents can be distributed across regions, and it's recommended that you tag agents with attributes to describe their location. Synchronous services like ZooKeeper should also remain within the same region to reduce network latency. For more information, see the Configuring High-Availibility [documentation](/docs/1.9/administration/high-availability/).

For applications which require HA, they should also be distributed across fault domains. With Marathon, this can be accomplished by using the [`UNIQUE`  and `GROUP_BY` constraints operator](https://mesosphere.github.io/marathon/docs/constraints.html).

## Separation of Concerns

HA services should be decoupled, with responsibilities divided amongst services. For example, web services should be decoupled from databases and shared caches.

## Eliminating Single Points of Failure

Single points of failure come in many forms. For example, a service like ZooKeeper can become a single point of failure when every service in your system shares one ZooKeeper cluster. You can reduce risks by running multiple ZooKeeper clusters for separate services. There's an Exhibitor [Universe package](https://github.com/mesosphere/exhibitor-dcos) that makes this easy.

Other common single points of failure include: 

- Single database instances (like a MySQL)
- One-off services
- Non-HA load balancers

## Fast Failure Detection

Fast failure detection comes in many forms. Services like ZooKeeper can be used to provide failure detection, such as detecting network partitions or host failures. Service health checks can also be used to detect certain types of failures. As a matter of best practice, services *should* expose health check endpoints, which can be used by services like Marathon.

## Fast Failover

When failures do occur, failover [should be as fast as possible](https://en.wikipedia.org/wiki/Fail-fast). Fast failover can be achieved by:

 * Using an HA load balancer like [Marathon-LB](/docs/1.9/usage/service-discovery/marathon-lb/), or [Minuteman](/docs/1.9/usage/service-discovery/load-balancing-vips/) for internal layer 4 load balancing.
 * Building apps in accordance with the [12-factor app](http://12factor.net/) manifesto.
 * Following REST best-practices when building services: in particular, avoiding storing client state on the server between requests.

A number of DC/OS services follow the fail-fast pattern in the event of errors. Specifically, both Mesos and Marathon will shut down in the case of unrecoverable conditions such as losing leadership.
