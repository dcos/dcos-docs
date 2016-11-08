---
post_title: Install First Package
nav_title: Installing Package
menu_order: 2
---

Welcome to part 2 of the DC/OS 101 Tutorial.

# Prerequisites
By now, you have a running DC/OS cluster and the DC/OS CLI installed and configured. If that isn't the case, please follow these [instructions](/docs/1.8/tutorial/cli/).
Furthermore, we use [jq](https://stedolan.github.io/jq/) as a json processor to simplify some of the below commands.

# Objective
By the end of this session we will have installed our first service--redis--from the DC/OS universe. Redis is a key-value store, which we will use for persisting data throughout the tutorial.

# Steps
  * Install custom local universe with the redis package (not required for packages which are Mesosphere universe)
      * `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/universe/marathon-local-universe.json`
      * Check that the deployment of the local-universe has finished: `dcos marathon app list`
      * Add the local universe as a package repo, available to your DC/OS cluster:: `dcos package repo add --index=0 dev-universe http://universe.marathon.mesos:8085/repo`
  * Install redis
      * Search the redis package in the (local) universe: `dcos package search redis`. This should return two entries (mr-redis and redis).
      * We are interested in the single redis container package which we install with `dcos package install redis`.
  * Next, let us check that redis is actually running.
      * BY looking at the UI: The redis task should be displayed in the Service Health tab along with the health status.
      * By looking at all DC/OS tasks: `dcos task`. This command will show us all running DC/OS tasks (i.e., Mesos taks).
      * By looking at all marathon apps: `dcos marathon app list`. This command will show us all running marathon apps. As services are started via marathon, we should see redis here as well. Note, that the health status (i.e., 1/1) is also shown here.
      * By looking at the redis log: `dcos task log redis`. This command will show us the logs (stdout and stderr) of the redid task. This allows you to check whether the actual startup was sucessful.
  * Let us actually use redis by storing a key manually via the redis-cli
      * SSH into node where redis is running: `dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')`
        * NOTE: This requires you to have the ssh-key required to conenct to the machines added to your local ssh agent (e.g., via ssh-add my_public_key). Check the [documentation](https://dcos.io/docs/1.8/administration/access-node/sshcluster/) for further details.
      * Because redis is running in docker container, we can list all docker containers using `docker ps` and get the ContainerID.
      * Connect to a bash session to the running container: `sudo docker exec -i -t CONTAINER_ID  /bin/bash`
      * Start the redis CLI: `redis-cli`
      * Set key `set mykey key1`
      * Check value is there `get mykey`

# Outcome
  We have just successfully installed our first service from the universe and verified it is running.

# Deep Dive
  The [universe](https://github.com/mesosphere/universe) is a package registry made available for DC/OS Clusters.
  It enables you to easily install services such as Apache Spark or Apache Cassandra in your cluster without having to deal with manual configuration. Universe packages are contributed by many different contributors and there are two categories of packages right now:
  First, selected packages which have gone through testing and certification and secondly, community packages which are not as well tested.

  You can also add own repo including your custom packages. See [here](https://docs.mesosphere.com/1.8/usage/repo/) for details.
