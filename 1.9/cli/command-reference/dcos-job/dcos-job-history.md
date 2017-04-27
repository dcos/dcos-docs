---
post_title: dcos job history
menu_order: 1
---
    
# Description
Show job run history.

# Usage

```bash
dcos job history <job-id> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--json`   |             |  Print JSON-formatted list. |
| `--show-failures`   |             |  Show the failure table and statistics for history. |

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<job-id>`   |             |  Specify the job ID. |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos job](/docs/1.9/cli/command-reference/dcos-job/) |  Deploy and manage jobs in DC/OS. |

# Examples

## View the history of job

In this example, a job history is shown.

1.  List the jobs and find the ID:

    ```bash
    dcos job list
    ```
    
    Here is the output:
    
    ```bash
    ID                DESCRIPTION                      STATUS       LAST SUCCESFUL RUN  
    my-job            A job that sleeps                Unscheduled         N/A          
    my-scheduled-job  A job that sleeps on a schedule  Unscheduled         N/A 
    ```
    
1.  View the job history for `my-scheduled-job`:

    ```bash
    dcos job history my-scheduled-job
    ```
    
    Here is the output:
    
    ```bash
    'my-scheduled-job'  Successful runs: 1 Last Success: 2017-02-17T23:18:33.842+0000
    ID                             STARTED                       FINISHED            
    20170217231831HkXNK  2017-02-17T23:18:31.651+0000  2017-02-17T23:18:33.843+0000 
    ```
    
    **Tip:** Specify the `--json` option to view the JSON app definition (e.g. `dcos job history my-scheduled-job`).