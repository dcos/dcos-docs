
---
post_title: DC/OS 101 - Connecting Apps/Service Discovery
menu_order: 3
---

# Prerequisites
We expect you to have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, we expect you have just deployed app1 in the previous step of this tutorial.

# Objective
Our application in the previous part used`redis.marathon.l4lb.thisdcos.directory:6379` as address for connecting to redis. As redis might be running on any agent in the cluster (and furthermore on different ports), how does this address link to the actual running redis instance?

# Steps
  This is called service discovery and is very important as we actually want to be ignorant (at least most of the times) about where our apps are running.
  DC/OS provides two options for serive discover: Mesos DNS and named virtual IPs.
  * Let us shh into our cluster and see how this works: `dcos node ssh --master-proxy --leader`
  * MesosDNS
     * Automatically for every marathon app, pattern `<task>.<scheduler>.mesos` where the default scheduler for jobs is `marathon`
     * Use dig to retrieve the A-record `dig redis.marathon.mesos`
      * A Record gives us only the host, what about the port? SRV records `dig srv _redis._tcp.marathon.mesos`
  * Named Vips: You can give your apps also custom name/port pairs.
    * So where does the magic `redis.marathon.l4lb.thisdcos.directory:6379` come from?
    `<vip-name>.<scheduler>.l4lb.thisdcos.directory:<vip-port>`

# Outcome
 We understood how apps can be found in the cluster.

# Deep Dive
        * Tradeoffs in service discovery
            * When to use which method for service discovery
            * Enumerate all MesosDNS tasks: `curl -s -f http://master.mesos:8123/v1/enumerate`

            Mesos-DNS Resources

   [Mesos DNS in DC/OS](https://dcos.io/docs/1.8/usage/service-discovery/mesos-dns/)
    Mesos-DNS Website: http://mesosphere.github.io/mesos-dns/
    Names VIPs: https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/
