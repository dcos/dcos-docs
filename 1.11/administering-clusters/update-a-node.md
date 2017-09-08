---
post_title: Updating Nodes
menu_order: 801
---

You can update agent nodes in an active DC/OS cluster by using maintenance windows or by manually killing agents. Maintenance windows are the preferred method since this is generally more stable and less error prone.

These steps are useful if you are downsizing a cluster, reconfiguring agent nodes, or moving a node to a new IP. When you change Mesos attributes (`⁠⁠⁠⁠/var/lib/dcos/mesos-slave-common`⁠⁠⁠⁠) or resources (⁠⁠⁠⁠`/var/lib/dcos/mesos-resources`⁠⁠⁠⁠), you must remove the agent node and re-register it with the master node under a new UUID. The master will then recognize the new attributes and resources specification.

**Warning:** ⁠⁠⁠All tasks that are running on the agent will be killed because you are changing agent attributes or resources. Mesos treats a re-registered agent as a new agent.

### Prerequisites:

*   [SSH installed and configured](/docs/1.10/administering-clusters/sshcluster/). This is required when removing nodes by manually killing agents.
*   Access to the [Admin Router permissions](/docs/1.10/overview/architecture/components/#admin-router).

# Updating nodes by using maintenance windows
With maintenance windows you can drain multiple nodes at the same time from outside the cluster. SSH access is not required.

You can define a maintenance schedule to evacuate your tasks prior to changing agent attributes or resources. 

1.  Define a maintenance schedule. For example, here is a basic maintenance schedule JSON file with the example machines  (`machine_ids`) and maintenance window (`unavailability`) specified:
    
    ```json
    {
      "windows" : [
        {
          "machine_ids" : [
            { "hostname" : "10.0.2.107", "ip" : "10.0.2.107" },
            { "hostname" : "10.0.2.5", "ip" : "10.0.2.5" }
          ],
          "unavailability" : {
            "start" : { "nanoseconds" : 1 },
            "duration" : { "nanoseconds" : 3600000000000 }
          }
        }
      ]
    }
    ```
    
    For a more complex example, see the [maintain-agents.sh](https://github.com/vishnu2kmohan/dcos-toolbox/blob/master/mesos/maintain-agents.sh) script.
 
1.  Invoke the `⁠⁠⁠⁠machine/down` endpoint with the machine JSON definition specified. For example, [here](https://github.com/vishnu2kmohan/dcos-toolbox/blob/master/mesos/down-agents.sh) is a script that calls `/machine/down/`. 

    **Important:** Invoking `machine/down` sends a `⁠⁠⁠⁠TASK_LOST`⁠⁠⁠⁠ message for any tasks that were running on the agent. Some DC/OS services, for example Marathon, will relocate tasks, but others will not, for example Kafka and Cassandra. For more information, see the DC/OS [service guides](https://docs.mesosphere.com/service-docs/) and the Mesos maintenance primitives [documentation](https://mesos.apache.org/documentation/latest/maintenance/).
    
1.  Perform your maintenance.
1.  Add the nodes back to your cluster by invoking the `⁠⁠⁠⁠machine/up` endpoint with the add agents JSON definition specified. For example:

    ```json
    [
      { "hostname" : "10.0.2.107", "ip" : "10.0.2.107" },
      { "hostname" : "10.0.2.5", "ip" : "10.0.2.5" }
    ]
    ```

# Updating nodes by manually killing agents
Draining nodes by using terminate signal, SIGUSR1, is easy to integrate with automation tools that can execute tasks on nodes in parallel, for example Ansible, Chef, and Puppet. 

1.  [SSH to the agent nodes](/docs/1.10/administering-clusters/sshcluster/).
1.  Stop the agents.

    -  **Private agent**
    
       ```bash
       sudo sh -c 'systemctl kill -s SIGUSR1 dcos-mesos-slave && systemctl stop dcos-mesos-slave'
       ```
    -  **Public agent**
    
       ```bash
       ⁠⁠⁠⁠sudo sh -c 'systemctl kill -s SIGUSR1 dcos-mesos-slave-public && systemctl stop dcos-mesos-slave-public'
       ```

1.  Perform your maintenance.
1.  Add the nodes back to your cluster.
    1.  Reload the systemd configuration.
    
        ```bash
        ﻿⁠⁠sudo systemctl daemon-reload
        ```
        
    1.  Remove the `latest` metadata pointer on the agent node:
    
        ```bash
        ⁠⁠⁠⁠sudo rm /var/lib/mesos/slave/meta/slaves/latest
        ```
        
    1.  Start your agents with the newly configured attributes and resource specification⁠⁠.
    
        -  **Private agent**
        
            ```bash
            sudo systemctl start dcos-mesos-slave
            ```
        -  **Public agent**
        
            ```bash
            sudo systemctl start dcos-mesos-slave-public
            ```
            
        **Tip:** You can check the status with this command:
        
        ```bash
        sudo systemctl status dcos-mesos-slave
        ```