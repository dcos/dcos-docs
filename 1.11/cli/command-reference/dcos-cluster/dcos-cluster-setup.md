---
post_title: dcos cluster setup
menu_order: 6
---

# Description
Configure the connection to a DC/OS cluster, attach to the cluster, and authenticate to DC/OS.

# Usage

```bash
dcos cluster setup <dcos_url> [OPTIONS]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
|  `--ca-certs=<ca-certs>` |             | (Enterprise DC/OS Only) The path to a list of trusted CAs to verify requests against.  |
|  `--insecure` |                        | Allow requests to bypass SSL certificate verification. Analogous to `dcos config set core.ssl_verify=False`|
|  `--no-check` |                        | (Enterprise DC/OS Only) Do not check the CA certificate downloaded from the cluster. This is insecure. |
|  `--password-env=<password_env>` |     | The name of an environment variable that contains the password for login. |
|  `--password-file=<password_file>`  |  | The path to a file that contains the password for login. |
|  `--password=<password>`  |            | The password for login. This is insecure.  |
|  `--private-key=<key_path>`  |         | The path to a file that contains the private key.  |
|  `--provider=<provider_id>`  |         | (Enterprise DC/OS Only) The authentication provider to use for login.  |
|  `--username=<username>`  |            | The username for login. |

## SSL options

If you do not specify one of the SSL options `--insecure`, `--no-check`, or `--ca-certs`, the CA certificate is downloaded from the cluster and a sha256 fingerprint of the certificate is presented to you for verification.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<dcos_url>`   |             | A publicly accessible proxy IP address to a master node. |


# Parent command

| Command | Description |
|---------|-------------|
| [dcos cluster](/docs/1.11/cli/command-reference/dcos-cluster/) | Manage DC/OS clusters. |

# Examples
For examples, see the [Connecting to Multiple Clusters](/docs/1.11/cli/multi-cluster-cli/) documentation.
