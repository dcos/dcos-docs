---
post_title: Installing First Package
menu_order: 2
---

Welcome to part 2 of the DC/OS 101 Tutorial.

<table class="table" bgcolor="#E6E6E6"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Disclaimer:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided solely on a "as is" basis and without warranty. Do not use in a production environment. This is a referential example meant to illustrate how this solution could be done with DC/OS. Before using a similar solution in your environment, you would need to adapt, validate, and test.</td> </tr> </table>

# Prerequisites
By now, you have a running DC/OS cluster and the DC/OS CLI installed and configured. If that isn't the case, please follow these [instructions](/docs/1.10/tutorials/dcos-101/cli/).
You use [jq](https://stedolan.github.io/jq/) as a json processor to simplify some of the commands below.

# Objective
By the end of this session you will have installed your first service - Redis - from the DC/OS universe. Redis is a key-value store, which you will use for persisting data throughout the tutorial.

# Steps
  * Install Redis
      * Search the redis package in the Universe: 
      
        ```bash
        dcos package search redis
        ```
        
        This should return two entries (mr-redis and redis).
        
      * You are interested in the single redis container package, which you install with this command:
      
        ```bash
        dcos package install redis
        ```
        
  * You can use any of the following methods to check that redis is running:
      * By looking at the GUI: The redis task should be displayed in the Service Health tab along with the health status.
      * By looking at all DC/OS tasks with the `dcos task` command. This command will show us all running DC/OS tasks (i.e., Mesos tasks).
      * By looking at all Marathon apps: `dcos marathon app list`. This command will show us all running Marathon apps. As services are started via Marathon, you should see redis here as well. Note, that the health status (i.e., 1/1) is also shown here.
      * By looking at the redis log: `dcos task log redis`. This command will show us the logs (stdout and stderr) of the redis task. This allows you to check whether the actual startup was successful.
  * Let's use redis by storing a key manually via the redis-cli
      * [SSH](/docs/1.10/administering-clusters/sshcluster/) into the node where redis is running: 
      
        ```bash
        dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')
        ```
    
      * Because Redis is running in Docker container, you can list all Docker containers using `docker ps` and get the ContainerID.
      * Connect to a bash session in the running container: 
      
        ```bash
        sudo docker exec -i -t CONTAINER_ID  /bin/bash
        ```
        
      * Start the Redis CLI: 
      
        ```bash
        redis-cli
        ```
        
      * Set key: 
      
        ```bash
        set mykey key1
        ```
        
      * Check value is there:
      
        ```bash
        get mykey
        ```

# Outcome
  You have just successfully installed your first service from the universe and verified it is running.

# Deep Dive
  [Universe](https://github.com/mesosphere/universe) is a package registry made available for DC/OS Clusters.
  It enables you to easily install services such as Apache Spark or Apache Cassandra in your cluster without having to deal with manual configuration. Universe packages are by many different contributors. There are two categories of packages right now:
  First, selected packages that have undergone testing and certification. Second, community packages, which are not as well tested.

  You can also add your own repo that includes your custom packages. See [the documentation](https://docs.mesosphere.com/1.10/administering-clusters/repo/) for details.
