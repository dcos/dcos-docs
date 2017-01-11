---
post_title: CLI
nav_title: CLI
menu_order: 10
---

**Important:** DC/OS 1.8 introduces binary CLIs for Linux, Windows, and Mac. The install script is replaced with a simple binary CLI. The 1.8 CLI is compatible with DC/OS 1.6.1 forward. For more information, see the [documentation](/docs/1.7/usage/cli/install/).

You can use the DC/OS command-line interface (CLI) to manage your cluster nodes, install DC/OS packages, inspect the cluster state, and administer the DC/OS service subcommands. You can install the CLI from the DC/OS web interface.

To list available commands, either run `dcos` with no parameters or run `dcos help`:

    $ dcos
    Command line utility for the Mesosphere Datacenter Operating
    System (DC/OS). The Mesosphere DC/OS is a distributed operating
    system built around Apache Mesos. This utility provides tools
    for easy management of a DC/OS installation.
    
    Available DC/OS commands:
    
        auth           	Authenticate to DCOS cluster
        config          Get and set DC/OS CLI configuration properties
        help            Display command line usage information
        marathon        Deploy and manage applications on the DC/OS
        node            Manage DC/OS nodes
        package         Install and manage DC/OS packages
        service         Manage DC/OS services
        task            Manage DC/OS tasks
    
    Get detailed command description with 'dcos <command> --help'.
    

# Environment Variables

For easy reference, these environment variables are supported by the DC/OS CLI:

The DC/OS CLI supports several environment variables that you can set dynamically.

`DCOS_CONFIG` Set the path to the DC/OS configuration file. By default, this variable is set to `DCOS_CONFIG=/<home-directory>/.dcos/dcos.toml`. For example, if you moved your DC/OS configuration file to `/home/jdoe/config/` you can specify this command:

    $ export DCOS_CONFIG=/home/jdoe/config/dcos.toml
    

`DCOS_SSL_VERIFY` Indicates whether to verify SSL certificates for HTTPS (`true`) or set the path to the SSL certificates (`false`). By default, this is variable is set to `true`. This is equivalent to setting the `core.ssl_config` option in the DC/OS configuration file. For example, to set the path to SSL certificates:

    $ export DCOS_SSL_VERIFY=false
    

`DCOS_LOG_LEVEL` Prints log messages to stderr at or above the level indicated. This is equivalent to the `--log-level` command-line option. The severity levels are:

*   **debug** Prints all messages to stderr, including informational, warning, error, and critical.
*   **info** Prints informational, warning, error, and critical messages to stderr.
*   **warning** Prints warning, error, and critical messages to stderr.
*   **error** Prints error and critical messages to stderr.
*   **critical** Prints only critical messages to stderr.

For example, to set the log level to warning:

    $ export DCOS_LOG_LEVEL=warning
    

`DCOS_DEBUG` Indicates whether to print additional debug messages to `stdout`. By default this is set to `false`. For example:

    $ export DCOS_DEBUG=true
    

# Configuration Files

By default, the DC/OS command line stores its configuration files in a directory called `~/.dcos` within your HOME directory. However, you can specify a different location by using the `DCOS_CONFIG` environment variable.

The configuration settings are stored in the `dcos.toml` file. You can modify these settings with the `dcos config` command.

**dcos_url** The the public master IP of your DC/OS installation. This is set by default during installation. For example:

    dcos config set core.dcos_url 52.36.102.191
    

**email** Your email address. This is set by default during installation. For example, to reset your email address:

    dcos config set core.email jdoe@mesosphere.com
    

**mesos_master_url** The Mesos master URL. This must be of the format: `http://<host>:<port>`. For example, to set your Mesos master URL:

    dcos config set core.mesos_master_url 52.34.160.132:5050
    

**reporting** Indicate whether to report usage events to Mesosphere. By default this is set to `True`. For example, to set to false:

    dcos config set core.reporting False
    

**ssl_verify** Indicates whether to verify SSL certs for HTTPS or path to certs. By default this is set to `False`. For example, to set to true:

    dcos config set core.ssl_verify True
    

**timeout** Request timeout in seconds, with a minimum value of 1 second. By default this is set to 5 seconds. For example, to set to 3 seconds:

    dcos config set core.timeout 3
    

**token** The OAuth access token. For example, to change the OAuth token:

    dcos config set core.token <token>

 
