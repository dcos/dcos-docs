---
post_title: Roadmap
nav_title: Roadmap
menu_order: 9
---

This roadmap provides a high level overview of the themes that the DC/OS project is focusing on in the near, medium and long term.
Please see the design docs and JIRAs for additional details on each item.

## Near Term

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

### Debugging
Tools for debugging applications at runtime, and integrating with existing debugging tools such as gdb and IDEs.

### Autoscaling
Automatic scale-out of container-based applications based on configurable metrics such as response time and throughput.
