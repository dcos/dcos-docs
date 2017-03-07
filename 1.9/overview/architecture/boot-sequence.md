---
post_title: Boot Sequence
nav_title: Boot Sequence
menu_order: 6
---

During installation, the DC/OS component services are all started in parallel but initialize and become responsive in a relatively consistent sequence because of interdependencies.

The DC/OS Diagnostics (3DT) service monitors component service and node health. A node is marked as healthy when all its component services are healthy.

## Master nodes

The following is the boot sequence of DC/OS component services on each master node.

1. DC/OS Diagnostics (3DT) starts
    1. Polls systemd for component status
    1. Reports node unhealthy until all components (systemd services) are healthy
    1. Reports cluster unhealthy until all master nodes are healthy
1. Exhibitor starts
    1. Creates ZooKeeper configuration and launches ZooKeeper
1. Mesos Master starts
    1. Registers with local ZooKeeper
    1. Discovers other Mesos Masters from ZooKeeper
    1. Elects a leading master
1. Mesos-DNS starts
    1. Discovers leading Mesos Master (from zk or local mesos-master?)
    1. Polls leading Mesos Master for cluster state
1. Networking components start
    1. Forwards DNS lookups to Mesos-DNS
    1. Initializes VIP translation
    1. Initializes overlay network
1. Container orchestration components start
    1. Registers with local ZooKeeper
    1. Elects a leading master
    1. Discovers leading Mesos Master from Mesos-DNS
    1. Leader registers with leading Mesos Master
1. Logging and Metrics components start
1. Security components start
1. Admin Router starts
    1. Discovers leading Mesos Master from Mesos-DNS
    1. Discovers leading Marathon from Mesos-DNS
    1. Redirects unauthorized traffic to authentication components
    1. Proxies API and GUI traffic to discovered components
    1. Proxies admin service traffic to DC/OS services
    1. Serves DC/OS GUI

## Agent nodes

The following is the boot sequence of DC/OS components on each agent node.

1. DC/OS Diagnostics (3DT) starts
    1. Polls systemd for component status
    1. Reports node unhealthy until all components (systemd services) are healthy
1. Mesos Agent starts
    1. Discovers leading Mesos Master from ZooKeeper
    1. Registers with leading Mesos Master
    1. Leading Mesos Master connects to the new agent using registered agent IP
    1. Leading Mesos Master starts offering the new agent's resources to schedulers for new tasks
    1. New DC/OS node become visible in the DC/OS API, GUI, and CLI
1. Networking components start
    1. Forwards DNS lookups to Mesos-DNS
    1. Initializes VIP translation
    1. Initializes overlay network
1. Logging and Metrics components start
1. Admin Router Agent starts
    1. Discovers leading Mesos Master from Mesos-DNS
    1. Proxies internal API traffic to discovered components

## Services

After DC/OS installation and initialization completes, you can install DC/OS services. Services can be installed through DC/OS package management from the Mesosphere Universe or through Marathon directly.

The following is the boot sequence of a DC/OS service.

1. Leading Mesos Master offers agent node resources to Marathon
1. Leading Marathon schedules the service onto agent nodes with sufficient resources
1. Mesos Agent starts the service as one or more containerized tasks

### Scheduler Services

Some DC/OS services are also schedulers that interact with DC/OS to manage tasks.

The following is the boot sequence of a DC/OS scheduler service.

1. Leading Mesos Master offers agent node resources to Marathon
1. Leading Marathon schedules the service onto agent nodes with sufficient resources
1. Mesos Agent starts the service as one or more containerized tasks
1. Scheduler service discovers leading Mesos Master from Mesos-DNS
1. Scheduler service registers with leading Mesos Master
1. Leading Mesos Master starts offering agent node resources to the new scheduler service

### More Information

For more information about tasks and services, see [Distributed Process Management](/docs/1.9/overview/architecture/distributed-process-management/).
