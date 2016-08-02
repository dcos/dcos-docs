---
nav_title: IP-per-Container
post_title: Configuring IP-per-Container in Overlay Networks
menu_order: 10
---

The overlay network feature is enabled by default in DC/OS. The default configuration provides an overlay network, `dcos`, whose YAML configuration is as follows:

```yaml
  dcos_overlay_network:
    vtep_subnet: 44.128.0.0/20
    vtep_mac_oui: 70:B3:D5:00:00:00
    overlays:
      - name: dcos
        subnet: 9.0.0.0/8
        prefix: 26
```

**Note:** Use a recent Linux kernel (3.9 or later) and Docker version 1.11 or later on the agent nodes.

Each overlay network is identified by a canonical `name` (see [limitations](#limitations) for constraints on naming overlay networks). Containers launched on an overlay network will get an IP address from the subnet allocated to the overlay network. To remove the dependency on a global IPAM, the overlay subnet is further split into smaller subnets. Each of the smaller subnets is allocated to an agent. The agents can then use a host-local IPAM to allocate IP addresses from their respective subnets to containers launched on the agent and attached to the given
overlay. The `prefix` determines the size of the subnet (carved from the overlay subnet) allocated to each agent and thus defines the number of agents on which the overlay can run.

In the default configuration above each overlay network is allocated a /8 subnet (in the “subnet” field), which is then divided into /26 container subnets to be used on each host that will be part of the network (in the “prefix” field) as shown:

![Overlay network address space](/docs/1.8/administration/overlay-networks/img/overlay-network-address-space.png)

The bits reserved for ContainerID (6 in this example) are then subdivided into two equal groups (of 5 bits in this example) that are used for Mesos containers and Docker containers respectively. With the default configuration each agent will be able to host a maximum of 2^5=32 Mesos containers and 32 docker containers. It is important to note that with this specific configuration, if a framework tries to launch more than 32 tasks on the Mesos containerzier or the Docker containerizer, it will result in a TASK_FAILURE. Please read the [limitations](#limitations) to understand more about this constraint in the system.

These values can be configured to adapt to each installation’s needs. You can also add more overlay networks in addition to the default one, or modify/delete the existing overlay network. It is important to note that currently the addition/deletion of an overlay network is supported only at the time of installation. The next section describes how you can add more overlay networks to the existing default configuration.

# Adding overlay networks during installation

DC/OS overlay networks can only be added and configured at install time. To replace or add another overlay network, [reinstall DC/OS according to these instructions](#replace).

You can override the default network or add additional overlay networks by modifying your `config.yaml` file:

```yaml
    agent_list:
    - 10.10.0.117
    - 10.10.0.116
    # Use this bootstrap_url value unless you have moved the DC/OS installer assets.
    bootstrap_url: file:///opt/dcos_install_tmp
    cluster_name: &lt;cluster-name&gt;
    master_discovery: static
    master_list:
    - 10.10.0.120
    - 10.10.0.119
    - 10.10.0.118
    resolvers:
    # You probably do not want to use these values since they point to public DNS servers.
    # Instead use values that are more specific to your particular infrastructure.
    - 8.8.4.4
    - 8.8.8.8
    ssh_port: 22
    ssh_user: centos
    dcos_overlay_network:
      vtep_subnet: 44.128.0.0/20
      vtep_mac_oui: 70:B3:D5:00:00:00
      overlays:
        - name: dcos
          subnet: 9.0.0.0/8
          prefix: 26
        - name: dcos-1
          subnet: 192.168.0.0/16
          prefix: 24
```

In the above example, we have defined two overlay networks. The overlay network `dcos` retains the default overlay network, and we have added another overlay network called `dcos-1` with subnet range `192.168.0.0/16`. When you create a network, you must give it a name and a subnet. That name is used to launch Marathon tasks and other Mesos framework tasks using this specific overlay network. Due to restrictions on the size of the Linux device names the overlay network name has to be less than thirteen characters. Please go through the [limitations](#limitations] section to learn more about the reasoning behind this limitation.

# Retrieving overlay network state

After the DC/OS installation is complete you can query the overlay network configuration using the `https://leader.mesos/overlay-master/state` endpoint from within the cluster. The `network` key at the bottom lists the current overlay configuration and the `agents` key is a list showing how overlays are split across the Mesos agents. The following shows the network state when there is a single overlay in the cluster named `dcos`.

```json
"agents": [
        {
            "ip": "10.10.0.120",
            "overlays": [
                {
                    "backend": {
                        "vxlan": {
                            "vni": 1024,
                            "vtep_ip": "198.15.0.1/20",
                            "vtep_mac": "70:b3:d5:0f:00:01",
                            "vtep_name": "vtep1024"
                        }
                    },
                    "docker_bridge": {
                        "ip": "44.128.0.128/25",
                        "name": "d-dcos"
                    },
                    "info": {
                        "name": "dcos",
                        "prefix": 24,
                        "subnet": "44.128.0.0/16"
                    },
                    "state": {
                        "status": "STATUS_OK"
                    },
                    "subnet": "44.128.0.0/24"
                }
            ]
        },
        {
            "ip": "10.10.0.118",
            "overlays": [
                {
                    "backend": {
                        "vxlan": {
                            "vni": 1024,
                            "vtep_ip": "198.15.0.2/20",
                            "vtep_mac": "70:b3:d5:0f:00:02",
                            "vtep_name": "vtep1024"
                        }
                    },
                    "docker_bridge": {
                        "ip": "44.128.1.128/25",
                        "name": "d-dcos"
                    },
                    "info": {
                        "name": "dcos",
                        "prefix": 24,
                        "subnet": "44.128.0.0/16"
                    },
                    "state": {
                        "status": "STATUS_OK"
                    },
                    "subnet": "44.128.1.0/24"
                }
            ]
        },
        {
            "ip": "10.10.0.119",
            "overlays": [
                {
                    "backend": {
                        "vxlan": {
                            "vni": 1024,
                            "vtep_ip": "198.15.0.3/20",
                            "vtep_mac": "70:b3:d5:0f:00:03",
                            "vtep_name": "vtep1024"
                        }
                    },
                    "docker_bridge": {
                        "ip": "44.128.2.128/25",
                        "name": "d-dcos"
                    },
                    "info": {
                        "name": "dcos",
                        "prefix": 24,
                        "subnet": "44.128.0.0/16"
                    },
                    "state": {
                        "status": "STATUS_OK"
                    },
                    "subnet": "44.128.2.0/24"
                }
            ]
        }
    ],
"network": {
        "overlays": [
            {
                "name": "dcos",
                "prefix": 24,
                "subnet": "44.128.0.0/16"
            }
        ],
        "vtep_mac_oui": "70:B3:D5:00:00:00",
        "vtep_subnet": "198.15.0.0/20"
    }
}
```

# Deleting Overlay Networks

To delete your overlay network, uninstall DC/OS, then delete the overlay replicated log on the master nodes and the iptable rules on the agent nodes that are associated with the overlay networks.

## The Replicated Log

DC/OS overlay uses a replicated log to persist the overlay network state across Mesos master reboots and to recover overlay state when a new Mesos master is elected. The overlay replicated log is stored at `/var/lib/dcos/mesos/master/overlay_replicated_log`. The overlay replicated log is **not** removed when DC/OS is uninstalled from the cluster, so you need to delete this log manually before reinstalling DC/OS. Otherwise, the Mesos master will try to reconcile the existing overlay replicated log during startup and will fail if it finds an overlay network that was not configured.

**Note:** The overlay replicated log is different from the [master's replicated log](http://mesos.apache.org/documentation/latest/replicated-log-internals/), which is stored at /var/lib/mesos/master/replicated_log. Removing the *overlay* replicated log will have no effect on the master's recovery semantics.

## iptables
The overlay networks install IPMASQ rules in order to allow containers to talk outside the overlay network. When you delete or replace overlay networks, you must remove the rules associated with the previous overlay networks. To remove the IPMASQ rules associated with each overlay, remove the IPMASQ rule from the POSTROUTING change of the NAT table that corresponds to the overlay networks subnet. Remove these rules on each agent node.

<a name="replace"></a>
# Replacing or Adding New Overlay Networks

To replace your overlay network, uninstall DC/OS and delete the replicated log on the master nodes and the iptable rules on the agent nodes. Then, reinstall with the desired networks specified in your `config.yaml` file.

<a name="limitations"></a>
# Limitations
* The DC/OS overlay network does not allow frameworks to reserve IP addresses that result in ephemeral addresses for containers across multiple incarnations on the overlay network. This restriction ensures that a given client connects to the correct service even if they have cached their DNS request.

  [VIPs (virtual IP addresses)](/docs/1.8/usage/service-discovery/load-balancing-vips/) are built in to DC/OS and offer a clean way of allocating static addresses to services. If you are using overlay networks, you should use VIPs to access your services.

* In DC/OS overlay we slice the subnet of an overlay network into smaller subnets and allocate these smaller subnets to agents. When an agent has exhausted its allocated address range and a framework tries to launch a container on the overlay network on this agent, the container launch will fail, leading to a TASK_FAILED message to the framework.

  Since there is no API to report the exhaustion of addresses on an agent, it is up to the framework to infer that containers cannot be launched on an overlay network due to lack of IP addresses on the agent. This limitation has a direct impact on the behavior of frameworks, such as Marathon, that try to launch "services" with a specified number of instances. Due to this limitation, frameworks such as Marathon might not be able to complete their obligation of launching a service on an overlay network if they repeatedly try to launch instances of a service on an agent that has exhausted its allocated IP address range.

  Keep this limitation in mind when debugging issues on frameworks that use an overlay network and see the `TASK_FAILED` message.

* The DC/OS overlay network uses Linux bridge devices on agents to connect Mesos and Docker containers to the overlay network. The names of these bridge devices are derived from the overlay network name. Since Linux has a limitation of fifteen characters on network device names, there is a character limit of thirteen characters for the overlay network name (two characters are used to distinguish between a CNI bridge and a Docker bridge on the overlay network).

* Certain names are reserved and cannot be used as DC/OS overlay network names, primarily because DC/OS overlay uses Docker networking underneath to connect Docker containers to the overlay, which in turn reserves certain network names. The reserved names are: `host`, `bridge` and `default`.

# Troubleshooting

The **Networking** tab of the DC/OS web interface provides information helpful for troubleshooting. You can see which containers are on which network and see their IP addresses.

