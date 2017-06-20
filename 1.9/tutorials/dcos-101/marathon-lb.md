---
post_title: Exposing Apps using Edge Router
nav_title: Exposing Apps Publicly
menu_order: 6
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.9/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.9/tutorials/dcos-101/cli/).
* [app2](/docs/1.9/tutorials/dcos-101/app2/) deployed and running in your cluster.

<table class="table" bgcolor="#E6E6E6"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Disclaimer:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided solely on a "as is" basis and without warranty. Do not use in a production environment. This is a referential example meant to illustrate how this solution could be done with DC/OS. Before using a similar solution in your environment, you would need to adapt, validate, and test.</td> </tr> </table>

# Objective
In this section you will make app2 available from outside the cluster by running it on a public agent node with Marathon-LB.


# Steps
DC/OS has two different node types: private and public agent nodes. Private agent nodes (usually) do not have ingress access from outside of the cluster, while public agent nodes allow for ingress access from outside the cluster.

By default, Marathon starts applications and services on private agent nodes, which cannot be accessed from the outside, the cluster. To expose an app to the outside you usually use a load balancer running on one of the public nodes. You will revisit the topic of load balancing (and different choices for load balancers) later in this tutorial, but for now, you can choose Marathon-LB as the load balancer.

  * Install Marathon-LB: `dcos package install marathon-lb`
  * Check that it is running: `dcos task` and identify the IP adress of the public agent node (Host) where Marathon-LB is running,
    * Warning: If you started your cluster using a cloud provider (especially AWS) dcos task might show you the private ip address of the host, which is not resolvable from outside the cluster (e.g., if you see something like 10.0.4.8 it is very likely a private address).
    In that case, you need to retrieve the public IP from your cloud provider. On AWS, go to the console and then search for the instance with the private IP shown by 'dcos task'. The public IP will be listed in the instance description as Public IP.
  * Connect to the webapp (from your local machine) via `<Public IP>:10000`. You should see a rendered version of the web page including the physical node and port app2 is running on.
  * Use the web form to add a new Key:Value pair
  * You can verify the new key was added in two ways:
    1. Check the total number of keys using app1: `dcos task log app1`
    2. Check redis directly
       1.  [SSH](/docs/1.9/administering-clusters/sshcluster/) into node where redis is running:
            
           ```bash
           dcos node ssh --master-proxy --mesos-id=$(dcos task  redis --json |  jq -r '.[] | .slave_id')
           ```
       * As redis is running in Docker container let us list all Docker container `docker ps` and get the ContainerID.
       * Connect to a bash session to the running container: `sudo docker exec -i -t CONTAINER_ID  /bin/bash`.
       * Start the redis CLI: `redis-cli`.
       * Check value is there: `get <newkey>`.

# Outcome
Congratulations! You've used Marathon-LB to expose your application to the public and added a new key to redis using the web frontend.
