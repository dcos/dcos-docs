---
post_title: Hybrid Cloud and Multi-Datacenter
menu_order: 6
---

DC/OS supports multi-availability zone (AZ) configurations. This topic describes the setup recommendations and caveats.

### Terminology

#### Zone
A zone is a failure domain that has isolated power, networking, and connectivity. Typically a single data center or independent fault domain on-premise or managed by a cloud provider. For example, AWS Availability Zones or GCP Zones. Servers within a zone are connected via high bandwidth (e.g. [1-10+ Gbps](https://blog.serverdensity.com/network-performance-aws-google-rackspace-softlayer/)), low-latency ([up to 1 ms](http://amistrongeryet.blogspot.com/2010/04/three-latency-anomalies.html)), and low-cost links.

#### Region
A region is a geographical region, such as a metro area, that consists of one or more zones. Zones within a region are connected via high bandwidth (e.g. [1-4 Gbps](https://blog.serverdensity.com/network-performance-aws-google-rackspace-softlayer/)), low-latency (up to 10 ms), low-cost links. Regions are typically connected through public internet via variable bandwidth (e.g. [10-100 Mbps](https://cloudharmony.com/speedtest-for-aws)) and latency ([100-500 ms](https://www.concurrencylabs.com/blog/choose-your-aws-region-wisely/)) links.

# General Recommendations

## Latency
DC/OS master nodes should be connected to each other via highly available and low latency network links. This is required because some of the coordinating components running on these nodes use quorum writes for high availability. For example, Mesos masters, Marathon schedulers, and ZooKeeper use quorum writes.

Similarly, most DC/OS services use ZooKeeper (or etcd, consul, etc) for scheduler leader election and state storage. For this to be effective, service schedulers should be connected to the ZooKeeper ensemble via a highly available, low-latency network link.

## Routing
DC/OS networking requires a unique address space. Cluster entities cannot share the same IP address. For example, apps and DC/OS agents must have unique IP addresses.

All IP addresses should be routable within the cluster.

# Multi-AZ Recommendations
Here are recommendations for specific multi-AZ configurations.

**Important:** A typical DC/OS cluster has all master and agent nodes in the same zone. None of the following multi-AZ setups have been explicitly tested or verified by Mesosphere.

## Single-zone masters and cross-zone agents within a region
All DC/OS masters are present in a single zone, but the agents can span multiple zones within that region.

#### Recommendations

- All agents within a zone should be tagged with an attribute (e.g., `zone:us-east-1a`) to easily constrain apps and services to specific zones.
- Any DC/OS service schedulers should be scheduled to the same zone as masters (e.g., by using constraints).
- For ease of failover of apps between zones, ensure that apps do not depend on zone level resources or that those resources are properly replicated and migrated on failover. Also ensure there is enough spare capacity in each zone to handle failover workload.

#### Caveats

- If an agent-only zone fails, all other zones will continue to function normally. Apps from the failed zone will be rescheduled into other zones as long as there is spare capacity.
- If an agent-only zone gets partitioned from the masters-containing zone, apps will continue to run in that zone but schedulers might “reschedule” copies of the apps into other zones. 
- If a masters-containing zone fails, apps in other zones continue to run. But app updates or rescheduling of failed apps is not possible, until a quorum of masters come up.
- The total cross-sectional bandwidth between zones is limited. This means that performance can be degraded for data (I/O) intensive DC/OS services if deployed across zones.

## Cross-zone masters and cross-zone agents within a region
DC/OS masters and agents span multiple zones within a region.

#### Recommendations

- Quorum size and placement of masters should tolerate zone failure. For example, for a quorum size of two, place each of the three masters in a separate zone. Do not place a quorum of masters into a single zone.
- Quorum size and placement of masters should tolerate zone failure for DC/OS service schedulers. This can be achieved using constraints.
- For ease of failover of apps between zones, ensure that either apps do not depend on zone level resources or that those resources are properly replicated and migrated on failover.

#### Caveats

- If a zone that contains masters fails, apps that belong to that zone will be rescheduled to other zones if there is spare capacity. All DC/OS components should work normally if a quorum of masters is alive.
- Because networking partitions are more likely across zones, masters could end up in split-brain scenario. For example, two different masters think they are the leader at the same time. This is typically harmless because only one leader is allowed to make modifiable actions, for example register or shutdown agents.
- The total cross-sectional bandwidth between zones is limited. This means that performance can be degraded for data (I/O) intensive DC/OS services if deployed across zones.

## Single region masters and cross-region agents 
DC/OS masters are within a region, possibly spanning zones. DC/OS agents span multiple regions. This setup is similar to masters in an on-prem datacenter and agents running on-prem and on public cloud. 

#### Recommendations

- This setup is typically not recommended because of how difficult it is to guarantee the latency and addressing requirements.
- Masters within the region should be placed in different zones to tolerate zone failures.
- DC/OS service schedulers should be constrained to the region which contains the masters.
- The total cross-sectional bandwidth between regions will be extremely limited. We do not recommend deploying single data (I/O) intensive DC/OS services across multiple regions

#### Caveats

- If the region that contains masters fails, apps in other regions will continue to run. However, app updates or rescheduling of failed apps is not possible, until a quorum of masters come up.


## Cross-region masters and cross-region agents 
DC/OS masters and agents span multiple regions. This setup is similar to masters and agents spanning on-prem DC and public cloud.

#### Recommendations

- This setup is typically not recommended because of how difficult it is to guarantee the latency and addressing requirements.
- This setup should only be considered if dedicated private connections between regions is available. For example, AWS Direct Connect or Azure Express Route.

#### Caveats

- Because networking partitions are more likely across zones, masters could end up in split-brain scenario. For example, two different masters think they are the leader at the same time. This is typically harmless because only one leader is allowed to make modifiable actions, for example register or shutdown agents.