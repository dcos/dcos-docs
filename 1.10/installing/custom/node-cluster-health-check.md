---
post_title: Node and Cluster Health Checks
menu_order: 1000
---

Node and cluster health checks provide information about your cluster, including available ports, Mesos agent status, and IP detect script validation. A health check is a shell command that reports the status of a DC/OS cluster or node via its exit code. You can write your own custom health checks or use the predefined checks. 

# Predefined Health Checks
DC/OS includes a set of predefined builtin health checks for DC/OS core components. These builtin checks include:

- All DC/OS components are healthy.
- The XZ utility is available.
- The IP detect script produces valid output.
- The Mesos agent has registered with the masters.

# Custom Health Checks
Custom checks are checks written by a user and specified when installing DC/OS in the `config.yaml` file. Custom checks should be written for non-core DC/OS components. Health checks for DC/OS core components are included out-of-the-box as [predefined health checks](#predefined-health-checks). For example, you can write custom health checks for:

-  The DC/OS service is healthy
-  The local mounts on nodes are healthy 

## Creating Custom Health Checks
Custom health checks are binary files that you create and store on your filesystem. A custom health check must report its status as one of the exit codes shown in this table. 

| Code         | Status   | Description                                       |
|--------------|----------|---------------------------------------------------|
| 0            | OK       | Check passed. No investigation needed.            |
| 1            | WARNING  | Check passed, but investigation may be necessary. |
| 2            | CRITICAL | Check failed. Investigate if unexpected.          |
| 3 or greater | UNKNOWN  | Status cannot be determined. Investigate.         |

Optionally you can configure the checks to output a human-readable message to stderr or stdout.

## Specifying Custom Health Checks
Before installing DC/OS, you must specify custom health checks in the `custom_checks` installation configuration parameter. If you want to modify the configuration file after installation, you must follow the [DC/OS upgrade process](/docs/1.10/installing/upgrading/).

If it's an absolute path (e.g., if you have an executable in `/usr/bin/`), you can specify it directly in the `cmd`. If you reference an executable by name without an absolute path (e.g., `echo` instead of `/usr/bin/echo`), the system will look for it by using this search path, and use the first executable that it finds: `/opt/mesosphere/bin:/usr/bin:/bin:/sbin`. 

For a description of this parameter and examples, see the [configuration parameter documentation](/docs/1.10/installing/custom/configuration/configuration-parameters/#custom_checks).

# Types of Health Checks

### Cluster Checks
Cluster checks report the health status of the entire DC/OS cluster. Cluster checks are available across your cluster on all nodes. You can discover which cluster checks have been defined by SSHing to your cluster node and running this command: `/opt/mesosphere/bin/dcos-shell dcos-diagnostics check cluster --list`.

### Node Checks
Node checks report the status of individual nodes after installation. Node checks can be run post-installation by connecting to an individual node via SSH. You can view which node checks have been defined by SSHing to your cluster node and running this command: `/opt/mesosphere/bin/dcos-shell dcos-diagnostics check node-poststart --list`.





# Running Health Checks
You can run these commands from your cluster node to invoke custom or predefined health checks.

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
    
1.  Run checks with the check name (`<checkname>`) specified.

    ```bash
    /opt/mesosphere/bin/dcos-shell dcos-diagnostics check node-poststart <checkname>
    ```
    
    For example, to run the `component_agent` check.
    
    ```bash
    /opt/mesosphere/bin/dcos-shell dcos-diagnostics check node-poststart component_agent
    ```   
     
    The output should resemble:
    
    ```bash
    {
      “status”: 2,
      “checks”: {
        “component_agent”: {
          “status”: 2,
          “output”: “”
        },
        “exhibitor”: {
          “status”: 0,
          “output”: “”
        }
      }
    }
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






