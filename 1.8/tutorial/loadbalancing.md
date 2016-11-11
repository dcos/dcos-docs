---
post_title: Load-balancing
nav_title: Load-balancing
menu_order: 8
---

# Prerequisites
In order to get started with this tutorial, you should have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, you have just deployed app2 and marathon-lb in our cluster and have verified both are running.

# Objective
In the last session, we will scale our application to multiple instances, and learn how internal and external services chose which instance to use once our application has been scaled.

# Steps
Load-balancers decide which instance of an app internal or external services should use. With DC/OS you have two different built-in load-balancer options: : [Marathon-LB](https://dcos.io/docs/1.8/usage/service-discovery/marathon-lb/) and [Named virtual IPs](https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/).
We have seen both before in the context of service discovery and especially marathon-lb when making app2 publically available.
Now we will explore both options in more detail.
* Therefore we first scale app2 to two instances: `dcos marathon app update /dcos-101/app2 instances=2`
* Marathon-lb
    * Check the app2 as before via *http://public-node>10000*. When you do this repeatedly you should see the request being served by different instances of app2.
    * You can also check the marathon-lb stats via `http://<public-node>:9090/haproxy?stats`
* Named VIPs
    * We have seen named vips before for service discovery inside our cluster
    * SSH to the leading master node: `dcos node ssh --master-proxy --leader`
    * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`. When you do this repeatedly you should see the request being served by different instances.
* Scale app2 back to one instance: `dcos marathon app update /dcos-101/app2 instances=1`



# Outcome
We used two different methods to load-balance requests two different instances of our app.

# Deep Dive
With two options, we actually need to decide on one of them.

   * [Marathon-LB](https://dcos.io/docs/1.8/usage/service-discovery/marathon-lb/)  is a layer 7 load balancer that is mostly used for external requests. It is based on the well-known HAProxy load balancer, and uses Marathon’s event bus to update its configuration in real time. Being a layer 7 load balancer, it supports session based features such as HTTP sticky sessions and zero-downtime deployments.
   * [Named VIPS](https://dcos.io/docs/1.8/usage/service-discovery/load-balancing-vips/) is layer 4 load balancer used for internal TCP traffic. As it’s tightly integrated with the kernel, it provides a load-balanced IP address which can be used from anywhere within the cluster.


Furthermore, there are also other [3rd party solutions](https://dcos.io/docs/1.8/usage/service-discovery/third-party-solution/) that can provide load-balancing on top of DC/OS.
