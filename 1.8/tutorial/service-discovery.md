
# Challenge
In the previous part we used `redis.marathon.l4lb.thisdcos.directory:6379` as address for connecting our webapp to redis. Redis could be running on any agent in the cluster (and on different ports...), who is this resolved?

# Steps
  This is called service discovery and is very important as we actually want to be ignorant (at least most of the times) about where our apps are running.
  MesosDNS and named virtual IPs.
  * SSH into cluster `dcos node ssh --master-proxy --leader`
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

    DNS in DC/OS: https://dcos.io/docs/1.8/usage/service-discovery/mesos-dns/
    Mesos-DNS Website: http://mesosphere.github.io/mesos-dns/
    Names VIPs: https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/
