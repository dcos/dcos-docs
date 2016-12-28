---
post_title: Getting Started
nav_title: Getting Started
feature_maturity: preview
menu_order: 10
---

You can create and administer jobs in the DC/OS web interface or via the API.

# DC/OS Web Interface

## Add a Job

From the DC/OS web interface, click the **Jobs** tab, then the **New Job** button. Fill in the following fields, or toggle to JSON mode to edit the JSON directly:

* **Job ID** - The ID of your job.
* **Description** - A description of your job.
* **CPU** - The amount of CPU your job requires.
* **Memory** - The amount of memory your job requires.
* **Disk space** - The amount of disk space your job requires.
* **Command** - The command your job will execute. Leave this blank if you will use a Docker image.
* **Schedule** - Specify the schedule in cron format, as well as the time zone and starting deadline. Use [this crontab generator](http://crontab.guru) for help with cron format and this [list of time zones](http://www.timeanddate.com/time/zones/) for time zone format. DC/OS supports the standart 5 element cron expression (minute hour dayOfMonth month dayOfWeek) as well as an optional year at the end (minute hour dayOfMonth month dayOfWeek year).
* **Docker Container** - Fill in this field if you will use a Docker image to specify the action of your job.
* **Labels** - Attach metadata to your job.

## Modify, View, or Remove a Job

From the **Jobs** tab, click the name of your job to modify or delete your job. While the job is running you can click the job instance to drill down to **Details**, **Files**, and **Logs** data.

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
