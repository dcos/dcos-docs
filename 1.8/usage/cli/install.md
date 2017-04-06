---
post_title: Installing the CLI
nav_title: Installing
menu_order: 1
---

The recommended method to install the DC/OS CLI is by clicking the quick-launch icon on the lower-left panel of the DC/OS [web interface](/docs/1.8/usage/webinterface). Or, you can manually install the CLI by following these instructions.

*   [Installing the DC/OS CLI on Linux](#linux)
*   [Installing the DC/OS CLI on macOS](#osx)
*   [Installing the DC/OS CLI on Windows](#windows)

# <a name="linux"></a>Installing on Linux

#### Prerequisites

*   A system external to your DC/OS cluster that you can install the CLI.
*   Network access from the external system to your DC/OS cluster.
*   A command-line environment, such as Terminal.
*   cURL: Installed by default on most Linux distributions.

#### Installing the DC/OS CLI

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`).

    ```bash
    curl -O https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos
    ```

    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.

1.  Make the CLI binary executable.

    ```bash
    chmod +x dcos
    ```

1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.

    ```bash
    dcos config set core.dcos_url http://example.com
    ```

1.  Authenticate your CLI with your master node and set the auth token:

    ```bash
    dcos auth login
    ```

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.8/administration/id-and-access-mgt/).

    Your CLI should now be authenticated with your cluster! Enter `dcos` to get started.

# <a name="osx"></a>Installing on macOS

#### Prerequisites

*   A system external to your DC/OS cluster that you can install the CLI.
*   Network access from the external system to your DC/OS cluster.
*   A command-line environment, such as Terminal.

#### Installing the DC/OS CLI

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`).

    ```bash
    curl -O https://downloads.dcos.io/binaries/cli/darwin/x86-64/dcos-1.8/dcos
    ```

    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.

1.  Make the CLI binary executable.

    ```bash
    chmod +x dcos
    ```
    
1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.

    ```bash
    dcos config set core.dcos_url http://example.com
    ```

1.  Authenticate your CLI with your master node and set the auth token.

    ```bash
    dcos auth login
    ```
    
    **Tip:** If your system is unable to find the executable, you may need to re-open the command prompt or add the installation directory to your PATH environment variable manually.    

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.8/administration/id-and-access-mgt/).

# <a name="windows"></a>Installing on Windows

#### Prerequisites

*   A system external to your DC/OS cluster onto which you will install the CLI
*   Network access from the external system to your DC/OS cluster
*   A command-line environment, such as Windows Powershell, which is installed by default on Windows 7 and later
*   Disable any security or antivirus software before beginning the installation.


1.  Run command-line environment as Administrator.

1.  Download the DC/OS CLI executable to your local directory ([dcos.exe](https://downloads.dcos.io/binaries/cli/windows/x86-64/dcos-1.8/dcos.exe)).

1.  Point the CLI to your DC/OS master node. In this example, `http://example.com` is the master node IP address.

    ```powershell
    dcos config set core.dcos_url http://example.com
    ```

1.  Authenticate your CLI with your master node:

    ```powershell
    dcos auth login
    ```

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.8/administration/id-and-access-mgt/).
