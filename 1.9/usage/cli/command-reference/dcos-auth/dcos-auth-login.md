---
post_title: dcos auth login
menu_order: 2
---

# Description
Log in to DC/OS authentication. 

# Usage

```bash
dcos auth login [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--password=<password>`   |             | Specify password on the command line (insecure). |
| `--password-env=<password_env>`   |             | Specify an environment variable name that contains the password. |
| `--password-file=<password_file>`   |             | Specify the path to a file that contains the password. |
| `--private-key=<key_path>`   |             | Specify the path to a file that contains the private key. |
| `--provider=<provider_id>`   |             | Specify the authentication provider to use for login. |
| `--username=<username>`   |             | Specify the username for login. |
| `--version, v`   |             | Print version information. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos auth](/docs/1.9/usage/cli/command-reference/dcos-auth/) |  Manage DC/OS identity and access. |

# Examples