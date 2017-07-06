---
post_title: Load-Balancing
menu_order: 7
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.9/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.9/cli/install/).
* [app2 and Marathon-LB](/docs/1.9/tutorials/dcos-101/app2/) deployed and running in your cluster.

<table class="table" bgcolor="#FAFAFA"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Important:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is to demonstrate capabilities, and may not be suited for use in a production environment. Before using a similar solution in your environment, you must adapt, validate, and test.</td> </tr> </table>

# Objective
In this final session, you will scale your application to multiple instances and learn how internal and external services choose which instance to use once the application has been scaled.

# Steps
Load-balancers decide which instance of an app internal or external services should use. With DC/OS, you have two different built-in load-balancer options: [Marathon-LB](/docs/1.9/networking/marathon-lb/) and [Named VIPs](/docs/1.9/networking/load-balancing-vips/).
You have already explored these load balancers in the context of service discovery, when you used Marathon-LB to publicly expose app2. Now let's explore them a bit more.
* First, scale app2 to two instances: `dcos marathon app update /dcos-101/app2 instances=2`
* Marathon-LB
    * Check app2 as before via `http://<public-node>10000`. When you do this repeatedly you should see the request being served by different instances of app2.
    * You can also check the Marathon-LB stats via `http://<public-node>:9090/haproxy?stats`
* Named VIPs
    * SSH to the leading master node: `dcos node ssh --master-proxy --leader`
    * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`. When you do this repeatedly you should see the request being served by different instances.
* Scale app2 back to one instance: `dcos marathon app update /dcos-101/app2 instances=1`



# Outcome
You used Marathon-LB and VIPs to load balance requests for two different instances of your app.

# Deep Dive
Consider these features and benefits when choosing the load balancing options.

   * [Marathon-LB](/docs/1.9/networking/marathon-lb/) is a layer 7 load balancer that is mostly used for external requests. It is based on the well-known HAProxy load balancer and uses Marathon’s event bus to update its configuration in real time. Being a layer 7 load balancer, it supports session-based features such as HTTP sticky sessions and zero-downtime deployments.
   * [Named VIPs](/docs/1.9/networking/load-balancing-vips/) is layer 4 load balancer used for internal TCP traffic. As it’s tightly integrated with the kernel, it provides a load balanced IP address which can be used from anywhere within the cluster.
