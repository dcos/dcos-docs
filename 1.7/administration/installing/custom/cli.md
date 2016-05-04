---
post_title: CLI DC/OS Installation Guide
nav_title: CLI
menu_order: 3
---

The automated CLI installer provides a guided installation of DC/OS from the command line. With this method you can choose from the complete set of DC/OS configuration options.

This installation method uses a bootstrap node to administer the DC/OS installation across your cluster. The bootstrap node uses an SSH key to connect to each node in your cluster to automate the DC/OS installation.

The DC/OS installation creates these folders:

*   `/opt/mesosphere`
    :   Contains all the DC/OS binaries, libraries, cluster configuration. Do not modify.

*   `/etc/systemd/system/dcos.target.wants`
    :   Contains the systemd service units which start the things that make up DC/OS. They must live outside of `/opt/mesosphere` because of systemd constraints.

*   Various units prefixed with `dcos` in `/etc/systemd/system`
    :   Copies of the units in `/etc/systemd/system/dcos.target.wants`. They must be at the top folder as well as inside `dcos.target.wants`.

# Configure your cluster

1. Create a directory named `genconf` on your bootstrap node and navigate to it.

    ```bash
    $ mkdir -p genconf
    ```

2. Create a `ip-detect` script

    In this step you create an IP detect script to broadcast the IP address of each node across the cluster. Each node in a DC/OS cluster has a unique IP address that is used to communicate between nodes in the cluster. The IP detect script prints the unique IPv4 address of a node to STDOUT each time DC/OS is started on the node.

    **Important:** The IP address of a node must not change after DC/OS is installed on the node. For example, the IP address must not change when a node is rebooted or if the DHCP lease is renewed. If the IP address of a node does change, the node must be [wiped and reinstalled][7].

    Create an IP detection script for your environment and save as `genconf/ip-detect`. You can use the examples below.

    *   #### Use the AWS Metadata Server

        This method uses the AWS Metadata service to get the IP address:

        ```bash
        #!/bin/sh
        # Example ip-detect script using an external authority
        # Uses the AWS Metadata Service to get the node's internal
        # ipv4 address
        curl -fsSL http://169.254.169.254/latest/meta-data/local-ipv4
        ```

    *   #### Use the GCE Metadata Server

        This method uses the GCE Metadata Server to get the IP address:

        ```bash
        #!/bin/sh
        # Example ip-detect script using an external authority
        # Uses the GCE metadata server to get the node's internal
        # ipv4 address

        curl -fsSL -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip
        ```

    *   #### Use the IP address of an existing interface

        This method discovers the IP address of a particular interface of the node.

        If you have multiple generations of hardware with different internals, the interface names can change between hosts. The IP detection script must account for the interface name changes. The example script could also be confused if you attach multiple IP addresses to a single interface, or do complex Linux networking, etc.

        ```bash
        #!/usr/bin/env bash
        set -o nounset -o errexit
        export PATH=/usr/sbin:/usr/bin:$PATH
        echo $(ip addr show eth0 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
        ```

    *   #### Use the network route to the Mesos master

        This method uses the route to a Mesos master to find the source IP address to then communicate with that node.

        In this example, we assume that the Mesos master has an IP address of `172.28.128.3`. You can use any language for this script. Your Shebang line must be pointed at the correct environment for the language used and the output must be the correct IP address.

        ```bash
        #!/usr/bin/env bash
        set -o nounset -o errexit

        MASTER_IP=172.28.128.3

        echo $(/usr/sbin/ip route show to match 172.28.128.3 | grep -Eo '[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}' | tail -1)
        ```

1.  Create a configuration file and save as `genconf/config.yaml`.

    In this step you create a YAML configuration file that is customized for your environment. DC/OS uses this configuration file during installation to generate your cluster installation files.

    You can use this template to get started. This template specifies 3 Mesos masters, 5 Mesos agents, and SSH configuration specified. If your servers are installed with a domain name in your `/etc/resolv.conf`, you should add `dns_search` to your `config.yaml` file. For parameters descriptions and configuration examples, see the [documentation][6].

    ```yaml
    ---
    agent_list:
    - <agent-private-ip-1>
    - <agent-private-ip-2>
    - <agent-private-ip-3>
    - <agent-private-ip-4>
    - <agent-private-ip-5>
    # Use this bootstrap_url value unless you have moved the DC/OS installer assets.
    bootstrap_url: file:///opt/dcos_install_tmp
    cluster_name: <cluster-name>
    master_discovery: static
    master_list:
    - <master-private-ip-1>
    - <master-private-ip-2>
    - <master-private-ip-3>
    resolvers:
    - 8.8.4.4
    - 8.8.8.8
    ssh_port: 22
    ssh_user: <username>
    ```

    **Important:** You cannot use an NFS mount for Exhibitor storage with the automated command line installation method. To use an NFS mount for Exhibitor storage (`exhibitor_storage_backend: shared_filesystem`), you must use the [advanced installation method][3].

3.  Copy your private SSH key to `genconf/ssh_key`. For more information, see the [ssh_key_path][6] parameter.

    ```bash
    $ cp <path-to-key> genconf/ssh_key && chmod 0600 genconf/ssh_key
    ```


# Install DC/OS

In this step you create a custom DC/OS build file on your bootstrap node and then install DC/OS across your cluster nodes with SSH. With this installation method you create a bootstrap server that uses your SSH key and connects to every node to automate the deployment.

You can view all of the automated command line installer options with the `--help` flag:

```bash
$ sudo bash dcos_generate_config.sh --help
Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
usage:
Install DC/OS

dcos_installer [-h] [-f LOG_FILE] [--hash-password HASH_PASSWORD] [-v]
[--web | --genconf | --preflight | --deploy | --postflight | --uninstall | --validate-config | --test]

Environment Settings:

  PORT                  Set the :port to run the web UI
  CHANNEL_NAME          ADVANCED - Set build channel name
  BOOTSTRAP_ID          ADVANCED - Set bootstrap ID for build

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         Verbose log output (DEBUG).
  --offline             Do not install preflight prerequisites on CentOS7,
                        RHEL7 in web mode
  --web                 Run the web interface.
  --genconf             Execute the configuration generation (genconf).
  --preflight           Execute the preflight checks on a series of nodes.
  --install-prereqs     Install preflight prerequisites. Works only on CentOS7
                        and RHEL7.
  --deploy              Execute a deploy.
  --postflight          Execute postflight checks on a series of nodes.
  --uninstall           Execute uninstall on target hosts.
  --validate-config     Validate the configuration in config.yaml
  --test                Performs tests on the dcos_installer application
```

**Tip:** If something goes wrong and you want to rerun your setup, use these cluster [cleanup instructions][7].

To install DC/OS:

1.  Download the [DC/OS installer][5] to your root directory.

    ```bash
    $ curl -O https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh
    ```

1.  From your home directory, run the DC/OS installer shell script on your bootstrapping master nodes to generate a customized DC/OS build. The setup script extracts a Docker container that uses the generic DC/OS install files to create customized DC/OS build files for your cluster. The build files are output to `./genconf/serve/`.

    ```bash
    $ sudo bash dcos_generate_config.sh --genconf
    ```

    Here is an example of the output.

    ```bash
    Extracting image from this script and loading into docker daemon, this step can take a few minutes
    dcos-genconf.e060aa49ac4ab62d5e-1e14856f55e5d5d07b.tar
    Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
    ====> EXECUTING CONFIGURATION GENERATION
    ...
    ```

    At this point your directory structure should resemble:

    ```
    ├── dcos-genconf.<HASH>.tar
    ├── dcos_generate_config.sh
    ├── genconf
    │   ├── config.yaml
    │   ├── ip-detect
    │   ├── cluster_packages.json
    │   ├── serve
    │   ├── ssh_key
    │   ├── state
    ```

2.  <a name="two"></a>Install the cluster prerequisites, including system updates, compression utilities (UnZip, GNU tar, and XZ Utils), and cluster permissions. For a full list of cluster prerequisites, see this [documentation][4].

    ```bash
    $ sudo bash dcos_generate_config.sh --install-prereqs
    ```

    Here is an example of the output.

    ```bash
    Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
    ====> dcos_installer.action_lib.prettyprint:: ====> EXECUTING INSTALL PREREQUISITES
    ====> dcos_installer.action_lib.prettyprint:: ====> START install_prereqs
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE install_prereqs
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE install_prereqs
    ====> dcos_installer.action_lib.prettyprint:: ====> END install_prereqs with returncode: 0
    ====> dcos_installer.action_lib.prettyprint:: ====> SUMMARY
    ====> dcos_installer.action_lib.prettyprint:: 2 out of 2 hosts successfully completed install_prereqs stage.
    ```

3.  Run a preflight script to validate that your cluster is installable.

    ```bash
    $ sudo bash dcos_generate_config.sh --preflight
    ```

    Here is an example of the output.

    ```bash
    Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
    ====> dcos_installer.action_lib.prettyprint:: ====> EXECUTING PREFLIGHT
    ====> dcos_installer.action_lib.prettyprint:: ====> START run_preflight
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE preflight
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE preflight
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE preflight_cleanup
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE preflight_cleanup
    ====> dcos_installer.action_lib.prettyprint:: ====> END run_preflight with returncode: 0
    ====> dcos_installer.action_lib.prettyprint:: ====> SUMMARY
    ====> dcos_installer.action_lib.prettyprint:: 2 out of 2 hosts successfully completed run_preflight stage.
    ```

    **Tip:** For a detailed view, you can append log level debug (`-v`) to your command. For example `sudo bash dcos_generate_config.sh --preflight -v`.

4.  Install DC/OS on your cluster.

    ```bash
    $ sudo bash dcos_generate_config.sh --deploy
    ```

    Here is an example of the output.

    ```bash
    Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
    ====> dcos_installer.action_lib.prettyprint:: ====> EXECUTING DC/OS INSTALLATION
    ====> dcos_installer.action_lib.prettyprint:: ====> START deploy_master
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE deploy_master
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE deploy_master_cleanup
    ====> dcos_installer.action_lib.prettyprint:: ====> END deploy_master with returncode: 0
    ====> dcos_installer.action_lib.prettyprint:: ====> SUMMARY
    ====> dcos_installer.action_lib.prettyprint:: 1 out of 1 hosts successfully completed deploy_master stage.
    ====> dcos_installer.action_lib.prettyprint:: ====> START deploy_agent
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE deploy_agent
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE deploy_agent_cleanup
    ====> dcos_installer.action_lib.prettyprint:: ====> END deploy_agent with returncode: 0
    ====> dcos_installer.action_lib.prettyprint:: ====> SUMMARY
    ====> dcos_installer.action_lib.prettyprint:: 1 out of 1 hosts successfully completed deploy_agent stage.
    ```

5.  Run the DC/OS diagnostic script to verify that services are up and running.

    ```bash
    $ sudo bash dcos_generate_config.sh --postflight
    ```

    Here is an example of the output.

    ```bash
    Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
    ====> dcos_installer.action_lib.prettyprint:: ====> EXECUTING POSTFLIGHT
    ====> dcos_installer.action_lib.prettyprint:: ====> START run_postflight
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE postflight
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE postflight
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE postflight_cleanup
    ====> dcos_installer.action_lib.prettyprint:: ====> STAGE postflight_cleanup
    ====> dcos_installer.action_lib.prettyprint:: ====> END run_postflight with returncode: 0
    ====> dcos_installer.action_lib.prettyprint:: ====> SUMMARY
    ====> dcos_installer.action_lib.prettyprint:: 2 out of 2 hosts successfully completed run_postflight stage.
    ```

6.  Monitor Exhibitor and wait for it to converge at `http://<master-public-ip>:8181/exhibitor/v1/ui/index.html`.

    **Tip:** This process can take about 10 minutes. During this time you will see the Master nodes become visible on the Exhibitor consoles and come online, eventually showing a green light.

    ![alt text](../img/chef-zk-status.png)

    When the status icons are green, you can access the DC/OS web interface.

7.  Launch the DC/OS web interface at `http://<public-master-ip>/` and login. If this doesn't work, take a look at the [troubleshooting docs][9]

    ![alt text](../img/ui-installer-login.gif)
    
    You are done!

    ![dashboard](../img/ui-dashboard.gif)


# Next Steps

- [Add users to your cluster][10]
- [Add a public agent][11]
- [Install the DC/OS Command-Line Interface (CLI)][2]
- [Troubleshooting DC/OS installation][9]
- [Use your cluster][8]
- [Uninstalling DC/OS][7]

### Add more agent nodes

After DC/OS is installed and deployed across your cluster, you can add more agent nodes.

**Prerequisite:**

*   The agent nodes must meet the hardware and software prerequisites.

1.  Update the `config.yaml` file with the additional agent nodes. For parameters descriptions and configuration examples, see the [documentation][2].
2.  Run the installation steps beginning with [installing the cluster][4] prerequisites:

    ```bash
    $ sudo bash dcos_generate_config.sh --install-prereqs
    ```

    **Important:** You can ignore the errors that are shown. For example, during the `--preflight` you may see this error:

    ```bash
    18:17:14::           Found an existing DC/OS installation. To reinstall DC/OS on this this machine you must
    18:17:14::           first uninstall DC/OS then run dcos_install.sh. To uninstall DC/OS, follow the product
    18:17:14::           documentation provided with DC/OS.
    18:17:14::
    18:17:14::
    18:17:14:: ====> 10.10.0.160:22 FAILED
    ```

 [2]: /docs/1.7/usage/cli/install/
 [3]: /docs/1.7/administration/installing/custom/advanced/
 [4]: /docs/1.7/administration/installing/custom/system-requirements/
 [5]: https://downloads.dcos.io/dcos/EarlyAccess/dcos_generate_config.sh
 [6]: /docs/1.7/administration/installing/custom/configuration-parameters/
 [7]: /docs/1.7/administration/installing/custom/uninstall/
 [8]: /docs/1.7/usage/
 [9]: /docs/1.7/administration/installing/custom/troubleshooting/
 [10]: /docs/1.7/administration/user-management/
 [11]: /docs/1.7/administration/installing/custom/create-public-agent/
