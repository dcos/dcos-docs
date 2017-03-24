---
post_title: dcos task exec
menu_order: 0
---

# Description
Launch a process inside of a task container.

# Usage

```bash
dcos task exec [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--interactive, -i`   |             |  Attach a STDIN stream to the remote command for an interactive session. |
| `--tty, -t`   |             |  Attach a TTY to the remote stream. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<args>`   |             |  Additional arguments to pass to the command. |
| `<cmd>`   |             |  The command to run inside the remote task's container. For example: `/bin/bash`. |
| `<task>`   |             |  A full task ID, a partial task ID, or a regular expression. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos task](/docs/1.9/usage/cli/command-reference/dcos-task/)   | Manage DC/OS tasks. |  