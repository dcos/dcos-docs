---
post_title: Getting Started
nav_title: Getting Started
menu_order: 10
---

You can create and administer jobs in the DC/OS web interface, the DC/OS CLI, or via the API.

# DC/OS Web Interface

## Add a Job

From the DC/OS web interface, click the **Jobs** tab, then the **New Job** button. Fill in the following fields, or toggle to JSON mode to edit the JSON directly:

* **CPU**
* **Memory**
* **Disk space**
* **Command** - The command your job will execute. Leave this blank if you will use a Docker image.
* **Schedule** - Specify the schedule in cron format, as well as the time zone and starting deadline. Use [this crontab generator](http://crontab.guru) for help.
* **Docker Container** - Fill in this field if you will use a Docker image to specify the action of your job.
* **Labels**

## Modify, View, or Remove a Job

From the "Jobs" tab, click the name of your job to modify or delete your job. While the job is running you can click the job instance to drill down to "Details," "Files," and "Logs" data.

<!--
# DC/OS CLI

You can create and manage jobs from the DC/OS CLI using `dcos job` commands. To see a full list of available commands, run `dcos job --help`.

## Add a Job

1. Create a job file in JSON format:

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
      "schedules": [
        {
          "id": "sleep-schedule",
          "enabled": true,
          "cron": "20 0 * * *",
          "concurrencyPolicy": "ALLOW"
        }
      ]
    }
    ```

    **Note:** You can only assign one schedule to a job.

1. Add the job:
    ```
    dcos job add myjob.json
    ```

    **Note:** You can choose any name for your job file.

1. Go to the "Jobs" tab of the DC/OS web interface to verify that you have added your job, or verify from the CLI:
     ```
     dcos job list
     ```

### Schedule-Only JSON

If you use the same schedule for more than one job, you can create a separate JSON file for the schedule, then reference the schedule ID in the `schedules:id` parameter of your job file.

```
[
  {
    "concurrencyPolicy": "ALLOW",
    "cron": "20 0 * * *",
    "enabled": true,
    "id": "nightly",
    "nextRunAt": "2016-07-26T00:20:00.000+0000",
    "startingDeadlineSeconds": 900,
    "timezone": "UTC"
  }
]
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

## Modify or View a Job

To modify your job, by update your JSON job file, then run

```
dcos job update <job-file.json>
```

To modify the schedule of your job, modify the `schedules` parameter of your jobs file. <!--is this right? or do you have a separate file? --> Then, run one of the following commands:

```
dcos job schedule add <job-id> <schedule-file>
dcos job schedule remove <job-id> <schedule-id>
dcos job schedule update <job-id> <schedule-id> <schedule-file>
```

To view details about your job, run:

```
dcos job show <job-id>
```

To view details about your job's schedule, run:

```
dcos job schedule show <job-id>
```

-->

# Metronome API

You can also create and administer jobs via the API. [View the full API here](http://dcos.github.io/metronome/docs/generated/api.html).

## Add a Job

The following command adds a job called `myjob.json`.

```
curl -X POST -H "Content-Type: application/json" -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs -d@/Users/<your-username>/myjob.json
```

## Remove a Job

The following command removes a job regardless of whether the job is running:
```
curl -X DELETE -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs/myjob?stopCurrentJobRuns=True
```

To remove a job only if it is not running, set `stopCurrentJobRuns` to `False`.

## Modify or View a Job

The following command shows all jobs:

```
curl -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs
```

The following command lists job runs:

```
curl -H "Authorization: token=$(dcos config show core.dcos_acs_token)" “$(dcos config show core.dcos_url)/service/metronome/v1/jobs/myjob/runs/“
```

Stop a run with the following command:

```
curl -X POST -H "Authorization: token=$(dcos config show core.dcos_acs_token)" “$(dcos config show core.dcos_url)/service/metronome/v1/jobs/myjob/runs/20160725212507ghwfZ/actions/stop”
```
