---
post_title: Examples
nav_title: Examples
feature_maturity: preview
menu_order: 20
---

<a name="create-job"></a>
# Create a Simple Job

This JSON creates a simple job with no schedule.

1. Create a JSON file with the following contents. 
    ```json
    {
      "id": "my-job",
      "description": "A job that sleeps",
      "run": {
        "cmd": "sleep 1000",
        "cpus": 0.01,
        "mem": 32,
        "disk": 0
      }
    }
    ```

1. Add the job from the DC/OS CLI.
    ```bash
    dcos job add <my-job>.json
    ```
    
    Alternatively, add the job using the API.
    ```bash
    curl -X POST -H "Content-Type: application/json" -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs -d@/Users/<your-username>/<myjob>.json
    ```

# Create a Job with a Schedule
**Note:** This example JSON only works when you add the job from the DC/OS CLI or the UI. Use the [example below](#schedule-with-api) to create a scheduled job via the API.

1. Create a JSON file with the following contents.
    ```
    {
            "id": "my-scheduled-job",
            "description": "A job that sleeps on a schedule",
            "run": {
                "cmd": "sleep 20000",
                "cpus": 0.01,
                "mem": 32,
                "disk": 0
            },
            "schedules": [
                {
                    "id": "sleep-nightly",
                    "enabled": true,
                    "cron": "20 0 * * *",
                    "concurrencyPolicy": "ALLOW"
            }
        ]
    }
    ```

1. Add the job.
    ```bash
    dcos job add <my-scheduled-job>.json
    ```
   
<a name="schedule-with-api"></a>

# Create a Job and Associate a Schedule

1. Add a job without a schedule using the [instructions above](#create-job).

1. Create JSON file with the following contents. This is the schedule for your job.

    ```
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

1. Add the schedule and associate it with the job.
    Via the DC/OS CLI:
    ```bash
    dcos job schedule add <job-id> <schedule-file>.json
    ```

    Via the API
    ```bash
    curl -X POST -H "Content-Type: application/json" -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/service/metronome/v1/jobs/<job-id>/schedules -d@/Users/<your-username>/<schedule-file>.json
    ```
    
**Note:** You can associate a schedule with more than one job.