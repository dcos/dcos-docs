---
post_title: Updating the CLI
nav_title: Updating
menu_order: 3
---

You can update the DC/OS CLI to the latest version or downgrade to an older version.

# <a name="upgrade"></a>Upgrade the CLI

**Important:** If you downloaded the CLI from PYPI or from the DC/OS UI version 1.7 or earlier, you must completely [uninstall](/docs/1.9/usage/cli/uninstall/) the CLI. You cannot upgrade. 

You can upgrade an existing DC/OS CLI installation to the latest build.

1.  Remove the current CLI binary. For example, if you installed to `/usr/local/bin/`:
                                   
    ```bash
    $ rm -rf /usr/local/bin/dcos
    ```

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`). Update the command with the desired upgrade version (`<version>`):
    
    ```bash
    $ curl https://downloads.dcos.io/binaries/cli/darwin/x86-64/dcos-<dcos-version>/dcos
    ```
    
    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.
    
1.  **Mac OS X and Linux:** Make the CLI binary executable. 
    
    ```bash
    chmod +x dcos
    ```
   
    **Tip:** If your system is unable to find the executable, you may need to re-open the command prompt or add the installation directory to your PATH environment variable manually.

1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.
    
    ```bash
    dcos config set core.dcos_url http://example.com
    ```

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.9/administration/id-and-access-mgt/).
    
    Your CLI should now be authenticated with your cluster! Enter `dcos` to get started.

    ```bash
    dcos
    Command line utility for the Mesosphere Datacenter Operating
    System (DC/OS). The Mesosphere DC/OS is a distributed operating
    system built around Apache Mesos. This utility provides tools
    for easy management of a DC/OS installation.

    Available DC/OS commands:

       auth           	Authenticate to DC/OS cluster
       config         	Manage the DC/OS configuration file
       help           	Display help information about DC/OS
       marathon       	Deploy and manage applications to DC/OS
       node           	Administer and manage DC/OS cluster nodes
       package        	Install and manage DC/OS software packages
       service        	Manage DC/OS services
       task           	Manage DC/OS tasks

    Get detailed command description with 'dcos <command> --help'.
    ```

# <a name="downgrade"></a>Downgrade the CLI

You can downgrade an existing DC/OS CLI installation to an older version.

1.  Remove the current CLI binary:

    ```bash
    $ rm path/to/binary/dcos
    ```

1.  From the directory you want to install the new DC/OS CLI binary, enter this command to update the DC/OS CLI with the downgrade version (`<version>`) specified:
    
    ```bash
    $ curl https://downloads.dcos.io/binaries/cli/darwin/x86-64/<version>/dcos
    ```
