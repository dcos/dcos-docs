---
post_title: Getting Started
nav_title: Getting Started
feature_maturity: preview
menu_order: 10
---

You can create and administer jobs in the DC/OS web interface or via the API.

# DC/OS Web Interface

**Note:** The DC/OS web interface does not cover all possible CLI commands and API calls. For more advanced Jobs configuration, use the `dcos job` commands of the DC/OS CLI or the Jobs API.

## Add a Job

From the DC/OS web interface, click the **Jobs** tab, then the **New Job** button. Fill in the following fields, or toggle to JSON mode to edit the JSON directly:

* **Job ID** - The ID of your job.
* **Description** - A description of your job.
* **CPU** - The amount of CPU your job requires.
* **Memory** - The amount of memory your job requires.
* **Disk space** - The amount of disk space your job requires.
* **Command** - The command your job will execute. Leave this blank if you will use a Docker image.
* **Schedule** - Specify the schedule in cron format, as well as the time zone and starting deadline. Use [this crontab generator](http://crontab.guru) for help.
* **Docker Container** - Fill in this field if you will use a Docker image to specify the action of your job.
* **Labels** - Attach metadata to your job so you can filter them. [Learn more about labels](/docs/1.9/usage/tutorials/task-labels.md).

## Modify, View, or Remove a Job

From the **Jobs** tab, click the name of your job to modify or delete your job. While the job is running you can click the job instance to drill down to **Details**, **Files**, and **Logs** data.

# DC/OS CLI
  
You can create and manage jobs from the DC/OS CLI using `dcos job` commands. To see a full list of available commands, run `dcos job --help`.
 
## Add a Job
 
1. Create a job file in JSON format. The `id` parameter is the job ID. You will use this ID later to manage your job.
 
    ```json
    {
        "id": "myjob",
        "description": "A job that sleeps regularly",
        "run": {
            "cmd": "sleep 20000",
            "cpus": 0.01,
            "mem": 32,
            "disk": 0
        },
        "schedules": {
            "id": "sleep-schedule",
            "enabled": true,
            "cron": "20 0 * * *",
            "concurrencyPolicy": "ALLOW"
        }
    }
    ```
 
     **Note:** You can only assign one schedule to a job.
 
1. Add the job:
    ```bash
    dcos job add <myjob>.json
    ```
 
    **Note:** You can choose any name for your job file.
 
1. Go to the "Jobs" tab of the DC/OS web interface to verify that you have added your job, or verify from the CLI:
    ```bash
    dcos job list
    ```
 
## Schedule-Only JSON
 
If you use the same schedule for more than one job, you can create a separate JSON file for the schedule. Use the [`dcos job schedule add` command](#add-sched) associate a job with the schedule.
 
```json
{
    "concurrencyPolicy": "ALLOW",
    "cron": "20 0 * * *",
    "enabled": true,
    "id": "nightly",
    "nextRunAt": "2016-07-26T00:20:00.000+0000",
    "startingDeadlineSeconds": 900,
    "timezone": "UTC"
}
```
 
## Remove a Job
 
1. Enter the following command on the DC/OS CLI:
 
    ```
    dcos job remove <job-id>
    ```
 
1. Go to the "Jobs" tab of the DC/OS web interface to verify that you have removed your job, or verify from the CLI:
 
    ```
    dcos job list
    ```
 
## Modify a Job
 
To modify your job, by update your JSON job file, then run
 
```
dcos job update <job-file>.json
```

### Modify a Job's Schedule

You can update the schedule of your job in two ways, depending if your job has a schedule specified in the `<job-file>.json` or if your job's schedule is kept in a separate file.

#### Modify a Job with a Schedule

Modify the `schedules` parameter of your `<job-file>.json`. Then run

```
dcos job update <job-file>.json
```

#### Modify a Job with a Separate Schedule file

Modify your `<schedule-file>.json`. Then, run one of the following commands:
 
```bash
dcos job schedule add <job-id> <schedule-file>.json
dcos job schedule remove <job-id> <schedule-id>
dcos job schedule update <job-id> <schedule-file>.json
```
 
## View Job Details

List all jobs:

```
dcos job list
```

List all previous runs of your job:

```
dcos job history <job-id>
```

To view details about your job, run:
 
```
dcos job show <job-id>
```
 
To view details about your job's schedule, run:
 
```
dcos job schedule show <job-id>
```

### Read Job logs

Inspect the log for your job:

```
dcos task log --completed <job-id>
```

To get the log for only a specific job run, use a job run ID from `dcos job history <job-id>`

```
dcos task log --completed <job-run-id>
```

# Jobs API

You can also create and administer jobs via the API. [View the full API here](http://dcos.github.io/metronome/docs/generated/api.html).

**Note:** The DC/OS CLI and web interface support a combined JSON format (accessed via the `/v0` endpoint) that allows you to specify a schedule in the job descriptor. To schedule a job via the API, use two calls: one to add an unscheduled job and another to associate a `<schedule-file>.json` with the job.

## Add a Job

The following command adds a job called `myjob.json`.

```
curl -X POST -H "Content-Type: application/json" -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs -d@/Users/<your-username>/<myjob>.json
```

## Remove a Job

The following command removes a job regardless of whether the job is running:
```
curl -X DELETE -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs/<myjob>?stopCurrentJobRuns=true
```

To remove a job only if it is not running, set `stopCurrentJobRuns` to `False`.

## Modify or View a Job

The following command shows all jobs:

```
curl -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs
```

The following command lists job runs:

```
curl -H "Authorization: token=$(dcos config show core.dcos_acs_token)" "$(dcos config show core.dcos_url)/service/metronome/v1/jobs/<myjob>/runs/"
```

Stop a run with the following command:

```
curl -X POST -H "Authorization: token=$(dcos config show core.dcos_acs_token)" "$(dcos config show core.dcos_url)/service/metronome/v1/jobs/<myjob>/runs/20160725212507ghwfZ/actions/stop"
```

<a name="add-sched"></a>
## Add a Schedule to a Job

The following command adds a schedule to a job:

```
curl -X POST -H "Content-Type: application/json" -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs/<job-id>/schedules -d@/Users/<your-username>/<schedule-file>.json 
```