---
post_title: Marathon Configuration Reference
menu_order: 000
---

This topic lists all available properties for Marathon application definitions and an example JSON application definition file with all properties shown.

- [Marathon Properties](#marathon-properties)
- [Example](#example)

# Marathon Properties

### acceptedResourceRoles
An array of resource roles. Marathon considers only resource offers with roles in this list for launching tasks of this app. For more information, see the [Mesos documentation](http://mesos.apache.org/documentation/latest/roles/).

### args
An array of strings that specifies the command to run. The `args` field may be used in place of `cmd` even when using the default command executor. 

**Important:** You must specify either [`cmd`](#cmd) or `args` in all app definitions. It is invalid to supply both `cmd` and `args` in the same app.

### backoffFactor
The multiplicand to apply to the `backoffSeconds` value. The default value is `1.15`. The `backoffSeconds` and `backoffFactor` values are multiplied until they reach the [`maxLaunchDelaySeconds`](#maxlaunchdelayseconds) value. After they reach that value, Marathon waits `maxLaunchDelaySeconds` before repeating this cycle exponentially. For example, if `backoffSeconds: 3`, `backoffFactor: 2`, and `maxLaunchDelaySeconds: 3600`, there will be ten attempts to launch a failed task, each three seconds apart. After these ten attempts, Marathon will wait 3600 seconds before repeating this cycle.

This prevents sandboxes associated with consecutively failing tasks from filling up the hard disk on Mesos slaves. This applies also to tasks that are killed due to failing too many health checks.

### backoffSeconds
The amount of time (in seconds) before Marathon retries launching a failed task. The default is `1`. The `backoffSeconds` and `backoffFactor` values are multiplied until they reach the `maxLaunchDelaySeconds` value. After they reach that value, Marathon waits `maxLaunchDelaySeconds` before repeating this cycle exponentially. For example, if `backoffSeconds: 3`, `backoffFactor: 2`, and `maxLaunchDelaySeconds: 3600`, there will be ten attempts to launch a failed task, each three seconds apart. After these ten attempts, Marathon will wait 3600 seconds before repeating this cycle.

This prevents sandboxes associated with consecutively failing tasks from filling up the hard disk on Mesos slaves. This applies also to tasks that are killed due to failing too many health checks.

### cmd
The command that is executed. This value is wrapped by Mesos via `/bin/sh -c ${app.cmd}`. 

**Important:** You must specify either `cmd` or [`args`](#args) in all app definitions. It is invalid to supply both `cmd` and `args` in the same app.

### constraints
Constraint operators that control where apps can run that allow you to optimize for either fault tolerance or locality. For more information, see the [Constraints documentation](https://mesosphere.github.io/marathon/docs/constraints.html).

### container
The container information. 

- **type** The containerizer runtime type, either `MESOS` or `DOCKER`. For more information, see [Using Containerizers](/docs/1.10/deploying-services/containerizers/).

- **portMappings** An array of port mappings between host and container. A port mapping is similar to passing `-p` into the Docker command line to specify a relationship between a port on the host machine and a port inside the container. If unspecified (null) at create time, defaults to { "portMappings": [ { "containerPort": 0, "name": "default" } ], ... }. Specify an empty array ([]) to indicate no ports are used by the app; no default is injected in this case.

  A port mapping consists of:

  - **containerPort** The container port (e.g., `8080`).
  - **hostPort** The host port (e.g., `0`). The default value is `0`. In [networking mode](#networks) `container`, the `hostPort` is not required, but if left unspecified Marathon will not randomly allocate a port. When using `container/bridge` mode, an unspecified (null) value for `hostPort` sets `hostPort: 0`. 
  - **servicePort** The service port (e.g., `9000`).
  - **protocol** The HTTP protocol, either `tcp` or `udp`.

  **Notes:**

  - Port mappings are used in conjunction with `container` and `container/bridge` [networking mode](#networks) and ignored when used in conjunction with `host` networking mode.
  - When used in conjunction with multiple `container` networks, each mapping entry that specifies a `hostPort` must also declare a `name` that identifies the network for which the mapping applies (a single `hostPort` may be mapped to only one container network, and `name` defaults to all container networks for a pod or app).
  - [`requirePorts`](#requirePorts) does not apply to `portMappings`.
  - Future versions of Marathon may fail to validate apps that declare `container.portMappings` with network modes other than `container` or `container/bridge`.

- **docker** The Docker container information.
    
    - **forcePullImage** Whether to pull the image, regardless if it is already available on the local system.
    - **image** The path to the Docker image.
    - **privileged** Whether to give extended privileges to this container. For more information, see the [Docker run command](https://docs.docker.com/engine/reference/commandline/run/).
      - `"privileged": false` Do not give extended privileges. This is the default value.
      - `"privileged": true` Give extended privileges. 
    - **parameters** Command-line options for the `docker run` command executed by the Mesos containerizer. Parameters passed in this manner are not guaranteed to be supported in the future, as Mesos may not always interact with Docker via the CLI.
    - **pullConfig** A secret whose value is a stringified JSON object in a Secret Store. See [Using a Private Docker Registry](/docs/1.10/deploying-services/private-docker-registry/#secret-store-instructions).
    
- **volumes** The volumes accessible to the container.
    - **containerPath** The path where your container will read and write data.
    - **external** An external persistent volume. See [External Persistent Volumes](/docs/1.10/storage/external-storage/).
        - **name** Name that your volume driver uses to look up the external volume.
        - **provider** The storage provider.
        - **options** Which Docker volume driver to use for storage. The only Docker volume driver supported by DC/OS is [REX-Ray](/docs/1.10/storage/external-storage/). 
        - **size** The size (in GiB) of the external persistent volume. 
    - **hostPath** The host path.
    - **mode** The access mode of the volume, either read-write (`RW`) or read-only (`RO`). 
    - **persistent** A local persistent volume. See [Local Persistent Volumes](/1.10/storage/persistent-volume/).
        - **size** The size (in MiB) of the local persistent volume. 
    
### cpus
The number of CPU shares per instance. A decimal fraction or integer.

### dependencies
A list of services upon which this application depends. The order to start, stop, and upgrade the application is derived from the dependencies. For example, suppose application `/a` relies on service `/b` which relies on `/c`. To start all 3 applications, first `/c` is started, then `/b` and `/a`.

### disk
The amount of disk space needed for the application. A decimal fraction or integer MB.

### env
Environment variables.

### executor
The executor used to launch the application. The default is `//cmd`, which takes the `cmd` and executes that on the shell level.

### fetch
An array of URIs to fetch. For more information, see the [Mesos Fetcher documentation](http://mesos.apache.org/documentation/latest/fetcher/).

A URI consists of:

- **uri** URI to be fetched by Mesos fetcher module.
- **executable** Set fetched artifact as executable.
- **extract** Extract fetched artifact if supported by Mesos fetcher module.
- **cache** Cache fetched artifact if supported by Mesos fetcher module.

### gpus
The number of GPU cores needed per instance.

### healthChecks
An array of checks that are run against an application’s tasks. Marathon health checks perform periodic checks on the containers distributed across a cluster to make sure they’re up and responding. For more information, see the [Health Checks documentation](/docs/1.10/deploying-services/creating-services/health-checks/).

A health check consists of:

- **gracePeriodSeconds** Specifies the amount of time (in seconds) to ignore health checks immediately after a task is started; or until the task becomes healthy for the first time.
- **intervalSeconds** Specifies the amount of time (in seconds) to wait between health checks.
- **maxConsecutiveFailures** Specifies the number of consecutive health check failures that can occur before a task is killed.
- **path** If `"protocol": "HTTP"`, this option specifies the path to the task health status endpoint. For example, `"/path/to/health"`.
- **portIndex** Specifies the port index in the ports array that is used for health requests. A port index allows the app to use any port, such as `"[0, 0, 0]"` and tasks could be started with port environment variables such as `$PORT1`.
- **protocol** Specifies the protocol of the requests: `HTTP`, `HTTPS`, `TCP`, or `Command`.
- **timeoutSeconds** Specifies the amount of time (in seconds) before a health check fails, regardless of the response.

### id
(Required) Unique identifier for the app consisting of a series of names separated by slashes. Each name must be at least 1 character and may only contain digits (0-9), dashes (-), dots (.), and lowercase letters (a-z). The name may not begin or end with a dash.

The allowable format is represented by the following regular expression:

```
^(([a-z0-9]|[a-z0-9][a-z0-9\\-]*[a-z0-9])\\.)*([a-z0-9]|[a-z0-9][a-z0-9\\-]*[a-z0-9])$
```

### instances
The number of instances of this application to start. You can change this number as needed to scale the application.

### labels
Metadata to expose additional information to other services. For example, you could label apps `"environment": "staging"` to mark services by their position in the pipeline.

### maxLaunchDelaySeconds
The maximum amount of time (in seconds) to wait, after applying the [`backoffSeconds`](#backoffseconds) and [`backoffFactor`](backofffactor) values, before attempting to restart failed tasks. The `backoffSeconds` and `backoffFactor` values are multiplied until they reach the `maxLaunchDelaySeconds` value. After they reach that value, Marathon waits `maxLaunchDelaySeconds` before repeating this cycle exponentially. For example, if `backoffSeconds: 3`, `backoffFactor: 2`, and `maxLaunchDelaySeconds: 3600`, there will be ten attempts to launch a failed task, each three seconds apart. After these ten attempts, Marathon will wait 3600 seconds before repeating this cycle.

This prevents sandboxes associated with consecutively failing tasks from filling up the hard disk on Mesos slaves. This applies also to tasks that are killed due to failing too many health checks.

### mem
The amount of memory (MB) required per instance.

### networks
An array of network definitions. An application can specify more than one network only when using the Universal Container Runtime (`MESOS`) [containerizer runtime](#container). Although Docker supports multiple networks per container, the Docker Engine containerizer runtime does not support multiple networks. 

A network definition consists of:

- **mode** Networking mode. Three modes of networking are supported: `host`, `container`, `container/bridge`. An application cannot mix networking modes: you must specify a single `host` network, a single `container/bridge` network, or one or more `container` networks.
- **name** Name of the network. Required when mode is `container`.
- **labels** See [labels](#labels).


### portDefinitions
An array of required port resources on the agent host. The number of items in the array determines how many dynamic ports are allocated for every task. For every port definition with port number zero, a globally unique (cluster-wide) service port is assigned and provided as part of the app definition to be used in load balancing definitions. For more information, see the [Networking documentation](/docs/1.10/networking/).

A port definition consists of:

- **port** An integer in the range 0, 65535.
- **name** Name of the service hosted on this port. If specified, it must be unique over all port definitions.
- **labels** Metadata to be interpreted by external applications such as firewalls.
- **protocol** The HTTP protocol, either `tcp` or `udp`.

Each port value is exposed to the instance via environment variables `$PORT0`, `$PORT1`, etc. Ports assigned to running instances are also available via the task resource.

Port definitions are used only with [`host`](#networks) networking mode. A port definition (specifically its port field) is interpreted through the lens of the [`requirePorts`](#requirePorts) field. When `requirePorts` is false (default), a port definition’s port is considered the service port and a host port is dynamically chosen by Marathon. When `requirePorts` is true, a port definition’s port is considered both a host port and service port.

The special port value of 0 tells Marathon to select any host port from a Mesos resource offer and any service port from the configured service port range.

**Notes:**

- Configure ports assignment for Docker containers in [`container.portMappings`](#container).
- If you use the [Universal Container Runtime](/docs/1.10/deploying-services/containerizers/ucr), pass zeros as port values to generate one or more arbitrary free ports for each application instance.

For more information, see [Containerizers](/docs/1.10/deploying-services/containerizers/).

### requirePorts
Whether the host ports of your tasks are automatically assigned. 

- `"requirePorts": false` Ports are automatically assigned. 
- `"requirePorts": true` Manually specify ports in advance. Marathon will only schedule the associated tasks on hosts that have the specified ports available. 

### residency
Set up a stateful application. For more information, see [local persistent volumes](/docs/1.10/storage/persistent-volume/).

- **taskLostBehavior** Indicates whether Marathon will launch the task on another node after receiving a `TASK_LOST` status update.

  - **WAIT_FOREVER** Do not relaunch the task after receiving a `TASK_LOST` status update. This setting is required to create a persistent volume. This is the default value.
  - **RELAUNCH_AFTER_TIMEOUT** Relaunch the task after receiving a `TASK_LOST` status update.

### taskKillGracePeriodSeconds
The amount of time (in seconds) between the executor sending SIGTERM to a task and then sending SIGKILL. 

### upgradeStrategy
The strategy that controls when Marathon stops old versions and launches new versions. During an upgrade all instances of an application are replaced by a new version. 

- **minimumHealthCapacity** The minimum percentage (expressed as a decimal fraction between `0.0` and `1.0`) of nodes that remain healthy during an upgrade. During an upgrade, Marathon ensures that this number of healthy instances are up. The default is `1.0`, which means no old instance can be stopped before another healthy new version is deployed. A value of `0.5` means that during an upgrade half of the old version instances are stopped first to make space for the new version. A value of `0` means take all instances down immediately and replace with the new application.
- **maximumOverCapacity** The maximum percentage (expressed as a decimal fraction between `0.0` and `1.0`) of new instances that can be launched at any point during an upgrade. The default value is `1`, which means that all old and new instances can exist during the upgrade process. A value of `0.1` means that during the upgrade process 10% more capacity than usual may be used for old and new instances. A value of `0.0` means that even during the upgrade process no more capacity may be used for the new instances than usual. Only when an old version is stopped, a new instance can be deployed.

If `"minimumHealthCapacity": 1` and `"maximumOverCapacity": 0`, at least one additional new instance is launched in the beginning of the upgrade process. When it is healthy, one of the old instances is stopped. After it is stopped, another new instance is started, and so on.

A combination of `"minimumHealthCapacity": 0.9` and `"maximumOverCapacity": 0` results in a rolling update, replacing 10% of the instances at a time, keeping at least 90% of the app online at any point of time during the upgrade.

A combination of `"minimumHealthCapacity": 1` and `"maximumOverCapacity": 0.1` results in a rolling update, replacing 10% of the instances at a time and keeping at least 100% of the app online at any point of time during the upgrade with 10% of additional capacity.

# Example

Here is an example JSON application definition that contains all fields.

```json
{
    "id": "/product/service/myApp",
    "cmd": "env && sleep 300",
    "cpus": 1.5,
    "mem": 256.0,
    "portDefinitions": [
        { "port": 8080, "protocol": "tcp", "name": "http", "labels": { "VIP_0": "10.0.0.1:80" } },
        { "port": 9000, "protocol": "tcp", "name": "admin" }
    ],
    "requirePorts": false,
    "instances": 3,
    "executor": "",
    "container": {
        "type": "DOCKER",
        "docker": {
            "image": "group/image",
            "privileged": false,
            "parameters": [
                { "key": "a-docker-option", "value": "xxx" },
                { "key": "b-docker-option", "value": "yyy" }
            ]
        },
        "portMappings": [
            {
                "containerPort": 8080,
                "hostPort": 0,
                "servicePort": 9000,
                "protocol": "tcp"
            },
            {
                "containerPort": 161,
                "hostPort": 0,
                "protocol": "udp"
            }
        ],
        "volumes": [
            {
                "containerPath": "data",
                "hostPath": "mydata",
                "mode": "RO",
                "persistent": {
                    "size": 10
                }
            },
            {
                "containerPath": "test-rexray-volume",
                "external": {
                  "size": 100,
                  "name": "my-test-vol",
                  "provider": "dvdi",
                  "options": { "dvdi/driver": "rexray" }
                  },
                "mode": "RW"
              }
        ]
    },
    "residency": {
        "taskLostBehavior": "WAIT_FOREVER"
        },
    "env": {
        "LD_LIBRARY_PATH": "/usr/local/lib/myLib"
    },
    "constraints": [
        ["attribute", "$OPERATOR", "value"]
    ],
    "acceptedResourceRoles": [
        "role1", "*"
    ],
    "labels": {
        "environment": "staging"
    },
    "fetch": [
        { "uri": "https://raw.github.com/mesosphere/marathon/master/README.md" },
        { "uri": "https://foo.com/archive.zip", "executable": false, "extract": true, "cache": true }
    ],
    "dependencies": ["/product/db/mongo", "/product/db", "../../db"],
    "healthChecks": [
        {
            "protocol": "HTTP",
            "path": "/health",
            "gracePeriodSeconds": 3,
            "intervalSeconds": 10,
            "portIndex": 0,
            "timeoutSeconds": 10,
            "maxConsecutiveFailures": 3
        },
        {
            "protocol": "HTTPS",
            "path": "/machinehealth",
            "gracePeriodSeconds": 3,
            "intervalSeconds": 10,
            "port": 3333,
            "timeoutSeconds": 10,
            "maxConsecutiveFailures": 3
        },
        {
            "protocol": "TCP",
            "gracePeriodSeconds": 3,
            "intervalSeconds": 5,
            "portIndex": 1,
            "timeoutSeconds": 5,
            "maxConsecutiveFailures": 3
        },
        {
            "protocol": "COMMAND",
            "command": { "value": "curl -f -X GET http://$HOST:$PORT0/health" },
            "maxConsecutiveFailures": 3
        }
    ],
    "backoffSeconds": 1,
    "backoffFactor": 1.15,
    "maxLaunchDelaySeconds": 3600,
    "taskKillGracePeriodSeconds": 2,
    "upgradeStrategy": {
        "minimumHealthCapacity": 0.5,
        "maximumOverCapacity": 0.2
    },
    "networks": [
      { "mode": "container/bridge" }
  ]
}
```
