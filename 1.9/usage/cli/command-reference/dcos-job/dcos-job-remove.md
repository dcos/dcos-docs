---
post_title: dcos job remove
menu_order: 4
---
    
# Description
Remove jobs.

# Usage

```bash
dcos job remove <job-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--stop-current-job-runs`   |             |  Remove all running jobs. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<job-id>`   |             |  Specify the job ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos job](/docs/1.9/usage/cli/command-reference/dcos-job/) |  Deploy and manage jobs in DC/OS. |

# Examples

## Remove a job

In this example, a job with the ID `my-job` is removed.

```bash
dcos job remove my-job
```

**Tip:** You can view the job IDs with the `dcos job list` command.