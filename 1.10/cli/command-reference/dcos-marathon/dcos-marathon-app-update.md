---
post_title: dcos marathon app update
menu_order: 9
---

# Description
Add an application.

# Usage

```bash
dcos marathon app update <app-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--force`   |             | Disable checks in Marathon during updates. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<app-id>`   |             |  The application ID. |
| `<properties>`   |             |  List of one or more JSON object properties, separated by a space. The list must be formatted as `<key>=<value>`. For example, `cpus=2.0 mem=308`. If omitted, properties are read from a JSON object provided on stdin. |


# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.10/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

# Examples

For examples, see the [documentation](/docs/1.10/deploying-services/update-user-service/).