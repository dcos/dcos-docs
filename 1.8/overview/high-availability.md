---
post_title: High Availability
nav_title: High Availability
menu_order: 6
---

This document discusses the high availability features in DC/OS and best practices for building highly available applications on DC/OS.

### Leader/follower architecture

A common pattern in highly available systems is the leader/follower concept. This is also sometimes referred to as: master/slave, primary/replica, or some
combination thereof. Generally speaking, this architecture is used when you have one authoritative process, with N standby processes. In some systems, the standby processes might also be capable of serving requests or performing other operations. For example, when running a database like MySQL with a master and replica, the replica is able to serve read-only requests, but it cannot accept writes (only the master will accept writes).

In DC/OS, a number of components follow the leader/follower pattern. We'll discuss some of them here and how they work.

#### Mesos

Mesos may be run in high availability mode, which requires running 3 or 5 masters. When run in HA mode, one master will become elected as the leader, while the other masters will become followers. Each master has a replicated log which contains some state about the cluster. The leading master is elected by using ZooKeeper to perform leader election. For more detail on this, see the [Mesos HA documentation](https://mesos.apache.org/documentation/latest/high-availability/).

#### Marathon

Marathon may be operated in HA mode, which allows running multiple Marathon instances (at least 2 for HA), with one elected leader. Marathon will use ZooKeeper for leader election, and the followers will not accept writes or API requests, but will proxy all API requests to the leading Marathon instance.

#### ZooKeeper

ZooKeeper is used by numerous services in DC/OS to provide consistency. ZooKeeper can be used as a distributed locking service, a state store, and a messaging system. ZooKeeper uses Paxos-like log replication and a leader/follower architecture to maintain consistency across multiple ZooKeeper instances. For a more detailed explanation of how ZooKeeper works, check out the [ZooKeeper internals document](https://zookeeper.apache.org/doc/r3.4.8/zookeeperInternals.html).

### Fault domain isolation

Fault domain isolation is an important part of building HA systems. In order to correctly handle failure scenarios, systems must be distributed across fault domains in order survive outages. There are different types of fault domains, a few examples of which are:

 * Physical domains: this includes machine, rack, datacenter, region, availability zone,   and so on.
 * Network domains: machines within the same network may be subject  to network partitions. For example, a shared network switch may fail or have  invalid configuration.

With DC/OS, it's recommended that masters be distributed across racks for HA, but not across DCs or regions. Agents may be distributed across regions/DCs, and it's recommended that you tag agents with attributes to describe their location. Synchronous services like ZooKeeper should also remain within the same region/DC to reduce network latency.

For applications which require HA, they should also be distributed across fault domains. With Marathon, this can be accomplished by using the [`UNIQUE`  and `GROUP_BY` constraints operator](https://mesosphere.github.io/marathon/docs/constraints.html).

### Separation of concerns

HA services should be decoupled, with responsibilities divided amongst services. For example, web services should be decoupled from databases and shared caches.

### Eliminating single points of failure

Single points of failure come in many forms. A service like ZooKeeper, for example, can become a single point of failure when every service in your system shares one ZooKeeper cluster. You can reduce risks by running multiple ZooKeeper clusters for separate services. With DC/OS, there's an [Exhibitor package](https://github.com/mesosphere/exhibitor-dcos) included which makes this easy:

```
$ dcos package install exhibitor
```

Other common single points of failure include: single database instances (like a MySQL), one-off services, and non-HA load balancers.

### Fast failure detection

Fast failure detection comes in many forms. Services like ZooKeeper can be used to provide failure detection, such as detecting network partitions or host failures. Service health checks can also be used to detect certain types of failures. As a matter of best practice, services *should* expose health check endpoints, which can be used by services like Marathon.

### Fast failover

When failures do occur, failover [should be as fast as possible](https://en.wikipedia.org/wiki/Fail-fast). Fast failover can be achieved by:

 * Using an HA load balancer like [Marathon-LB](https://github.com/mesosphere/marathon-lb), or [Minuteman](https://github.com/dcos/minuteman) for internal layer 4    load balancing.
 * Building apps in accordance with the [12-factor app](http://12factor.net/)    manifesto.
 * Following REST best-practices when building services: in particular,    avoiding storing client state on the server between requests.

A number of DC/OS services follow the fail-fast pattern in the event of errors. Specifically, both Mesos and Marathon will shut down in the case of unrecoverable conditions such as losing leadership.
