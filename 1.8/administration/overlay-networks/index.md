---
nav_title: Virtual Networks
post_title: Virtual Networks
feature_maturity: preview
menu_order: 11.5
---

The DC/OS virtual network feature is an out-of-the-box virtual networking solution that provides an ip-per-container for Mesos and Docker containers alike. The DC/OS virtual network uses CNI (Container Network Interface) for the [Mesos Containerizer](http://mesos.apache.org/documentation/latest/containerizer/#Mesos) and Docker libnetwork for the [Docker Containerizer](http://mesos.apache.org/documentation/latest/containerizer/#Docker).

DC/OS virtual networks allow containers launched through the Mesos Containerizer or Docker Containerizer to co-exist on the same IP network, allocating each container its own unique IP address. DC/OS virtual networks offer the following advantages:

* Both Mesos and Docker containers can communicate from within a single node and between nodes on a cluster.
* Services can run in isolation from other traffic coming from any other virtual network or host in the cluster.
* You don't have to worry about potentially overlapping ports in applications, or using workarounds to avoid overlapping (e.g. using nonstandard ports for services).
* You can generate any number of instances of a class of tasks and have them all listen on the same port so that clients don’t have to do port discovery.
* You can run applications that require intra-cluster connectivity, like Cassandra, HDFS, and Riak.
* You can create multiple virtual networks to isolate different portions of your organization, for instance, development, marketing, and production.

**Note:** Isolation guarantees among subnets depend on your firewall policies.

[Learn how to use virtual networks in your applications](/docs/1.8/usage/service-discovery/load-balancing-vips/overlay-networks/).

# Overview

DC/OS virtual network architecture:

![Overview of the DC/OS Virtual Networks architecture](img/overlay-networks.png)

DC/OS virtual networks do not require an external IP address management (IPAM) solution because IP allocation is handled via the Mesos Master replicated log. Virtual networks do not support external IPAMs.

The components of the virtual network interact in the following ways:

- Both the Mesos master and the Mesos agents run DC/OS overlay modules that communicate directly.

- The CNI isolator is used for the Mesos containerizer. [DNI](https://docs.docker.com/engine/userguide/networking/) is used for the Docker containerizer, shelling out to the Docker daemon.

- For intra-node IP discovery we use an overlay orchestrator called Virtual Network Service. This operator-facing system component is responsible for programming the overlay backend using a library called [lashup](https://github.com/dcos/lashup) that implements a gossip protocol to disseminate and coordinate overlay routing information among all Mesos agents in the DC/OS cluster.

**Note:** Your network must adhere to the [DC/OS system requirements](/docs/1.8/administration/installing/custom/system-requirements/) to use DC/OS virtual networks.

# Virtual Network Service: DNS

The [Virtual Network Service](/docs/1.8/overview/components/)
maps names to IPs on your virtual network. You can use these DNS addresses to access your task:

* **Container IP:** Provides the container IP address: `<taskname>.<framework_name>.containerip.dcos.thisdcos.directory`
* **Auto IP:** Provides a best guess of a task's IP address: `<taskname>.<framework_name>.autoip.dcos.thisdcos.directory`. This is used during migrations to the overlay.

Terminology:
* `taskname`: The name of the task
* `framework_name`: The name of the framework, if you are unsure, it is likely `marathon`

# Limitations
* The DC/OS virtual network does not allow services to reserve IP addresses that result in ephemeral addresses for containers across multiple incarnations on the virtual network. This restriction ensures that a given client connects to the correct service.

  [VIPs (virtual IP addresses)](/docs/1.8/usage/service-discovery/load-balancing-vips/) are built in to DC/OS and offer a clean way of allocating static addresses to services. If you are using virtual networks, you should use VIPs to access your services in order to support cached DNS requests and static IP addresses.

* The limitation on the total number of containers on the virtual network is the same as the number of IP addresses available on the overlay subnet. However, the limitation on the number of containers on an agent depends on the subnet (which will be a subset of the overlay subnet) allocated to the agent. For a given agent subnet, half the address space is allocated to the `MesosContainerizer` and the other half is allocated to the `DockerContainerizer`.

* In DC/OS overlay, the subnet of an virtual network is sliced into smaller subnets and these smaller subnets are allocated to agents. When an agent has exhausted its allocated address range and a service tries to launch a container on the virtual network on this agent, the container launch will fail and the service will receive a `TASK_FAILED` message.

  Since there is no API to report the exhaustion of addresses on an agent, it is up to the service to infer that containers cannot be launched on an virtual network due to lack of IP addresses on the agent. This limitation has a direct impact on the behavior of services, such as Marathon, that try to launch services with a specified number of instances. Due to this limitation, services such as Marathon might not be able to complete their obligation of launching a service on an virtual network if they try to launch instances of a service on an agent that has exhausted its allocated IP address range.

  Keep this limitation in mind when debugging issues on frameworks that use an virtual network and you see the `TASK_FAILED` message.

* The DC/OS virtual network uses Linux bridge devices on agents to connect Mesos and Docker containers to the virtual network. The names of these bridge devices are derived from the virtual network name. Since Linux has a limitation of fifteen characters on network device names, there is a character limit of thirteen characters for the virtual network name (two characters are used to distinguish between a CNI bridge and a Docker bridge on the virtual network).

* Certain names are reserved and cannot be used as DC/OS virtual network names, primarily because DC/OS overlay uses Docker networking underneath to connect Docker containers to the overlay, which in turn reserves certain network names. The reserved names are: `host`, `bridge` and `default`.

* Marathon health checks will not work with certain virtual network configurations. If you are not using the default DC/OS virtual network configuration and Marathon is isolated from the virtual network, health checks will fail consistently even if the service is healthy.

  Marathon health checks _will_ work in any of the following circumstances:

  * You are using the default DC/OS virtual network configuration.
  * Marathon has access to the virtual network.
  * You use a [`command` health check](http://mesosphere.github.io/marathon/docs/health-checks.html).
