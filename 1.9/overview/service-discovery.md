---
post_title: Service Discovery
menu_order: 8
---

There are two levels of service discovery in DC/OS. Along with every task that runs on DC/OS being provided a well known DNS name, anyone can request a well known VIP that enables clients to have a single configuration value.

# VIPs

You can assign a VIP or VIPs to one of your services by following the steps in the [Service Discovery][1] section.

# Mesos-DNS

Every task started by DC/OS gets a well known DNS name. You can even enumerate every [DNS name][5] in your cluster. For a Marathon service named "testing", you can find where it is running via:

        dig testing.marathon.mesos

Take a look at the [mesos-DNS documentation][4] for a more in-depth look at how Mesos-DNS is working and what it is doing for you.

[1]: /docs/1.9/usage/service-discovery/
[4]: /docs/1.9/usage/service-discovery/mesos-dns/
[5]: /docs/1.9/usage/service-discovery/mesos-dns/service-naming/
