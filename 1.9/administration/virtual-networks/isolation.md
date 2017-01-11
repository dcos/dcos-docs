---
nav_title: Isolation
post_title: Configuring Isolation in Virtual Networks
feature_maturity: preview
menu_order: 20
---

You can create multiple virtual networks to isolate different portions of your organization, for instance, development, marketing, and production.

# iptables rules

DC/OS uses [iptables](http://linux.die.net/man/8/iptables) to set up virtual network isolation. iptables are a high-speed, built-in mechanism for filtering traffic in Linux systems. We recommend configuring filtering by deploying a homogenous set of rules to all nodes in your infrastructure. In order to simplify this, we also recommend using the [ipset](http://ipset.netfilter.org/ipset.man.html) feature of iptables.

Set up your own chain that jumps from the `FORWARD` chain. You can do this by running the following command:

    $ iptables -N dcos-isolation

We want to set up a default deny or a default accept policy between filtered overlays. To set up default deny, run the following:

    $ iptables -A dcos-isolation -j REJECT

To set up default accept, run the following:

    $ iptables -A dcos-isolation -j RETURN

To make troubleshooting easier, use the `REJECT` directive as opposed to the `DROP` directive. The default is to allow all.

Use ipset to get onto the isolation chain. Create a `hash:net` type ipset named `overlays` that has all of the virtual networks that you want to restrict traffic from, or to. Then insert the rule:

    $ iptables -I FORWARD -m set --match-set overlays src -m set --match-set overlays dst -j dcos-isolation

This rule says that if a given packet is from any of the overlays and is destined to any other overlay, send it to the `dcos-isolation` rule. In most environments, the system does not prevent an virtual network's outbound packets from reentering the same virtual network. To prevent this, add an exception set of type `hash:net,net` and add entries for networks that should not be filtered. Modify the rule to:

    $ iptables -I FORWARD -m set --match-set overlays src -m set --match-set overlays dst -m set ! --match-set src,dst overlay-exceptions -j dcos-isolation

The actual iptables rules that live on the `dcos-isolation` chain are simple rules. For organization, use ipsets of type `hash:net` and refer to `src` sets and `dest` sets.

**Note:** Future versions of DC/OS may automatically create the overlay ipsets. Network names prefixed with `dcos-` and `mesos-` are therefore reserved and should not be used.

# Example

In this example, the user has created two virtual networks, "IT" and "HR", and wants isolation according to the following rules:

* HR apps can connect to IT apps.
* IT apps cannot connect to HR apps. 
* All IT apps can communicate amongst themselves.
* All HR apps can communicate amongst themselves.

IT only runs apps on port 80. Assume an HR overlay with the agent subnets carved from `192.168.0.0/16` and an IT subnet carved from `10.150.0.0/16`.

First, create the sets you need:

    $ iptables -N dcos-isolation
    $ iptables -A dcos-isolation -j REJECT # Changes it to default reject
    $ ipset create it hash:net
    $ ipset create hr hash:net
    $ ipset create overlays list:set

Next, define the subnets and policies:

    $ ipset add it 10.250.0.0/16
    $ ipset add hr 192.168.0.0/16
    $ ipset create simple_allowed hash:net,net
    $ ipset create complex_allowed hash:net,port,net
    $ iptables -I FORWARD -m set --match-set overlays src -m set --match-set overlays dst -j dcos-isolation
    $ iptables -A dcos-isolation -m set --match-set simple_allowed src,dst -j RETURN

Then, allow traffic going from HR and allow bidirectional connections:

    $ iptables -A dcos-isolation -m set --match-set complex_allowed src,dst,dst -j RETURN
    $ iptables -A dcos-isolation -m conntrack --ctstate RELATED,ESTABLISHED -j RETURN

Create hairpin exception rules:

    $ iptables -I dcos-isolation -m set --match-set it src -m set --match-set it dst -j RETURN
    $ iptables -I dcos-isolation -m set --match-set hr src -m set --match-set hr dst -j RETURN
    $ ipset add simple_allowed 192.168.0.0./16,192.168.0.0./16
    $ ipset add simple_allowed 10.250.0.0/16,10.250.0.0/16
    $ ipset add complex_allowed 192.168.0.0/16,80,10.250.0.0/16 #this allows traffic from HR to IT on port 80

Debug with these commands:

    $ iptables -L -v -n
    $ iptables -I dcos-isolation -j TRACE
