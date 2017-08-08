---
post_title: dcos cluster setup
menu_order: 6
---

# Description
Configure the CLI to communicate with your DC/OS cluster.

# Usage

```bash
dcos cluster setup <dcos_url> [OPTIONS]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
|  --ca-certs=<ca-certs> |             | (Enterprise DC/OS Only) Specify the path to a list of trusted CAs to verify requests against.  |
|  --insecure |             | Allow requests to bypass SSL certificate verification.  |
|  --no-check |             | (Enterprise DC/OS Only) Do not check the CA certificate downloaded from the cluster. This is insecure. |
|  --password-env=<password_env> |             | Specify password on the command line. This is insecure.  |
|  --password-file=<password_file  |             |  Specify the path to a file that contains the password. |
|  --password=<password>  |             | Specify password on the command line. This is insecure.  |
|  --private-key=<key_path>]  |             | Specify the path to a file that contains the private key.  |
|  --provider=<provider_id>  |             | Specify the authentication provider to use for login.  |
|  --username=<username>  |             |  Specify the username for login. |



# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<dcos_url>`   |             | A publicly accessible proxy IP address to one of your master nodes. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos cluster](/docs/1.10/cli/command-reference/dcos-cluster/) | Manage your DC/OS clusters. |

# Examples
For examples, see the [Connecting to Multiple Clusters](/docs/1.10/cli/multi-cluster-cli/) documentation.