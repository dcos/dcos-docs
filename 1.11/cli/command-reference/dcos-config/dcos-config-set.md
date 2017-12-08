---
post_title: dcos config set
menu_order: 1
---

# Description
Add or set DC/OS configuration properties. Here are the available properties.

| **Property**  | **Description** |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `core.dcos_acs_token`   | The DC/OS authentication token. When you log into the DC/OS CLI using `dcos auth login`, it stores the authentication token value locally. For more information, see the [documentation](/docs/1.11/security/iam-api/). |
| `core.dcos_url`         | The public master URL of your DC/OS cluster.|
| `core.mesos_master_url` | The Mesos master URL. Defaults to `core.dcos_url`. |
| `core.pagination`       | Indicates whether to paginate output. Defaults to true.|
| `core.ssl_verify`       | Indicates whether to verify SSL certificates or set the path to the SSL certificates.|
| `core.timeout`          | The request timeout in seconds, with a minimum value of 1 second. Defaults to 3 minutes.|


# Usage

```bash
dcos config set <name> <value> [OPTION]
```

# Options

None.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<name>`   |             |  The name of the property. |
| `<value>`   |             |  The value of the property. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos config](/docs/1.11/cli/command-reference/dcos-config/) |  Manage DC/OS configuration. |


# Examples

## Set request timeout

In this example, the request timeout is set to 5 minutes.

```bash
dcos config set core.timeout 300
```

Here is the output:

```bash
[core.timeout]: set to '300'
```

## Set SSL setting

In this example, the verify SSL certificates for HTTPS is set to `true`.

```bash
dcos config set core.ssl_verify true
```

Here is the output:

```bash
[core.ssl_verify]: set to 'true'
```
