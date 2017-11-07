---
post_title: Logging
feature_maturity: preview
menu_order: 3.4
---

DC/OS cluster nodes generate logs that contain diagnostic and status information for DC/OS core components and DC/OS services.

## Service, task, and node logs

The logging component provides an HTTP API `/system/v1/logs/` that exposes the system logs.

You can access information about DC/OS scheduler services, like Marathon or Kafka, with the following CLI command:

```bash
dcos service log --follow <scheduler-service-name>
```

You can access DC/OS task logs by running this CLI command:

```bash
dcos task log --follow <service-name>
```

You access the logs for the master node with the following CLI command:

```bash
dcos node log --leader
```

To access the logs for an agent node, run `dcos node` to get the Mesos IDs of your nodes, then run the following CLI command:

```bash
dcos node log --mesos-id=<node-id>
```

You can download all the log files for your service from the **Services > Services** tab in the [DC/OS GUI](/docs/1.9/gui/). You can also monitor stdout/stderr.

For more information, see the Service and Task Logs [quick start guide](/docs/1.9/monitoring/logging/quickstart/).

## System logs

DC/OS components use `systemd-journald` to store their logs. To access the DC/OS core component logs, [SSH into a node][5] and run this command to see all logs:

```bash
journalctl -u "dcos-*" -b
```

You can view the logs for specific [components](/docs/1.9/overview/architecture/components/) by entering the component name. For example, to access Admin Router logs, run this command:

```bash
journalctl -u dcos-nginx -b
```

You can find which components are unhealthy in the DC/OS GUI **Nodes** tab.

![system health](/docs/1.9/img/ui-system-health-logging.png)

# Log aggregation

Streaming logs from machines in your cluster isn’t always viable. Sometimes you need a history of what's happened, which requires a method for storing and aggregating logs. These topics describe some of the most common solutions:

- [Log Management with ELK](/docs/1.9/monitoring/logging/aggregating/elk/)
- [Log Management with Splunk](/docs/1.9/monitoring/logging/aggregating/splunk/)

[5]: /docs/1.9/administering-clusters/sshcluster/
