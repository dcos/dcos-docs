---
post_title: Logging
menu_order: 3
---

DC/OS cluster nodes generate logs that contain diagnostic and status information for DC/OS core components and DC/OS services. There are a couple different types of logs in DC/OS and each of them is managed differently.

## Service and Task Logs

If you're running something on top of DC/OS, then let's get started right away by running the CLI command listed below. For more in depth documents on background and more methods of getting access to your logs, check out [service and task logs][1].

```bash
$ dcos task log --follow my-service-name
```

Take a look at the [CLI installation documentation][2] if you’re not already running the CLI.

## System Logs

For most use cases, you’re normally interested in the logs for unhealthy components. These can be found in the DC/OS UI under `System`.

![DC/OS Components](assets/components.png "DC/OS Components") FIXME

As you can imagine, it is also possible to aggregate your system logs. Take a look at our [ELK][3] and [Splunk][4] tutorials if you're interested.

All the DC/OS components use journald to store their logs. If you'd like to [SSH into a node][5], you'll be able to see them by running the following command:

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
