---
post_title: Installing the CLI
nav_title: Installing
menu_order: 1
---

The recommended method to install the DC/OS CLI is from the DC/OS web interface. Or, you can manually install the CLI by using the instructions [below](#manual). 

# Installing CLI from the web interface

1.  At the top-left corner of the DC/OS web interface, click the down arrow to the right of your cluster name.

    ![open cluster popup](/docs/1.11/img/open-cluster-popup.png)

1.  Select **Install CLI**.

    ![CLI install UI](/docs/1.11/img/install-cli.png)
    
1.  Copy and paste the code snippets into your terminal.

    ![CLI copy/paste](/docs/1.11/img/install-cli-terminal.png)

# <a name="manual"></a>Manually installing the CLI

*   [Installing the DC/OS CLI on Linux](#linux)
*   [Installing the DC/OS CLI on macOS](#osx)
*   [Installing the DC/OS CLI on Windows](#windows)

## <a name="linux"></a>Installing on Linux

### Prerequisites

*   A system external to your DC/OS cluster that you can install the CLI.
*   Network access from the external system to your DC/OS cluster.
*   A command-line environment, such as Terminal.
*   cURL: Installed by default on most Linux distributions.

### Installing the DC/OS CLI

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`).

    ```bash
    curl -O https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.10/dcos
    ```

    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.

1.  Move the CLI binary to your local bin directory.

    ```bash
    sudo mv dcos /usr/local/bin 
    ```

1.  Make the CLI binary executable.

    ```bash
    chmod +x /usr/local/bin/dcos
    ```

1.  Set up the connection from the CLI to your DC/OS cluster. In this example, `http://example.com` is the master node URL.

    ```bash
    dcos cluster setup http://example.com
    ```

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.11/security/).

    Your CLI should now be authenticated with your cluster! Enter `dcos` to get started.

## <a name="osx"></a>Installing on macOS

### Prerequisites

*   A system external to your DC/OS cluster that you can install the CLI.
*   Network access from the external system to your DC/OS cluster.
*   A command-line environment, such as Terminal.
*   cURL: If you don't have cURL, follow the instructions in [Install curl on Mac OSX](http://macappstore.org/curl/).

### Installing the DC/OS CLI

1.  Download the DC/OS CLI binary (`dcos`) to your local directory (for example, `/usr/local/bin/`).

    ```bash
    curl -O https://downloads.dcos.io/binaries/cli/darwin/x86-64/dcos-1.10/dcos
    ```

    **Important:** The CLI must be installed on a system that is external to your DC/OS cluster.

1.  Make the CLI binary executable.

    ```bash
    chmod +x dcos
    ```

1.  Set up the connection from the CLI to your DC/OS cluster. In this example, `http://example.com` is the master node URL.

    ```bash
    dcos cluster setup http://example.com
    ```
    **Tip:** If your system is unable to find the executable, you may need to re-open the command prompt or add the installation directory to your PATH environment variable manually.

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.11/security/).

    Your CLI should now be authenticated with your cluster! Enter `dcos` to get started.

## <a name="windows"></a>Installing on Windows

### Prerequisites

*   A system external to your DC/OS cluster onto which you will install the CLI
*   Network access from the external system to your DC/OS cluster
*   A command-line environment, such as Windows Powershell, which is installed by default on Windows 7 and later
*   Disable any security or antivirus software before beginning the installation.


1.  Run command-line environment as Administrator.

1.  Download the DC/OS CLI executable to your local directory ([dcos.exe](https://downloads.dcos.io/binaries/cli/windows/x86-64/dcos-1.10/dcos.exe)).

1.  Set up the connection from the CLI to your DC/OS cluster. In this example, `http://example.com` is the master node URL.

    ```powershell
    dcos cluster setup http://example.com
    ```

    Follow the instructions in the DC/OS CLI. For more information about security, see the [documentation](/docs/1.11/security/).

    Your CLI should now be authenticated with your cluster! Enter `dcos` to get started.
