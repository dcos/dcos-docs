---
post_title: dcos job show runs
menu_order: 11
---
    
# Description
Show the successful and failure status of job runs.

# Usage

```bash
dcos job show runs <job-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--json`   |             |  Print JSON-formatted list. |
| `--q`   |             |  Print an array of run IDs only. |
| `--run-id <run-id>`   |             |  The ID of a job run. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<job-id>`   |             |  Specify the job ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos job](/docs/1.9/cli/command-reference/dcos-job/) |  Deploy and manage jobs in DC/OS. |

# Examples

## Show the run status

In this example, the successful runs for a job are shown.

```bash
dcos job show runs my-scheduled-job
```

Here is the output:

```bash
JOB ID            ID                            STARTED AT           
my-scheduled-job  20170218001959YVKlq  2017-02-18T00:19:59.417+0000  
my-scheduled-job  20170217230705AfpRn  2017-02-17T23:07:05.218+0000
```