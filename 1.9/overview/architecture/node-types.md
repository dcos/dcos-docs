---
post_title: Node Types
nav_title: Node Types
menu_order: 1
---

A DC/OS node is a virtual or physical machine on which DC/OS components run. DC/OS nodes are networked together to form a DC/OS cluster.

A DC/OS cluster is composed of three types of nodes: masters, private agents, and public agents.

![DC/OS Node Types](/docs/1.9/overview/architecture/img/dcos-node-types.png)


## Master Nodes

A DC/OS master node is a node that works together with other master nodes to manage the rest of the cluster.

Master nodes contain the bulk of the DC/OS components, including a Mesos master process.

### Protected Zone

Depending on distribution, deployment method, and infrastructure configuration, master nodes may be publicly accessible or in a network zone that restricts access to improve security. Common strategies include restricting master node access to the IP range of your offices and requiring [VPN](https://en.wikipedia.org/wiki/Virtual_private_network) access.

### High Availability

Multiple master nodes work together to provide high availability and fault tolerance.

A cluster with only one master node is usable for development, but is not highly available and may not be able to recover from failure.

### Leader Election

Mesos performs [leader election](https://en.wikipedia.org/wiki/Leader_election) and routes incoming traffic to the current leader to ensure consistency.

Like Mesos, several other DC/OS master node components perform independent leader election. This means that the leaders for different components, like Marathon and ZooKeeper, may be on different master nodes.

### Quorum

To maintain consistency, a quorum (half plus one) of master nodes must be connected at all times.

For example, having three master nodes allows one to be down; having five master nodes allows two to be down, allowing for failure during a rolling update. Additional master nodes can be added for additional risk tolerance.

The number of master nodes can only be specified during installation. This is primarily because of the complexity of changing the quorum and configuration of multiple components with leaders on different nodes. This may change in the future.


## Agent Nodes

A DC/OS agent node is a node on which user tasks are run.

Agent nodes contain a few DC/OS components, including a Mesos agent process.

Agent nodes can be public or private, depending on agent and network configuration.

### Public Agent Nodes

A public agent node is an agent node that is on a network that allows ingress from outside of the cluster via the cluster’s [infrastructure networking](/docs/1.9/overview/concepts/#infrastructure-network).

The resources on private agent nodes are, by default, configured to only be allocated to tasks that specify the `slave_public` role. The Mesos agents on private agent nodes also have the `public_ip:true` agent attribute to assist in their discovery.

Public agent nodes are used primarily for externally facing reverse proxy load balancers, like Marathon-LB. This provides a [DMZ](https://en.wikipedia.org/wiki/DMZ_%28computing%29) that decreases the surface area accessible by malicious attackers.

Clusters generally have only a few public agent nodes, because a few load balancers can usually handle proxying to multiple services.

### Private Agent Nodes

A private agent node is an agent node that is on a network that does not have ingress access from outside of the cluster via the cluster’s [infrastructure networking](/docs/1.9/overview/concepts/#infrastructure-network).

The resources on private agent nodes are, by default, configured to allow undifferentiated allocation. More precisely, the resources are given the `*` role, allowing them to be allocated to any task that does not specify a role. For more information, see [Mesos resource roles](http://mesos.apache.org/documentation/latest/roles/).

Because these resources are undifferentiated, most tasks are scheduled on private agent nodes and are inaccessible from outside the cluster, decreasing the surface area accessible by malicious attackers. For this reason, clusters are generally comprised of mostly private agent nodes. Likewise, most [Mesosphere Universe](https://dcos.io/docs/1.8/overview/concepts/#mesosphere-universe) packages install by default on private agent nodes.

## More Information

For more on master and agent node components, see [Components](/docs/1.9/overview/architecture/components/).

For more on security, see [Securing Your Cluster](/docs/1.9/administration/securing-your-cluster/).

For more on scaling your cluster, see [Adding Agent Nodes](/docs/1.9/administration/installing/custom/add-a-node/).

For more on configuring public nodes, see [Converting Agent Node Types](/docs/1.9/administration/installing/custom/convert-agent-type/).
