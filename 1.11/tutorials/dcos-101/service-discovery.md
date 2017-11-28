---
post_title: Connecting Apps/Service Discovery
nav_title: Service Discovery
menu_order: 4
---

Welcome to part 4 of the DC/OS 101 Tutorial

<table class="table" bgcolor="#FAFAFA"> <tr> <td align=justify style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;">**Important:** Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is purely to demonstrate capabilities, and it may not be suited for use in a production environment. Before using a similar solution in your environment, you should adapt, validate, and test.</td> </tr> </table>

# Prerequisites
* A [running DC/OS cluster](/docs/1.11/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.11/tutorials/dcos-101/cli/).
* [app1](/docs/1.11/tutorials/dcos-101/app1/) deployed and running in your cluster.

# Objective
Your [app](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.py) in the previous part of this tutorial used `redis.marathon.l4lb.thisdcos.directory` as the address for connecting to Redis, with port 6379. As Redis might be running on any agent in the cluster, and potentially on different ports, how does this address resolve to the actual running Redis instance?

In this section, you will learn about DC/OS service discovery by exploring the different options available for apps in DC/OS.

# Service Discovery
  [Service discovery](/docs/1.11/networking/) enables addressing of applications independently of where they are running in the cluster, which is particularly useful in cases where applications may fail and be restarted on a different host.

  DC/OS provides two options for service discovery: 

  1. Mesos-DNS
  1. Named Virtual IPs.


SSH into the Mesos master node in your cluster to see how these different service discovery methods work: 

`dcos node ssh --master-proxy --leader`

# Mesos-DNS
  
  [Mesos-DNS](/docs/1.11/networking/mesos-dns/) assigns DNS entries for every task. The naming pattern for these entries is  *task.scheduler.mesos*
  
  The default scheduler for jobs is [Marathon](https://dcos.io/docs/1.11/overview/architecture/components/#marathon), so the Mesos-DNS name for your Redis service is *redis.marathon.mesos*.
  
  Let's use the [dig](https://linux.die.net/man/1/dig) command to retrieve the address record (also called the A record). Dig is a command line utility to query DNS servers. When used without argument, it will use the system-wide configured DNS servers to query against, which in a DC/OS cluster is configured to point at Mesos-DNS: 

  `dig redis.marathon.mesos`

  The answer should be similar to this response:

  ```
  ;; ANSWER SECTION:
  redis.marathon.mesos. 60  IN  A 10.0.0.43
  ```

  The response tells us that there is an instance of the `redis.marathon.mesos` service at 10.0.0.43.

  The A record only contains IP address information about the host. To connect to the service, you also need to know the port. In order to achieve this, Mesos-DNS also assigns a Service, or SRV, record for each Marathon app, containing the port number.

  Use the following dig command to access the SRV record: 

  `dig srv _redis._tcp.marathon.mesos`
  
  The answer should look similar to this response:

  ```
  ;; ANSWER SECTION:
  _redis._tcp.marathon.mesos. 60  IN  SRV 0 0 30585 redis-1y1hj-s1.marathon.mesos.

  ;; ADDITIONAL SECTION:
  redis-1y1hj-s1.marathon.mesos. 60 IN  A 10.0.0.43
  ```

  This output tells you that your Redis service is running on `10.0.0.43:30585`

# Named Virtual IPs
  
  * [Named VIPs](/docs/1.11/networking/load-balancing-vips/) allow you to assign name/port pairs to your apps, which means you can give your apps meaningful names with a predictable port. They also provide built-in load balancing when using multiple instances of an application. 
  For example, you can assign a named VIP to your Redis service by adding the following to the package definition:

  ```
  "VIP_0": "/redis:6379"
  ```

  The full name is then generated using the following schema:
  *vip-name.scheduler.l4lb.thisdcos.directory:vip-port*. 

  As we can see from the example [application](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.py), this is the mechanism used by the redis package, and so you can access the Redis service from within the cluster at `redis.marathon.l4lb.thisdcos.directory:6379`.

# Outcome
You know how to use service discovery to connect to your application from within your DC/OS cluster, and have learned about the two mechanisms for service discovery available in DC/OS.

# Deep Dive
What are the differences between [Mesos-DNS](#mesosdns) and [Named VIPs](#namedvips)?

## Mesos-DNS
Mesos-DNS is a simple solution to finding applications inside the cluster. While DNS is supported by many applications, Mesos-DNS has the following drawbacks:

  * DNS caching: Applications sometimes cache DNS entries for efficiency and therefore might not have updated address information (e.g., after a task failure).
  * You need to use SRV DNS records to retrieve information about the allocated ports. While applications commonly understand DNS A records, not all applications support SRV records.


## Named VIPs
Named VIPs load balance the IP address/port pair using an intelligent algorithm to ensure optimal routing of the traffic in relation to the original requestor, and also provide a local caching layer for high perfornance. They also allow you to give your apps meaningful names and select a specific port. Because of these advantages over Mesos-DNS, we suggest using Named VIPs as the default service discovery method in DC/OS.
