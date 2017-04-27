---
post_title: dcos marathon app update
menu_order: 9
---

# Description
Add an application.

# Usage

```bash
dcos marathon app add <app-resource> [OPTION]
```

# Options

None.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<app-resource>`   |             |  Path to a file or HTTP(S) URL that contains the app's JSON definition. If omitted, the definition is read from stdin. For a detailed description see the [documentation](/docs/1.9/deploying-services/marathon-api/). |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.9/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

# Examples

For examples, see the [documentation](/docs/1.9/deploying-services/update-user-service/).