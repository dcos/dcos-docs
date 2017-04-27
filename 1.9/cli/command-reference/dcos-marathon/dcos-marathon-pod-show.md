---
post_title: dcos marathon pod show
menu_order: 27
---

# Description
Display detailed information for a specific pod.

# Usage

```bash
dcos marathon pod show <pod-id> [OPTION]
```

# Options

None.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<pod-id>`   |             | The pod ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.9/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

# Examples

# Show Pod JSON
To see the pod definition, run the following command:
```
dcos marathon pod show <pod-id>
```
You can use the `show` command to read data about the pod programmatically.