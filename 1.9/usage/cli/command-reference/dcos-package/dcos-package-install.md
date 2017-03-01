---
post_title: dcos package install
menu_order: 1
---

# Description
Install a package.

# Usage

```bash
dcos package install <package-name> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--app`   |             |  Application only. |
| `--app-id=<app-id>`   |             |  The application ID. |
| `--cli`   |             |  Command line only. |
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--options=<file>`   |             | Path to a JSON file that contains customized package installation options. |
| `--package-version=<package-version>`   |             | The package version. |
| `--version, v`   |             | Print version information. |
| `--yes`   |             | Disable interactive mode and assume "yes" is the answer to all prompts. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<package-name>`   |             |  Name of the DC/OS package. |
        
# Parent command

| Command | Description |
|---------|-------------|
| [dcos package](/docs/1.9/usage/cli/command-reference/dcos-package/)   | Install and manage DC/OS software packages. |

# Examples

For an example, see the [documentation](/docs/1.9/usage/managing-services/config/).