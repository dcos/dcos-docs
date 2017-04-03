---
post_title: dcos package
menu_order: 7
---

# Description
Install and manage DC/OS software packages.

# Usage

```bash
dcos package
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--config-schema`   |             |  Show the configuration schema for the subcommand. |
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--version, v`   |             | Print version information. |
        
# Child commands

| Command | Description |
|---------|-------------|
| [dcos package describe](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-describe/)   | Get specific details for packages. |  
| [dcos package install](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-install/)   | Install a package. |  
| [dcos package list](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-list/)   | Print a list of the installed DC/OS packages. |  
| [dcos package repo add](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-repo-add/)   | Add a package repository to DC/OS. |  
| [dcos package repo list](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-repo-list/)   | Remove a package repository from DC/OS. |  
| [dcos package repo remove](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-repo-remove/)   | Remove a package repository from DC/OS. |  
| [dcos package search](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-search/)   | Search the package repository. |  
| [dcos package uninstall](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-uninstall/)   | Uninstall a package. |  
| [dcos package update](/docs/1.9/usage/cli/command-reference/dcos-package/dcos-package-update/)   | This command has been deprecated. Repositories are dynamically updated when they are added by the `dcos package repo add` command. | 