---
post_title: Quick Start
menu_order: 0
feature_maturity: experimental
---

Use this guide to get started with the DC/OS metrics component. 

**Prerequisites:** 

- At least one [DC/OS service](/docs/1.9/usage/marathon/application-basics/) is deployed.
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
        $ dcos marathon app add test-metrics.json
        ```
        
1.  [SSH to the agent node](/1.9/administration/access-node/sshcluster/) that is running your app, where (`--mesos-id=<mesos-id>`) is the Mesos ID of the node running your app.

    ```
    $ dcos node ssh --master-proxy --mesos-id=<mesos-id>
    ```
    
    **Tip:** To get the Mesos ID of the node that is running your app, run `dcos task` followed by `dcos node`. For example:
    
    1.  Running `dcos task` shows that host `10.0.0.193` is running the Marathon task `test-metrics.93fffc0c-fddf-11e6-9080-f60c51db292b`.
    
        ```bash
        $ dcos task
        NAME          HOST        USER  STATE  ID                                                  
        test-metrics  10.0.0.193  root    R    test-metrics.93fffc0c-fddf-11e6-9080-f60c51db292b  
        ```
    
    1.  Running `dcos node` shows that host `10.0.0.193` has the Mesos ID `7749eada-4974-44f3-aad9-42e2fc6aedaf-S1`.
    
        ```bash
        $ dcos node
         HOSTNAME       IP                         ID                    
        10.0.0.193  10.0.0.193  7749eada-4974-44f3-aad9-42e2fc6aedaf-S1  
        ```

1.  View metrics.         

1.  View metrics. 

    -   **Metrics for all containers running on a host**

        To show all containers that are deployed on the agent node, run this command from your agent node. 
        
        ```bash
        $ curl -s http://localhost:61001/system/v1/metrics/v0/containers | jq
        ```
    
        The output should resemble this:
        
        ```json
        ["121f82df-b0a0-424c-aa4b-81626fb2e369","87b10e5e-6d2e-499e-ae30-1692980e669a"]
        ```

    -   **<a name="container-metrics"></a>Metrics for a specific container**
        
        To view the metrics for a specific container, run this command from your agent node container ID (`<container-id>`) specified. 
    
        ```bash
        $ curl -s http://localhost:61001/system/v1/metrics/v0/containers/<container-id>/app | jq
        ```

        The output should resemble:
        
        ```json
        {
          "datapoints": [
            {
              "name": "dcos.metrics.module.container_received_bytes_per_sec",
              "value": 0,
              "unit": "",
              "timestamp": "2016-12-15T18:12:24Z"
            },
            {
              "name": "dcos.metrics.module.container_throttled_bytes_per_sec",
              "value": 0,
              "unit": "",
              "timestamp": "2016-12-15T18:12:24Z"
            }
          ],
          "dimensions": {
            "mesos_id": "",
            "container_id": "d41ae47f-c190-4072-abe7-24d3468d40f6",
            "executor_id": "test-metrics.e3a1fe9e-c2f1-11e6-b94b-2e2d1faf2a70",
            "framework_id": "fd39fe4f-930a-4b89-bb3b-a392e518c9a5-0001",
            "hostname": ""
          }
        }
        ```
    
    -   **<a name="container-metrics"></a>Metrics from container-level cgroup allocations**
 
        To view cgroup allocations, run this command from your agent node with your container ID (`<container-id>`) specified.
      
        ```bash
        $ curl -s http://localhost:61001/system/v1/metrics/v0/containers/<container-id> | jq
        ```
    
        The output will contain a `datapoints` array that contains information about container resource allocation and utilization provided by Mesos. For example:
    
        ```json
        {
          "datapoints": [
            {
              "name": "cpus_system_time_secs",
              "value": 0.68,
              "unit": "",
              "timestamp": "2016-12-13T23:15:19Z"
            },
            {
              "name": "cpus_limit",
              "value": 1.1,
              "unit": "",
              "timestamp": "2016-12-13T23:15:19Z"
            },
            {
              "name": "cpus_throttled_time_secs",
              "value": 23.12437475,
              "unit": "",
              "timestamp": "2016-12-13T23:15:19Z"
            },
            {
              "name": "mem_total_bytes",
              "value": 327262208,
              "unit": "",
              "timestamp": "2016-12-13T23:15:19Z"
            },
        ```
    
        The output will also contain an object named `dimensions` that contains metadata about the `cluster/node/app`.
            
        ```json
        ...
        "dimensions": {
            "mesos_id": "a29070cd-2583-4c1a-969a-3e07d77ee665-S0",
            "container_id": "6972ad7c-1701-4970-ae14-4372f76eda37",
            "executor_id": "confluent-kafka.7aff271b-c182-11e6-a88f-22e5385a5fd7",
            "framework_name": "marathon",
            "framework_id": "a29070cd-2583-4c1a-969a-3e07d77ee665-0001",
            "framework_role": "slave_public",
            "hostname": "",
            "labels": {
              "DCOS_MIGRATION_API_PATH": "/v1/plan",
              "DCOS_MIGRATION_API_VERSION": "v1",
              "DCOS_PACKAGE_COMMAND": "eyJwaXAiOlsiaHR0cHM6Ly9kb3dubG9hZHMubWVzb3NwaGVyZS5jb20va2Fma2EvYX...
              "DCOS_PACKAGE_FRAMEWORK_NAME": "confluent-kafka",
              "DCOS_PACKAGE_IS_FRAMEWORK": "true",
              "DCOS_PACKAGE_METADATA": "eyJwYWNrYWdpbmdWZXJzaW9uIjoiMy4wIi...
              "DCOS_PACKAGE_NAME": "confluent-kafka",
              "DCOS_PACKAGE_REGISTRY_VERSION": "3.0",
              "DCOS_PACKAGE_RELEASE": "10",
              "DCOS_PACKAGE_SOURCE": "https://universe.mesosphere.com/repo",
              "DCOS_PACKAGE_VERSION": "1.1.16-3.1.1",
              "DCOS_SERVICE_NAME": "confluent-kafka",
              "DCOS_SERVICE_PORT_INDEX": "1",
              "DCOS_SERVICE_SCHEME": "http",
              "MARATHON_SINGLE_INSTANCE_APP": "true"
            }
          }
        }       
        ...
        ```

    -   **<a name="host-metrics"></a>Host level metrics**

        To view host-level metrics, run this command from your agent node with your authentication token (`<auth-token>`) specified:

        ```bash
        $ curl -s http://localhost:61001/system/v1/metrics/v0/node | jq
        ```
        
        The output will contain a `datapoints` array about resource allocation and utilization. For example:
        
        ```json
        ...
        "datapoints": [
            {
              "name": "uptime",
              "value": 23631,
              "unit": "",
              "timestamp": "2016-12-14T01:00:19Z"
            },
            {
              "name": "processes",
              "value": 209,
              "unit": "",
              "timestamp": "2016-12-14T01:00:19Z"
            },
            {
              "name": "cpu.cores",
              "value": 4,
              "unit": "",
              "timestamp": "2016-12-14T01:00:19Z"
            }
        ...    
        ```
        
        The output will contain an object named `dimensions` that contains metadata about the cluster and node. For example:
        
        ```json
        ...
        "dimensions": {
            "mesos_id": "a29070cd-2583-4c1a-969a-3e07d77ee665-S0",
            "hostname": "10.0.2.255"
          }
        ...  
        ```