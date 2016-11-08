
---
post_title: DC/OS 101 - Understanding Ressources
menu_order: 3
---

# Prerequisites
We expect you to have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, you have just deployed app2 and marathon-lb in our cluster and have verified both are running.

# Objective
When scaling an app how is decided which app we should talk to?

# Steps
  This is the topic of load balancing. With DC/OS you have two different in-built options: Marathon-lb and named vips.
  We have seen both before in the context of service discovery and especially marathon-lb while making app2 publically available.
  * Scale app2 to two instances: `dcos marathon app update /dcos-101/app2 instances=2`
  * Marathon-lb
      * Check the webapp as before via http://<public-node>:10000, when doing this repeatedly you should see the request being served by different instances (see host:port pairs)
      * Check the logs `dcos task log app2` TODO merge logging into master
      * You can also check the stats via `http://<public-node>:9090/haproxy?stats`
  * Named VIPs
      * We have seen named vips before for service discovery inside our cluster
      * SSH to master `dcos node ssh --master-proxy --leader`
      * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`, when doing this repeatedly you should see the request being served by different instances (see host:port pairs)
      * Check the logs `dcos task log app2` TODO merge logging into master
  * Scale app2 back to one instance: `dcos marathon app update /dcos-101/app2 instances=1`



# Outcome
 We understand the meaning of allocated vs used resources and how to debug issues related to memory allocation.

# Deep Dive
   Differences between between both options, when to use what.
   * Marathon-lb layer 7 : External
   * Named VIPS layer 4 LB: Internal
   * TODO Add [picture](https://mesosphere.com/blog/2015/12/04/dcos-marathon-lb)
