---
post_title: Upgrading
menu_order: 2.5
---

## Summary

This document provides instructions for upgrading a DC/OS cluster from version 1.8 to 1.9. If this upgrade is performed on a supported OS with all prerequisites fulfilled, this upgrade _should_ preserve the state of running tasks on the cluster.  This document reuses portions of the [Advanced DC/OS Installation Guide][advanced-install].

**Important:**

- Review the [release notes](https://dcos.io/releases/) before upgrading DC/OS.
- The Advanced Installation method is the _only_ recommended upgrade path for DC/OS. It is recommended that you familiarize yourself with the [Advanced DC/OS Installation Guide][advanced-install] before proceeding.
- The [VIP features](/docs/1.9/usage/service-discovery/load-balancing-vips/virtual-ip-addresses/), added in DC/OS 1.8, require that ports 32768 - 65535 are open between all agent and master nodes for both TCP and UDP.
- Virtual networks require minimum Docker version 1.11. For more information, see the [documentation](/docs/1.9/administration/virtual-networks/).
- The DC/OS UI and APIs may be inconsistent or unavailable while masters are being upgraded. Avoid using them until all masters have been upgraded and have rejoined the cluster. You can monitor the health of a master during an upgrade by watching Exhibitor on port 8181.
- Task history in the Mesos UI will not persist through the upgrade.

## Prerequisites

- Mesos, Mesos Frameworks, Marathon, Docker and all running tasks in the cluster should be stable and in a known healthy state.
- For Mesos compatibility reasons, we recommend upgrading any running Marathon-on-Marathon instances on DC/OS 1.8 to Marathon version 1.3.5 before upgrading to DC/OS 1.9.
- You must have access to copies of the config files used with DC/OS 1.8: `config.yaml` and `ip-detect`.
- You must be using systemd 218 or newer to maintain task state.
- All hosts (masters and agents) must be able to communicate with all other hosts on all ports, for both TCP and UDP.
- In CentOS or RedHat, install IP sets with this command (used in some IP detect scripts): `$ sudo yum install -y ipset`
- You must be familiar with using `systemctl` and `journalctl` command line tools to review and monitor service status. Troubleshooting notes can be found at the end of this [document](#troubleshooting).
- You must be familiar with the [Advanced DC/OS Installation Guide][advanced-install].
- You should take a snapshot of ZooKeeper prior to upgrading. Marathon supports rollbacks, but does not support downgrades.
- The full DC/OS version string that you are upgrading from.
  - In 1.8 this can be found in the lower left corner of the DC/OS UI when screen is maximized.
  - In 1.9 this can be found under the Cluster menu.

## Supported Upgrade Paths

- 1.8.latest => 1.9.latest
- 1.9.x => 1.9.(x+1)
- 1.9.x => 1.9.x (for configuration changes)

## Instructions

### Bootstrap Nodes

1.  Copy and update the DC/OS 1.8 `config.yaml` and `ip-detect` files to a new, clean folder on your bootstrap node.

    **Important:**

    *  You cannot change the `exhibitor_zk_backend` setting during an upgrade.
    *  The syntax of the DC/OS 1.9 `config.yaml` differs from that of DC/OS 1.8. For a detailed description of the 1.9 `config.yaml` syntax and parameters, see the [documentation](/docs/1.9/administration/installing/custom/configuration-parameters/).

1.  After you have converted your 1.8 `config.yaml` into the 1.9 `config.yaml` format, you can build your installer package:

    1.  Download the file `dcos_generate_config.sh`.
    1.  Generate the installation files. Replace `<installed_cluster_version>` in the below command with the DC/OS version currently running on the cluster you intend to upgrade, for example `1.8.8`.
        ```bash
        $ dcos_generate_config.sh --generate-node-upgrade-script <installed_cluster_version>
        ```
    1.  The command in the previous step will produce a URL in the last line of its output, prefixed with `Node upgrade script URL:`. Record this URL for use in later steps. It will be referred to in this document as the "Node upgrade script URL".
    1.  Run the [nginx][advanced-install] container to serve the installation files.

### DC/OS Masters

Proceed with upgrading every master node one-at-a-time in any order using the following procedure. When you complete each upgrade, monitor the Mesos master metrics to ensure the node has rejoined the cluster and completed reconciliation.

1.  Download and run the node upgrade script:

    ```
    $ curl -O <Node upgrade script URL>
    $ sudo bash ./dcos_node_upgrade.sh
    ```

1.  Validate the upgrade:

    - Monitor the Exhibitor UI to confirm that the Master rejoins the ZooKeeper quorum successfully (the status indicator will turn green).  The Exhibitor UI is available at `http://<dcos_master>:8181/`.
    - Verify that `curl http://<dcos_master_private_ip>:5050/metrics/snapshot` has the metric `registrar/log/recovered` with a value of `1`.
    - Verify that `http://<dcos_master>/mesos` indicates that the upgraded master is running Mesos 1.2.0.

### DC/OS Agents

Proceed with upgrading every agent in any order. Agent upgrades can be parallelized with a few caveats. During an upgrade the Mesos agent will go offline briefly (tasks will continue to run) and load on the Master nodes will increase slightly and proportional to the number of Agents rejoining the cluster. For maximum service availability it is recommended to upgrade Agents one at a time and only perform parallel upgrades if the larger upgrade batch size has been well tested with the same workload.

### On all DC/OS Agents:

1.  Download and run the node upgrade script:
    ```
    $ curl -O <Node upgrade script URL>
    $ sudo bash dcos_node_upgrade.sh
    ```

1.  Validate the upgrade:

    - Verify that `curl http://<dcos_agent_private_ip>:5051/metrics/snapshot` has the metric `slave/registered` with a value of `1`.
    - Monitor the Mesos UI to verify that the upgraded node rejoins the DC/OS cluster and that tasks are reconciled (`http://<dcos_master>/mesos`).

## <a name="troubleshooting"></a>Troubleshooting Recommendations

The following commands should provide insight into upgrade issues:

### On All Cluster Nodes

```
$ sudo journalctl -u dcos-download
$ sudo journalctl -u dcos-spartan
$ sudo systemctl | grep dcos
```

### On DC/OS Masters

```
$ sudo journalctl -u dcos-exhibitor
$ less /var/lib/dcos/exhibitor/zookeeper/zookeeper.out
$ sudo journalctl -u dcos-mesos-dns
$ sudo journalctl -u dcos-mesos-master
```

### On DC/OS Agents

```
$ sudo journalctl -u dcos-mesos-slave
```

## Notes:

- Packages available in the DC/OS 1.9 Universe are newer than those in the DC/OS 1.8 Universe. Services are not automatically upgraded when DC/OS 1.9 is installed because not all DC/OS services have upgrade paths that will preserve existing state.

[advanced-install]: /docs/1.9/administration/installing/custom/advanced/
