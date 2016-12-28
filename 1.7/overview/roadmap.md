---
post_title: Roadmap
nav_title: Roadmap
menu_order: 9
---

This roadmap provides a high level overview of the themes that the DC/OS project is focusing on in the near, medium and long term.
Please see the design docs and JIRAs for additional details on each item.

## Near Term

### Unified DC/OS API
DC/OS consists of a number of components that each serve a specialized function. Every component has its own API, with different syntax, conventions, and endpoints. The Unified DC/OS API brings all of these together under one umbrella. It’s the “POSIX” of DC/OS. The initial focus will be on networking, and integrating the Marathon API. For more information, see the [Design doc](/docs/1.7/overview/design/dcos-api/).

### Support for Container Network Interface
The [Container Network Interface (CNI)](https://github.com/appc/cni) is a proposed standard for configuring network interfaces for Linux containers. For more information, see the [Design doc](https://docs.google.com/document/d/1FFZwPHPZqS17cRQvsbbWyQbZpwIoHFR_N6AAApRv514/edit).

### Virtual Networks in DC/OS levaraging CNI & VxLAN
DC/OS Virtual Networking Service builds on the CNI standard and provides IP per Container capability to workloads running on top of DC/OS. For more information, see the [Design doc](https://docs.google.com/document/d/1Ped26pNOoET5H-QM--D6aPiCpG3qgvknNUbZJLz-rao/edit).

### Edge load balancing
A Layer 7 On-ramp/Off-ramp with load balancing capabilities that routes incoming North-South web traffic to services running on DC/OS. For more information, see the [Design doc](https://docs.google.com/document/d/1G7Pj9cqRZjQkJz89E343067-InfDqW7RtcX94F4w_So/edit#heading=h.28ogyrx55sfi). This effort plans to integrate edge load balancing into the [DC/OS service discovery](/docs/1.7/usage/service-discovery/) layer, without the need for individually managed HAProxy.

### Pluggable External Volumes
Support for pluggable external volume providers such as [REX-Ray](https://github.com/emccode/rexray), [Flocker](https://github.com/ClusterHQ/flocker), etc. For more information, see the [design doc for external volumes (Docker Volume Driver) in Mesos](https://docs.google.com/document/d/1uhi1lf1_sEmnl0HaqHUCsqPb9m9jOKbRlXYW1S-tZis/edit?usp=sharing).
<!-- and [external volumes in Marathon](https://mesosphere.github.io/marathon/docs/external-volumes.html). -->

## Medium Term

### Pods
Pods enable the popular "sidecar" pattern where multiple containers are scheduled together on the same host and with shared resources. Pods allows co-scheduling of monitoring agents, service registration clients, and more with the main application process.

### Metrics API
The Metrics API provides a way for any component of DC/OS to publish its own metrics. Metrics can be forwarded to standard metrics aggregation tools such as Graphite, Grafana, InfluxDB, and Prometheus.

### Unified Logging
Aggregate logs from all parts of DC/OS via Journald. This includes master, agent, and service logs. Plugins and tutorials for integrating with log aggregation systems like Splunk or ELK.

### System Services
Run a service on every node in the cluster to support add-ons that need a daemon process to be present cluster-wide. Examples are monitoring agents, log ingestion, security monitoring and enforcement, networking.

### Package Profiles
Multiple configuration profiles in Universe packages, to support dev/prod configurations and small/medium/large setups.

### Package Dependencies
Support for dependencies in Universe packages.

### GPU Support
Support for discovery, isolation, and consumption of GPUs. Users will be able to request machines with GPU support for their tasks. DC/OS provides isolation so that multiple containers cannot interfere with each other.

### DC/OS on Windows
Support running DC/OS nodes on Windows machines, and support for scheduling workloads in Windows containers.


## Long Term

### Jobs
Schedule run-to-completion jobs with DC/OS, such as ETL and system maintenance tasks. This is currently accomplished by the Chronos scheduler which needs to be installed separately. The goal of this project is to integrate this functionality into DC/OS itself.

### Debugging
Tools for debugging applications at runtime, and integrating with existing debugging tools such as gdb and IDEs.

### Autoscaling
Automatic scale-out of container-based applications based on configurable metrics such as response time and throughput.
