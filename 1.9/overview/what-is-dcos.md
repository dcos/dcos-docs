---
post_title: What is DC/OS?
menu_order: 1
---

As a datacenter operating system, DC/OS is itself a distributed system, a cluster manager, a container platform, and an operating system.

## Distributed System

As a distributed system, DC/OS includes a group of agent nodes that are coordinated by a group of master nodes. Like other distributed systems, several of the components running on the master nodes perform [leader election](https://en.wikipedia.org/wiki/Distributed_computing#Coordinator_election) with their peers.

## Cluster Manager

As a cluster manager, DC/OS manages both resources and tasks running on the agent nodes. The agent nodes provide resources to the cluster. Those resources are then bundled into resource offers and made available to registered schedulers. The schedulers then accept these offers and allocate their resources to specific tasks, indirectly placing tasks on specific agent nodes. The agent nodes then spawn executors to manage each task type and the executors run and manage the tasks assigned to them. Unlike external cluster provisioners, DC/OS runs in the cluster and manages the lifecycle of the tasks it launches. This cluster management functionality is provided primarily by [Apache Mesos](/docs/1.9/overview/concepts/#apache-mesos).

## Container Platform

As a container platform, DC/OS includes two built-in task schedulers (Marathon and DC/OS Jobs (Metronome)) and two container runtimes (Docker and Mesos). Combined, this functionality is commonly referred to as container orchestration. In addition to the built-in schedulers for services and jobs, DC/OS also supports custom schedulers for handling more complex application-specific operational logic. Stateful services like databases and message queues often take advantage of these custom schedulers to handle advanced scenerios (e.g. setup, tear down, backup, restore, migration, synchronization, rebalancing, etc).

All tasks on DC/OS are containerized. Containers can be started from images downloaded from a container repository (e.g. [Docker Hub](https://hub.docker.com/)) or they can be native executables (e.g. binaries or scripts) containerized at runtime. While Docker is currently required on every node, it may become optional in the future, as components and packages migrate to using the Mesos Universal Container Runtime for imaged and native workloads.

## Operating System

As an operating system, DC/OS abstracts the cluster hardware and software resources and provides common services to applications. On top of cluster management and container orchestration functionality, these common services additionally provide package management, networking, logging and metrics, storage and volumes, and identity management.

Similar to Linux, DC/OS has both system space (aka kernel space) and user space. The system space is a protected area that is not accessible to users and involves low-level operations such as resource allocation, security, and process isolation. The user space is where the user applications, jobs, and services live. The built-in package manager can be used to install services into the user space.

Unlike Linux, DC/OS is not a [host operating system](/docs/1.9/overview/concepts/#host-operating-system). DC/OS spans multiple machines, but relies on each machine to have its own host operating system and host kernel.
