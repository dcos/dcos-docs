---
post_title: dcos config set
menu_order: 1
---

# Description
Add or set a DC/OS configuration properties. Here are the available properties.

| **Property**  | **Description** |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| core.dcos_acs_token   | This property contains the DC/OS authentication token. When you log into the DC/OS CLI using `dcos auth login`, it stores the authentication token value locally. For more information, see the [documentation](/docs/1.9/security/iam-api/). |
| core.dcos_url         | This property contains the public master IP of your DC/OS cluster.|
| core.mesos_master_url | This property specifies the Mesos master URL.|
| core.pagination       | This property indicates whether to paginate output. |
| core.ssl_verify       | This property specifies whether to verify SSL certificates for HTTPS (`true`) or set the path to the SSL certificates (`false`). |
| core.timeout          | This property specifies the request timeout in seconds, with a minimum value of 1 second. By default this is set to 5 seconds.  |


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
| [dcos config](/docs/1.9/cli/command-reference/dcos-config/) |  Manage DC/OS configuration. |


# Examples

## Configure CLI to DC/OS Cluster

In this example, the public master IP of the cluster is set to `http://www.yourcloud.com`.

```bash
dcos config set core.dcos_url http://www.yourcloud.com
```

Here is the output:

```bash
[core.dcos_url]: changed from 'https://joel-ee-m-elasticl-4s1iwxbuuz86-366325365.us-west-2.elb.amazonaws.com' to 'http://www.yourcloud.com'
```

## Set SSL setting

In this example, the verify SSL certificates for HTTPS is set to `true`.

``bash
dcos config set core.ssl_verify true
```

Here is the output:

```bash
[core.ssl_verify]: set to 'true'
```


