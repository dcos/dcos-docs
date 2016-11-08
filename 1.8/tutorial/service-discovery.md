---
post_title: Connecting Apps/Service Discovery
nav_title: Service Discovery
menu_order: 4
---

# Prerequisites
In order to get started with this tutorial, you should have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, we expect you have just deployed app1 in the previous step of this tutorial.

# Objective
Our application in the previous part used`redis.marathon.l4lb.thisdcos.directory:6379` as the address for connecting to redis. As redis might be running on any agent in the cluster (and furthermore on different ports), how does this address link to the actual running redis instance?
In this section, we will learn about DC/OS service discovery by exploring the different options for service discovery for apps in DC/OS.

# Steps
  [Service discovery](https://dcos.io/docs/1.8/usage/service-discovery/)  is very important as we actually want to be ignorant (at least most of the time) about where our apps are running, but still be able to connect to them. This is especially true in cases where apps fail and might be restarted on a different host.
  DC/OS provides two options for service discover: Mesos-DNS and Named virtual IPs.
  * Let us shh into our cluster and see how this works: `dcos node ssh --master-proxy --leader`,
  * [Mesos-DNS](https://dcos.io/docs/1.8/usage/service-discovery/mesos-dns/) assigns a Mesos-DNS for every Marathon app.  The naming pattern is  *task.scheduler.mesos* and as the default scheduler for jobs is `marathon`, so the Mesos-DNS name for our redis service is *redis.marathon.mesos*.

  Let us use [dig](https://en.wikipedia.org/wiki/Dig_(command)) to retrieve the *A*ddress record: `dig redis.marathon.mesos`.
     The answer should contain something like the following response:

  ~~~~
  ;; ANSWER SECTION:
  redis.marathon.mesos. 60  IN  A 10.0.0.43
  ~~~~

  The response tells us that the host for the 'redis.marathon.mesos'' is 10.0.0.43.

  The *A*ddress record only contains information abbout the host, which is not sufficient to connect to the service as we also need to know the port. The Service locator (SRV) DNS record includes port information as well: `dig srv _redis._tcp.marathon.mesos`.
  The answer should look similar to this response:

  ~~~~
  ;; ANSWER SECTION:
  _redis._tcp.marathon.mesos. 60  IN  SRV 0 0 30585 redis-1y1hj-s1.marathon.mesos.

  ;; ADDITIONAL SECTION:
  redis-1y1hj-s1.marathon.mesos. 60 IN  A 10.0.0.43
  ~~~~

   So we now know that our redis app is running on 10.0.0.43:30585.

    * [Named Vips](https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/) allow you to assign name/port pairs to your apps.
    For example the package defintion for our redis service contains the following label:

    ~~~
    "VIP_0": "/redis:6379"
    ~~~

    The full name is then generated using the following schema:
    *vip-name.scheduler.l4lb.thisdcos.directory:vip-port*. Hence, we can use *redis.marathon.l4lb.thisdcos.directory:6379 to reach our redis service from within the cluster.

# Outcome
We explored how service-discovery enables us to find our tasks within the DC/OS cluster.

# Deep Dive
So what are the differences between Mesos-DNS and Named VIPs?
Mesos-DNS is a rather simple solution to find applications inside the cluster and DNS is supported by many applications.
But DNS entries have several disadvantages, including:

  * DNS-Caching: Applications might cache DNS entries for efficiency and  hence not use an updated address information (e.g., after a task failure).
  * SRV Records: We have seen that in order to retrieve information about the allocated ports we need to utilize SRV DNS records. Even though DNS A records are commonly understood by applications, not all applications can deal with SRV records.

Named VIPs actually load-balance the IP address port pair, and hence also redirects to the current instance in cases where the applications cached the IP address. Furthermore, they allow you to select a port as well. Hence, you should consider Named VIPs are the default option for service discovery in DC/OS.
