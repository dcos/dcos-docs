---
post_title: dcos experimental
menu_order: 2.1
---
    
# Description
Manage commands that under development and subject to change.

# Usage

```bash
dcos experimental [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--version, v`   |             | Print version information. |  
    
Description:
    Commands under development and subject to change.

Usage:
    dcos experimental --help
    dcos experimental --info
    dcos experimental --version
    dcos experimental package add [--json]
                                  (--dcos-package=<dcos-package> |
                                    (--package-name=<package-name>
                                      [--package-version=<package-version>]))
    dcos experimental package build <build-definition>
                                    [--json]
                                    [--output-directory=<output-directory>]
    dcos experimental service start <package-name>
                                    [--json]
                                    [--package-version=<package-version>]
                                    [--options=<options-file>]

Commands:
    package add
        Adds a DC/OS package to DC/OS.
    package build
        Build a package locally to be added to DC/OS or to be shared with
        Universe.
    service start
        Starts a service from a DC/OS package that was added to DC/OS. See
        `dcos experimental package add` for information on how to add a
        package to DC/OS.

Options:
    --dcos-package=<dcos-package>
        Path to a DC/OS Package.
    -h, --help
        Print usage.
    --info
        Print a short description of this subcommand.
    --json
        Prints information is json format.
    --options=<options-file>
        Path to a JSON file that contains customized package execution options.
    --output-directory=<output-directory>
        Path to the directory where the data should be stored.
        Defaults to the current working directory.
    --package-name=<package-name>
        Name of the DC/OS package in the package repository.
    --package-version=<package-version>
        The package version to add.
    --version
        Print version information.

Positional Arguments:
    <build-definition>
        Path to a DC/OS Package Build Definition.
    <package-name>
        Name of a DC/OS package that has been added to DC/OS.

# Child commands

| Command | Description |
|---------|-------------|
| [dcos experimental package add](/docs/1.9/usage/cli/command-reference/dcos-experimental/dcos-experimental-package-add/)   |  Add a DC/OS package to DC/OS. |     
| [dcos experimental package build](/docs/1.9/usage/cli/command-reference/dcos-experimental/dcos-experimental-package-build/)   |  Build a package locally to be added to DC/OS or to be shared with Universe. |     
| [dcos experimental package start](/docs/1.9/usage/cli/command-reference/dcos-experimental/dcos-experimental-package-start/)   |  Start a service from a non-native DC/OS package. See `dcos experimental package add` for information on how to add a package to DC/OS. |   