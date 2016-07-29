---
nav_title: Virtual Networks
post_title: Overlay Networks
menu_order: 11.5
---

The DC/OS overlay network feature is an out-of-the-box virtual networking solution that provides an ip-per-container for Mesos and Docker containers alike. The DC/OS overlay network uses CNI (Container Network Interface) for the MesosContainerizer and Docker libnetwork for the DockerContainerizer.

DC/OS overlay networks allow containers launched through the MesosContainerizer or DockerContainerizer to co-exist on the same IP network, allocating each container their own unique IP address. DC/OS overlay networks offer the following advantages:

* Both Mesos and Docker containers can communicate from within a single node and between nodes on a cluster.

* Services can be created such that their traffic is isolated from other traffic coming from any other overlay network or host in the cluster.

* They remove the need to worry about potentially overlapping ports in applications, or the need to use nonstandard ports for services to avoid overlapping.

* You can generate any number of instances of a class of tasks and have them all listen on the same port so that clients don’t have to do port discovery.

* You can run applications that require intra-cluster connectivity, like Cassandra, HDFS, and Riak.

* You can create multiple overlay networks to isolate different portions of your organization, for instance, development, marketing, and production.

**Note:** Isolation guarantees among subnets depend on your firewall policies.

[Learn how to use overlay networks in your applications](/docs/1.8/usage/overlay-networks/).

# Overview

The overall approach to overlay networks in DC/OS looks as follows:

![Overview of the DC/OS Overlay Networks architecture](/1.8/administration/overlay-networks/img/overlay-networks.png)

DC/OS overlay networks do not require an external IP address management (IPAM) solution because IP allocation is handled via the Mesos Master replicated log. Overlay networks do not support external IPAMs.

The components of the overlay network interact in the following ways:

- Both the Mesos master and the Mesos agents run DC/OS overlay modules that communicate directly.

- The CNI isolator is used for the Mesos containerizer. [DNI](https://docs.docker.com/engine/userguide/networking/dockernetworks/) is used for the Docker containerizer, shelling out to the Docker daemon.

- For intra-node IP discovery we use an overlay orchestrator called navstar. This operator-facing system component is responsible for programming the overlay backend using a library called [lashup](https://github.com/dcos/lashup) that implements a gossip protocol to disseminate and coordinate overlay routing information among all Mesos agents in the DC/OS cluster.

**Note:** To use overlay networks in DC/OS you must use a recent Linux kernel (3.9 and later) as well as Docker version 1.11 and later on the agent nodes.
