---
post_title: High-Availibility 
menu_order: 3.1
---

DC/OS supports high-availability configurations, including mult-zone, multi-region, and hybrid cloud. 

# Terminology

## Rack
A rack is is a physical server. If you have racks, you should spread your masters across racks. 

There is no direct mapping of a rack to AWS. 

## Region
A region is a geographical region, such as a metro area, that consists of one or more zones. Zones within a region are connected via high bandwidth (e.g. [1-4 Gbps](https://blog.serverdensity.com/network-performance-aws-google-rackspace-softlayer/)), low-latency (up to 10 ms), low-cost links. Regions are typically connected through public internet via variable bandwidth (e.g. [10-100 Mbps](https://cloudharmony.com/speedtest-for-aws)) and latency ([100-500 ms](https://www.concurrencylabs.com/blog/choose-your-aws-region-wisely/)) links.

## Zone
A zone is a failure domain that has isolated power, networking, and connectivity. Typically a zone is a single data center or independent fault domain on-premise, or managed by a cloud provider. For example, AWS Availability Zones or GCP Zones. Servers within a zone are connected via high bandwidth (e.g. 1-10+ Gbps), low-latency (up to 1 ms), and low-cost links.

# General Recommendations

## Latency
DC/OS master nodes should be connected to each other via highly available and low latency network links. This is required because some of the coordinating components running on these nodes use quorum writes for high availability. For example, Mesos masters, Marathon schedulers, and ZooKeeper use quorum writes.

Similarly, most DC/OS services use ZooKeeper (or etcd, consul, etc) for scheduler leader election and state storage. For this to be effective, service schedulers should be connected to the ZooKeeper ensemble via a highly available, low-latency network link.

## Routing
DC/OS networking requires a unique address space. Cluster entities cannot share the same IP address. For example, apps and DC/OS agents must have unique IP addresses.

All IP addresses should be routable within the cluster.