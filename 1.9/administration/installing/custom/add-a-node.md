---
post_title: Adding Agent Nodes
nav_title: Add Node
menu_order: 800
---

You can add agent nodes to an existing DC/OS cluster. 

Agent nodes are designated as [public](/docs/1.9/overview/concepts/#public) or [private](/docs/1.9/overview/concepts/#private) during installation. By default, they are designated as private during [GUI][1] or [CLI][2] installation.

### Prerequisites:

*   DC/OS is installed using the [custom](/docs/1.9/administration/installing/custom/) installation method.
*   The archived DC/OS installer file (`dcos-install.tar`) from your [installation](/docs/1.9/administration/installing/custom/gui/#backup).
*   Available agent nodes that satisfy the [system requirements](/docs/1.9/administration/installing/custom/system-requirements/).
*   The CLI JSON processor [jq](https://github.com/stedolan/jq/wiki/Installation).
*   SSH installed and configured. This is required for accessing nodes in the DC/OS cluster.

### Install DC/OS agent nodes
Copy the archived DC/OS installer file (`dcos-install.tar`) to the agent node. This archive is created during the GUI or CLI [installation](/docs/1.9/administration/installing/custom/gui/#backup) method.

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
    
    **Tip:** You can verify the node type by running this command from the DC/OS CLI. 
             
    -   Run this command to count the private agents. 
    
        ```bash
        $ dcos node --json | jq --raw-output '.[] | select(.reserved_resources.slave_public == null) | .id' | wc -l
        ```
    
    -   Run this command to count the public agents. 
     
        ```bash
        $ dcos node --json | jq --raw-output '.[] | select(.reserved_resources.slave_public != null) | .id' | wc -l
        ```

 [1]: /docs/1.9/administration/installing/custom/gui/
 [2]: /docs/1.9/administration/installing/custom/cli/
