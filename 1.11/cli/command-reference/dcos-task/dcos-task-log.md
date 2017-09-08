---
post_title: dcos task log
menu_order: 1
---

# Description
Print the task log.

# Usage

```bash
dcos task log <file> <task> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--completed`   |             | Print completed and in-progress tasks. |
| `--follow`   |             |  Dynamically update the log. |
| `--lines=N`   |     10      |  Print the last N lines. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<file>`   |  stdout  |  Specify the sandbox file to print. |
| `<task>`   |             |  A full task ID, a partial task ID, or a regular expression. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos task](/docs/1.10/cli/command-reference/dcos-task/)   | Manage DC/OS tasks. | 

# Examples

For an example, see the [documentation](/docs/1.10/monitoring/logging/).