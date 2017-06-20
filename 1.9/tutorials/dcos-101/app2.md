---
post_title: Deploying native Applications
nav_title: Native Applications
menu_order: 5
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.9/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.9/tutorials/dcos-101/cli/).
* [app1](/docs/1.9/tutorials/dcos-101/app1/) deployed and running in your cluster.

<table class="table" bgcolor="#E6E6E6"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Disclaimer:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided solely on a "as is" basis and without warranty. Do not use in a production environment. This is a referential example meant to illustrate how this solution could be done with DC/OS. Before using a similar solution in your environment, you would need to adapt, validate, and test.</td> </tr> </table>

# Objective
You already deployed an app which is running internally in your cluster (i.e., it is not targeted to users directly). Next, you will deploy an app which provides a web GUI to users.
You want to deploy this app natively, i.e., not relying on Docker (which is third-party dependency and hence adds complexity).


# Steps
  * Understand the application
    * Take a short look at [app2](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go). App2 is a go-lang based HTTP server exposing a very simple interface to redis.
  * Deploy app 2
    * Take a short look at the [app definition](https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json). In this case, the app is a binary without external dependencies.
    Hence there is no need to deploy it in a Docker container.
    * Deploy app2: `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json`.
  * You have multiple options to check app 2 is sucessfully running:
    * By looking at all DC/OS tasks: `dcos task`
    * By looking at all Marathon apps: `dcos marathon app list`
    * Curl the http server from within the cluster (in this case from the leading master):
       * `dcos node ssh --master-proxy --leader`
       * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`
       This should return you raw html code from app2's webserver.
  * Make app2 available to the public
    * Curling the app from within the cluster and viewing the raw html is a nice thing (more or less), but in reality, You want to expose the app to the public. DC/OS has two different [node types](https://docs.mesosphere.com/1.9/overview/concepts/#dcos-agent-node): private and public. Private agent nodes (usually) do not have access from outside of the cluster, while public agent nodes allow for access from outside the cluster.
    * By default, Marathon will start applications and services on private agent nodes, which prevents them from being accessed from outside the cluster. To expose an app to the outside you usually use a load balancer running on one of the public nodes. You will revisit the topic of load balancing (and load balancer options) later in this tutorial, but for this tutorial, Marathon-LB is used as the load-balancer.
      * Install Marathon-LB: `dcos package install marathon-lb`
      * Check that it is running: `dcos task` and identify the IP adress of the public agent node (Host) where Marathon-LB is running on.
     * Warning: If you started your cluster using a cloud provider (in particular AWS) dcos task might show you the private ip address of the host, which is not resolvable from the outside (e.g., if you see something like 10.0.4.8 it is very likely a private address).
          In that case, you need to retrieve the public IP from your cloud provider. On AWS, go to the console and then search for the instance with the private IP shown by 'dcos task'. The public IP will be listed in the instance description as *Public IP*.
   * Connect to the webapp (from your local machine) via `<Public-IP>:10000`. You should see a rendered version of the web page including the physical node and port app2 is running on.
     * Use the web form to add a new Key:Value pair
     * You can verify the new key was added in two ways:
       1. Check the total number of keys using app1: `dcos task log app1`
       2. Check redis directly
          * SSH into node where redis is running: `dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')`
          * NOTE: This requires you to have the ssh-key required to connect to the machines added to your local SSH agent (e.g., via ssh-add my_public_key). Check the [documentation](/docs/1.9/administering-clusters/sshcluster/) for further details.
       * Because redis is running in a Docker container, you need to list all Docker containers using the `docker ps` command to get the *ContainerID*.
         * Connect to a bash session to the running container: `sudo docker exec -i -t CONTAINER_ID  /bin/bash`
         * Start the redis CLI: `redis-cli`
         * Check value is there: `get <newkey>`

# Outcome
 You have deployed a second app that uses the native Mesos containerizer. You used Marathon-LB to expose the app to the public and added a new key to redis using the web frontend.

# Deep Dive
You have now deployed apps in two different ways: using Docker (app1) and natively (app2).
Let us explore the differences in some more detail.
DC/OS uses [containerizers](/docs/1.9/deploying-services/containerizers/) to run tasks in containers. Running tasks in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically. DC/OS supports the Mesos containerizer types DC/OS Universal container runtime and Docker containerizer.

For your first app, you actually used a Docker container image to package app1's depencies (remember: never rely on depencies being installed on an agent!) and then used the Docker containerizer to execute it. As the Docker containerizer internally uses the [Docker runtime](https://docs.docker.com/engine/userguide/intro/), you effectively used the Docker runtime.

For your second app, you did not have any depencies and hence could rely on the default DC/OS Universal container runtime. Internally, both runtimes use the same OS features for isolation, namely [cgroups](https://en.wikipedia.org/wiki/Cgroups) and [namespaces](https://en.wikipedia.org/wiki/Linux_namespaces).
This actually makes it possible to use the DC/OS Universal container runtime for running Docker images. Check the [DC/OS Universal container runtime](/docs/1.9/deploying-services/containerizers/) documentation for details.
