---
post_title: dcos config
menu_order: 2
---

# Description
This command manages the DC/OS configuration file. A default configuration file is created during initial DCOS CLI setup and is located in `~/.dcos/dcos.toml`.

## Environment variables
Configuration properties all have corresponding environment variables. If a property is in the "core" section (ex. "core.foo", it corresponds to environment variable DCOS_FOO. All other properties (ex "foo.bar") correspond to environment variable DCOS_FOO_BAR.

Environment variables take precedence over corresponding configuration property.

# Usage

```bash
dcos config 
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--version, v`   |             | Print version information. |

# Child commands

| Command | Description |
|---------|-------------|
| [dcos config set](/docs/1.9/usage/cli/command-reference/dcos-config/dcos-config-set/)   | Add or set a DC/OS configuration property. |  
| [dcos config show](/docs/1.9/usage/cli/command-reference/dcos-config/dcos-config-show/)    | Print the DC/OS configuration file contents. |  
| [dcos config unset](/docs/1.9/usage/cli/command-reference/dcos-config/dcos-config-unset/)    | Remove a property from the configuration file. |  
| [dcos config validate](/docs/1.9/usage/cli/command-reference/dcos-config/dcos-config-validate/)    | Validate changes to the configuration file. |  