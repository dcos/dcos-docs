---
post_title: dcos marathon app kill
menu_order: 2
---

# Description
Kill a running application instance.

# Usage

```bash
dcos marathon app kill <app-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--host=<host>`   |             | The hostname that is running app. |
| `--scale`   |             | Scale the app down after performing the the operation.  |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<app-id>`   |             |  The application ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.9/usage/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

<!-- # Examples -->