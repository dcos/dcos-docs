---
post_title: Concepts
nav_title: Concepts
menu_order: 5
---


# <a name="dcos-concepts"></a>DC/OS Concepts

DC/OS is made up of many open source components, several of which existed before DC/OS. The terms used in this document may be similar to pre-existing terms that you are familiar with, however, they might be used in a different way with DC/OS.

- [DC/OS](#dcos)
- [DC/OS GUI](#dcos-gui)
- [DC/OS CLI](#dcos-cli)
- [Cluster](#dcos-cluster)
- [Network](#network)
  - [Infrastructure Network](#infrastructure-network)
  - [Virtual Network](#dcos-virtual-network)
- [Node](#dcos-node)
  - [Master Node](#dcos-master-node)
  - [Agent Node](#dcos-agent-node)
    - [Private Agent Node](#private-agent-node)
    - [Public Agent Node](#public-agent-node)
- [Host Operating System](#host-operating-system)
- [Bootstrap Machine](#bootstrap-machine)
- [Service](#dcos-service)
  - [Marathon Service](#marathon-service)
  - [Systemd Service](#systemd-service)
  - [System Service](#system-service)
  - [User Service](#user-service)
- [Service Group](#dcos-service-group)
- [Job](#dcos-job)
- [Scheduler](#dcos-scheduler)
- [Scheduler Service](#dcos-scheduler-service)
- [Component](#dcos-component)
- [Package](#dcos-package)
- [Package Manager](#dcos-package-manager)
- [Package Registry](#dcos-package-registry)
- [Mesosphere Universe](#mesosphere-universe)
- [Container-Registry](#container-registry)
- [Cloud Template](#cloud-template)

### <a name="dcos"></a>DC/OS

DC/OS is a [distributed operating system](https://en.wikipedia.org/wiki/Distributed_operating_system) for the datacenter.

- Unlike traditional distributed operating systems, DC/OS is also a container platform that manages containerized tasks based on native executables or container images, like [Docker images](https://docs.docker.com/engine/tutorials/dockerimages/).
- Unlike traditional [operating systems](https://en.wikipedia.org/wiki/Operating_system), DC/OS runs on a [cluster of nodes](#cluster), instead of a single machine. Each DC/OS node also has a [host operating system](#host-operating-system) that manages the underlying machine.
- DC/OS is made up of many components, most notably a distributed systems kernel ([Mesos](#mesos)) and a container orchestration engine ([Marathon](#marathon)).
- Prior to version 1.6, DC/OS was known as The Datacenter Operating System (DCOS). With version 1.6 the platform was renamed to DC/OS and open sourced.
- While DC/OS itself is open source, premium distributions like [Mesosphere Enterprise DC/OS](https://mesosphere.com/product/) may include additional closed-source components and features (e.g. multitenancy, fine-grained permissions, secrets management, and end-to-end encryption).

### <a name="dcos-gui"></a>DC/OS GUI

The [DC/OS graphical user interface (GUI)](/docs/1.9/usage/webinterface/) is an interface for remotely controlling and managing a DC/OS cluster from a web browser. The GUI is also sometimes called the DC/OS UI or DC/OS web interface.

### <a name="dcos-cli"></a>DC/OS CLI

The [DC/OS command line interface (CLI)](/docs/1.9/usage/cli/) is an interface for remotely controlling and managing a DC/OS cluster from a terminal.

### <a name="dcos-cluster"></a>Cluster

A DC/OS cluster is a set of networked DC/OS nodes with a quorum of master nodes and any number of public and/or private agent nodes.

### <a name="network"></a>Network

DC/OS has two types of networks: infrastructure networks and virtual networks.

#### <a name="infrastructure-network"></a>Infrastructure Network

An infrastructure network is a physical or virtual network provided by the infrastructure on which DC/OS runs. DC/OS does not manage or control this networking layer, but requires it to exist in order for DC/OS nodes to communicate.

#### <a name="dcos-virtual-network"></a>Virtual Network

A DC/OS virtual network is specifically an virtual network internal to the cluster that connects DC/OS components and containerized tasks running on DC/OS.

- The virtual network provided by DC/OS is VXLAN managed by the Virtual Network Service (Navstar).
- Virtual networks must be configured by an administrator before being used by tasks.
- Tasks on DC/OS may opt-in to being placed on a specific virtual network and given a container-specific IP.
- Virtual networks allow logical subdivision of the tasks running on DC/OS.
- Each task on a virtual network may be configured with optional address groups that virtually isolate communication to tasks on the same network and address group.

### <a name="dcos-node"></a>Node

A DC/OS node is a virtual or physical machine on which a Mesos agent and/or Mesos master process runs. DC/OS nodes are networked together to form a DC/OS cluster.

#### <a name="dcos-master-node"></a>Master Node

A DC/OS master node is a virtual or physical machine that runs a collection of DC/OS components that work together to manage the rest of the cluster.

- Each master node contains multiple DC/OS components, including most notably a [Mesos master](#mesos-master) process.
- Master nodes work in a [quorum](https://en.wikipedia.org/wiki/Quorum_%28distributed_computing%29) to provide consistency of cluster coordination. To avoid [split brain](https://en.wikipedia.org/wiki/Split-brain_%28computing%29) cluster partitioning, clusters should always have an odd number of master nodes. For example, having three master nodes allows one to be down; having five master nodes allows two to be down, allowing for failure during a rolling update. Additional master nodes can be added for additional risk tolerance.
- A cluster with only one master node is usable for development, but is not highly available and may not be able to recover from failure.

#### <a name="dcos-agent-node"></a>Agent Node

A DC/OS agent node is a virtual or physical machine on which Mesos tasks are run.

- Each agent node contains multiple DC/OS components, including most notably a [Mesos agent](#mesos-agent) process.
- Agent nodes can be [private](#private-agent-node) or [public](#public-agent-node), depending on agent and network configuration.

For more information, see [Network Security](/docs/1.9/administration/securing-your-cluster/) and [Adding Agent Nodes](/docs/1.9/administration/installing/custom/add-a-node/).

##### <a name="private-agent-node"></a>Private Agent Node

A private agent node is an agent node that is on a network that *does not* allow ingress from outside of the cluster via the cluster’s infrastructure networking.

- The Mesos agent on each private agent node is, by default, configured with none of its resources allocated to any specific Mesos roles (`*`).
- Most service packages install by default on private agent nodes.
- Clusters are generally comprised of mostly private agent nodes.

##### <a name="public-agent-node"></a>Public Agent Node

A public agent node is an agent node that is on a network that *does* allow ingress from outside of the cluster via the cluster’s infrastructure networking.

- The Mesos agent on each public agent node is configured with the `public_ip:true` agent attribute and all of its resources allocated to the `slave_public` role.
- Public agent nodes are used primarily for externally facing reverse proxy load balancers, like [Marathon-LB](/docs/1.9/usage/service-discovery/marathon-lb/).
- Clusters generally have only a few public agent nodes, because a single load balancer can handle proxying multiple services.

For more information, see [Converting Agent Node Types](/docs/1.9/administration/installing/custom/convert-agent-type/).

### <a name="host-operating-system"></a>Host Operating System

A host operating system is the [operating system](https://en.wikipedia.org/wiki/Operating_system) that runs on each DC/OS node underneath the DC/OS components, manages the local hardware and software resources, and provides common services for running other programs and services.

- DC/OS currently supports the following host operating systems: [CentOS](https://www.centos.org/), [RHEL](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux), and [CoreOS](https://coreos.com/).
- While the host OS manges local tasks and machine resources, DC/OS manages cluster tasks and resources so that the user does not generally need to interact with the host operating systems on the nodes.

### <a name="bootstrap-machine"></a>Bootstrap Machine

A bootstrap machine is the machine on which the DC/OS installer artifacts are configured, built, and distributed.

- The bootstrap machine is not technically considered part of the cluster since it does not have DC/OS installed on it (this may change in the future). For most installation methods, the bootstrap node must be accessible to and from the machines in the cluster via infrastructure networking.
- The bootstrap machine is sometimes used as a jumpbox to control SSH access into other nodes in the cluster for added security and logging.
- One method of allowing master nodes to change IPs involves running ZooKeeper with Exhibitor on the bootstrap machine. Other alternatives include using S3, DNS, or static IPs, with various tradeoffs. For more information, see [configuring the exhibitor storage backend](/docs/1.9/administration/installing/custom/configuration-parameters/#exhibitor_storage_backend).
- If a bootstrap machine is not required for managing master node IP changes or as an SSH jumpbox, it can be shut down after bootstrapping and spun up on demand to [add new nodes](/docs/1.9/administration/installing/custom/add-a-node/) to the cluster.

For more information, see the [system requirements](/docs/1.9/administration/installing/custom/system-requirements/#bootstrap-node).

### <a name="dcos-service"></a>Service

A DC/OS service is a set of one or more service instances that can be started and stopped as a group and restarted automatically if they exit before being stopped.

- Services is currently just a DC/OS GUI abstraction that translates to Marathon apps and pods in the CLI and API. This distinction will change over time as the name "service" is pushed upstream into component APIs.
- Sometimes "service" may also refer to a systemd service on the host OS. These are generally considered components and don’t actually run on Marathon or Mesos.
- A service may be either a system service or a user service. This distinction is new and still evolving as namespacing is transformed into a system-wide first class pattern.

#### <a name="marathon-service"></a>Marathon Service

A Marathon service consists of zero or more containerized service instances. Each service instance consists of one or more containerized Mesos tasks.

- Marathon apps and pods are both considered services.
    - Marathon app instances map 1 to 1 with tasks.
    - Marathon pod instances map 1 to many with tasks.
- Service instances are restarted as a new Mesos Task when they exit prematurely.
- Service instances may be re-scheduled onto another agent node if they exit prematurely and the agent is down or does not have enough resources any more.
- Services may be installed directly via the [DC/OS API (Marathon)](http://mesosphere.github.io/marathon/docs/rest-api.html) or indirectly via the [DC/OS Package Manager (Cosmos)](#package-manager) from a [package repository](#dcos-package-repository) like [Mesosphere Universe](#mesosphere-universe). The [DC/OS GUI](#dcos-gui) and [DC/OS CLI](#dcos-cli) may be used to interact with the DC/OS Package Manager (Cosmos) more easily.
- A Marathon service may be a [DC/OS scheduler](#dcos-scheduler), but not all services are schedulers.
- A Marathon service is an abstraction around Marathon service instances which are an abstraction around Mesos tasks. Other schedulers (e.g. DC/OS Jobs (Metronome), Jenkins) have their own names for abstractions around Mesos tasks.

Examples: Cassandra (scheduler), Marathon-on-Marathon, Kafka (scheduler), Nginx, Tweeter.

#### <a name="systemd-service"></a>Systemd Service

A systemd service is a service that consists of a single, optionally containerized, machine operating system process, running on the master or agent nodes, managed by systemd, owned by DC/OS itself.

- All systemd service are currently either host OS service, DC/OS dependencies, DC/OS components, or services manually managed by the system administrator.

Examples: Most DC/OS components, (system) Marathon.

#### <a name="system-service"></a>System Service

A system service is a service that implements or enhances the functionality of DC/OS itself, run as either a Marathon service or a systemd service, owned by the system (admin) user or DC/OS itself.

- A system service may require special permissions to interact with other system services.
- Permission to operate as a system service on an Enterprise DC/OS cluster requires specific fine-grained permissions, while on open DC/OS all logged in users have the same administrative permissions.

Examples: All DC/OS components.

#### <a name="user-service"></a>User Service

A user service is a Marathon service that is not a system service, owned by a user of the system.

- This distinction is new and still evolving as namespacing is transformed into a system-wide first class pattern and mapped to fine-grained user and user group permissions.

Examples: Jenkins, Cassandra, Kafka, Tweeter.

### <a name="dcos-service-group"></a>Service Group

A DC/OS service group is a hierarchical (path-like) set of DC/OS services for namespacing and organization.

- Service groups are currently only available for Marathon services, not systemd services.
- This distinction may change as namespacing is transformed into a system-wide first class pattern.

### <a name="dcos-job"></a>Job

A DC/OS job is a set of similar short-lived job instances, running as Mesos tasks, managed by the DC/OS Jobs (Metronome) component.

- A job can be created to run only once, or may run regularly on a schedule.

### <a name="dcos-scheduler"></a>Scheduler

A DC/OS scheduler is a Mesos scheduler that runs as a systemd service on master nodes or Mesos task on agent nodes.

- The key differences between a DC/OS scheduler and Mesos scheduler are where it runs and how it is installed.
- Some schedulers come pre-installed as DC/OS components (e.g. Marathon, DC/OS Jobs (Metronome)).
- Some schedulers can be installed by users as user services (e.g Kafka, Cassandra).
- Some schedulers run as multiple service instances to provide high availability (e.g. Marathon).
- In certain security modes within Enterprise DC/OS, a DC/OS scheduler must authenticate and be authorized using a service account in order to register with Mesos as a framework.

### <a name="dcos-scheduler-service"></a>Scheduler Service

A DC/OS scheduler service is a long-running DC/OS scheduler that runs as a DC/OS service (Marathon or systemd).

- Since DC/OS schedulers can also be run as short-lived tasks, not all schedulers are services.

### <a name="dcos-component"></a>Component

A DC/OS component is a DC/OS system service that is distributed with DC/OS.

- Components may be systemd services or Marathon services.
- Components may be deployed in a high availability configuration.
- Most components run on the master nodes, but some (e.g. mesos-agent) run on the agent nodes.

Examples: Mesos, Marathon, Mesos-DNS, Bouncer, Admin Router, DC/OS Package Manager (Cosmos), Minuteman, History Service, etc.

### <a name="dcos-package"></a>Package

A DC/OS package is a bundle of metadata that describes how to configure, install, and uninstall a DC/OS service using Marathon.

### <a name="dcos-package-manager"></a>Package Manager

The [DC/OS Package Manager (Cosmos)(https://github.com/dcos/cosmos)) is a component that manages installing and uninstalling packages on a DC/OS cluster.

- The DC/OS GUI and DC/OS CLI act as clients to interact with the DC/OS Package Manager.
- The [DC/OS Package Manager API](https://github.com/dcos/cosmos) allows programmatic interaction.

### <a name="dcos-package-registry"></a>Package Registry

A DC/OS package registry is a repository of DC/OS packages.

- The [DC/OS Package Manager](#dcos-package-manager) may be configured to install packages from one or more package registries.

### <a name="mesosphere-universe"></a>Mesosphere Universe

The Mesosphere Universe is a public package registry, managed by Mesosphere.

For more information, see the [Universe repository](https://github.com/mesosphere/universe) on GitHub.

### <a name="container-registry"></a>Container Registry

A container registry is a repository of pre-built container images.

The [Docker Runtime](#mesos-docker-runtime) and [Mesos Container Runtime](#mesos-universal-container-runtime) can both pull and run Docker images from public or private Docker container registries.

### <a name="cloud-template"></a>Cloud Template

A cloud template is an infrastructure-specific method of decoratively describing a DC/OS cluster.

For more information, see [Cloud Installation Options](/docs/1.9/administration/installing/cloud/).


# <a name="mesos-concepts"></a>Mesos Concepts

The following terms are contextually correct when talking about Apache Mesos, but may be hidden by other abstraction within DC/OS.

- [Apache Mesos](#apache-mesos)
- [Master](#mesos-master)
- [Agent](#mesos-agent)
- [Task](#mesos-task)
- [Executor](#mesos-executor)
- [Scheduler](#mesos-scheduler)
- [Framework](#mesos-framework)
- [Role](#mesos-role)
- [Resource Offer](#mesos-resource-offer)
- [Containerizer](#mesos-containerizer)
  - [Mesos Universal Container Runtime](#mesos-universal-container-runtime)
  - [Docker Runtime](#mesos-docker-runtime)
- [Exhibitor &amp; ZooKeeper](#mesos-exhibitor-zookeeper)
- [Mesos\-DNS](#mesos-dns)

### <a name="apache-mesos"></a>Apache Mesos

Apache Mesos is a distributed systems kernel that manages cluster resources and tasks.

- Mesos is one of the core components of DC/OS that predates DC/OS itself, bringing maturity and stability to the platform.

For more information, see the [Mesos website](http://mesos.apache.org/).

### <a name="mesos-master"></a>Master

A Mesos master is a process that runs on master nodes to coordinate cluster resource management and facilitate orchestration of tasks.

- The Mesos masters form a quorum and elect a leader.
- The lead Mesos master collects resources reported by Mesos agents and makes resource offers to Mesos schedulers. Schedulers then may accept resource offers and place tasks on their corresponding nodes.

### <a name="mesos-agent"></a>Agent

A Mesos agent is a process that runs on agent nodes to manage the executors, tasks, and resources of that node.

- The Mesos agent registers some or all of the node’s resources, which allows the lead Mesos master to offer those resources to schedulers, which decide on which node to run tasks.
- The Mesos agent reports task status updates to the lead Mesos master, which in turn reports them to the appropriate scheduler.

### <a name="mesos-task"></a>Task

A Mesos task is an abstract unit of work, lifecycle managed by a Mesos executor, that runs on a DC/OS agent node.

- Tasks are often processes or threads, but could even just be inline code or items in a single-threaded queue, depending on how their executor is designed.
- The Mesos built-in command executor runs each task as a process that can be containerized by one of several [Mesos containerizers](#mesos-containerizer).

### <a name="mesos-executor"></a>Executor

A Mesos executor is a method by which Mesos agents launch tasks.

- Executor processes are launched and managed by Mesos agents on the agent nodes.
- Mesos tasks are defined by their scheduler to be run by a specific executor (or the default executor).
- Each executor runs in its own container.

For more information about framework schedulers and executors, see the [Application Framework development guide](http://mesos.apache.org/documentation/latest/app-framework-development-guide/).

### <a name="mesos-scheduler"></a>Scheduler

A Mesos scheduler is a program that defines new Mesos tasks and assigns resources to them (placing them on specific nodes).

- A scheduler receives resource offers describing CPU, RAM, etc., and allocates them for discrete tasks that can be launched by Mesos agents.
- A scheduler must register with Mesos as a framework.

Examples: Kafka, Marathon, Cassandra.

### <a name="mesos-framework"></a>Framework

A Mesos framework consists of a scheduler, tasks, and optionally custom executors.

- The term framework and scheduler are sometimes used interchangeably. Prefer scheduler within the context of DC/OS.

For more information about framework schedulers and executors, see the [Application Framework development guide](http://mesos.apache.org/documentation/latest/app-framework-development-guide/).

### <a name="mesos-role"></a>Role

A Mesos role is a group of Mesos Frameworks that share reserved resources, persistent volumes, and quota. These frameworks are also grouped together in Mesos' hierarchical Dominant Resource Fairness (DRF) share calculations.

- Roles are often confused as groups of resources, because of they way they can be statically configured on the agents. The assignment is actually the inverse: resources are assigned to roles.
- Role resource allocation can be configured statically on the Mesos agent or changed at runtime using the Mesos API.

### <a name="mesos-resource-offer"></a>Resource Offer

A Mesos resource offer provides a set of unallocated resources (e.g. cpu, disk, memory) from an agent to a scheduler so that the scheduler may allocate those resources to one or more tasks. Resource offers are constructed by the leading Mesos master, but the resources themselves are reported by the individual agents.

### <a name="mesos-containerizer"></a>Containerizer

A containerizer is a containerization and resource isolation abstraction around a specific container runtime, namely the [Docker Runtime](#mesos-docker-runtime) and [Mesos Universal Container Runtime](#mesos-universal-container-runtime).

#### <a name="mesos-universal-container-runtime"></a>Mesos Universal Container Runtime

The Mesos Universal Container Runtime is a containerizer that supports traditional Mesos containers around binary executables and also Mesos containers launched from Docker images. Containers managed by the Mesos Universal Container Runtime do not use [Docker-Engine](https://www.docker.com/products/docker-engine), even if launched from a Docker image.

#### <a name="mesos-docker-runtime"></a>Docker Runtime

The Docker Runtime is a containerizer that supports launching Docker containers from Docker images with [Docker-Engine](https://www.docker.com/products/docker-engine).

### <a name="mesos-exhibitor-zookeeper"></a>Exhibitor &amp; ZooKeeper

Mesos depends on ZooKeeper, a high-performance coordination service to manage the cluster state. Exhibitor automatically configures and manages ZooKeeper on the [master nodes](#master-node).

### <a name="mesos-exhibitor-zookeeper"></a>Mesos-DNS

Mesos-DNS is a DC/OS component that provides service discovery within the cluster. Mesos-DNS allows applications and services that are running on Mesos to find each other by using the domain name system (DNS), similar to how services discover each other throughout the Internet.

For more information, see the [Mesos-DNS documentation](/docs/1.9/usage/service-discovery/mesos-dns/).

# <a name="marathon-concepts"></a>Marathon Concepts

The following terms are contextually correct when talking about Marathon, but may be hidden by other abstraction within DC/OS.

- [Marathon](#marathon)
- [Application](#marathon-application)
- [Pod](#marathon-pod)
- [Group](#marathon-group)

### <a name="marathon"></a>Marathon

Marathon is a container orchestration engine for Mesos and DC/OS.

- Marathon is one of the core components of DC/OS that predates DC/OS itself, bringing maturity and stability to the platform.

For more information, see the [Marathon website](https://mesosphere.github.io/marathon/).

### <a name="marathon-application"></a>Application

A Marathon application is a long-running service that may have one or more instances that map one to one with Mesos tasks.

- The user creates an application by providing Marathon with an application definition (JSON). Marathon then schedules one or more application instances as Mesos tasks, depending on how many the definition specified.
- Applications currently support the use of either the [Mesos Universal Container Runtime](#mesos-universal-container-runtime) or the [Docker Runtime](#mesos-docker-runtime).

### <a name="marathon-pod"></a>Pod

A Marathon pod is a long-running service that may have one or more instances that map one to many with colocated Mesos tasks.

- The user creates a pod by providing Marathon with a pod definition (JSON). Marathon then schedules one or more pod instances as Mesos tasks, depending on how many the definition specified.
- Pod instances may include one or more tasks that share certain resources (e.g. IPs, ports, volumes).
- Pods currently require the use of the [Mesos Universal Container Runtime](#mesos-universal-container-runtime).

### <a name="marathon-group"></a>Group

A Marathon group is a set of services (applications and/or pods) within a hierarchical directory [path](https://en.wikipedia.org/wiki/Path_%28computing%29) structure for namespacing and organization.
