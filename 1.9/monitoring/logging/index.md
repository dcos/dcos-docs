---
post_title: Logging
feature_maturity: preview
menu_order: 3.4
---

DC/OS cluster nodes generate logs that contain diagnostic and status information for DC/OS core components and DC/OS services.

## Service, Task, and Node Logs

The logging component provides an HTTP API (`/system/v1/logs/`), which exposes the system logs.

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

## System Logs

DC/OS components use `systemd-journald` to store their logs. To access the DC/OS core component logs, [SSH into a node][5] and run this command to see all logs:

```bash
journalctl -u "dcos-*" -b
```

You can view the logs for specific [components](/docs/1.9/overview/architecture/components/) by entering the component name. For example, to access Admin Router logs, run this command:

```bash
journalctl -u dcos-nginx -b
```

You can find which components are unhealthy in the DC/OS GUI from the **Nodes** tab.

![system health](/docs/1.9/img/ui-system-health-logging.png)

# Aggregation

Unfortunately, streaming logs from machines in your cluster isn’t always viable. Sometimes, you need the logs stored somewhere else as a history of what’s happened. This is where log aggregation really is required. Check out how to get it setup with some of the most common solutions:

- [ELK](/docs/1.9/monitoring/logging/aggregating/elk/)
- [Splunk](/docs/1.9/monitoring/logging/aggregating/splunk/)


[1]: /docs/1.9/monitoring/logging/quickstart/
[2]: /docs/1.9/cli/install/
[3]: /docs/1.9/monitoring/logging/aggregating/elk/
[4]: /docs/1.9/monitoring/logging/aggregating/splunk/
[5]: /docs/1.9/administering-clusters/sshcluster/
