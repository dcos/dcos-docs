---
post_title: Load Balancing and VIPs
nav_title: Load Balancing and VIPs
menu_order: 00
---

DC/OS comes with an east-west load balancer that enables multi-tier microservices architectures. It acts as a TCP Layer 4 load balancer, and it's tightly integrated with the kernel. 

## Usage
You can use the layer 4 load balancer by assigning a [VIP from the DC/OS GUI](/docs/1.9/networking/load-balancing-vips/virtual-ip-addresses/). Alternatively, if you're using something other than Marathon, you can create a label on the [port](https://github.com/apache/mesos/blob/b18f5bf48fda12bce9c2ac8e762a08f537ffb41d/include/mesos/mesos.proto#L1813) protocol buffer while launching a task on Mesos. This label's key must be in the format `VIP_$IDX`, where `$IDX` is replaced by a number, starting from 0. Once you create a task, or a set of tasks with a VIP, they will automatically become available to all nodes in the cluster, including the masters.

### Details
When you launch a set of tasks with these labels, DC/OS distributes them to all of the nodes in the cluster. All of the nodes in the cluster act as decision makers in the load balancing process. A process runs on all the agents that the kernel consults when packets are recognized with this destination address. This process keeps track of availability and reachability of these tasks to attempt to send requests to the right backends.

### Recommendations

#### Caveats
- Do not firewall traffic between the nodes.
- Do not change `ip_local_port_range`.
- You must have the `ipset` package installed.
- You must use a supported [operating system](/docs/1.9/installing/custom/system-requirements/).

#### Persistent Connections
It is recommended that you keep long-running persistent connections, otherwise, you can quickly fill up the TCP socket table. The default local port range on Linux allows source connections from 32768 to 61000. This allows 28232 connections to be established between a given source IP and a destination address and port pair. TCP connections must go through the time wait state prior to being reclaimed. The Linux kernel's default TCP time wait period is 120 seconds. Without persistent connections, you would exhaust the connection table by only making 235 new connections per second.

#### Health checks
It is recommended that you use Mesos health checks. Mesos health checks are surfaced to the load balancing layer. Marathon only converts **command** [health checks](/docs/1.9/deploying-services/creating-services/health-checks/) to Mesos health checks. You can simulate HTTP health checks via a command similar to:
 
 ```bash
 test "$(curl -4 -w '%{http_code}' -s http://localhost:${PORT0}/|cut -f1 -d" ")" == 200
 ```
 
 This ensures the HTTP status code returned is 200. It also assumes your application binds to localhost. The `${PORT0}` is set as a variable by Marathon. You should not use TCP health checks because they may provide misleading information about the liveness of a service.

**Important:** Docker container command health checks are run inside the Docker container. For example, if cURL is used to check NGINX, the NGINX container must have cURL installed, or the container must mount `/opt/mesosphere` in RW mode.

### Demo
If you would like to run a demo, you can configure a Marathon app as mentioned above, and use the URI `https://s3.amazonaws.com/sargun-mesosphere/linux-amd64`, as well as the command `chmod 755 linux-amd64 && ./linux-amd64 -listener=:${PORT0} -say-string=version1` to execute it. You can then test it by hitting the application with the command: `curl http://1.2.3.4:5000`. This app exposes an HTTP API. This HTTP API answers with the PID, hostname, and the 'say-string' that's specified in the app definition. In addition, it exposes a long-running endpoint at `http://1.2.3.4:5000/stream`, which will continue to stream until the connection is terminated. The code for the application is available here: `https://github.com/mesosphere/helloworld`.

#### Exposing it to the outside
You can create an HAProxy configuration like this:

```
defaults
  log global
  mode  tcp
  contimeout 50000000
  clitimeout 50000000
  srvtimeout 50000000

listen appname 0.0.0.0:80
    mode tcp
    balance roundrobin
    server mybackend 1.2.3.4:5000
```

A Marathon app definition for this looks like:

```
{
    "acceptedResourceRoles": [
        "slave_public"
    ],
    "container": {
        "docker": {
            "image": "sargun/haproxy-demo:3",
            "network": "HOST"
        },
        "type": "DOCKER"
    },
    "cpus": 0.5,
    "env": {
        "CONFIGURL": "https://gist.githubusercontent.com/sargun/3037bdf8be077175e22c/raw/be172c88f4270d9dfe409114a3621a28d01294c3/gistfile1.txt"
    },
    "instances": 1,
    "mem": 128,
    "ports": [
        80
    ],
    "requirePorts": true
}
```

This will run an HAProxy on the public agent, on port 80. If you'd like, you can make the number of instances equal to the number of public agents. Then, you can point your external load balancer at the pool of public agents on port 80. Adapting this would simply involve changing the backend entry, as well as the external port.

## Potential Roadblocks
### IP Overlay
Problems can arise if the VIP address that you specified is used elsewhere in the network. Although the VIP is a 3-tuple, it is best to ensure that the IP dedicated to the VIP is only in use by the load balancing software and isn't in use at all in your network. Therefore, you should choose IPs from the RFC1918 range.

### Ports
Port 61420 must be open for the load balancer to work correctly. Because the load balancer maintains a partial mesh, it needs to ensure that connectivity between nodes is unhindered.

## Implementation
The local process polls the master node roughly every 5 seconds. The master node caches this for 5 seconds as well, bounding the propagation time for an update to roughly 11 seconds. Although this is the case for new VIPs, it is not the case for failed nodes.

### Data plane
The load balancer dataplane primarily utilizes IPVS.

### Load balancing algorithm
The load balancing algorithm used is IPVS Weighted Least Connection algorithm.  Currently all the backends have a weight of 1.

### Failure detection
The load balancer includes a state of the art failure detection scheme. This failure detection scheme takes some of the work done in the [HyParView](http://asc.di.fct.unl.pt/~jleitao/pdf/dsn07-leitao.pdf) work. The failure detector maintains a fully connected sparse graph of connections amongst the nodes in the cluster.

Every node maintains an adjacency table. These adjacency tables are gossiped to every other node in the cluster. These adjacency tables are then used to build an application-level multicast overlay.

These connections are monitored via an adaptive ping algorithm. The adaptive ping algorithm maintains a window of pings between neighbors, and if the ping times out, they sever the connections. Once this connection is severed the new adjacencies are gossiped to all other nodes, therefore potentially triggering cascading health checks. This allows the system to detect failures in less than a second. Although, the system has backpressure when there are lots of failures, and fault detection can rise to 30 seconds.

## Next steps

- [Assign a VIP to your application](/docs/1.9/networking/load-balancing-vips/virtual-ip-addresses/)
