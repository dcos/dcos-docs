---
nav_title: Configuring IP-per-Container
post_title: Configuring IP-per-Container in Virtual Networks
feature_maturity: preview
menu_order: 10
---

The virtual network feature is enabled by default in DC/OS. The default configuration of DC/OS provides an virtual network, `dcos`, whose YAML configuration is as follows:

```yaml
  dcos_overlay_network:
    vtep_subnet: 44.128.0.0/20
    vtep_mac_oui: 70:B3:D5:00:00:00
    overlays:
      - name: dcos
        subnet: 9.0.0.0/8
        prefix: 26
```

Each virtual network is identified by a canonical `name` (see [limitations](/docs/1.8/administration/virtual-networks/) for constraints on naming virtual networks). Containers launched on an virtual network get an IP address from the subnet allocated to the virtual network. To remove the dependency on a global IPAM, the overlay subnet is further split into smaller subnets. Each of the smaller subnets is allocated to an agent. The agents can then use a host-local IPAM to allocate IP addresses from their respective subnets to containers launched on the agent and attached to the given
overlay. The `prefix` determines the size of the subnet (carved from the overlay subnet) allocated to each agent and thus defines the number of agents on which the overlay can run.

In the default configuration above each virtual network is allocated a /8 subnet (in the “subnet” field), which is then divided into /26 container subnets to be used on each host that will be part of the network (in the “prefix” field) as shown:

![Virtual network address space](/docs/1.8/administration/virtual-networks/img/overlay-network-address-space.png)

The bits reserved for ContainerID (6 in this example) are then subdivided into two equal groups (of 5 bits in this example) that are used for Mesos containers and Docker containers respectively. With the default configuration, each agent will be able to host a maximum of 2^5=32 Mesos containers and 32 docker containers. With this specific configuration, if a service tries to launch more than 32 tasks on the Mesos containerizer or the Docker containerizer, it will receive a `TASK_FAILED`. Consult the [limitations](/docs/1.8/administration/virtual-networks/) section of the main Virtual Networks page to learn more about this constraint.

You can modify the default virtual network configuration and add more virtual networks to fit your needs. Currently, you can only add or delete an virtual network at install time. The next section describes how you can add more virtual networks to the existing default configuration.

# Adding virtual networks during installation

DC/OS virtual networks can only be added and configured at install time. To replace or add another virtual network, [reinstall DC/OS according to these instructions](#replace).

You can override the default network or add additional virtual networks by modifying your `config.yaml` file:

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

In the above example, we have defined two virtual networks. The virtual network `dcos` retains the default virtual network, and we have added another virtual network called `dcos-1` with subnet range `192.168.0.0/16`. When you create a network, you must give it a name and a subnet. That name is used to launch Marathon tasks and other Mesos framework tasks using this specific virtual network. Due to restrictions on the size of Linux device names, the virtual network name must be less than thirteen characters. Consult the [limitations](/docs/1.8/administration/virtual-networks/) section of the main Virtual Networks page to learn more.

# Retrieving virtual network state

After DC/OS installation is complete, you can query the virtual network configuration using the `https://leader.mesos/overlay-master/state` endpoint from within the cluster. The `network` key at the bottom lists the current overlay configuration and the `agents` key is a list showing how overlays are split across the Mesos agents. The following shows the network state when there is a single overlay in the cluster named `dcos`.

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

# Deleting Virtual Networks

To delete your virtual network, uninstall DC/OS, then delete the overlay replicated log on the master nodes and the iptable rules on the agent nodes that are associated with the virtual networks.

## The Replicated Log

DC/OS overlay uses a replicated log to persist the virtual network state across Mesos master reboots and to recover overlay state when a new Mesos master is elected. The overlay replicated log is stored at `/var/lib/dcos/mesos/master/overlay_replicated_log`. The overlay replicated log is **not** removed when DC/OS is uninstalled from the cluster, so you need to delete this log manually before reinstalling DC/OS. Otherwise, the Mesos master will try to reconcile the existing overlay replicated log during startup and will fail if it finds an virtual network that was not configured.

**Note:** The overlay replicated log is different from the [master's replicated log](http://mesos.apache.org/documentation/latest/replicated-log-internals/), which is stored at /var/lib/mesos/master/replicated_log. Removing the *overlay* replicated log will have no effect on the master's recovery semantics.

## iptables
The virtual networks install IPMASQ rules in order to allow containers to talk outside the virtual network. When you delete or replace virtual networks, you must remove the rules associated with the previous virtual networks. To remove the IPMASQ rules associated with each overlay, remove the IPMASQ rule from the POSTROUTING change of the NAT table that corresponds to the virtual networks subnet. Remove these rules on each agent node.

<a name="replace"></a>
# Replacing or Adding New Virtual Networks

To replace your virtual network, uninstall DC/OS and delete the replicated log on the master nodes and the iptable rules on the agent nodes. Then, reinstall with the desired networks specified in your `config.yaml` file.

# Troubleshooting

The **Networking** tab of the DC/OS web interface provides information helpful for troubleshooting. You can see which containers are on which network and see their IP addresses.

