---
post_title: dcos node
menu_order: 6
---
    
# Description
View DC/OS node information.

# Usage

```bash
dcos node [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--json`   |             |  Print JSON-formatted data. |
| `--version, v`   |             | Print version information. |

# Child commands

| Command | Description |
|---------|-------------|
| [dcos node diagnostics](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-diagnostics/)   | View the details of diagnostics bundles. |  
| [dcos node diagnostics create](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-diagnostics-create/)   | Create a diagnostics bundle.|  
| [dcos node diagnostics delete](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-diagnostics-delete/)   | Delete a diagnostics bundle.|  
| [dcos node diagnostics download](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-diagnostics-download/)   | Download a diagnostics bundle.|  
| [dcos node list components](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-list-components/)   |             |  
| [dcos node log](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-log/)   | Print the Mesos logs for the leading master node, agent nodes, or both. |  
| [dcos node ssh](/docs/1.9/usage/cli/command-reference/dcos-node/dcos-node-ssh/)   | Establish an SSH connection to the master or agent nodes of your DC/OS cluster. |  