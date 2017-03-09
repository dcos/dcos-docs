---
post_title: CLI
nav_title: CLI
menu_order: 10 
---

You can use the DC/OS command-line interface (CLI) to manage your cluster nodes, install DC/OS packages, inspect the cluster state, and administer the DC/OS service subcommands. 

You can quickly [install](/docs/1.9/usage/cli/install) the CLI from the DC/OS web interface.

To list available commands, either run `dcos` with no parameters or run `dcos help`:

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
    

# Environment Variables

These environment variables are supported by the DC/OS CLI and can be set dynamically.

#### `DCOS_CONFIG` 
Set the path to the DC/OS configuration file. By default, this variable is set to `DCOS_CONFIG=/<home-directory>/.dcos/dcos.toml`. For example, if you moved your DC/OS configuration file to `/home/jdoe/config/` you can specify this command:

```bash
$ export DCOS_CONFIG=/home/jdoe/config/dcos.toml
```
    
#### `DCOS_SSL_VERIFY` 
Indicates whether to verify SSL certificates for HTTPS (`true`) or set the path to the SSL certificates (`false`). By default, this is variable is set to `true`. Setting this environment variable is equivalent to setting the `core.ssl_config` option in the DC/OS configuration [file](#configuration-files). For example, to indicate that you want to set the path to SSL certificates:

```bash
$ export DCOS_SSL_VERIFY=false
```

#### `DCOS_LOG_LEVEL` 
Prints log messages to stderr at or above the level indicated. This is equivalent to the `--log-level` command-line option. The severity levels are:

*   **debug** Prints all messages to stderr, including informational, warning, error, and critical.
*   **info** Prints informational, warning, error, and critical messages to stderr.
*   **warning** Prints warning, error, and critical messages to stderr.
*   **error** Prints error and critical messages to stderr.
*   **critical** Prints only critical messages to stderr.

For example, to set the log level to warning:

```bash
$ export DCOS_LOG_LEVEL=warning
```
    

#### `DCOS_DEBUG` 
Indicates whether to print additional debug messages to `stdout`. By default this is set to `false`. For example:

```bash
$ export DCOS_DEBUG=true
```
    

# <a name="configuration-files"></a>Configuration Files

By default, the DC/OS command line stores its configuration files in a directory called `~/.dcos` within your HOME directory. However, you can specify a different location by using the `DCOS_CONFIG` environment variable.

The configuration settings are stored in the `dcos.toml` file. You can modify these settings with the [dcos config set](/docs/1.9/usage/cli/command-reference/dcos-config/dcos-config-set/) command.
 
