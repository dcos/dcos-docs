---
post_title: Jobs
nav_title: Jobs
feature_maturity: preview
menu_order: 80 
---

You can create scheduled jobs in DC/OS without installing a separate service. Create and administer jobs in the DC/OS web interface, the DC/OS CLI, or via an API.

**Note:** The Jobs functionality of DC/OS is provided by the [DC/OS Jobs (Metronome)](https://github.com/dcos/metronome) component, an open source Mesos framework that comes pre-installed with DC/OS. You may sometimes see the Jobs functionality referred to as "Metronome" in the logs, and the service endpoint is `service/metronome`.

## Functionality

You can create a job as a single command you include when you create the job, or you can point to a Docker image.

When you create your job, you can specify:

* The amount of CPU your job will consume.
* The amount of memory your job will consume.
* The disk space your job will consume.
* The schedule for your job, in cron format. You can also set the time zone and starting deadline.
* An arbitrary number of labels to attach to your job.
* Permissions for your job.