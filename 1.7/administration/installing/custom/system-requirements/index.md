---
post_title: System Requirements
menu_order: 1
---
# Hardware Prerequisites

You must have a single bootstrap node, Mesos master nodes, and Mesos agent nodes.

## Bootstrap node

1 node with 2 Cores, 16 GB RAM, 60 GB HDD. This is the node where DC/OS installation is run. This bootstrap node must also have:

*   Python, pip, and virtualenv must be installed for the DC/OS [CLI][1]. pip must be configured to pull packages from PyPI or your private PyPI, if applicable.
*   A High-availability (HA) load balancer, such as HAProxy to balance the following TCP ports to all master nodes: 80, 443, 8080, 8181, 2181, 5050.
*  An unencrypted SSH key that can be used to authenticate with the cluster nodes over SSH. Encrypted SSH keys are not supported.

## Cluster nodes

The cluster nodes are designated Mesos masters and agents during installation.

### Master nodes

Here are the master node hardware requirements.

<table class="table">
  <tr>
    <th>
      Minimum
    </th>

    <th>
      Recommended
    </th>
  </tr>

  <tr>
    <td>
      Nodes: 1<br />OS: RHEL/CentOS 7.2<br />Processor: 4 cores<br />Memory: 32 GB RAM<br />Hard disk space: 120 GB
    </td>

    <td>
      Nodes: 3<br />OS: RHEL/CentOS 7.2<br />Processor: 4 cores<br />Memory: 32 GB RAM<br />Hard disk space: 120 GB
    </td>
  </tr>
  <tr>
     <td colspan="2">
      <p>There are many mixed workloads on the masters, for example Mesos replicated log and ZooKeeper. Some of these require fsync()ing every so often, and this can generate a lot of very expensive random I/O. We recommend the following: <ul><li>Solid-state drive (SSD)</li><li>RAID controllers with a BBU</li><li>RAID controller cache configured in writeback mode</li></ul></p>
      </td>
      </tr>
</table>

### Agent nodes

Here are the agent node hardware requirements.

<table class="table">
  <tr>
    <th class="tg-e3zv">
      Minimum
    </th>

    <th class="tg-e3zv">
      Recommended
    </th>
  </tr>

  <tr>
    <td class="tg-031e">
      Nodes: 1<br />OS: RHEL/CentOS 7.2<br />Processor: 2 cores<br />Memory: 16 GB RAM<br />Hard disk space: 60 GB
    </td>

    <td class="tg-031e">
      Nodes: 6<br />OS: RHEL/CentOS 7.2<br />Processor: 2 cores<br />Memory: 16 GB RAM<br />Hard disk space: 60 GB
    </td>
  </tr>

  <tr>
    <td colspan="2">
      The agent nodes must also have: * A <code>/var</code> directory with 10 GB or more of free space. This directory is used by the sandbox for both Docker and Mesos Containerizer.* Network Access to a public Docker repository or to an internal Docker registry.</ul>
    </td>
  </tr>
</table>

</ul>

*   Your Linux distribution must be running the latest version. You can update CentOS with this command:
<pre>$ sudo yum upgrade -y</pre>

*   On RHEL 7 and CentOS 7, firewalld must be stopped and disabled. It is a known <a href="https://github.com/docker/docker/issues/16137" target="_blank">Docker issue</a> that firewalld interacts poorly with Docker. For more information, see the <a href="https://docs.docker.com/v1.6/installation/centos/#firewalld" target="_blank">Docker CentOS firewalld</a> documentation.
<pre>$ sudo systemctl stop firewalld && sudo systemctl disable firewalld</pre>

</ul>

### Port Configuration

*   Each node is network accessible from the bootstrap node.
*   Each node has SSH enabled and ports open from the bootstrap node.
*   Each node has unfettered IP-to-IP connectivity from itself to all nodes in the DC/OS cluster.
*   Each node has Network Time Protocol (NTP) for clock synchronization enabled.


# Software Prerequisites

## All Nodes

### Docker

**Requirements**

* Docker 1.7 or greater must be installed on all bootstrap and cluster nodes.

**Recommendations**

* Docker 1.9 or greater is recommended <a href="https://github.com/docker/docker/issues/9718" target="_blank">for stability reasons</a>.

* Do not use Docker `devicemapper` storage driver in `loop-lvm` mode. For more information, see [Docker and the Device Mapper storage driver](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/).

* Prefer `OverlayFS` or `devicemapper` in `direct-lvm` mode when choosing a production storage driver. For more information, see Docker's <a href="https://docs.docker.com/engine/userguide/storagedriver/selectadriver/" target="_blank">Select a Storage Driver</a>.

* Manage Docker on CentOS with systemd. systemd handles starting Docker on boot and restarting it when it crashes.

* Run Docker commands as the root user (with `sudo`) or as a user in the <a href="https://docs.docker.com/engine/installation/linux/centos/#create-a-docker-group" target="_blank">docker user group</a>.

**Distribution-Specific Installation**

Each Linux distribution requires Docker to be installed in a specific way:

*   **CentOS** - [Install Docker from Docker's yum repository][2].
*   **RHEL** - Install Docker by using a subscription channel. For more information, see <a href="https://access.redhat.com/articles/881893" target="_blank">Docker Formatted Container Images on Red Hat Systems</a>. <!-- $ curl -sSL https://get.docker.com | sudo sh -->
*   **CoreOS** - Comes with Docker pre-installed and pre-configured.

For more more information, see Docker's <a href="http://docs.docker.com/engine/installation/" target="_blank">distribution-specific installation instructions</a>.

## Bootstrap node

The bootstrap node is a permanent part of your cluster and is required for DC/OS recovery. The leader state and leader election of your Mesos masters is maintained in Exhibitor ZooKeeper. Before installing DC/OS, you must ensure that your bootstrap node has the following prerequisites.

### DC/OS setup file

Download and save the [DC/OS setup file][3] to your bootstrap node. This file is used to create your customized DC/OS build file.

### Docker Nginx (advanced installer)

For advanced install only, install the Docker Nginx image with this command:

```bash
$ sudo docker pull nginx
```

## Cluster nodes

For advanced install only, your cluster nodes must have the following prerequisites. The cluster nodes are designated as Mesos masters and agents during installation.

### Data compression (advanced installer)

You must have the <a href="http://www.info-zip.org/UnZip.html" target="_blank">UnZip</a>, <a href="https://www.gnu.org/software/tar/" target="_blank">GNU tar</a>, and <a href="http://tukaani.org/xz/" target="_blank">XZ Utils</a> data compression utilities installed on your cluster nodes.

To install these utilities on CentOS7 and RHEL7:

```bash
$ sudo yum install -y tar xz unzip curl ipset
```


### Cluster permissions (advanced installer)

On each of your cluster nodes, use the following command to:

*   Disable SELinux or set it to permissive mode.
*   Add nogroup to each of your Mesos masters and agents.</li>
*   Reboot your cluster for the changes to take affect</p>

    ```bash
    $ sudo sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config &&
      sudo groupadd nogroup &&
      sudo reboot
    ```

    **Tip:** It may take a few minutes for your node to come back online after reboot.

# Next step

- [GUI DC/OS Installation Guide][4]
- [CLI DC/OS Installation Guide][1]
- [Advanced DC/OS Installation Guide][5]

[1]: /docs/1.7/administration/installing/custom/cli/
[2]: /docs/1.7/administration/installing/custom/system-requirements/install-docker-centos/
[3]: https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh
[4]: /docs/1.7/administration/installing/custom/gui/
[5]: /docs/1.7/administration/installing/custom/advanced/
