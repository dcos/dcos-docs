---
post_title: dcos config show
menu_order: 2
---

# Description
Print the DC/OS configuration file contents.

# Usage

```bash
dcos config show <name> [OPTION]
``` 

# Options

None.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<name>`   |             |  The name of the property. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos config](/docs/1.9/cli/command-reference/dcos-config/) |  Manage DC/OS configuration. |

# Examples

## View a specific config value

In this example, the DC/OS URL is shown.

```bash
dcos config show core.dcos_url
```

Here is the output:

```bash
https://your-cluster-9vqnkrq5pt2n-2781474.cloue-1.elb.amazonaws.com
```

## View all config values

In this example, all config values are shown.

```bash
dcos config show
```

Here is the output:

```bash
core.dcos_url https://your-cluster-9vqnkrq5pt2n-2781474.cloue-1.elb.amazonaws.com
core.ssl_verify false
```


