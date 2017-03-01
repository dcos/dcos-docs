---
post_title: dcos job run
menu_order: 5
---
    
# Description
Run a job now.

# Usage

```bash
dcos job run <job-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--help, h`   |             |  Print usage. |
| `--info`   |             |  Print a short description of this subcommand. |
| `--version, v`   |             | Print version information. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<job-id>`   |             |  Specify the job ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos job](/docs/1.9/usage/cli/command-reference/dcos-job/) |  Deploy and manage jobs in DC/OS. |

# Examples

## Run a job

In this example, a job named `my-job` is run.

```bash
$ dcos job run my-job
```

**Tip:** You can view the job IDs with the `dcos job list` command.