---
post_title: CLI Specification
menu_order: 3
post_excerpt: ""
feature_maturity: ""
---

The [DC/OS command-line interface (CLI)](/docs/1.10/cli) is a utility to manage cluster nodes, install and manage packages, inspect the cluster state, and manage services and tasks.

The DC/OS CLI is open and extensible: anyone can create a new subcommand and make it available for installation by end users. For example, the [Spark DC/OS service][2] provides CLI extensions for working with Spark. When installed, you can type the following command to submit Spark jobs and query their status:

    dcos spark [<flags>] <command>

This document is intended for a developer creating new DC/OS CLI subcommands. See also [Universe Getting Started][1].

# How the DC/OS CLI discovers subcommands

When you run the `dcos` command, it searches the current shell's PATH for executables with names that are prefixed with `dcos-` in the `~/.dcos/clusters/<cluster_id>/subcommands/<package_name>/env/bin` directory.

## Installing a CLI subcommand

To install a CLI subcommand, run:

    dcos package install <package>

or

    dcos package install <package> --cli

The same [packaging format and repository][11] is used for both DC/OS services and CLI subcommands.

**Note:** CLI modules are [cluster-specific](/docs/1.10/cli/multi-cluster-cli) and stored in `~/.dcos/clusters/<cluster_id>/subcommands`. You must install a CLI module for each cluster. For example, if you connect to cluster 1, and install the Spark module, then connect to cluster 2 which is also running Spark, Spark CLI commands are not available until you install the module for that cluster.

## Creating a DC/OS CLI subcommand

### Requirements

* Executables for Mac, Linux, and Windows

### Standard flags
You must assign a standard set of flags to each DC/OS CLI subcommand, described below:

```
--info
--help
-h
```

#### --info
The `--info` flag shows a short, one-line description of the function of your subcommand. This content is displayed when the user runs `dcos help`.    


##### Example from the Spark CLI:

```
dcos spark --info
Spark DC/OS CLI Module
```

When you run the `dcos` command without parameters, the info is returned for each subcommand:

```
dcos | grep spark
      spark        Spark DC/OS CLI Module
```

#### --help and -h
The  `--help` and `-h` flags both show the detailed usage for your subcommand.

Example from the Marathon CLI:

```
dcos marathon --help
Description:
    Deploy and manage applications to DC/OS.
...
```

### Subcommand naming conventions
The DC/OS CLI subcommand naming convention is:

    dcos <subcommand> <resource> <verb>

A `resource` is typically a noun and `verb` is an action supported by the resource. For example, in the following command, `resource` is `app` and the action is `add`:

    dcos marathon app add

### Subcommand logging
The environment variable `DCOS_LOG_LEVEL` is set to the log level the user sets at the command line.

The logging levels are described in [Python’s logging HOWTO][7]: DEBUG, INFO, WARNING, ERROR and CRITICAL.

### Packaging a CLI subcommand

To make your subcommand available to end users:

1. Add a package entry to the Mesosphere Universe repository. See the [Universe README][9] for the specification.

The package entry must contain a file named [resource.json][10] that contains links to the executable subcommands.

When you run `dcos package install <package> --cli`:

1. The package entry for <package> is retrieved from the repository.
2. The `resource.json` file is parsed to find the CLI resources.
3. The executable for the user's platform is downloaded.

### The DC/OS CLI module

The [DC/OS CLI module][8] has a set of tools useful to subcommand developers.


## Example: Hello World subcommand

The [Hello World example][3] implements a new subcommand called `helloworld`:

    dcos package install helloworld --cli
    dcos helloworld


[1]: https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md
[2]: https://github.com/mesosphere/spark-build 
[3]: https://github.com/mesosphere/dcos-helloworld
[7]: https://docs.python.org/2/howto/logging.html#when-to-use-logging
[8]: https://github.com/dcos/dcos-cli
[9]: https://github.com/mesosphere/universe/blob/version-3.x/README.md
[10]: https://github.com/mesosphere/universe/blob/version-3.x/README.md#resourcejson
[11]: https://github.com/mesosphere/universe/blob/version-3.x/README.md
