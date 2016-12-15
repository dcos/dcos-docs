---
post_title: Connecting Apps/Service Discovery
nav_title: Service Discovery
menu_order: 4
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.8/tutorial/cli/) with [the DC/OS CLI installed](/docs/1.8/tutorial/cli/).
* [app1](/docs/1.8/tutorial/app1/) deployed and running in your cluster.

# Objective
Our application in the previous part used `redis.marathon.l4lb.thisdcos.directory:6379` as the address for connecting to redis. As redis might be running on any agent in the cluster (and furthermore on different ports), how does this address link to the actual running redis instance?
In this section, we will learn about DC/OS service discovery by exploring the different options for service discovery for apps in DC/OS.

# Steps
  [Service discovery](https://dcos.io/docs/1.8/usage/service-discovery/) allows you to connect to your applications without necessarily knowing where they are running. Service discovery is particularly useful in cases where applications may fail and be restarted on a different host.

  DC/OS provides two options for service discovery: Mesos-DNS and Named virtual IPs.
  * SSH into your cluster to see how these service discovery methods work: `dcos node ssh --master-proxy --leader`,
  <a name="mesosdns"></a>
  * [Mesos-DNS](https://dcos.io/docs/1.8/usage/service-discovery/mesos-dns/) assigns a Mesos-DNS for every Marathon app. The naming pattern is  *task.scheduler.mesos* and the default scheduler for jobs is `marathon`, so the Mesos-DNS name for our redis service is *redis.marathon.mesos*.

  Let us use [dig](https://en.wikipedia.org/wiki/Dig_(command)) to retrieve the address record (also called the A record): `dig redis.marathon.mesos`.

  The answer should contain similar to this response:

  ```
  ;; ANSWER SECTION:
  redis.marathon.mesos. 60  IN  A 10.0.0.43
  ```

  The response tells us that the host for the `redis.marathon.mesos` is 10.0.0.43.

  The A record only contains information about the host. In order to connect to the service, we also need to know the port. Use the following dig command to access the Service locator (SRV) DNS record, which also provides port information: `dig srv _redis._tcp.marathon.mesos`.
  The answer should look similar to this response:

  ```
  ;; ANSWER SECTION:
  _redis._tcp.marathon.mesos. 60  IN  SRV 0 0 30585 redis-1y1hj-s1.marathon.mesos.

  ;; ADDITIONAL SECTION:
  redis-1y1hj-s1.marathon.mesos. 60 IN  A 10.0.0.43
  ```

  So we now know that our redis app is running on 10.0.0.43:30585.

  <a name="namedvips"></a>
  * [Named Vips](https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/) allow you to assign name/port pairs to your apps. Named VIPs allow you to assign meaningful names to your apps.
  For example, we can assign a named VIP to our redis service by adding the following to the package definition:

  ~~~
  "VIP_0": "/redis:6379"
  ~~~

  The full name is then generated using the following schema:
  *vip-name.scheduler.l4lb.thisdcos.directory:vip-port*. In the example above, you can access the redis service from within the cluster at the following address: redis.marathon.l4lb.thisdcos.directory:6379.

# Outcome
You know how to use service discovery to connect to your application from within your DC/OS cluster.

# Deep Dive
What are the differences between [Mesos-DNS](#mesosdns) and [Named VIPs](#namedvips)?

## Mesos-DNS
Mesos-DNS is a rather simple solution to finding applications inside the cluster. While DNS is supported by many applications, Mesos-DNS has the following drawbacks::

  * DNS caching: Applications sometimes cache DNS entries for efficiency and therefore might not have updated address information (e.g., after a task failure).
  * We need to use SRV DNS records to retrieve information about the allocated ports. Even though applications commonly understand DNS A records, not all applications support SRV records.


## Named VIPs
Named VIPs load balance the IP address/port pair and therefore also redirect the current instance when applications have cached the IP address. They also allow you to select a port. Because Named VIPs offer these advantages over Mesos-DNS, we suggest using Named VIPs as the default service discovery method in DC/OS.
