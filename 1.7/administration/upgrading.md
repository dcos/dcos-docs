---
post_title: Upgrading
menu_order: 11
---

## Summary

This document provides instructions for upgrading a DC/OS cluster from version 1.6 to 1.7. If this upgrade is performed on a supported OS with all prerequisites fulfilled, this upgrade _should_ preserve the state of running tasks on the cluster.  This document reuses portions of the [Advanced DC/OS Installation Guide][advanced-install].

**Important:**

- Review the [release notes](https://dcos.io/releases/) before upgrading DC/OS.
- The Advanced Installation method is the _only_ recommended upgrade path for DC/OS. It is recommended that you familiarize yourself with the [Advanced DC/OS Installation Guide][advanced-install] before proceeding.
- The [VIP features](/docs/1.7/usage/service-discovery/virtual-ip-addresses/), added in DC/OS 1.7, require that ports 32768 - 65535 are open between all agent and master nodes for both TCP and UDP.
- The DC/OS UI and APIs may be inconsistent or unavailable while masters are being upgraded. Avoid using them until all masters have been upgraded and have rejoined the cluster. You can monitor the health of a master during an upgrade by watching Exhibitor on port 8181.
- Task history in the Mesos UI will not persist through the upgrade.

## Prerequisites

- Mesos, Mesos Frameworks, Marathon, Docker and all running tasks in the cluster should be stable and in a known healthy state.
- For Mesos compatibility reasons, we recommend upgrading any running Marathon-on-Marathon instances to version Marathon 0.16.0-RC3 before proceeding with this DC/OS upgrade.
- You must have access to copies of the config files used with DC/OS 1.6: `config.yaml` and `ip-detect`.
- You must be using systemd 218 or newer to maintain task state.
- All hosts (masters and agents) must be able to communicate with all other hosts on all ports, for both TCP and UDP.
- In CentOS or RedHat, install IP sets with this command (used in some IP detect scripts): `$ sudo yum install -y ipset`
- You must be familiar with using `systemctl` and `journalctl` command line tools to review and monitor service status. Troubleshooting notes can be found at the end of this [document](#troubleshooting).
- You must be familiar with the [Advanced DC/OS Installation Guide][advanced-install].

## Instructions

### Bootstrap Nodes

1.  Copy and update the DC/OS 1.6 `config.yaml` and `ip-detect` files to a new, clean folder on your bootstrap node.

    **Important:**

    *  You cannot change the `exhibitor_zk_backend` setting during an upgrade.
    *  The syntax of the DC/OS 1.7 `config.yaml` differs from that of DC/OS 1.6. For a detailed description of the 1.7 `config.yaml` syntax and parameters, see the [documentation](/docs/1.7/administration/installing/custom/configuration-parameters/).

1.  After you have merged your 1.6 `config.yaml` into the 1.7 `config.yaml` format, you can build your installer package:

    1.  Download the file `dcos_generate_config.sh`.
    1.  Generate the installation files.
    1.  Disable Docker restarts in `dcos_install.sh` by using this command:

        ```
        sed -i -e "s/systemctl restart systemd-journald//g" -e "s/systemctl restart docker//g" genconf/serve/dcos_install.sh
        ```

        **Important:** This step is critical to prevent task restarts.

    1.  Run the [NGINX][advanced-install] container to serve the installation files.

### DC/OS Masters

Identify the ZooKeeper leader among the masters. This node should be the last master node that you upgrade. You can determine whether a master node is a ZooKeeper leader by sending the `stat` command to the ZooKeeper client port.

```
$ echo stat | /opt/mesosphere/bin/toybox nc localhost 2181 | grep "Mode:"
```

Proceed with upgrading every master node using the following procedure. When you complete each upgrade, monitor the logs to ensure the node has rejoined the cluster and completed reconciliation.

1.  Download the `dcos_install.sh` script:

    ```
    $ curl -O <bootstrap_url>/dcos_install.sh
    ```

1.  Remove all of the DC/OS software packages:

    ```
    $ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
    ```

1.  Remove the DC/OS install and config directories:

    ```
    $ sudo rm -rf /opt/mesosphere /etc/mesosphere
    ```

1. Install DC/OS 1.7:

    ```
    $  sudo bash dcos_install.sh -d master
    ```

1.  Validate the upgrade

    - Monitor the Exhibitor UI to confirm that the Master rejoins the ZooKeeper quorum successfully (the status indicator will turn green).  The Exhibitor UI is available at `http://<dcos_master>:8181/`.
    - Verify that `http://<dcos_master>/mesos` indicates that the upgraded master is running Mesos 0.28.0.

### DC/OS Agents

**Important:** When reinstalling on agent nodes, there is a 75 second timeout for the agent to respond to health check pings from the mesos-masters before it is considered lost and its tasks are given up for dead.

### On all DC/OS Agents:

1.  Download the dcos_install.sh script:

    ```
    $ curl -O <bootstrap_url>/dcos_install.sh
    ```

1.  Remove all of the DC/OS software packages:

    ```
    $ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
    ```

1.  Remove the DC/OS install and config directories:

    ```
    $ sudo rm -rf /opt/mesosphere /etc/mesosphere
    ```

1.  The DC/OS installer discovers and combines your agent's configuration parameters into a file named `mesos-resources`. As a part of this process the available disk space of each node is calculated. If you have not made explicit disk size reservations, you must create a placeholder for the disk reservation file. This prevents the installer from building a new disk reservation file that might conflict with your stored agent metadata:

    ```
    $ sudo mkdir -p /var/lib/dcos
    $ sudo touch /var/lib/dcos/mesos-resources
    ```

1.  Install DC/OS 1.7:

    -  [Private](/docs/1.7/overview/concepts/#private) agents (default)

       ```
       $ sudo bash dcos_install.sh -d slave
       ```

    -  [Public](/docs/1.7/overview/concepts/#public) Agents

       ```
       $ sudo bash dcos_install.sh -d slave_public
       ```

1.  Validate the upgrade:

    Monitor the Mesos UI to verify that the upgraded node rejoins the DC/OS cluster and that tasks are reconciled (`http://<dcos_master>/mesos`).

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
$ less /opt/mesosphere/active/exhibitor/usr/zookeeper/zookeeper.out
$ sudo journalctl -u dcos-mesos-dns
$ sudo journalctl -u dcos-mesos-master
```

### On DC/OS Agents

```
$ sudo journalctl -u dcos-mesos-slave
```

## Notes:

- Packages available in the DC/OS 1.7 Universe are newer than those in the DC/OS 1.6 Universe. Services are not automatically upgraded when  DC/OS 1.7 is installed because not all DC/OS services have upgrade paths that will preserve existing state.

[advanced-install]: /docs/1.7/administration/installing/custom/advanced/
