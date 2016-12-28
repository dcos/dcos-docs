---
post_title: Upgrading
menu_order: 11
---

## Summary

This document provides instructions for upgrading a DC/OS cluster from version 1.7 to 1.8 using AWS cloudformation templates. It is recommended that you familiarize yourself with the [Advanced DC/OS Installation on AWS] before proceeding.

**Important:**

- The upgrade process described involves deleting all the instances, it will NOT save any persistent data.  If you have services which persist data locally to the cluster and the data should be preserved, it is recommended to create a second cluster running the new version of DC/OS and migrate the services and data to the new cluster.
- The [VIP features](/docs/1.8/usage/service-discovery/load-balancing-vips/virtual-ip-addresses/), added in DC/OS 1.8, require that ports 32768 - 65535 are open between all agent and master nodes for both TCP and UDP.
- The DC/OS UI and APIs may be inconsistent or unavailable while masters are being upgraded. Avoid using them until all masters have been upgraded and have rejoined the cluster. You can monitor the health of a master during an upgrade by watching Exhibitor on port 8181.
- Task history in the Mesos UI will not persist through the upgrade.


## Instructions

1. Login to the current leader master of the cluster.
   1. Using DC/OS CLI: 
      
      ```bash
      $ dcos node ssh --master-proxy --leader
      ```
   1. After you are logged in, run the following command. This command creates a new 1.8 directory (`/var/lib/dcos/exhibitor/zookeeper`) as a symlink to the old (`/var/lib/zookeeper`): 
   
      ```bash
      $ for node in $(dig +short master.mesos); do ssh -o StrictHostKeyChecking=no $node "sudo mkdir -p /var/lib/dcos/exhibitor && sudo ln -s /var/lib/zookeeper /var/lib/dcos/exhibitor/zookeeper"; done
      ```

   1. Go to `http://master-node/exhibitor`.
   
      1. Go to config tab , it should have three fields which have (`/var/lib/zookeeper`). 
        ![Exhibitor UI](../img/dcos-exhibitor-fields-before.png)
        ![Exhibitor UI](../img/dcos-exhibitor-fields-before-2.png)
      1. Edit the config and change all three fields that contain (`/var/lib/zookeeper/`) to (`/var/lib/dcos/exhibitor/zookeeper/`).
        ![Exhibitor UI](../img/dcos-exhibitor-fields-after.png)
        ![Exhibitor UI](../img/dcos-exhibitor-fields-after-2.png)
      1. Commit and perform a rolling restart. This will take a couple of minutes and during that time the Exhibitor UI will flash, wait for the commit to be performed fully.
   
   1. Make sure the cluster is healthy at this point.
   
      1. Verify you can access the dashboard.
      1. Verify all components are healthy.
   
1. Update Cloudformation stacks.
   1. Generate the new templates following instructions at [Advanced DC/OS Installation Guide][advanced-aws-custom]. 
   1. See the AWS [documentation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-direct.html) on updating CloudFormation stacks. 
   1.  Update the Cloudformation stacks associated with the cluster in the same manner in which they were deployed. For example, if the zen template was used to deploy the cluster then it is only necessary to update the zen stack, since this will cause all of the dependent templates to update as well.
   
1. Deleting instances
   1. Deleting master nodes.
   
      * Identify the ZooKeeper leader among the masters. This node should be the last master node that you delete. You can determine whether a master node is a ZooKeeper leader by sending the `stat` command to the ZooKeeper client port.
        
        ```bash
        $ echo stat | /opt/mesosphere/bin/toybox nc localhost 2181 | grep "Mode:"
        ```
        
        When you complete deleting each node, monitor the Mesos master metrics to ensure the node has rejoined the cluster and completed reconciliation.
  
   1. Validate the master deletion.
   
      1. Monitor the Exhibitor UI to confirm that the Master rejoins the ZooKeeper quorum successfully (the status indicator will turn green).  The Exhibitor UI is available at `http://<dcos_master>:8181/`.
      1. Verify that `curl http://<dcos_master_private_ip>:5050/metrics/snapshot` has the metric `registrar/log/recovered` with a value of `1`.
      1. Verify that `http://<dcos_master>/mesos` indicates that the upgraded master is running Mesos 1.0.1.

    
   1. Deleting agent nodes.
   
      1. Choose an agent node for replacement and shutdown the Mesos agent with the command `systemctl kill -s SIGUSR1 dcos-mesos-slave` or `systemctl kill -s SIGUSR1 dcos-mesos-slave-public` depending on agent type. 
        This ensures that tasks are quickly rescheduled and the agent is cleanly removed from the cluster.
      1. Terminate the agent using AWS web UI or CLI tools.
      1. Verify a replacement agent node joins and is healthy. Watch the agent node count in the DC/OS UI to confirm the replacement agent joins the cluster.
      1. Repeat the above steps for all the old agent nodes.
      
[advanced-aws-custom]: /docs/1.8/administration/installing/cloud/aws/advanced/aws-custom/