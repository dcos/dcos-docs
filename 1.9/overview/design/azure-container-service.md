---
post_title: >
    Reference implementation: The Azure Container Service
nav_title: ACS
menu_order: 1
---

[DC/OS](https://github.com/dcos) is a distributed operating system -- powered by [Apache Mesos](https://mesos.apache.org) -- that treats collections of CPUs, RAM, networking and so on as a distributed kernel and then implements core distributed system components that handle system-wide tasks such as scheduling, dns, service discovery, and others without regard to the underlying infrastructure. The [Azure Container Service](https://azure.microsoft.com/documentation/articles/container-service-deployment/) is a reference implementation of DC/OS optimized to take advantage of the features of Microsoft Azure infrastructure. If you already have an Azure account, you can try out a reference implementation of DC/OS built on Microsoft Azure by [creating an Azure Container Service cluster](https://aka.ms/acscreate). (Grab a [free Azure trial account](https://azure.microsoft.com/pricing/free-trial/) first if you don't have one.)

This document describes:

- Advantages of using DC/OS
- Azure infrastructure and the implementation architecture
- Bill of materials used to construct DC/OS and the ACS clusters

## Benefits of DC/OS

DC/OS is powered by Apache Mesos used as the distributed kernel of a set of computers that you can treat as one unit, though you retain control of each and every one. In DC/OS, the kernel of the system is in fact any number of mesos masters and agents both publicly available and private; failed mesos masters are replaced by a standby master transparently, and handles leader election. Masters, of course, handle failed agents and processes.

DC/OS applications function as system components in its distributed user space. The most obivous is the system marathon component, which is the distributed `init` for DC/OS; but this also includes the Admin Router service, the Mesos-DNS service, Exhibitor, and other system-wide components that are used by user processes and manage the masters and agents.

For a more comprehensive architecturel description of DC/OS, see [The Architecture of DC/OS](../../architecture/); for a more complete discussion of components, see [An Introduction to DC/OS Components](../../components/).

### Why DC/OS and not Mesos?

Using Mesos directly is in fact what [many companies do successfully](https://mesos.apache.org/documentation/latest/powered-by-mesos/), so there's every chance you might want or need to deploy mesos yourself. DC/OS, however, has several important features above and beyond the set of open-source mesos features that you can use yourself:

1. Deploying and managing mesos can be complex, precisely because it can manage very complex environments; DC/OS makes that complexity straightforward to use and supported by the community.
2. DC/OS implements fault tolerance across not just industrial but internet scale.
3. The DC/OS universe of packages for easy installation supports developers, data scientists, and system administrators alike with all their favorite open source packages.
4. The real-time metrics "firehouse" is open for use by your favorite diagnostics and analytics packages.
5. DC/OS has three ways to automate your distributed OS: a powerful CLI, a lovely UI, and a rich API.

### The Universe of packages

It's worth nothing that point 3, above, are the tools you need to use. Here's a list of what was in the universe on Day 1 of DC/OS, categorized by the type of license.

#### Apache License V2

- ArangoDB
- Apache Cassandra
- Crate
- Elastic Search
- Etcd
- Exhibitor
- Apache Hadoop
- Hue
- Jenkins
- Apache Kafka
- Linkerd
- Mr Redis
- Namerd
- Quobyte
- Riak
- Spark Notebook
- Apache Spark
- Apache Storm
- Docker Swarm
- Apache Zeppelin

#### Simplified BSD

- Datadog
- Nginx

#### MIT

- OpenVPN Admin
- OpenVPN
- Ruxit

And while it's easy to think of using the universe of packages available with the DC/OS packaging system, you can also publish there to give your skills back to the community, too.

Deploying DC/OS yourself may also be what you want to do, but you can start with a reference implementation of DC/OS in "the cloud" with the Azure Container Service.

## Azure Container Service infrastructure and optimizations

The Azure Container Service is built with DC/OS as one of the critical orchestration options and the DC/OS implementation is optimized for easy creation and usage on Microsoft Azure and on-premise, eventually with Azure Stack, and is one of the best ways to get started with DC/OS, mesos, and a distributed cluster that can be used and managed like one large system whether in your datacenter or in Azure.

The Azure Container Service implementation brings several more benefits to you:

1. Pretty much the easiest way to get started with DC/OS. Click a few buttons, provide a few parameters and you are ready to deploy your apps. If you have an Azure account, [try it](https://aka.ms/acscreate).
2. DC/OS deployments are vetted and optimize specifically for Azure: all VMs, storage, networks, load balancers, and so on are created and configured for a highly available DC/OS cluster: it just "happens".
3. Potential to increase integration with Azure services if you decide it would benefit your deployments as the system moves forward.
4. Complete support: Brings Microsoft support to the infrastructure to complement Mesosphere's support of DC/OS.

The default ACS architecture looks like this:

![Azure Container Service archictecture using DC/OS.](../img/dcos-acs.png)



## DC/OS component list

The following list shows the components used by DC/OS itself. You'll note that the core components center around Mesos, Marathon, Python, and so on.


- 3dt
- adminrouter
- boost-system
- boto
- bouncer
- cosmos
- curl
- dcos-cluster-id
- dcos-history-service
- dcos-image
- dcos-image-deps
- dcos-installer
- dcos-installer-ui
- dcos-oauth
- dcos-signal
- dcos-ui
- dnspython
- erlang
- exhibitor
- flask
- hadoop
- hdfs-mesos
- java
- libevent
- logrotate
- marathon
- mesos
- mesos-buildenv
- mesos-dns
- mesos-metrics-module
- mesos-modules-private
- minuteman
- ncurses
- networking_api
- openssl
- python
- python-dateutil
- python-docopt
- python-jinja2
- python-kazoo
- python-markupsafe
- python-passlib
- python-pyyaml
- python-requests
- python-retrying
- six
- spartan
- strace
- toybox
- treeinfo.json
- zk-value-consensus
