---
post_title: Service Discovery and Load Balancing in DC/OS
nav_title: Service Discovery
menu_order: 3
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->
In a dynamic environment, actually discovering where a service is currently running is difficult. There are many different ways to go about this, but we strongly recommend using [VIPs][1].

You can check out our deep dive on how we've implemented [VIPs and L4 load balancing][4]. This solution really makes working with services on DC/OS easy.

# How do my services talk to each other?

When creating a service, you have the opportunity to assign a VIP (IP:PORT) that your service can be reached at. Check out the [VIP][1] documentation for some details on how to do that.

# What if I don't have a VIP configured?

Mesos-DNS creates a well known DNS name for every task that runs on DC/OS. You can either take a look at [DNS naming][5] for a quick way to find your service's DNS entry or take a look at the [deep-dive][2] for an overview.

If you're unable to use Mesos-DNS or VIPs, you can use a [load balanced solution][3].

[1]: virtual-ip-addresses/
[2]: mesos-dns/
[3]: marathon-lb/
[4]: load-balancing/
[5]: dns-naming/
