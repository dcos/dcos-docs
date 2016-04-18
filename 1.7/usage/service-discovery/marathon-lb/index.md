---
post_title: Marathon-LB
---

After you boot a DC/OS cluster, all tasks can be discovered using Mesos-DNS. Discovery through DNS, however, has some limitations that include:

*   DNS does not identify service ports, unless you use an SRV query; most apps are not able to use SRV records "out of the box."
*   DNS does not have fast failover.
*   DNS records have a TTL (time to live) and Mesos-DNS uses polling to create the DNS records; this can result in stale records.
*   DNS records do not provide any service health data.
*   Some applications and libraries do not correctly handle multiple A records; in some cases the query might be cached and not correctly reloaded as required.

For many applications, you can address these concerns with [VIPs][1]. For those that are unable to take advantage of VIPS, we provide a tool for Marathon called Marathon Load Balancer, or marathon-lb for short.

Marathon-lb is based on HAProxy, a rapid proxy and load balancer. HAProxy provides proxying and load balancing for TCP and HTTP based applications, with features such as SSL support, HTTP compression, health checking, Lua scripting and more. Marathon-lb subscribes to Marathon’s event bus and updates the HAProxy configuration in real time.

You can can configure marathon-lb with various topologies. Here are some examples of how you might use marathon-lb:

*   Use marathon-lb as your edge load balancer and service discovery mechanism. You could run marathon-lb on public-facing nodes to route ingress traffic. You would use the IP addresses of your public-facing nodes in the A-records for your internal or external DNS records (depending on your use-case).
*   Use marathon-lb as an internal LB and service discovery mechanism, with a separate HA load balancer for routing public traffic in. For example, you may use an external F5 load balancer on-premise, or an Elastic Load Balancer on Amazon Web Services.
*   Use marathon-lb strictly as an internal load balancer and service discovery mechanism.
*   You might also want to use a combination of internal and external load balancers, with different services exposed on different load balancers.

Here, we discuss the fourth option above in order to highlight the features of marathon-lb.

![lb1](img/lb1.jpg)

# Next Steps

- [Getting Started][2]

[1]: ../virtual-ip-addresses/
[2]: usage/
