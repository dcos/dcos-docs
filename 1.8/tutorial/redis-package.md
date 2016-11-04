---
post_title: DC/OS 101 - Install First Package
menu_order: 3
---

Let us continue with part 2 of the DC/OS 101 Tutorial.

# Challenge
After connecting the cli, we now are ready to install our first service redis from the universe.
Redis is a key value store which we will use for persistence throughout the tutorial.

# Steps
  * Install custom local universe
      AFTER REDIS IS MERGED TO UNIVERSE WE CAN DROP THIS STEP.
      * `wget https://raw.githubusercontent.com/joerg84/dcos-101/master/universe/marathon-local-universe.json`
      * `dcos marathon app add marathon-local-universe.json`
      * `dcos package repo add --index=0 dev-universe http://universe.marathon.mesos:8085/repo`
  * Install redis
      * `dcos package search redis`
      * `dcos package install redis`
  * Check that redis is running
      * `dcos task`
      * `dcos marathon app list`
      * `dcos task log  redis`
  * Start using redis by storing a key manually via the redis-cli
      * SSH into node where redis is running `dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')`
        * NOTE: This requires you to have the key required to ssh to the machines in your local ssh agent (ssh-add)
      * As redis is running in docker container let us list all docker container `docker ps` and get Container ID.
      * Connect to container: `sudo docker exec -i -t CONTAINER_ID  /bin/bash`
      * Start redis CLI `redis-cli`
      * Set key `set mykey key1`
      * Check value is there `get mykey`

# Outcome
 We have sucessfully installed our first service from the universe and tested it is running

# Deep Dive
 Universe Overview, community vs certified, own repo

