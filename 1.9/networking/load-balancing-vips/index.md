---
post_title: Load Balancing and Virtual IPs (VIPs)
menu_order: 00
---

DC/OS provides an east-west load balancer (minuteman) that enables multi-tier microservices architectures. It acts as a TCP layer 4 load balancer and leverages load-balancing features within the Linux kernel to achieve near line-rate throughputs and latency. The features include:

- Distributed load balancing of applications.
- Facilitates east-west communication within the cluster.
- User specifies an FQDN address to the DC/OS service.
- Respects health checks.
- Automatically allocates virtual IPs to service FQDN.

You can use the layer 4 load balancer by assigning a [VIP](/docs/1.9/networking/load-balancing-vips/virtual-ip-addresses/) in your app definition. After you create a task, or a set of tasks, with a VIP, they will automatically become available to all nodes in the cluster, including the masters.

When you launch a set of tasks, DC/OS distributes them to a set of nodes in the cluster. The Minuteman instance running on each of the cluster agents coordinates the load balancing decisions. Minuteman on each agent programs the IPVS module within the Linux kernel with entries for all the tasks associated with a given service. This allows the Linux kernel to make load-balancing decisions at near line-rate speeds. Minuteman tracks the availability and reachability of these tasks and keeps the IPVS database up-to-date with all of the healthy backends, which means the Linux kernel can select a live backend for each request that it load balances.

### Requirements

-  Do not firewall traffic between the nodes (allow all TCP/UDP).
-  Do not change `ip_local_port_range`.
-  You must use a supported [operating system](/docs/1.9/installing/custom/system-requirements/).

#### Persistent Connections
Keep long-running persistent connections, otherwise, you can quickly fill up the TCP socket table. The default local port range on Linux allows source connections from 32768 to 61000. This allows 28232 connections to be established between a given source IP and a destination address and port pair. TCP connections must go through the time wait state prior to being reclaimed. The Linux kernel's default TCP time wait period is 120 seconds. Without persistent connections, you would exhaust the connection table by only making 235 new connections per second.

#### Health checks
Use Mesos health checks. Mesos health checks are surfaced to the load balancing layer. Marathon only converts **command** [health checks](/docs/1.9/deploying-services/creating-services/health-checks/) to Mesos health checks. You can simulate HTTP health checks via a command similar to:
 
 ```bash
 test "$(curl -4 -w '%{http_code}' -s http://localhost:${PORT0}/|cut -f1 -d" ")" == 200
 ```
 
 This ensures the HTTP status code returned is 200. It also assumes your application binds to localhost. The `${PORT0}` is set as a variable by Marathon. You should not use TCP health checks because they may provide misleading information about the liveness of a service.

**Important:** Docker container command health checks are run inside the Docker container. For example, if cURL is used to check NGINX, the NGINX container must have cURL installed, or the container must mount `/opt/mesosphere` in RW mode.

## Troubleshooting

### DC/OS Overlay Virtual Network
Problems can arise if the VIP address that you specified is used elsewhere in the network. Although the VIP is a 3-tuple, it is best to ensure that the IP dedicated to the VIP is only in use by the load balancing software and isn't in use at all in your network. Therefore, you should choose IPs from the RFC1918 range.

### Ports
Port 61420 must be open for the load balancer to work correctly. Because the load balancer maintains a partial mesh, it needs to ensure that connectivity between nodes is unhindered.

## Next steps

- [Assign a VIP to your application](/docs/1.9/networking/load-balancing-vips/virtual-ip-addresses/)
- [Learn about the implementation details](https://github.com/dcos/minuteman)