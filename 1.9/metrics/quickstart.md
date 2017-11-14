---
post_title: Metrics Quick Start
nav_title: Quick Start
menu_order: 0
feature_maturity: preview
---

Use this guide to get started with the DC/OS metrics component. 

**Prerequisites:** 

- At least one [DC/OS service](/docs/1.9/deploying-services/creating-services/) is deployed.
- Optional: the CLI JSON processor [jq](https://github.com/stedolan/jq/wiki/Installation).

The metrics component is natively integrated with DC/OS and no additional setup is required.  

1.  Optional: Deploy a sample Marathon app for use in this quick start guide. If you already have tasks running on DC/OS, you can skip this setup step.

    1.  Create the following Marathon app definition and save as `test-metrics.json`. 
        
        ```json
        {
          "id": "/test-metrics",
          "cmd": "while true;do echo stdout;echo stderr >&2;sleep 1;done",
          "cpus": 0.001,
          "instances": 1,
          "mem": 128
        }
        ```
    
    1.  Deploy the app with this CLI command:
        
        ```bash
        dcos marathon app add test-metrics.json
        ```
        
1.  [SSH to the agent node](/docs/1.9/administering-clusters/sshcluster/) that is running your app, where (`--mesos-id=<mesos-id>`) is the Mesos ID of the node running your app.

    ```
    dcos node ssh --master-proxy --mesos-id=<mesos-id>
    ```
    
    **Tip:** To get the Mesos ID of the node that is running your app, run `dcos task` followed by `dcos node`. For example:
    
    1.  Running `dcos task` shows that host `10.0.0.193` is running the Marathon task `test-metrics.93fffc0c-fddf-11e6-9080-f60c51db292b`.
    
        ```bash
        dcos task
        NAME          HOST        USER  STATE  ID                                                  
        test-metrics  10.0.0.193  root    R    test-metrics.93fffc0c-fddf-11e6-9080-f60c51db292b  
        ```
    
    1.  Running `dcos node` shows that host `10.0.0.193` has the Mesos ID `7749eada-4974-44f3-aad9-42e2fc6aedaf-S1`.
    
        ```bash
        dcos node
         HOSTNAME       IP                         ID                    
        10.0.0.193  10.0.0.193  7749eada-4974-44f3-aad9-42e2fc6aedaf-S1  
        ```
        
1.  View metrics. 

    -   **Metrics for all containers running on a host**

        To show all containers that are deployed on the agent node, run this command from your agent node. 
        
        ```bash
        curl -s http://localhost:61001/system/v1/metrics/v0/containers | jq
        ```
    
        The output should resemble this:
        
        ```json
        ["28dfb041-42bb-4064-bd4f-bd56c472eb1e","d46f5b51-2adb-4978-bf8a-2a4a85103ab6"]
        ```

    -   **<a name="container-metrics"></a>Metrics for a specific container**
        
        To view the metrics for a specific container, run this command from your agent node with the container ID (`<container-id>`) specified. 
    
        ```bash
        curl -s http://localhost:61001/system/v1/metrics/v0/containers/<container-id>/app | jq
        ```

        The output should resemble:
        
        ```json
        {
          "datapoints": [
            {
              "name": "dcos.metrics.module.container_received_bytes_per_sec",
              "value": 0,
              "unit": "",
              "timestamp": "2017-11-14T18:26:50Z"
            },
            {
              "name": "dcos.metrics.module.container_throttled_bytes_per_sec",
              "value": 0,
              "unit": "",
              "timestamp": "2017-11-14T18:26:50Z"
            }
          ],
          "dimensions": {
            "mesos_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-S1",
            "cluster_id": "411bea44-f30a-42f7-be22-b4426dce0163",
            "container_id": "28dfb041-42bb-4064-bd4f-bd56c472eb1e",
            "executor_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
            "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
            "task_name": "test-metrics",
            "task_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
            "hostname": "10.0.1.22"
          }
        }
        ```
    
    -   **<a name="container-metrics"></a>Metrics for container-level cgroup allocations**
 
        To view cgroup allocations, run this command from your agent node with the container ID (`<container-id>`) specified.
      
        ```bash
        curl -s http://localhost:61001/system/v1/metrics/v0/containers/<container-id> | jq
        ```
    
        The output will contain a `datapoints` array that contains information about container resource allocation and utilization provided by Mesos. For example:
    
        ```json
        {
          "datapoints": [
            {
              "name": "net.tx.errors",
              "value": 0,
              "unit": "count",
              "timestamp": "2017-11-14T18:23:44.463276715Z",
              "tags": {
                "container_id": "28dfb041-42bb-4064-bd4f-bd56c472eb1e",
                "executor_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
                "executor_name": "Command Executor (Task: test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c) (Command: sh -c 'while true;d...')",
                "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
                "source": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c"
              }
            },
            {
              "name": "net.tx.bytes",
              "value": 0,
              "unit": "bytes",
              "timestamp": "2017-11-14T18:23:44.463276715Z",
              "tags": {
                "container_id": "28dfb041-42bb-4064-bd4f-bd56c472eb1e",
                "executor_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
                "executor_name": "Command Executor (Task: test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c) (Command: sh -c 'while true;d...')",
                "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
                "source": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c"
              }
            },
            {
              "name": "disk.limit",
              "value": 0,
              "unit": "bytes",
              "timestamp": "2017-11-14T18:23:44.463276715Z",
              "tags": {
                "container_id": "28dfb041-42bb-4064-bd4f-bd56c472eb1e",
                "executor_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
                "executor_name": "Command Executor (Task: test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c) (Command: sh -c 'while true;d...')",
                "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
                "source": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c"
              }
            },
            ...
            },
            {
              "name": "cpus.limit",
              "value": 0.101,
              "unit": "count",
              "timestamp": "2017-11-14T18:23:44.463276715Z",
              "tags": {
                "container_id": "28dfb041-42bb-4064-bd4f-bd56c472eb1e",
                "executor_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
                "executor_name": "Command Executor (Task: test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c) (Command: sh -c 'while true;d...')",
                "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
                "source": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c"
              }
            }
          ],
        ...
        }
        ```
    
        The output will also contain an object named `dimensions` that contains metadata about the `cluster/node/app`.
            
        ```json
        ...
        "dimensions": {
          "mesos_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-S1",
          "cluster_id": "411bea44-f30a-42f7-be22-b4426dce0163",
          "container_id": "28dfb041-42bb-4064-bd4f-bd56c472eb1e",
          "executor_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
          "framework_name": "marathon",
          "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
          "framework_role": "slave_public",
          "framework_principal": "dcos_marathon",
          "task_name": "test-metrics",
          "task_id": "test-metrics.ce1b8027-c968-11e7-865b-1a388d16765c",
          "hostname": "10.0.1.22"
        }
        ...
        ```
        
        If you run a Universe package such as Spark, the `dimensions` will have information about the package in the `labels`:
        
        ```json
          ...
          "dimensions": {
            "mesos_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-S1",
            "cluster_id": "411bea44-f30a-42f7-be22-b4426dce0163",
            "container_id": "d46f5b51-2adb-4978-bf8a-2a4a85103ab6",
            "executor_id": "spark.ffe8a5d8-c96b-11e7-865b-1a388d16765c",
            "framework_name": "marathon",
            "framework_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-0001",
            "framework_role": "slave_public",
            "framework_principal": "dcos_marathon",
            "task_name": "spark",
            "task_id": "spark.ffe8a5d8-c96b-11e7-865b-1a388d16765c",
            "hostname": "10.0.1.22",
            "labels": {
              "DCOS_PACKAGE_FRAMEWORK_NAME": "spark",
              "DCOS_PACKAGE_NAME": "spark",
              "DCOS_PACKAGE_SOURCE": "https://universe.mesosphere.com/repo",
              "DCOS_PACKAGE_VERSION": "2.1.0-2.2.0-1",
              "DCOS_SERVICE_NAME": "spark",
              "DCOS_SERVICE_PORT_INDEX": "2",
              "DCOS_SERVICE_SCHEME": "http",
              "SPARK_URI": ""
            }
          }
          ...
        ```

    -   **<a name="host-metrics"></a>Node level metrics**

        To view node-level metrics, run this command from your agent node:

        ```bash
        curl -s http://localhost:61001/system/v1/metrics/v0/node | jq
        ```
        
        The output will contain a `datapoints` array about node resource allocation and utilization. For example:
        
        ```json
        ...
        {
          "datapoints": [
            {
              "name": "filesystem.inode.free",
              "value": 38436612,
              "unit": "count",
              "timestamp": "2017-11-14T18:32:44.488816719Z",
              "tags": {
                "path": "/"
              }
            },
            {
              "name": "memory.cached",
              "value": 1885151232,
              "unit": "bytes",
              "timestamp": "2017-11-14T18:32:44.489104374Z"
            },
            {
              "name": "network.in.dropped",
              "value": 0,
              "unit": "count",
              "timestamp": "2017-11-14T18:32:44.489286319Z",
              "tags": {
                "interface": "docker0"
              }
            },
            {
              "name": "filesystem.inode.total",
              "value": 32768,
              "unit": "count",
              "timestamp": "2017-11-14T18:32:44.488816719Z",
              "tags": {
                "path": "/usr/share/oem"
              }
            },
            ...
            {
              "name": "cpu.system",
              "value": 0.09,
              "unit": "percent",
              "timestamp": "2017-11-14T18:32:44.488494518Z"
            },
            {
              "name": "swap.total",
              "value": 0,
              "unit": "bytes",
              "timestamp": "2017-11-14T18:32:44.489104374Z"
            },
            {
              "name": "load.5min",
              "value": 0.02,
              "unit": "count",
              "timestamp": "2017-11-14T18:32:44.488791828Z"
            },
            {
              "name": "filesystem.inode.used",
              "value": 68220,
              "unit": "count",
              "timestamp": "2017-11-14T18:32:44.488816719Z",
              "tags": {
                "path": "/var/lib/docker/overlay"
              }
            }
          ],
        ...
        } 
        ```
        
        The output will contain an object named `dimensions` that contains metadata about the cluster and node. For example:
        
        ```json
        ...
        "dimensions": {
          "mesos_id": "41932554-feb2-43b3-b5b8-1f61aaa308c1-S1",
          "cluster_id": "411bea44-f30a-42f7-be22-b4426dce0163",
          "hostname": "10.0.1.22"
        }
        ...  
        ```
