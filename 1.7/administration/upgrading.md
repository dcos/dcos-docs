---
post_title: Upgrading
---

## Summary

#### These steps provide instructions for upgrading a DC/OS cluster from DC/OS 1.6 to 1.7.  If performed on a supported OS with all prerequisites fulfilled, this upgrade _should_ preserve the state of running tasks on the cluster.  This guide follows some of the steps outlined in the Advanced DC/OS Installation Guide:
https://dcos.io/docs/1.7/administration/installing/custom/advanced/

#### The Advanced Installation method is the only recommended upgrade path for DC/OS.  Please familiarize yourself with the Advanced DC/OS Installation Guide before proceeding.

## Prerequisites

- Mesos, Mesos Frameworks, Marathon, Docker and all running tasks in the cluster should be stable and in a known healthy state.
-  You must have access to copies of the config files used with DCOS 1.6: `config.yaml` and `ip-detect`
- You must be using systemd 218 or newer to maintain task state
- Be sure that all hosts (masters and agents) can communicate with all other hosts on port `53|UDP`
- In CentOS|RedHat, `$ sudo yum install -y ipset` (used in some IP detect scripts)
- You must be familiar with using `systemctl` and `journalctl` command line tools to review and monitor service status. Troubleshooting notes can be found at the end of this document.

## Instructions

These upgrade instructions follow the general procedural patterns of the Advanced DC/OS Installation Guide.  Please familiarize yourself with the Advanced DC/OS Installation Guide before performing an upgrade of DC/OS:
https://dcos.io/docs/1.7/administration/installing/custom/advanced/

### Bootstrap Node(s)

#### Copy and Update config.yaml and ip-detect

Copy the DC/OS 1.6 config.yaml and ip-detect script to a new, clean folder on your bootstrap node. 

**IT IS NOT POSSIBLE TO CHANGE THE `exhibitor_zk_backend` SETTING DURING AN UPGRADE**

Please note, the syntax of the DC/OS 1.7 config.yaml differs from that of DC/OS 1.6.  For a detailed description of config.yaml syntax and parameters, see:
https://dcos.io/docs/1.7/administration/installing/custom/configuration-parameters/

#### Continue Bootstrap Setup

Once you have merged your config.yaml into the config.yaml for the new version, proceed to build your installer package:

- Download the file dcos_generate_config.sh.
- Generate the installation files.
- Disable Docker restarts in `dcos_install.sh` *This step is critical to prevent task restarts*

```
sed -i -e "s/systemctl restart systemd-journald//g" -e "s/systemctl restart docker//g" genconf/serve/dcos_install.sh
```

- Run the nginx container to serve the installation files.

### DC/OS Masters

Identify your Mesos leader node. This node should be the last master node that you upgrade. Proceed with upgrading every master node using the following procedure. When you complete each upgrade, monitor the logs to ensure the unit has re-joined the cluster and completed reconciliation.

#### Download the dcos_install.sh script

```
$ curl -O <bootstrap_url>/dcos_install.sh
```

#### Uninstall pkgpanda

```
$ sudo -i /opt/mesosphere/bin/pkgpanda uninstall 
```

#### Remove The DC/OS 1.6 Data Directory

```
$ sudo rm -rf /opt/mesosphere /etc/mesosphere
```

#### Install DC/OS 1.7

```
$  sudo bash dcos_install.sh -d master
```

#### Validate The Upgrade

- Monitor the Exhibitor UI to confirm that the Master re-joins the Zookeeper quorum successfully (status indicator will turn green).  The Exhibitor UI is available at http://<dcos_master>:8181/.
- Verify that  http://<dcos_master>/mesos indicates that the upgraded Master is running Mesos 0.28.0.

### DC/OS Agents

When re-installing on agent nodes, it is important to consider that there is a 75 second timeout for the agent to respond to health check pings from the mesos-masters before it is considered lost and its tasks are given up for dead.

### On all DC/OS Agents:

#### Download The dcos_install.sh Script

```
$ curl -O <bootstrap_url>/dcos_install.sh
```

#### Uninstall pkgpanda

```
$ sudo -i /opt/mesosphere/bin/pkgpanda uninstall 
```

#### Remove The DC/OS 1.6 Data Directory

```
$ sudo rm -rf /opt/mesosphere
```

#### Install DC/OS 1.7

##### For Private Agents (default)

```
$ sudo bash dcos_install.sh -d slave
```

##### For Public Agents

```
$ sudo bash dcos_install.sh -d slave_public
```

#### Validate The Upgrade

Monitor the Mesos UI to verify that the upgraded node re-joins the DC/OS cluster and that tasks are reconciled (http://<dcos_master>/mesos).

## Troubleshooting Recommendations

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

- Packages available in the DC/OS 1.7 Universe are newer than those in the DC/OS 1.6 Universe.  While frameworks will not be automatically upgraded when installing DC/OS 1.7, not all DC/OS frameworks have upgrade paths that will preserve existing state.
- For Mesos compatibility reasons, we recommend upgrading any running Marathon-on-Marathon instances to version 0.16.0-RC3 before proceeding with this DC/OS upgrade.

