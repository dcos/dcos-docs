---
post_title: Features
nav_title: Features
menu_order: 3
---
This is an overview of the features that make DC/OS more than the sum of its parts.

- [High Resource Utilization](#high-resource-utilization)
- [Mixed Workload Colocation](#mixed-workload-colocation)
- [Container Orchestration](#container-orchestration)
- [Extensible Resource Isolation](#extensible-resource-isolation)
- [Stateful Storage Support](#stateful-storage-support)
- [Package Management](#package-management)
- [Cloud-Agnostic Installer](#cloud-agnostic-installer)
- [Web and Command Line Interfaces](#web-and-command-line-interfaces)
- [Elastic Scalability](#elastic-scalability)
- [High Availability](#high-availability)
- [Zero Downtime Upgrades](#zero-downtime-upgrades)
- [Integration-Tested Components](#integration-tested-components)
- [Service Discovery and Load Balancing](#service-discovery-and-load-balancing)


## High Resource Utilization

DC/OS makes it easy to get the most out of your compute resources.

Deciding where to run processes to best utilize cluster resources is hard, NP-hard in-fact. Deciding where to place long-running services which have changing resource requirements over time is even harder. In reality there's no single scheduler that can efficiently and effectively place all types of tasks. There's no way for a single scheduler to be infinitely configurable, universally portable, lightning fast, and easy to use - all at the same time.

DC/OS manages this problem by separating resource management from task scheduling. Mesos manages CPU, memory, disk, and GPU resources. Task placement is delegated to higher level schedulers that are more aware of their task's specific requirements and constraints. This model, known as two-level scheduling, enables multiple workloads to be colocated efficiently.


## Mixed Workload Colocation

DC/OS makes it easy to run all your computing tasks on the same hardware.

For scheduling long-running services, DC/OS tightly integrates with Marathon to provide a solid stage on which to launch microservices, web applications, or other schedulers.

For other types of work, DC/OS makes it easy to select and install from a library of industry-standard schedulers. This opens the door to running batch jobs, analytics pipelines, message queues, big data storage, and more.

For complex custom workloads, you can even write your own scheduler to optimize and precisely control the scheduling logic for specific tasks.


## Container Orchestration

DC/OS provides easy-to-use container orchestration right out of the box.

Docker provides a great development experience, but trying to run Docker containers in production presents significant challenges. To overcome these challenges, DC/OS includes Marathon as a core component, giving you a production-grade, battle-hardened scheduler that is capable of orchestrating both containerized and non-containerized workloads.

With Marathon, you have the ability to reach extreme scale, scheduling tens of thousands of tasks across thousands of nodes. You can use highly configurable declarative application definitions to enforce advanced placement constraints with node, cluster, and grouping affinities.


## Extensible Resource Isolation

DC/OS makes it possible to configure multiple resource isolation zones.

Not all tasks have the same requirements. Some require maximum isolation for security or performance guarantees. Others are ephemeral, public, or easily restarted. And most are somewhere in between.

The simplest isolation method is to just delegate to Docker. It’s trivial to run Docker containers on DC/OS, but Docker is a bit of a blunt instrument when it comes to isolation. The [Mesos containerizer](http://mesos.apache.org/documentation/latest/mesos-containerizer/) is much more flexible, with multiple independently configurable isolators, and pluggable custom isolators. The Mesos containerizer can even run Docker containers without being chained to the fragility of `dockerd`.


## Stateful Storage Support

DC/OS gives your services multiple persistent and ephemeral storage options.

External persistent volumes, the bread and butter of block storage, are available on many platforms. These are easy to use and reason about because they work just like legacy server disks, however, by design, they compromise speed for elasticity and replication.

Distributed file systems are a staple of cloud native applications, but they tend to require thinking about storage in new ways and are almost always slower due to network-based interaction.

Local ephemeral storage is the Mesos default for allocating temporary disk space to a service. This is enough for many stateless or semi-stateless 12-factor and cloud native applications, but may not be good enough for stateful services.

Local persistent volumes bridge the gap and provide fast, persistent storage. If your service is replicating data already or your drives are RAID and backed up to nearline or tape drive, local volumes might give you enough fault tolerance without the speed tax.


## Package Management

DC/OS makes it easy to install both public community and private proprietary packaged services.

The Mesosphere Universe Package Repository connects you with a library of open source industry-standard schedulers, services, and applications. Why reinvent the wheel if you don't have to? Take advantage of community projects to handle batch job scheduling, highly available data storage, robust message queuing, and more.

DC/OS also supports installing from multiple package repositories: you can host your own private packages to be shared within your company or with your customers.


## Cloud-Agnostic Installer

The DC/OS Installer makes it easy to install DC/OS on any cluster of physical or virtual machines.

For users with their own on-premise hardware or virtual machine provisioning infrastructure, the GUI or CLI Installer provides a quick, intuitive way to install DC/OS.

For users deploying to the public cloud, DC/OS offers several configurable cloud provisioning templates for AWS, Azure, and Packet.

For the advanced user, the Advanced Installer provides a scriptable, automatable interface to integrate with your prefered configuration management system.


## Web and Command Line Interfaces

The DC/OS web and command line interfaces make it easy to monitor and manage the cluster and its services.

The DC/OS web interface lets you monitor resource allocation, running services, current tasks, component health, available packages, and more with intuitive browser-based navigation, real-time graphs, and interactive debugging tools.

The DC/OS command line interface provides control of DC/OS from the comfort of a terminal. It’s powerful, yet easily scriptable, with handy plugins to interact with installed services.


## Elastic Scalability

DC/OS gives you the power to easily scale your services up and down with the turn of a dial.

Horizontal scaling is trivial in Marathon, as long as your service supports it. You can change the number of service instances at any time. DC/OS even lets you autoscale the number of instances based on session count, using the Marathon Load Balancer.

Vertical scaling is also supported in Marathon, allowing you to allocate more or less resources to services and automatically performing a rolling update to reschedule the instances without downtime.

Adding nodes to a DC/OS cluster is a snap too. The DC/OS Installer uses immutable artifacts that allow you to provision new nodes without having to recompile, reconfigure, or re-download component packages from flaky remote repositories.


## High Availability

DC/OS is highly available and makes it easy for your services to be highly available too.

Mission-critical services require health monitoring, self-healing, and fault tolerance both for themselves and the platform and infrastructure they run on. DC/OS gives you multiple layers of protection.

To achieve self-healing, DC/OS services are monitored by Marathon and restarted when they fail. Even legacy services that don't support distribution or replication can be automatically restarted by Marathon to maximize uptime and reduce service interruption. On top of that, all core DC/OS components, including Marathon, are monitored by the DC/OS diagnostics service and restarted by `systemd` when they fail.

To achieve fault tolerance, DC/OS can run in multiple master configurations. This provides not just system-level fault tolerance but also scheduler-level fault tolerance. DC/OS can even survive node failure during an upgrade with no loss of service.


## Zero Downtime Upgrades

DC/OS provides automation for updating services and the systems with zero downtime.

DC/OS services running on Marathon can all be updated with rolling, blue-green, or canary deployment patterns. If the update fails, roll it back with a single click. These powerful tools are critical for minimizing downtime and user interruption.

DC/OS itself also supports zero-downtime upgrades with its powerful installer. Stay up-to-date with the latest open source components with a single combined update.


## Integration-Tested Components

DC/OS provides a well-tested set of open source components and bakes them all together with a single combined installer.

Mixing and matching open source components can be a pain. You never know which versions will work together or what the side effects of their interactions will be. Let the Mesos experts handle it for you! Get to production quickly and focus on the quality of your products, not the stability of your platform.


## Service Discovery and Load Balancing

DC/OS includes several options for automating service discovery and load balancing.

Distributed services create distributed problems, but you don't have to solve them all yourself. DC/OS includes automatic DNS endpoint generation, an API for service lookup, transport layer (L4) virtual IP proxying for high speed internal communication, and application layer (L7) load balancing for external-facing services.
