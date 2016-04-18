---
post_title: The Architecture of DC/OS
nav_title: Architecture
---

An operating system abstracts resources such as CPU, RAM and networking and provides common services to applications. DC/OS is a distributed operating system that abstracts the resources of a cluster of machines and provides common services, such as running processes across a number of nodes, service discovery, and package management, just to name a few. In the following, we have a look at the architecture of DC/OS and the interaction of its components.

In order to simplify the understanding of DC/OS, we will re-use terminology known from traditional operating system such as Linux, for example kernel and user space. The kernel space is a protected space that is inaccessible for users and involves low-level operations such as resource allocation, security, and process isolation. The user space is where the user applications and higher order services live, for example the GUI of your OS.

## 100,000ft view

DC/OS, as many operating systems, differentiates between the kernel space, comprising Mesos Masters and Mesos Agents and the user space, spanning System Components (such as Mesos-DNS or Distributed DNS Proxy) as well services like Marathon or Spark and processes managed by said services (for example a Marathon application).

![DC/OS architecture 100,000ft view](../img/dcos-architecture-100000ft.png)

### Kernel space

In DC/OS, the kernel space is responsible for the resource allocation across the cluster. It's also where the two-level scheduling process lives. There are two types of processes in the kernel space:

- One or more **Mesos Masters**. The `mesos-master` process orchestrates tasks that are run on Mesos Agents. The Mesos Master process receives resource reports from Mesos Agents and distributes those resources to registered DC/OS services, such as Marathon or Spark. When a leading Mesos Master fails due to a crash or goes offline for an upgrade, a standby Mesos Master automatically becomes the leader without causing any disruption to running services. Leader election is performed via ZooKeeper.
- There are two types of **Mesos Agents**: private agent nodes run the deployed apps and services. The optional public agent nodes can provide public access to DC/OS services and applications. The `mesos-slave` process on a Mesos Agent manages its local resources (CPU cores, RAM, etc.) and registers said resources with the Mesos Masters. It also accepts schedule requests from the Mesos Master and invokes an Executor to launch a Task via [containerizers](http://mesos.apache.org/documentation/latest/containerizer/):
  - The Mesos containerizer provides lightweight containerization and resource isolation of executors using Linux-specific functionality such as cgroups and namespaces.
  - The Docker containerizer provides support for launching tasks that contain Docker images.

### User space

The DC/OS user space spans System Components and Services (like Chronos or Kafka):

- [System Components](../components/) are installed and are running by default in the DC/OS cluster and include (but are not limited to) the following:
  - The Admin router is an open source NGNIX configuration that provides central authentication and proxy to DC/OS services.
  - Exhibitor automatically configures ZooKeeper during installation and provides a usable Web UI to ZooKeeper.
  - Mesos-DNS provides service discovery, allowing apps and services to find each other by using the domain name system (DNS).
  - Minuteman is the internal layer 4 load balancer.
  - Distributed DNS Proxy is the internal DNS dispater.
  - System Marathon, the native Marathon instance that is the 'init system' for DC/OS, starts and monitors DC/OS services.
  - ZooKeeper, a high-performance coordination service that manages the DC/OS services.
- Services
  - A service in DC/OS is consists of a Scheduler (responsible for scheduling tasks on behalf of a user) and an Executor (running Tasks on Agents)
  - User-level applications, for example an NGINX webserver launched through Marathon

## <a name="boot"></a>Boot sequence

In the following, we have a look at how a DC/OS cluster boots up, this means, we have a cluster of nodes with DC/OS installed and switch on the power. What happens?

Note that the following is post-install, that is it assumes that all System Components and DC/OS kernel-level software has been installed on the nodes in a DC/OS cluster.

### Master nodes

On each Master node the following happens, in chronological order:

1. [Exhibitor](https://github.com/mesosphere/exhibitor-dcos) starts up, creates ZooKeeper configuration and launches ZooKeeper
1. The Mesos Masters are launched, they register with the local ZooKeeper (127.0.0.1) and discover the other Masters
1. Mesos-DNS is launched on every master node
1. Mesos-DNS keeps hitting `leader.mesos:5050/master/state.json`. The DNS entry `leader.mesos` is special and points to the currently leading Mesos Master
1. The Distributed DNS Proxy runs on all nodes (master/agents) and forwards DNS lookups to Mesos-DNS
1. System Marathon is launched. It starts on every master node
1. System Marathon connects to the local ZooKeeper (127.0.0.1), discovers leading Mesos Master (aka. `leader.mesos`) and registers as a framework with it
1. Admin router depends on the Mesos Master, Mesos-DNS and the Distributed DNS Proxy. It runs on each of the master nodes. This is what serves the DC/OS UI and proxies external admin connections into the cluster
1. DC/OS UI, Mesos UI, Marathon UI, and Exhibitor UI become externally accessible as these are all made available via. admin router.
1. Auth is managed by OAuth (only masters)
1. History services provides the data for the graphs in the UI (only masters)
1. DC/OS diagnostics (also systemd service, on every node)

### Agent nodes

On each Agent node the following happens, in chronological order:

1. The Mesos Agent waits until it can ping `leader.mesos`
1. The Mesos Agent starts up and discovers the leading Mesos Master (aka. `leader.mesos`) via ZooKeeper
1. The Mesos Agent registers as an agent with the leading Mesos Master (aka. `leader.mesos`)
1. The Mesos Master confirms by trying to connect back to it with the IP the agent registered with.
1. The Mesos Agent becomes available for launching new tasks on
1. DC/OS nodes become visible in the DC/OS UI

### Services

For each service:

- Service scheduler starts up and discovers the leading Mesos Master via ZooKeeper
- Service scheduler registers with leading Mesos Master
- Mesos Master confirms and scheduler stores service ID in ZooKeeper
- Once a service is registered the resource offer cycle between Mesos Master and  scheduler kicks in (details in next section).

## Distributed process management

We now focus on the management of processes in a DC/OS cluster: from the resource allocation to the execution of a process.

Before we dive into the details of the interaction between different DC/OS components, let's define the terminology used in the following:

- Master: this is the leading Mesos Master in the DC/OS cluster (`leader.mesos`).
- Scheduler: the scheduler component of a service, for example the Marathon scheduler.
- User: also known as Client, is a cluster-external or internal app that kicks off a process, for example a human user that submits a Marathon app spec.
- Agent: a private or public Mesos Agent; originally was called Mesos Slave and you might still see references to it in the codebase.
- Executor: is part of a service running on an Agent, managing one or more tasks
- Task: a Mesos task, the unit of execution in DC/OS.
- Process: a logical collection of tasks initiated by a Client, for example a Marathon app or a Chronos job.

On a high level, the following interaction takes place between the DC/OS components when a User requests to launch a process. Note that communication takes place between the different layers (such as the User interacting with the Scheduler) as well as within a layer, for example, a Master communicating with Agents.

![Concept of distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-concept.png)

Let’s now have a look at a concrete example, using the Marathon service and a User wanting to launch a container based on a Docker image:

![Example of distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-example.png)

From a timing perspective, the interaction between above components looks as follows (note that Executors and Task are folded into one block since in practice this is often the case):

![Sequence diagram for distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-seq-diagram.png)

The steps in detail are:

| Step | Description |
| ---- | ----------- |
| 1    | Client/Scheduler init: the Client needs to know how to connect to the Scheduler in order to launch a process, for example via Mesos-DNS or DC/OS CLI |
| 2    | Mesos Master sends resource offer to Scheduler: the resource offers are based on cluster resources managed through Agents and the [DRF](https://www.cs.berkeley.edu/~alig/papers/drf.pdf) algorithm in Mesos Master.|
| 3    | Scheduler declines resource offer since no process requests from Clients are pending. As long as no clients have initiated a process, the scheduler will reject offers from the Master |
| 4    | Client initiates process launch. For example, this could be a user creating a Marathon app via the UI or via the HTTP endpoint `/v2/app` |
| 5    | Mesos Master sends resource offers . For example, `cpus(*):1; mem(*):128; ports(*):[21452-21452]` |
| 6    | If resource offer matches the requirements the Scheduler has for the process, it accepts the offer and sends a `launchTask` request to Mesos Master |
| 7    | Mesos Master directs Mesos Agent(s) to launch tasks |
| 8    | Mesos Agent launches tasks via Executor |
| 9    | Executor reports task status to Mesos Agent |
| 10   | Mesos Agent reports task status to Mesos Master |
| 11   | Mesos Master report task status to scheduler |
| 12   | Scheduler reports process status to client |
