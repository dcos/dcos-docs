---
post_title: Listing Nodes
menu_order: 13
---

You can view of all of the nodes that are used across your cluster by using the CLI or UI.

-   From the CLI, enter this command to print a high-level list of nodes:

    ```bash
    $ dcos node 
    ```
    
    The output will look like this:
    
    ```bash
     HOSTNAME      IP                        ID                    
     10.0.2.3   10.0.2.3  f446856d-30d0-4991-8ff8-59ea9b06c6f5-S2  
     10.0.2.4   10.0.2.4  f446856d-30d0-4991-8ff8-59ea9b06c6f5-S0  
     10.0.2.5   10.0.2.5  f446856d-30d0-4991-8ff8-59ea9b06c6f5-S1  
     10.0.5.98  10.0.5.98  f446856d-30d0-4991-8ff8-59ea9b06c6f5-S3
    ```
    
    **Tip:** You can use the `dcos node --json` option to print a detailed JSON-formatted list of nodes. Details include ports, hostnames, roles, and running tasks. For example:
    
    ```bash
    [
      {
        "TASK_ERROR": 0,
        "TASK_FAILED": 0,
        "TASK_FINISHED": 0,
        "TASK_KILLED": 0,
        "TASK_KILLING": 0,
        "TASK_LOST": 0,
        "TASK_RUNNING": 0,
        "TASK_STAGING": 0,
        "TASK_STARTING": 0,
        "active": true,
        "attributes": {
          "public_ip": "true"
        },
        "framework_ids": [],
        "hostname": "10.0.5.98",
        "id": "f446856d-30d0-4991-8ff8-59ea9b06c6f5-S3",
        "offered_resources": {
          "cpus": 0.0,
          "disk": 0.0,
          "mem": 0.0
        },
        "pid": "slave(1)@10.0.5.98:5051",
        "registered_time": 1466616121.93364,
        "reserved_resources": {
          "slave_public": {
            "cpus": 4.0,
            "disk": 0.0,
            "mem": 14019.0,
            "ports": "[1-21, 23-5050, 5052-32000]"
          }
    ...
    ```

-   From the [UI](/docs/1.9/usage/webinterface/) you can click on **Nodes** to view of all of the nodes that are used across your cluster.


