---
post_title: dcos task ls
menu_order: 2
---

# Description
Print the list of files in the Mesos task sandbox.

# Usage

```bash
dcos task ls <task> <path> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--completed`   |             | Print completed and in-progress tasks. |
| `--long`   |             |  Print full Mesos sandbox file attributes. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<task>`   |             |  A full task ID, a partial task ID, or a regular expression. |
| `<path>`   |     `.`      |  The Mesos sandbox directory path. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos task](/docs/1.10/cli/command-reference/dcos-task/)   | Manage DC/OS tasks. |  