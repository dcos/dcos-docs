---
post_title: dcos marathon group show
menu_order: 21
---

# Description
Print a detailed list of groups.

# Usage

```bash
dcos marathon group show <group-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--group-version=<group-version>`   |             |  The group version to use for the command. It can be specified as an absolute or relative value. Absolute values must be in ISO8601 date format. Relative values must be specified as a negative integer and they represent the version from the currently deployed group definition. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<group-id>`   |             |  The group ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.9/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

<!-- # Examples -->