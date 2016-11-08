---
post_title: DC/OS 101 - User Facing Apps
menu_order: 3
---

# Prerequisites
We expect you to have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, we expect you have just deployed app1.

# Objective
We already deployed an app which is running internally in our cluster (i.e., it is not targeted to users directly). Next, will deploy an app which provides a web UI to users.
Secondly, we also want to deploy an app natively, i.e., not relying on Docker.


# Steps
  * Check out app1
    * Take a short look at out [app2](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go). App2 is a go-lang based HTTP server exposing a very simple interface to redis.
  * Deploy app
    * Take a short look at the [app definition](https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json). In this case, the app is a binary without external dependencies.
    Hence there is no need to deploy it in a docker container.
    * Add app `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json`.
  * Let us check that app2 is running
    * By looking at all DC/OS tasks: `dcos task`
    * By looking at all marathon apps: `dcos marathon app list`
    * Curl the http server from within cluster (in this case from the leading master):
       * `dcos node ssh --master-proxy --leader`
       * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`
       This should return you dome raw html code from app2's webserver.
    * Make it available to the public
      Curling the app from within the cluster and viewing the raw html is a nice thing (more or less), but in reality, we want to expose the app to the public. Therefore we have understood that DC/OS has two different [node types](https://docs.mesosphere.com/1.8/overview/concepts/#dcos-agent-node): private and public agent nodes. Private agent nodes (usually) do not have ingress access from outside of the cluster, while public agent nodes allow for ingress access from outside the cluster.
      Marathon will start application and services by default on private agent nodes and hence they cannout be accessed from the outside. The default pattern to expose an app to the outside is to use a load-balancer running on one of the public nodes. We will revisit the topic of load-balancing later in this tutorial, but for now, we choose marathon-lb as one potential load-balancer.
       * Install marathon-lb: `dcos package install marathon-lb`
       * Check that it is running: `dcos task` and identify the IP adress of the public agent node (Host) where marathon-lb is running on,
        * Warning: If you started your cluster using a cloud provider, in particular, AWS `dcos task` might show you the private ip adress of the host which is not resolvable from the outside (e.g., if you see something like 10.0.4.8 it is very likely a private adress).
        In that case, you need to retrieve the public IP your cloud provider. For example for AWS, one option would be to go to the console and then search for the instance with the private IP shown by 'dcos task'. The public IP will be listed in the instance description as `Public IP`.
       * Connect to the webapp (from your local machine) via `<Public IP>:10000`. You should see a rendered version of the web page including the physical node and port app2 is running on.
       * Use the web form to add a new Key:Value pair
       * Let us verify the new key was actually added to redis
         * Check the total number of keys using app1: `dcos task log app1`
         * Check redis directly
           * SSH into node where redis is running: `dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')`
            * NOTE: This requires you to have the key required to ssh to the machines added to your local ssh agent (e.g., via ssh-add key).
           * As redis is running in docker container let us list all docker container `docker ps` and get the ContainerID.
           * Connect to a bash session to the running container: `sudo docker exec -i -t CONTAINER_ID  /bin/bash`
           * Start the redis CLI: `redis-cli`
           * Check value is there: `get <newkey>`

# Outcome
 We have deployed our second App which is using the native Mesos Containerizer. We used marathon-lb to expose the app to the public and added a new key to redis using the web frontend.

# Deep Dive
We have now deployed apps in two different ways: using Docker (app1) and natively (app2).
Let us explore the differences in some more detail.
DC/OS uses [containerizers](https://dcos.io/docs/1.8/usage/containerizers/) to to run tasks in containers. Running tasks in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically. DC/OS supports the Mesos containerizer types DC/OS Universal container runtime and Docker containerizer.

For our first app, we actually used a docker container image to package app1's depencies (Rembember: never rely on depencies being installed on an agent!) and then used the Docker containerizer to execute it. As the Docker containerizer internally uses the [docker runtime](https://docs.docker.com/engine/userguide/intro/), we effectively used the docker runtime.

For our second app, we did not have any depencies and hence could rely on the default DC/OS Universal container runtime. Internally, both runtimes actually use the same OS features the isolation, namely [cgroups](https://en.wikipedia.org/wiki/Cgroups) and [namespaces](https://en.wikipedia.org/wiki/Linux_namespaces).
This actually makes it possible to use the DC/OS Universal container runtime for running docker images. Check the [DC/OS Universal container runtime](https://dcos.io/docs/1.8/usage/containerizers/) documentation for details.
