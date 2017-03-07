---
post_title: Converting Agent Node Types
nav_title: Convert Node Type
menu_order: 700
---

You can convert agent nodes to public or private for an existing DC/OS cluster. 

Agent nodes are designated as [public](/docs/1.9/overview/concepts/#public) or [private](/docs/1.9/overview/concepts/#private) during installation. By default, they are designated as private during [GUI][1] or [CLI][2] installation.

### Prerequisites:
These steps must be performed on a machine that is configured as a DC/OS node. Any tasks that are running on the node will be terminated during this conversion process.

*   DC/OS is installed using the [custom](/docs/1.9/administration/installing/custom/) installation method and you have deployed at least one [master](/docs/1.9/overview/concepts/#master) and one [private](/docs/1.9/overview/concepts/#private) agent node.
*   The archived DC/OS installer file (`dcos-install.tar`) from your [installation](/docs/1.9/administration/installing/custom/gui/#backup).     
*   The CLI JSON processor [jq](https://github.com/stedolan/jq/wiki/Installation).
*   SSH installed and configured. This is required for accessing nodes in the DC/OS cluster.

### Determine the node type
You can determine the node type by running this command from the DC/OS CLI. 

-   Run this command to determine how many private agents are there in the cluster. A result of `0` indicates that there are no private agents.

    ```bash
    $ dcos node --json | jq --raw-output '.[] | select(.reserved_resources.slave_public == null) | .id' | wc -l
    ```

-   Run this command to determine how many public agents are there in the cluster. A result of `0` indicates that there are no public agents.
    
    ```bash
    $ dcos node --json | jq --raw-output '.[] | select(.reserved_resources.slave_public != null) | .id' | wc -l
    ```

### Uninstall the DC/OS private agent software

1.  Uninstall DC/OS on the agent node.

    ```bash
    $ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
    $ sudo systemctl stop dcos-mesos-slave
    $ sudo systemctl disable dcos-mesos-slave
    ```

2.  Remove the old directory structures on the agent node.

    ```bash
    $ sudo rm -rf /etc/mesosphere /opt/mesosphere /var/lib/mesos /var/lib/dcos
    ```

3.  Restart the machine.

    ```bash
    $ sudo reboot
    ```        

### Install DC/OS and convert agent node
Copy the archived DC/OS installer file (`dcos-install.tar`) to the node that that is being converted. This archive is created during the GUI or CLI [installation](/docs/1.9/administration/installing/custom/gui/#backup) method.

1.  Copy the files to your agent node. For example, you can use Secure Copy (scp) to copy `dcos-install.tar` to your home directory:

    ```bash
    $ scp ~/dcos-install.tar $username@$node-ip:~/dcos-install.tar
    ```

2.  SSH to the machine:

    ```bash
    $ ssh $USER@$AGENT
    ```

1.  Create a directory for the installer files:

     ```bash
     $ sudo mkdir -p /opt/dcos_install_tmp
     ```

1.  Unpackage the `dcos-install.tar` file:

    ```bash
    $ sudo tar xf dcos-install.tar -C /opt/dcos_install_tmp
    ```

1.  Run this command to install DC/OS on your agent nodes. You must designate your agent nodes as public or private.

    Private agent nodes:
    
    ```bash
    $ sudo bash /opt/dcos_install_tmp/dcos_install.sh slave
    ```
    
    Public agent nodes:
    
    ```bash
    $ sudo bash /opt/dcos_install_tmp/dcos_install.sh slave_public
    ```

 [1]: /docs/1.9/administration/installing/custom/gui/
 [2]: /docs/1.9/administration/installing/custom/cli/
