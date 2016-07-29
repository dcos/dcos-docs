---
post_title: Creating a Public Agent
nav_title: Public Agent
menu_order: 8
---

In DC/OS, agent nodes that are publicly accessible are designated as public and those that are not are designated as private. By default, agent nodes are designated as private during [GUI][1] or [CLI][2] installation.

You can determine how many public agent nodes are in your cluster by running the following command from the DC/OS CLI. A result of `0` indicates that you do not have a public agent. A result of `1` means that you have one or more public agents.

```bash
$ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | grep slave_public | wc -l
           0
```

These steps must be performed on a machine that is configured as a DC/OS node. Any tasks that are running on the node will be terminated during this conversion process.

### Prerequisites:

*   DC/OS is installed and you have deployed at least one master and one private agent node.
*   The archived DC/OS installer file (`dcos-install.tar`) from your [installation](/docs/1.7/administration/installing/custom/gui/#backup).     

### Uninstall the DC/OS private agent software

1.  Uninstall the current DC/OS software on the agent node.

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

### Install DC/OS and convert to a public agent node
Copy the archived DC/OS installer file (`dcos-install.tar`) to the node that that is being converted to a public agent. This archive is created during the GUI or CLI [installation](/docs/1.7/administration/installing/custom/gui/#backup) method.

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

3.  Install DC/OS as a public agent:

    ```bash
    $ sudo bash /opt/dcos_install_tmp/dcos_install.sh slave_public
    ```

4.  Verify that your new agent node is public by running this command from a workstation with the DC/OS CLI. You should see a result of `1`, which indicates that you have at least one public node.

    ```bash
    $ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | grep slave_public | wc -l
               1
    ```

    You should see an output greater than zero to indicate at least one public agent.

 [1]: /docs/1.7/administration/installing/custom/gui/
 [2]: /docs/1.7/administration/installing/custom/cli/
