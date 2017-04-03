---
post_title: dcos node log
menu_order: 5
---
    
# Description
Print the Mesos logs for the leading master node, agent nodes, or both.

# Usage

```bash
dcos node log [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--leader`   |             |  The leading master. |
| `--follow`   |             |  Dynamically update the log. |
| `--lines=N`   |     10      |  Print the last N lines. |
| `--master`   |             |  This option is deprecated and is replaced by `--leader`. |
| `--mesos-id=<mesos-id>`   |             | The agent ID of a node. |
| `--slave=<agent-id>`   |             | This option is deprecated and is replaced by `--mesos-id`. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos node](/docs/1.9/usage/cli/command-reference/dcos-node/) | View DC/OS node information. | 

<!-- # Examples -->

