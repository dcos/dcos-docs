---
post_title: Installing the CLI
nav_title: Installing
menu_order: 1
---

The easiest way to install the DC/OS CLI is by clicking the signpost icon in the lower left corner of the DC/OS web interface. Or, you can manually install the CLI by following these instructions.

*   [Installing the DC/OS CLI on Linux][1]
*   [Installing the DC/OS CLI on OS X][2]
*   [Installing the DC/OS CLI on Windows][3]

# <a name="linux"></a>Installing on Linux

#### Prerequisites

*   A system external to your DC/OS cluster that you can install the CLI.
*   Network access from the external system to your DC/OS cluster.
*   A command-line environment, such as Terminal.
*   cURL: Installed by default on most Linux distributions.

#### Installing the DC/OS CLI

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`).

    ```bash
    $ curl https://downloads.dcos.io/binaries/cli/linux/x86-64/0.4.10/dcos
    ```
    
    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.

1.  Make the CLI binary executable.
 
    ```bash
    chmod +x <path/to/download/directory>/dcos
    ```

1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.

    ```bash
    dcos config set core.dcos_url http://example.com
    ```
    
1.  Authenticate your CLI with your master node and set the auth token:

    ```bash
    $ dcos auth login
    ```
    
    Follow the on-screen instructions to complete authentication.

You are now ready to use the CLI. Enter `dcos` to get started.

```bash
$ dcos
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

# <a name="osx"></a>Installing on OS X

#### Prerequisites

*   A system external to your DC/OS cluster that you can install the CLI.
*   Network access from the external system to your DC/OS cluster.
*   A command-line environment, such as Terminal.
*   cURL: Installed by default on OS X

#### Installing the DC/OS CLI

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`).

    ```bash
    $ curl https://downloads.dcos.io/binaries/cli/darwin/x86-64/0.4.10/dcos
    ```
    
    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.

1.  Make the CLI binary executable.
 
    ```bash
    chmod +x <path/to/download/directory>/dcos
    ```

1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.

    ```bash
    dcos config set core.dcos_url http://example.com
    ```

1.  Authenticate your CLI with your master node and set the auth token:

    ```bash
    $ dcos auth login
    ```
    
    Follow the on-screen instructions to complete authentication.

You are now ready to use the CLI. Enter `dcos` to get started.

```bash
$ dcos
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

# <a name="windows"></a>Installing on Windows

#### Prerequisites

*   A system external to your DC/OS cluster onto which you will install the CLI
*   Network access from the external system to your DC/OS cluster
*   A command-line environment, such as Windows Powershell: Installed by default on Windows 7 and later
*   Disable any security or antivirus software before beginning the installation.


1.  Run command-line environment as Administrator.

1.  Download the DC/OS CLI executable to your local directory ([dcos.exe](https://downloads.dcos.io/binaries/cli/windows/x86-64/0.4.10/dcos.exe)).

1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.

    ```powershell
    dcos config set core.dcos_url http://example.com
    ```
    
1.  Authenticate your CLI with your master node and set the auth token:
   
    ```powershell
    $ dcos auth login
    ```
    
    You will be prompted for your username and password. For more information on the `superuser` and security, see the [documentation](/1.7/administration/id-and-access-mgt/).
    
    ```powershell
    $ dcos auth login
    http://dcos-ab-1234.us-west-2.elb.amazonaws.com username: bootstrapuser
    bootstrapuser@http://dcos-ab-1234.us-west-2.elb.amazonaws.com's password: 
    ```
    
1.  Authenticate your CLI with your master node and set the auth token:

    ```bash
    $ dcos auth login
    ```
    
    Follow the on-screen instructions to complete authentication.

You are now ready to use the CLI. Enter `dcos` to get started.

```powershell
$ dcos
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

 [1]: #linux
 [2]: #osx
 [3]: #windows
 [3]: http://git-scm.com/download/mac
