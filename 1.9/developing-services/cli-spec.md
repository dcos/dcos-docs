---
post_title: CLI Specification
menu_order: 3
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

This document is intended for a developer creating new DC/OS CLI commands.

See also the [Universe Getting Started][1].

## The DC/OS CLI
You can [install](/docs/1.9/cli/install/) the DC/OS Command Line Interface (CLI) locally on your machine. The DC/OS CLI communicates with the DC/OS cluster, running either on-premise or with a cloud provider.

The DC/OS CLI uses a single command, `dcos`. All functions are expressed as subcommands, and are shown with the `dcos help` command.

The DC/OS CLI is open and extensible: anyone can create a new subcommand and make it available for installation by end users.

For example, the Spark DC/OS Service provides [CLI extensions for working with Spark][2]. When installed, you can type the following command to run Spark jobs in the datacenter and query their status:

    dcos spark [parameters]


## How to create a new DC/OS CLI subcommand

### Requirements
DC/OS CLI subcommands:

* executables specified for Mac, Linux, and Windows

### Example: Hello World
The [Hello World example][3] implements a new subcommand called **helloworld**:

    dcos package install helloworld --cli
    dcos helloworld

### How the DC/OS CLI discovers subcommands
When the `dcos` command is run, it searches the current shell’s PATH for executables with names that are prefixed with `dcos-` in the `~/.dcos/subcommands` directory.

In the Hello World example, written in Python, you can create an executable of the subcommand using [pyinstaller][4].

### DC/OS CLI configuration
The DC/OS CLI maintains a configuration file in [TOML format][5], where subcommands can store configuration data.

The environment variable `DCOS_CONFIG` contains the path to this file.

Example of a configuration file:
```
[marathon]
host = "localhost"
port = "8080"


[package]
sources = [ "git://github.com/mesosphere/universe.git", "https://github.com/mesosphere/universe/archive/master.zip",]
cache = "/tmp/dcos-cache"


[your-subcommand]
foo = [ "bar", "baz" ]
```

You can make changes to the configuration file by using the `dcos config` command. For example, to change the marathon.host value:

    dcos config set marathon.host localhost

### Standard flags
You must assign a standard set of flags to each DC/OS CLI subcommand, described below:

```
--info
--version
--help
-h
--config-schema
```

#### --info
The `--info` flag shows a short, one-line description of the function of your subcommand. This content is displayed when the user runs `dcos help`.    

Example from the Spark CLI:

```
dcos spark --info
Run and manage Spark jobs
```

```
dcos help | grep spark
      spark        Run and manage Spark jobs
```

#### --version
The `--version` flag shows the version of the subcommand package. Notice that the subcommand package is unrelated to the version of the Service running on DC/OS.

For example, Spark v1.2.1 might be installed on DC/OS, whereas the local spark DC/OS CLI package might be at v0.1.0.

An example from the Marathon CLI:

    dcos marathon --version
    dcos-marathon version 0.1.0

#### --help and -h
The  `--help` and `-h` flags both show the detailed usage for your subcommand.

An example from the Marathon CLI:

```
dcos marathon --help
Deploy and manage applications on the DC/OS


Usage:
	dcos marathon --config-schema
	dcos marathon --info
	dcos marathon app add [<app-resource>]
	dcos marathon app list
	dcos marathon app remove [--force] <app-id>
	dcos marathon app restart [--force] <app-id>
	dcos marathon app show [--app-version=<app-version>] <app-id>
	dcos marathon app start [--force] <app-id> [<instances>]
	dcos marathon app stop [--force] <app-id>
	dcos marathon app update [--force] <app-id> [<properties>...]
	dcos marathon app version list [--max-count=<max-count>] <app-id>
	dcos marathon deployment list [<app-id>]
	dcos marathon deployment rollback <deployment-id>
	dcos marathon deployment stop <deployment-id>
	dcos marathon deployment watch [--max-count=<max-count>]
     	     [--interval=<interval>] <deployment-id>
	dcos marathon task list [<app-id>]
	dcos marathon task show <task-id>


Options:
	-h, --help               	Show this screen
	--info                   	Show a short description of this subcommand
	--version                	Show version
	--force                    ...
	--app-version=<app-version>  ...
	--config-schema          	...
	--max-count=<max-count>  	...
	--interval=<interval>    	...


Positional arguments:
	<app-id>                	The application id
	<app-resource>          	...
	<deployment-id>         	The deployment id
	<instances>             	The number of instances to start
	<properties>            	...
	<task-id>               	The task id
```

#### --config-schema
The DC/OS CLI validates configurations set with the `dcos config` set command, by comparing them against a [JSON Schema][6] that you define.

When your Marathon CLI subcommand is passed the `--config-schema` flag, it MUST output a JSON Schema document for its configuration.

Here’s an example from the Marathon CLI:

```
dcos marathon --config-schema
{
  "$schema": "http://json-schema.org/schema#",
  "additionalProperties": false,
  "properties": {
	"host": {
  	"default": "localhost",
  	"description": "",
  	"title": "Marathon hostname or IP address",
  	"type": "string"
	},
	"port": {
  	"default": 8080,
  	"description": "",
  	"maximum": 65535,
  	"minimum": 1,
  	"title": "Marathon port",
  	"type": "integer"
	}
  },
  "required": [
	"host",
	"port"
  ],
  "type": "object"
}
```

### Parameter naming conventions
The DC/OS CLI commands naming convention is:

    dcos <subcommand> <resource> <verb>

A resource is typically a noun. For example:

    dcos marathon app add

### Logging
The environment variable DCOS_LOG_LEVEL is set to the log level the user sets at the command line.

The logging levels are described in [Python’s logging HOWTO][7]: DEBUG, INFO, WARNING, ERROR and CRITICAL.    

### The DC/OS CLI Module

The [DC/OS Python package][8] is a set of common functionality useful to subcommand developers.

### Packaging
To make your subcommand available to end users, you must:

1. Add a package entry to the Mesosphere Universe repository. See the [Universe README][9] for the specification.

The package entry contains a file named [resource.json][10] that contains links to the executable subcommands.

When the end user runs `dcos package install spark --cli`:

1. The package entry for Spark is retrieved from the repository,
2. The `resource.json` file is parsed to find the CLI resources
3. The executable for the user’s platform is downloaded

## How to install a new CLI subcommand

You can install a new CLI subcommand by using this syntax:

    dcos package install <cli package> --cli

The same [packaging format and repository][11] is used for both DC/OS Services and CLI subcommands.    



[1]: https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md
[2]: https://github.com/mesosphere/spark-build 
[3]: https://github.com/mesosphere/dcos-helloworld
[4]: http://www.pyinstaller.org/
[5]: https://github.com/toml-lang/toml
[6]: http://json-schema.org/documentation.html
[7]: https://docs.python.org/2/howto/logging.html#when-to-use-logging
[8]: https://github.com/dcos/dcos-cli
[9]: https://github.com/mesosphere/universe/blob/version-3.x/README.md
[10]: https://github.com/mesosphere/universe/blob/version-3.x/README.md#resourcejson
[11]: https://github.com/mesosphere/universe/blob/version-3.x/README.md
