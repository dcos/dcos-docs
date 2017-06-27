---
post_title: Node and Cluster Health Checks
menu_order: 1000
---

Node and cluster health checks provide information about your cluster, including available ports, Mesos agent status, and IP detect script validation. The checks are defined during installation in the config.yaml file and can be run by connecting to individual DC/OS nodes via SSH. 

## Cluster Checks
Cluster checks report the health status of the entire DC/OS cluster. Cluster checks are available across your cluster on all nodes. Common cluster checks include: 

- Is the Mesos leader is present? 
- Does ZooKeeper have quorum?
- Can a framework register with Mesos and run a task?

You can discover which cluster checks have been defined by SSHing to your cluster node and running this command: `dcos-diagnostics check cluster --list`.

## Node Checks
Node checks report the status of individual nodes after installation. Node checks can be run post-installation by connecting to an individual node via SSH. 

You can view which node checks have been defined by SSHing to your cluster node and running this command: `dcos-diagnostics check node-poststart --list`.

# Defining Custom Health Checks
Custom health checks must be defined before installation in the DC/OS installation configuration file. If you want to modify the configuration file after installation, you must follow the [DC/OS upgrade process](/docs/1.10/installing/upgrading/).

Define your custom health checks in the `custom_checks` configuration parameter. For a description of this parameter and examples, see the [configuration parameter documentation](/docs/1.10/installing/custom/configuration/configuration-parameters/#custom_checks).

# Running Health Checks
After you have defined custom health checks, you can run these commands from your cluster node.

**Prerequisites:**

- DC/OS is installed and you are logged in with superuser permission.


1.  [SSH to a cluster node](/docs/1.10/administering-clusters/sshcluster/).

    ```bash
    dcos node --master-proxy --mesos-id=<agent-node-id>
    ```
 
1.  Run this command to view the available health checks, with your check type (`<check-type>`) specified. The check type can be either cluster (`cluster`) or node (`node-poststart`).

    ```bash
    /opt/mesosphere/bin/dcos-shell dcos-diagnostics check <check-type> --list
    ```
    
    Your output should resemble:
    
    ```bash
    {
      "clock_sync": {
        "description": "System clock is in sync.",
        "full_cmd": [
          "/opt/mesosphere/bin/dcos-checks",
          "time"
        ],
        "timeout": "1s"
      },
      "components_agent": {
        "description": "All DC/OS components are healthy",
        "full_cmd": [
          "/opt/mesosphere/bin/dcos-checks",
          "--role",
          "agent",
          "--iam-config",
          "/run/dcos/etc/dcos-diagnostics/agent_service_account.json",
          "--force-tls",
          "--ca-cert=/run/dcos/pki/CA/ca-bundle.crt",
          "components",
          "--scheme",
          "https",
          "--port",
          "61002"
        ],
        "timeout": "3s"
      },
      ...
    ```
    
# Examples

## List all checks

List all cluster checks.

```
/opt/mesosphere/bin/dcos-shell dcos-diagnostics check cluster --list
```

List all node checks.

```bash
/opt/mesosphere/bin/dcos-shell dcos-diagnostics check node-poststart --list
```

## List specific checks

List specific cluster checks (`check1`).

```bash
/opt/mesosphere/bin/dcos-shell dcos-diagnostics check cluster --list check1 [check2 [...]]
```

List specific node checks (`check1`).

```bash
/opt/mesosphere/bin/dcos-shell dcos-diagnostics check node-poststart --list check1 [check2 [...]]
```

## Run all checks

Run cluster checks.

```bash
/opt/mesosphere/bin/dcos-shell dcos-diagnostics check cluster
```

Run node checks.

```bash
/opt/mesosphere/bin/dcos-shell dcos-diagnostics check node-poststart
```

## Run specific checks

Run specific cluster checks (`check1`).

```bash
dcos-diagnostics check cluster check1 [check2 [...]]
```

Run specific node checks (`check1`).

```bash
dcos-diagnostics check node-poststart check1 [check2 [...]]
```






