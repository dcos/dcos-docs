---
post_title: Logging
menu_order: 3
---

DC/OS cluster nodes generate logs that contain diagnostic and status information for DC/OS core components and DC/OS services. There are two different types of logs in DC/OS. Each of them is managed differently.

## Service and Task Logs

If you're running a service on top of DC/OS, get started right away by running the CLI command listed below. For more in-depth documents on background and more methods of getting access to your logs, see [service and task logs][1].

```bash
$ dcos task log --follow my-service-name
```

Consult the [CLI installation documentation][2] if you’re not already running the CLI.

## System Logs

For most use cases, you are interested in the logs for unhealthy components. These can be found in the DC/OS UI under `System`.

![system health](img/ui-system-health-logging.gif)

You can also aggregate your system logs. Take a look at our [ELK][3] and [Splunk][4] tutorials for more information.

All the DC/OS components use journald to store their logs. [SSH into a node][5] abd run the following command see them:

```bash
$ journalctl -u "dcos-*" -b
```

## Next Steps

- [Service and Task logs][1]
- Log Aggregation

    - [ELK][3]
    - [Splunk][4]

[1]: service-logs/
[2]: /docs/1.7/usage/cli/install/
[3]: elk/
[4]: splunk/
[5]: ../sshcluster/
