---
post_title: Metrics
feature_maturity: preview
menu_order: 100
---

The [metrics component](/docs/1.9/overview/architecture/components/#dcos-metrics) provides metrics from DC/OS cluster hosts, containers running on those hosts, and from applications running on DC/OS that send statsd metrics to the Mesos Metrics Module. The metrics component is natively integrated with DC/OS and is available per-host from the `/system/v1/metrics/v0` HTTP API endpoint. No additional setup is required.  

## Overview
DC/OS provides these types of metrics: 

  * **Host:** metrics about the specific node which is part of the DC/OS cluster. 
  * **Container:** metrics about cgroup allocations from tasks running in Mesos or Docker containerizers. 
  * **Application:** metrics about a specific application running inside the DC/OS Universal [container runtime](/docs/1.9/deploying-services/containerizers/).

The [Metrics API](/docs/1.9/metrics/metrics-api/) exposes these areas. 

All three metrics layers are aggregated by a collector which is shipped as part of the DC/OS distribution. This enables metrics to run on every host in the cluster. It is the main entry point to the metrics ecosystem, aggregating metrics sent to it by the Metrics Mesos module, or gathering host and container level metrics on the box which is runs. 

The Mesos Metrics Module is bundled with every agent in the cluster. This module enables applications to publish metrics from applications running on top of DC/OS to the collector by exposing a StatsD port and host environment variable inside every container. These metrics are appended with structured data such as `agent-id`, `framework-id`, and `task-id`.

<!-- insert graphic -->

Per-container metrics tags enable you to arbitrarily group metrics, for example on a per-framework or per-system, or agent basis. Here are the available tags:

* `agent_id`
* `container_id`
* `executor_id`
* `framework_id`
* `framework_name`
* `framework_principal`
* `hostname`
* `labels`

DC/OS applications will discover the endpoint via an environment variable (`STATSD_UDP_HOST` or `STATSD_UDP_PORT`). Applications leverage this StatsD interface to send custom profiling metrics to the system.

For more information on which metrics are collected, see the Metrics [Reference](/docs/1.9/metrics/reference/).