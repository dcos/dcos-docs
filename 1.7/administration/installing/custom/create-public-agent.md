---
post_title: Converting a Private Node to Public  
layout: page
published: true
---

In DC/OS, we distinguish between agents that are accessible from the cloud and those which are not with the notion of "public agents". By default, agent nodes are designated as private during [GUI](/administration/installing/custom/gui/) or [CLI](/administration/installing/custom/cli/) installation.

You can determine the count of public agents in your cluster by running the following command. A result of 0 means that you do not have a public agent, as shown below:

    ```bash
    $ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | jq '.slaves[] | .reserved_resources' | grep slave_public | wc -l
           0
    ```

### Prerequisites:

1. DC/OS is installed and you have deployed at least one private agent node.

### Converting private agents to public:

**The following steps must be taken on a machine that is currently a DC/OS node. If this node is currently running tasks, those tasks will be terminated in this process.**

1.  Uninstall the current DC/OS software on the agent node.

    ```bash
    $ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
    $ sudo systemctl stop dcos-mesos-slave
    $ sudo systemctl disable dcos-mesos-slave
    ```

1.  Remove the old directory structures on the agent node.

    ```bash
    $ sudo rm -rf /opt/mesosphere /var/lib/mesos
    ```

1.  Restart the machine.

    ```bash
    $sudo reboot
    ```

### Install DC/OS

1.  Copy the `dcos-install.tar` file created in the GUI or CLI installation method to the machine that will be a public agent.

    ```bash
    $ ssh $USER@$AGENT "sudo mkdir -p /opt/dcos_install_tmp"
    $ scp ~/dcos-install.tar $ROOT_USER@$AGENT:~/dcos-install.tar
    ```

1.  SSH to the machine:

    ```bash
    $ ssh $USER@$AGENT
    ```

1.  Install DC/OS as a public agent:

    ```bash
    $ sudo mv ~/dcos-install.tar /opt/dcos_install_tmp
    $ sudo bash /opt/dcos_install_tmp/dcos_install.sh slave_public
    ```

1.  Verify that your new agent node is public by running this command from DC/OS CLI.

    ```bash
    $ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | jq '.slaves[] | .reserved_resources' | grep slave_public | wc -l
    ```

    You should see an output greater than zero to indicate at least one public agent.
