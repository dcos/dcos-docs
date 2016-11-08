---
post_title: DC/OS 101 - Install First Package
menu_order: 3
---

Welcome to part 2 of the DC/OS 101 Tutorial.

# Prerequisites
We expect you to have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, for your convenience we use [jq](https://stedolan.github.io/jq/) in some of the below commands.

# Objective
We now are ready to install our first service -redis- from the universe.
Redis is a key-value store which we will use for persisting data throughout the tutorial.

# Steps
  * Install custom local universe
      AFTER REDIS IS MERGED TO UNIVERSE WE CAN DROP THIS STEP.
      * `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/universe/marathon-local-universe.json`
      * Check that the deployment of the local-universe has finished: `dcos marathon app list`
      * Add the local-universe as package repo: `dcos package repo add --index=0 dev-universe http://universe.marathon.mesos:8085/repo`
  * Install redis
      * Search the redis package in the (local) universe: `dcos package search redis`. This should return two entries (mr-redis and redis).
      * We are interested in the single redis container package which we install with `dcos package install redis`.
  * Next, let us check that redis is actually running.
      * By looking at all DC/OS tasks: `dcos task`
      * By looking at all marathon apps: `dcos marathon app list`
      * By looking at the redis log: `dcos task log redis`
  * Let us actually use redis by storing a key manually via the redis-cli
      * SSH into node where redis is running: `dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')`
        * NOTE: This requires you to have the key required to ssh to the machines added to your local ssh agent (e.g., via ssh-add key).
      * As redis is running in docker container let us list all docker container `docker ps` and get the ContainerID.
      * Connect to a bash session to the running container: `sudo docker exec -i -t CONTAINER_ID  /bin/bash`
      * Start the redis CLI: `redis-cli`
      * Set key `set mykey key1`
      * Check value is there `get mykey`

# Outcome
  We have just successfully installed our first service from the universe and verified it is running.

# Deep Dive
  The [universe](https://github.com/mesosphere/universe) is a package registry made available for DC/OS Clusters.
  It enabled you to easily install services such as Apache Spark or Apache Cassandra in your cluster without having to deal with the
  low-level details. Universe packages are contributed by many different contributors and there are two categories of packages right now:
  First, selected packages which have gone through testing and certification and secondly, community packages which are not as well tested.

  You can also add own repo including your custom packages. See [here](https://docs.mesosphere.com/1.8/usage/repo/) for details.
