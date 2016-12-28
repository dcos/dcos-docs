---
post_title: >
  Autoscaling Marathon services using CPU and memory
nav_title: CPU/Memory
---

A Python service, `marathon-autoscale.py`, autoscales your Marathon application based on the utilization metrics which Mesos reports. You can run this service from within your DC/OS cluster. `marathon-autoscale.py` is intended to demonstrate what is possible when you run your services on DC/OS.

Periodially, `marathon-autoscale.py` will monitor the aggregate CPU and memory utilization for all tasks that make up the specified Marathon service. When your threshold is hit, `marathon-autoscale.py` will increase the number of tasks for your Marathon service.

**Prerequisites**

*   A [running DC/OS cluster][1].
*   A service running on Marathon that you'd like to autoscale.

# Install the application

SSH to the system where you will run marathon-autoscale.py and install it:

        $ dcos node ssh --master
        $ git clone https://github.com/mesosphere/marathon-autoscale.git
        $ cd marathon-autoscale

# Run the application

When you run the application, you'll be prompted for the following parameters:

*   **marathon_host (string)** - Fully qualified domain name or IP of the Marathon host (without http://).
*   **marathon_app (string)** - The name of the Marathon app to autoscale (without "/").
*   **max_mem_percent (int)** - The percentage of average memory utilization across all tasks for the target Marathon app before scaleout is triggered.
*   **max_cpu_time (int)** - The average CPU time across all tasks for the target Marathon app before scaleout is triggered.
*   **trigger_mode (string)** - 'or' or 'and' determines whether both CPU and memory must be triggered or just one or the other.
*   **autoscale_multiplier (float)** - The number by which current instances will be multiplied to determine how many instances to add during scaleout.
*   **max_instances (int)** - The ceiling for the number of instances to stop scaling out EVEN if thresholds are crossed.

```bash
$ /opt/mesosphere/bin/python marathon-autoscale.py
Enter the DNS hostname or IP of your Marathon Instance : ip-**-*-*-***
Enter the Marathon Application Name to Configure Autoscale for from the Marathon UI : testing
Enter the Max percent of Mem Usage averaged across all Application Instances to trigger Autoscale (ie. 80) : 5
Enter the Max percent of CPU Usage averaged across all Application Instances to trigger Autoscale (ie. 80) : 5
Enter which metric(s) to trigger Autoscale ('and', 'or') : or
Enter Autoscale multiplier for triggered Autoscale (ie 1.5) : 2
Enter the Max instances that should ever exist for this application (ie. 20) : 10
```

 [1]: /docs/1.9/administration/installing/
