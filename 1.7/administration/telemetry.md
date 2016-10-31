---
post_title: Telemetry
menu_order: 7
---

To continuously improve the DC/OS experience, we have included a telemetry component that reports anonymous usage data back to us. We use this data to monitor the reliability of core DC/OS components, installations, and to find out which features are most popular. There are two sections that have the telemetry component implemented:

## System

You will see a ping to `segment.com` once per hour with this data:

```
{
    "clusterId": "71159751-c28a-4a23-a279-d36ffc2fff40\n",
    "environmentVersion": "1.7-dev",
    "health-unit-dcos-adminrouter-reload-service-total": 1,
    "health-unit-dcos-adminrouter-reload-service-unhealthy": 0,
    "health-unit-dcos-adminrouter-reload-timer-total": 1,
    "health-unit-dcos-adminrouter-reload-timer-unhealthy": 0,
    "health-unit-dcos-adminrouter-service-total": 1,
    "health-unit-dcos-adminrouter-service-unhealthy": 0,
    "health-unit-dcos-cluster-id-service-total": 1,
    "health-unit-dcos-cluster-id-service-unhealthy": 0,
    "health-unit-dcos-cosmos-service-total": 1,
    "health-unit-dcos-cosmos-service-unhealthy": 0,
    "health-unit-dcos-ddt-service-total": 3,
    "health-unit-dcos-ddt-service-unhealthy": 0,
    "health-unit-dcos-epmd-service-total": 3,
    "health-unit-dcos-epmd-service-unhealthy": 0,
    "health-unit-dcos-exhibitor-service-total": 1,
    "health-unit-dcos-exhibitor-service-unhealthy": 0,
    "health-unit-dcos-gen-resolvconf-service-total": 3,
    "health-unit-dcos-gen-resolvconf-service-unhealthy": 0,
    "health-unit-dcos-gen-resolvconf-timer-total": 3,
    "health-unit-dcos-gen-resolvconf-timer-unhealthy": 0,
    "health-unit-dcos-history-service-service-total": 1,
    "health-unit-dcos-history-service-service-unhealthy": 0,
    "health-unit-dcos-logrotate-service-total": 3,
    "health-unit-dcos-logrotate-service-unhealthy": 0,
    "health-unit-dcos-logrotate-timer-total": 3,
    "health-unit-dcos-logrotate-timer-unhealthy": 0,
    "health-unit-dcos-marathon-service-total": 1,
    "health-unit-dcos-marathon-service-unhealthy": 0,
    "health-unit-dcos-mesos-dns-service-total": 1,
    "health-unit-dcos-mesos-dns-service-unhealthy": 0,
    "health-unit-dcos-mesos-master-service-total": 1,
    "health-unit-dcos-mesos-master-service-unhealthy": 0,
    "health-unit-dcos-mesos-slave-public-service-total": 1,
    "health-unit-dcos-mesos-slave-public-service-unhealthy": 0,
    "health-unit-dcos-mesos-slave-service-total": 1,
    "health-unit-dcos-mesos-slave-service-unhealthy": 0,
    "health-unit-dcos-minuteman-service-total": 3,
    "health-unit-dcos-minuteman-service-unhealthy": 0,
    "health-unit-dcos-oauth-service-total": 1,
    "health-unit-dcos-oauth-service-unhealthy": 0,
    "health-unit-dcos-rexray-service-total": 2,
    "health-unit-dcos-rexray-service-unhealthy": 0,
    "health-unit-dcos-signal-service-total": 1,
    "health-unit-dcos-signal-service-unhealthy": 0,
    "health-unit-dcos-signal-timer-total": 3,
    "health-unit-dcos-signal-timer-unhealthy": 0,
    "health-unit-dcos-spartan-service-total": 3,
    "health-unit-dcos-spartan-service-unhealthy": 0,
    "health-unit-dcos-spartan-watchdog-service-total": 3,
    "health-unit-dcos-spartan-watchdog-service-unhealthy": 0,
    "health-unit-dcos-spartan-watchdog-timer-total": 3,
    "health-unit-dcos-spartan-watchdog-timer-unhealthy": 0,
    "health-unit-dcos-vol-discovery-priv-agent-service-total": 1,
    "health-unit-dcos-vol-discovery-priv-agent-service-unhealthy": 0,
    "health-unit-dcos-vol-discovery-pub-agent-service-total": 1,
    "health-unit-dcos-vol-discovery-pub-agent-service-unhealthy": 0,
    "provider": "aws",
    "source": "cluster",
    "variant": "open"
  }

```

Along with the health of each system component in your cluster, this also tells us which version you are running.

## User Interface

When using the DC/OS UI, we receive two types of notifications:

- Login information
- The pages you’ve viewed while navigating the UI

<hr>

## Opt-Out

- [Instructions](../opt-out/)
