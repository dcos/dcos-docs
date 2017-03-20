---
post_title: Install a Package
menu_order: 2
---

Welcome to part 2 of the DC/OS 101 Tutorial.

# Prerequisites
- A running DC/OS cluster with the DC/OS CLI installed and configured. If that isn't the case, please follow these [instructions](/docs/1.9/usage/tutorials/dcos-101/cli/).
- An unencrypted SSH key that can be used to authenticate with the cluster nodes over SSH. Encrypted SSH keys are not supported. See the [documentation](/docs/1.9/administration/access-node/sshcluster/) for further details.
- [jq](https://stedolan.github.io/jq/), a JSON processor to simplify some of the commands below.

# Objective
Install the Redis DC/OS service from the DC/OS Universe. Redis is a key-value store, which we will use for persisting data throughout the tutorial.

# Steps
  * Install Redis
      * Search for the redis package in the Universe with this command: `dcos package search redis`. This should return two entries (`mr-redis` and `redis`).
        ```bash
        $ dcos package search redis
        NAME      VERSION      SELECTED  FRAMEWORK  DESCRIPTION                                                                       
        mr-redis  0.0.1        False     True       Redis is the fastest in-memory KV-Cache and Datatstructure store                  
        redis     3.0.7-0.0.1  False     False      This is a single redis container, which is not suited for HA setups. Redis is...
        ```
      * For this tutorial we are interested in the single Redis container package. You can install with this command:
        ```bash
        $ dcos package install redis
        ```
  * Use any of the following methods to check that redis is running:
      * DC/OS UI Services tab: The Redis service should be displayed in the **Services** tab along with the health status.
        ![Redis service](/docs/1.9/usage/tutorials/img/redis-service.png)
      * The `dcos task` command: This command show all running DC/OS tasks.
        ```bash
        $ dcos task
        NAME   HOST       USER  STATE  ID                                          
        redis  10.0.3.89  root    R    redis.805f3ae3-0d87-11e7-9881-22172a0b4171  
        ```
      * The `dcos marathon app list` command: This command show us all running Marathon apps. As services are started via Marathon, we should see Redis here as well. Note, that the health status (i.e., 1/1) is also shown here.
        ```bash
        $ dcos marathon app list
        ID      MEM   CPUS  TASKS  HEALTH  DEPLOYMENT  WAITING  CONTAINER  CMD   
        /redis  1024   1     1/1    1/1       ---      False      DOCKER   None
        ```
      * The Redis log with the `dcos task log redis` command. This command shows the stdout and stderr logs for the Redis task. This allows you to check whether the actual startup was successful.
  * Let's use Redis by storing a key manually via the redis-cli
      * SSH into the node where Redis is running: 
        ```bash
        $ dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')
        ```
      * Because Redis is running in Docker container, you can list all Docker containers using `docker ps` and get the ContainerID.
      * Run this command to connect to a bash session in the running container: 
      
        ```bash
        $ udo docker exec -i -t CONTAINER_ID  /bin/bash
        ```
      * Start the Redis CLI: 
        ```bash
        redis-cli
        ```
      * Set the key:
        ```bash
        set mykey key1
        ```
      * Check value is there:
        ```bash
        get mykey
        ```

# Outcome
  You have just successfully installed the Redis service from the Universe and verified it is running.

# Deep Dive
  For more information, see the managing services [documentation](/docs/1.9/usage/managing-services/).
