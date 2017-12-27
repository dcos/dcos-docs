---
post_title: Sending DC/OS Metrics to Datadog
feature_maturity: preview
menu_order: 3.5
---

The Datadog metrics standalone plugin supports sending metrics from the DC/OS metrics service directly to [DatadogHQ](https://www.datadoghq.com/). The plugin includes the function of the Datadog agent. You must install a plugin on each node in your cluster. This plugin works with DC/OS 1.9.4 and higher.

**Prerequisite:**

- DC/OS is [installed](/docs/1.9/installing/)

# Install the DC/OS Datadog standalone metrics plugin

For each node in your cluster, transfer your plugin binary and then add a systemd unit to manage the service. This unit differs slightly between master and agent nodes.

1. On every node in your cluster:

   1. Download the _latest_ Datadog _standalone_ plugin binary, `dcos-metrics-datadog-standalone-plugin_1.<x>.<y>`, from the [releases](https://github.com/dcos/dcos-metrics/releases) page.
   1. Rename the plugin to `dcos-metrics-datadog-standalone-plugin` and move to `/opt/mesosphere/bin`.
   1. Assign permissions to the plugin: `chmod 0755 /opt/mesosphere/bin/dcos-metrics-datadog-standalone-plugin`.

1.  On every master node:
    1. Create the master systemd service file in `/etc/systemd/system/dcos-metrics-datadog-master.service`. Fill in your [Datadog API key](https://app.datadoghq.com/account/settings#api) and set the `-config` option based on whether you are running DC/OS Enterprise or DC/OS open source.

        ```
        [Unit]
        Description=DC/OS Datadog Standalone Metrics Plugin (master)

        [Service]
        ExecStart=/opt/mesosphere/bin/dcos-metrics-datadog-standalone-plugin -dcos-role master -datadog-key  <Datadog_API_key> -metrics-port 80 -config [/opt/mesosphere/etc/dcos-metrics-config-ee.yaml | /opt/mesosphere/etc/dcos-metrics-config.yaml]
        ```

    2. Reload the systemd state by running `sudo systemctl daemon-reload`.
    3. Start the systemd service with `sudo systemctl start dcos-metrics-datadog-master`.
    4. View the system logs and verify the plugin is running with `sudo journalctl -u dcos-metrics-datadog-master`.

1.  On every agent node:
    1. Create the agent systemd service file in `/etc/systemd/system/dcos-metrics-datadog-agent.service`. Fill in your [Datadog API key](https://app.datadoghq.com/account/settings#api) and set the `-config` option based on whether you are running DC/OS Enterprise or DC/OS open source.

        ```
        [Unit]
        Description=DC/OS Datadog Standalone Metrics Plugin (agent)

        [Service]
        ExecStart=/opt/mesosphere/bin/dcos-metrics-datadog-standalone-plugin -dcos-role agent -datadog-key  <Datadog_API_key> -config [/opt/mesosphere/etc/dcos-metrics-config-ee.yaml | /opt/mesosphere/etc/dcos-metrics-config.yaml]
        ```

    2. Reload the systemd state by running `sudo systemctl daemon-reload`.
    3. Start the systemd service with `sudo systemctl start dcos-metrics-datadog-agent`.
    4. View the system logs and verify the plugin is running with `sudo journalctl -u dcos-metrics-datadog-agent`.
