---
post_title: DNS Quick Reference
nav_title: DNS Reference
menu_order: 20
---

This quick reference provides a summary of the available options.

To help explain, we'll use this imaginary application:

* The Service is in the following hierarchy:
 * Group: `outergroup` > Group: `subgroup` > Service Name: `myapp`
* Port: `555`
 * Port Name: `myport`
 * Load Balanced
* Running on a [Virtual Network](/docs/1.8/usage/service-discovery/load-balancing-vips/overlay-networks/)
* Running on the Marathon framework (if unsure, it's probably this one)
 * If you are running another framework, then replace any instance of `marathon` with the name of your framework.

# Service Discovery Options

Use one of these options to find the DNS name for your task.
You should choose the first option that satisfies your requirements:

1.  `outergroupsubgroupmyapp.marathon.l4lb.thisdcos.directory:555`
 * This is only available when the service is load balanced. `:555` is not a part of the DNS address, but is there to show that this address and port is load balanced as a pair rather than individually.
1.  `myapp-subgroup-outergroup.marathon.containerip.dcos.thisdcos.directory`
 * This is only available when the service is running on a [virtual network](/docs/1.8/usage/service-discovery/load-balancing-vips/overlay-networks/).
1.  `myapp-subgroup-outergroup.marathon.agentip.dcos.thisdcos.directory`
 * This is always available and should be used when the service is not running on a [virtual network](/docs/1.8/usage/service-discovery/load-balancing-vips/overlay-networks/).
1.  `myapp-subgroup-outergroup.marathon.autoip.dcos.thisdcos.directory`
 * This is always available and should be used to address an application that is transitioning on or off a [virtual network](/docs/1.8/usage/service-discovery/load-balancing-vips/overlay-networks/).
1.  `myapp-subgroup-outergroup.marathon.mesos`
 * This is always available, and is equivalent for the most part to the `agentip`. However it is less specific and less performant than the `agentip` and thus use is discouraged.

Other discovery option(s):

* `_myport._myapp.subgroup.outergroup._tcp.marathon.mesos`
 * This is not a DNS A record but rather a DNS SRV record. This is only available when the port has a name. SRV records are a mapping from a
   name to an "Address + Port" pair.
