---
post_title: dcos marathon pod add
menu_order: 23
---

# Description
Add a pod.

# Usage

```bash
dcos marathon pod add <pod-resource> [OPTION]
```

# Options

None.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<pod-resource>`   |             |  Path to a file or HTTP(S) URL that contains the pod's JSON definition. If omitted, the definition is read from stdin. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.10/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

# Examples

# Add a Pod

To add a pod, first create a JSON pod definition. Then, run the following command:
```
dcos marathon pod add <pod-json-file>
```