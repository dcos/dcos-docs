---
post_title: Architecture
nav_title: Architecture
menu_order: 2
---

DC/OS is a platform for running distributed containerized software, like apps, jobs, and services. As a platform, DC/OS is distinct from and agnostic to the infrastructure layer. This means that the infrastructure may consist of virtual or physical hardware as long as it provides compute, storage, and networking.

![DC/OS Architecture Layers](/docs/1.9/overview/architecture/img/dcos-architecture-layers.png)

## Software Layer

At the software layer, DC/OS provides package management and a package repository to easily install and manage multiple types of services: databases, message queues, stream processors, artifact repositories, monitoring solutions, continuous integration tools, source control management, log aggregators, etc. In addition to these packaged apps and services, the user may install their own custom apps, services, and scheduled jobs.

For more information, see [Task Types](/docs/1.9/overview/architecture/task-types/).

## Platform Layer

At the platform layer there are dozens of components grouped into the following categories:

- Cluster Management
- Container Orchestration
- Container Runtimes
- Logging and Metrics
- Networking
- Package Management
- IAM and Security
- Storage

These components are divided across multiple node types:

- Master Nodes
- Private Agent Nodes
- Public Agent Nodes

For DC/OS to be installed, each node must already be provisioned with one of the supported host operating systems.

For more information, see [Components](/docs/1.9/overview/architecture/components/), [Node Types](/docs/1.9/overview/architecture/node-types/), and [Host Operating System](/docs/1.9/overview/concepts/#host-operating-system).

## Infrastructure Layer

At the infrastructure layer, DC/OS can be installed on public clouds, private clouds, or on-premises hardware. Some of these install targets have automated provisioning tools, but almost any infrastructure can be used, as long as it includes multiple x86 machines on a shared IPv4 network.

For more information, see [Installing](/docs/1.9/administration/installing/).

## External Components

In addition to the software that runs in the datacenter, DC/OS includes and integrates with several external components: the [GUI](/docs/1.9/usage/webinterface/), [CLI](/docs/1.9/usage/cli/), [package repository](/docs/1.9/usage/repo/), and [container registry](/docs/1.9/overview/concepts/#container-registry).
