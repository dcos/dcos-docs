---
post_title: Jobs
nav_title: Jobs
menu_order: 6.5
---

You can create scheduled jobs in DC/OS without installing a separate service. Create and administer jobs in the DC/OS web interface or via an API.

**Note:** The Jobs functionality of DC/OS is provided by the [Metronome](https://github.com/dcos/metronome) component, an open source Mesos framework that comes pre-installed with DC/OS. In the DC/OS web interface, you may sometimes see the Jobs functionality referred to as "Metronome."

## Functionality

You can create a job as a single command you include when you create the job, or you can point to a Docker image.

When you create your job, you can specify:

* The amount of CPU your job will consume.
* The amount of memory youd job will consume.
* The disk space your job will consume.
* The schedule for your job, in cron format. You can also set the time zone and starting deadline.
* An arbitrary number of labels to attach to your job.
* Permissions for your job.
