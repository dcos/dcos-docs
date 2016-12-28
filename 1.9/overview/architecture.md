---
post_title: Architecture
nav_title: Architecture
menu_order: 2
---

An operating system abstracts resources such as CPU, RAM, and networking and provides common services to applications. DC/OS is a distributed operating system that abstracts the resources of a cluster of machines and provides common services. These common services include running processes across a number of nodes, service discovery, and package management. This topic discusses the architecture of DC/OS and the interaction of its components.

To simplify the understanding of DC/OS, we will reuse the Linux terminology for kernel and user space. The kernel space is a protected area that is not accessible to users and involves low-level operations such as resource allocation, security, and process isolation. The user space is where the user applications and higher order services live, for example the GUI of your OS.

## 100,000 ft view

The DC/OS kernel space is comprised of Mesos masters and Mesos agents. The user space includes System Components such as Mesos-DNS, Distributed DNS Proxy, and services such as Marathon or Spark. The user space also includes processes that are managed by the services, for example a Marathon application.

![DC/OS architecture 100,000ft view](../img/dcos-architecture-100000ft.png)

Before we dive into the details of the interaction between different DC/OS components, let's define the terminology used.

- Master: aggregates resource offers from all agent nodes and provides them to registered frameworks.
- Scheduler: the scheduler component of a service, for example the Marathon scheduler.
- User: also known as Client, is an application either internal or external to the cluster that kicks off a process, for example a human user that submits a Marathon app spec.
- Agent: runs a discrete Mesos task on behalf of a framework. It is an agent instance registered with the Mesos master. The synonym of agent node is worker or slave node. You can have private or public agent nodes.
- Executor: launched on agent nodes to run tasks for a service.
- Task: a unit of work scheduled by a Mesos framework and executed on a Mesos agent.
- Process: a logical collection of tasks initiated by a Client, for example a Marathon app or a Chronos job.

### Kernel space

In DC/OS, the kernel space manages resource allocation and two-level scheduling across the cluster. The two types of processes in the kernel space are Mesos masters and agents:

- **Mesos masters** The `mesos-master` process orchestrates tasks that are run on Mesos agents. The Mesos Master process receives resource reports from Mesos agents and distributes those resources to registered DC/OS services, such as Marathon or Spark. When a leading Mesos master fails due to a crash or goes offline for an upgrade, a standby Mesos master automatically becomes the leader without disrupting running services. ZooKeeper performs leader election.
- **Mesos agents**: Mesos agent nodes run discrete Mesos tasks on behalf of a framework. Private agent nodes run the deployed apps and services through a non-routable network. Public agent nodes run DC/OS apps and services in a publicly accessible network. The `mesos-slave` process on a Mesos agent manages its local resources (CPU cores, RAM, etc.) and registers these resources with the Mesos masters. It also accepts schedule requests from the Mesos master and invokes an Executor to launch a Task via [containerizers](http://mesos.apache.org/documentation/latest/containerizer/):
  - The Mesos containerizer provides lightweight containerization and resource isolation of executors using Linux-specific functionality such as cgroups and namespaces.
  - The Docker containerizer provides support for launching tasks that contain Docker images.

### User space

The DC/OS user space spans System Components and DC/OS services such as Chronos or Kafka:

- [System Components][components] are installed and are running by default in the DC/OS cluster and include the following:
  - The Admin Router is an open source NGINX configuration that provides central authentication and proxy to DC/OS services.
  - Exhibitor automatically configures ZooKeeper during installation and provides a usable Web UI to ZooKeeper.
  - Mesos-DNS provides service discovery, allowing apps and services to find each other by using the domain name system (DNS).
  - Minuteman is the internal layer 4 load balancer.
  - Distributed DNS Proxy is the internal DNS dispatcher.
  - DC/OS Marathon, the native Marathon instance that is the 'init system' for DC/OS, starts and monitors DC/OS services.
  - ZooKeeper, a high-performance coordination service that manages the DC/OS services.
- Services
  - A service in DC/OS consists of a Scheduler (responsible for scheduling tasks on behalf of a user) and an Executor (running Tasks on agents).
  - User-level applications, for example an NGINX webserver launched through Marathon.

## <a name="boot"></a>Boot sequence

During DC/OS installation, the components come online in this sequence.

### Master nodes

On each master node the following happens, in chronological order:

1. [Exhibitor](https://github.com/mesosphere/exhibitor-dcos) starts up, creates ZooKeeper configuration and launches ZooKeeper.
1. The Mesos masters are launched, register with the local ZooKeeper (127.0.0.1), and discover the other masters.
1. Mesos-DNS is launched on every master node.
1. Mesos-DNS keeps hitting `leader.mesos:5050/master/state.json`. The DNS entry `leader.mesos` points to the currently leading Mesos master.
1. The Distributed DNS Proxy runs on all master and agent nodes, and forwards DNS lookups to Mesos-DNS.
1. DC/OS Marathon is launched and starts on every master node.
1. DC/OS Marathon connects to the local ZooKeeper (127.0.0.1), discovers the leading Mesos master (`leader.mesos`) and registers as a framework.
1. Admin Router depends on the Mesos master, Mesos-DNS, and the Distributed DNS Proxy. It runs on each of the master nodes. The admin router is what serves the DC/OS UI and proxies external admin connections into the cluster.
1. DC/OS UI, Mesos UI, and Exhibitor UI become externally accessible through the Admin Router.
1. [Auth][auth] is managed on the master nodes.
1. The history service provides the data for the graphs in the DC/OS UI dashboard. This data is obtained from the masters.
1. DC/OS diagnostics and systemd service on every node.

### Agent nodes

On each agent node the following happens, in chronological order:

1. The Mesos agents wait until they can ping `leader.mesos`.
1. The Mesos agents start up and discover the leading Mesos master (`leader.mesos`) by using ZooKeeper.
1. The Mesos agents register as agent with the leading Mesos master (`leader.mesos`).
1. The Mesos master attempts to connect back to the agent node by using the IP address the agent registered with.
1. The Mesos agents becomes available for launching new tasks.
1. DC/OS nodes become visible in the DC/OS UI.

### Services

After DC/OS installation completes, you can install DC/OS services. For each installed DC/OS service, the following happens:

- Service scheduler starts up and discovers the leading Mesos master via ZooKeeper.
- Service scheduler registers with leading Mesos master (`leader.mesos`).
- Mesos master confirms and scheduler stores the service ID in ZooKeeper.
- After a service is registered, the resource offer cycle between the Mesos master and scheduler is started (details in next section).

## Distributed process management

This section describes the management of processes in a DC/OS cluster, from the resource allocation to the execution of a process.

At a high level, this interaction takes place between the DC/OS components when a user launches a process. Communication occurs between the different layers, such as the user interacting with the scheduler, and within a layer, for example, a master communicating with agents.

![Concept of distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-concept.png)

Here is an example, using the Marathon service and a user launching a container based on a Docker image:

![Example of distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-example.png)

The chronological interaction between the above components looks like this. Notice that Executors and Task are folded into one block since in practice this is often the case:

![Sequence diagram for distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-seq-diagram.png)

In detail, here are the steps:

<table class="table">
<thead>
<tr>
<th>Step</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>Client/Scheduler init: the Client needs to know how to connect to the Scheduler in order to launch a process, for example via Mesos-DNS or DC/OS CLI.</td>
</tr>
<tr>
<td>2</td>
<td>Mesos master sends resource offer to Scheduler: the resource offers are based on cluster resources managed through agents and the <a href="https://www.cs.berkeley.edu/~alig/papers/drf.pdf">DRF</a> algorithm in Mesos master.</td>
</tr>
<tr>
<td>3</td>
<td>Scheduler declines resource offers because no process requests from Clients are pending. As long as no clients have initiated a process, the scheduler will reject offers from the master.</td>
</tr>
<tr>
<td>4</td>
<td>Client initiates process launch. For example, this could be a user creating a Marathon app via the DC/OS <a href="/docs/1.9/usage/webinterface">Services</a> tab or via the HTTP endpoint <code>/v2/app</code>.</td>
</tr>
<tr>
<td>5</td>
<td>Mesos master sends the resource offers . For example, <code>cpus(*):1; mem(*):128; ports(*):[21452-21452]</code></td>
</tr>
<tr>
<td>6</td>
<td>If resource offer matches the requirements the Scheduler has for the process, it accepts the offer and sends a <code>launchTask</code> request to Mesos master.</td>
</tr>
<tr>
<td>7</td>
<td>Mesos master directs Mesos agents to launch tasks.</td>
</tr>
<tr>
<td>8</td>
<td>Mesos agent launches tasks via Executor.</td>
</tr>
<tr>
<td>9</td>
<td>Executor reports task status to Mesos agent.</td>
</tr>
<tr>
<td>10</td>
<td>Mesos agent reports task status to Mesos master.</td>
</tr>
<tr>
<td>11</td>
<td>Mesos master reports task status to scheduler.</td>
</tr>
<tr>
<td>12</td>
<td>Scheduler reports process status to client.</td>
</tr>
</tbody>
</table>

[auth]: /docs/1.9/administration/id-and-access-mgt/
[components]: /docs/1.9/overview/components/
