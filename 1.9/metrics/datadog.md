---
post_title: Datadog Metrics for DC/OS
feature_maturity: preview
menu_order: 3.5
---

The Datadog metrics plugin for DC/OS supports sending metrics from the DC/OS metrics service on master and agent hosts to a Datadog agent for shipping to DatadogHQ.

# Installation

## Build the plugin

**Prerequisite:** 

- DC/OS is [installed](/docs/1.9/installing/)
- [Go programming environment](https://golang.org/doc/install) <!-- dcos-metrics must be run from within the go directory -->
-  Git:
   -  **macOS:** Get the installer from [Git downloads](http://git-scm.com/download/mac).
   -  **Unix/Linux:** See these <a href="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git" target="_blank">installation instructions</a>.

1. Clone the DC/OS metrics repository:

   ```bash
   git clone git@github.com:dcos/dcos-metrics
   ```
   
1. Navigate to the `dcos-metrics` repository and run the build command:

   ```bash
   cd dcos-metrics && make && make plugins
   ```

   The plugin is available in the build directory:

   ```
   tree build
   build
   ├── collector
   │   └── dcos-metrics-collector-1.0.0-rc7
   ├── plugins
   │   └── dcos-metrics-datadog_plugin-1.0.0-rc7
   └── statsd-emitter
       └── dcos-metrics-statsd-emitter-1.0.0-rc7
   ```

## Install the Datadog agent in your DC/OS cluster

Install the `datadog` package in DC/OS:

1.  Go to the **Universe** tab of the DC/OS GUI and find the **Datadog** package. 
    ![datadog package](/docs/1.9/img/datadog-package.png)
1.  Click **INSTALL PACKAGE** -> **ADVANCED INSTALLATION** and enter [your Datadog API_KEY](https://app.datadoghq.com/account/settings#api).
1.  Click **REVIEW AND INSTALL** to complete your installation.

After a few minutes, a Datadog agent will be running in the cluster at the default location used by the Datadog plugin: `datadog-agent.marathon.mesos:8125`.

## Test the DC/OS Datadog metrics plugin (agents only)
As a stopgap during testing, you may be able to manually run the Datadog plugin on your agents by running it as a Marathon task. You must first upload your binary to a web server that's visible to your cluster, then create a Marathon application like the following (with customized `cmd`, `instances`, and `uris` to meet your needs):

```json
{
  "cmd": "chmod +x ./dcos-metrics-* && ./dcos-metrics-* -dcos-role agent -auth-token <CONTENT OF 'dcos config show core.dcos_acs_token'>",
  "instances": <number-of-agents>,
  "uris": [ "https://YOURFILEHOST.COM/dcos-metrics-datadog_plugin-YOURBUILDVERSION" ],
  "id": "test-datadog-plugin",
  "cpus": 0.1,
  "mem": 128,
  "disk": 0,
  "acceptedResourceRoles": [ "slave_public", "*" ]
}
```

## Install the DC/OS Datadog metrics plugin
When you're happy with the test results, you'll need to install the plugin into your cluster. For each host in your cluster, transfer your binary for the plugin and then add a systemd unit to manage the service. This unit differs slightly between agent and master hosts.

### Create a Valid Auth Token for DC/OS
Follow the instructions based on whether you are using Enterprise or open source DC/OS:

- [Enterprise DC/OS](https://docs.mesosphere.com/1.9/security/service-auth/custom-service-auth/)
- [Open source DC/OS](https://dcos.io/docs/administration/id-and-access-mgt/managing-authentication/) 

You will use this auth token below.

### Deploy the Metrics Plugin to Every Cluster Host

1.  Copy the Datadog plugin from a local host to your remote host (`my.host:/usr/bin`):

    ```bash
    scp dcos-metrics-datadog-plugin-1.0.0-rc7 my.host:/usr/bin
    ```
    
    
1.  [SSH to your master node](/docs/1.9/administering-clusters/sshcluster/) and assign permissions to the plugin. 

    ```bash
    dcos node ssh --master-proxy --leader
    chmod 0755 /usr/bin/dcos-metrics-datadog-plugin-1.0.0-rc7
    ```

### Master Systemd Unit
Create a master systemd unit file on your master node and save as `/etc/systemd/system/dcos-metrics-datadog-plugin.service`. 

```
[Unit]
Description=DC/OS Datadog Metrics Plugin (master)

[Service]
ExecStart=/usr/bin/dcos-metrics-datadog-plugin-1.0.0rc7 -dcos-role master -metrics-port 80 -auth-token <MY_AUTH_TOKEN>
```

### Agent Systemd Unit
Add an agent systemd unit file on your master node and save as `/etc/systemd/system/dcos-metrics-datadog-plugin.service`.

```
[Unit]
Description=DC/OS Datadog Metrics Plugin (agent)

[Service]
ExecStart=/usr/bin/dcos-metrics-datadog-plugin-1.0.0rc7 -dcos-role agent -auth-token <MY_AUTH_TOKEN>
```

*Note:* This plugin runs on the agent Admin Router port `:61001` by default, so the port is not passed as it was in the master version of the service.

### Enable, Start, and Verify

1.  Enable and start the Datadog plugin.

    ```bash
    systemctl enable dcos-metrics-datadog-plugin && systemctl start dcos-metrics-datadog-plugin
    ```
    
1.  View the system logs and verify that everything is okay.
    
    ```bash
    journalctl -u dcos-metrics-datadog-plugin
    ```

You're done!