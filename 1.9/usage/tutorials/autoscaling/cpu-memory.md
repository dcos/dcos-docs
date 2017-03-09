---
post_title: >
  Autoscaling Marathon services using CPU and memory
nav_title: CPU/Memory
menu_order: 0
---

A Python service, `marathon-autoscale.py`, autoscales your Marathon application based on the utilization metrics which Mesos reports. You can run this service from within your DC/OS cluster. `marathon-autoscale.py` is intended to demonstrate what is possible when you run your services on DC/OS.

Periodially, `marathon-autoscale.py` will monitor the aggregate CPU and memory utilization for all tasks that make up the specified Marathon service. When your threshold is hit, `marathon-autoscale.py` will increase the number of tasks for your Marathon service.

**Prerequisites**

*   A [running DC/OS cluster][1].
*   A service running on Marathon that you'd like to autoscale.
*   Python 3
*   Git:
    *   **OS X:** Get the installer from [Git downloads](http://git-scm.com/download/mac).
    *   **Unix/Linux:** See these [installation instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

# Install the Autoscale App on a Node

SSH to the system where you will run `marathon-autoscale.py` and install it.

1.  SSH to the node where you will run `marathon-autoscale.py`, where node ID (`<mesos-id>`) is the node where you want to run the app.
    
    ```bash
    $ dcos node ssh --master-proxy --mesos-id=<mesos-id>
    ```
    
    **Tip:** Run `dcos node` to get the available node IDs.
    
1.  Clone the [autoscale][13] GitHub repository to your node.

    ```bash
    $ git clone https://github.com/mesosphere/marathon-autoscale.git
    ```

# Run the Autoscale App

1.  Navigate to the `marathon-autoscale` repository:

    ```bash
    $ cd marathon-autoscale
    ```
    
1.  Enter this command to run the application:

    ```bash
    $ python marathon-autoscale.py
    ```

    You will be prompted for the following parameters:
   
    ```bash
    # Fully qualified domain name or IP of the Marathon host (without http://).
    Enter the DNS hostname or IP of your Marathon Instance : ip-**-*-*-***
    # The name of the Marathon app to autoscale (without "/").
    Enter the Marathon Application Name to Configure Autoscale for from the Marathon UI : testing
    # The percentage of average memory utilization across all tasks for the target Marathon app before scaleout is triggered.
    Enter the Max percent of Mem Usage averaged across all Application Instances to trigger Autoscale (ie. 80) : 5
    # The average CPU time across all tasks for the target Marathon app before scaleout is triggered.
    Enter the Max percent of CPU Usage averaged across all Application Instances to trigger Autoscale (ie. 80) : 5
    # 'or' or 'and' determines whether both CPU and memory must be triggered or just one or the other.
    Enter which metric(s) to trigger Autoscale ('and', 'or') : or
    # The number by which current instances will be multiplied. This determines how many instances to add during scaleout.
    Enter Autoscale multiplier for triggered Autoscale (ie 1.5) : 2
    # The ceiling for the number of instances to stop scaling out EVEN if thresholds are crossed.
    Enter the Max instances that should ever exist for this application (ie. 20) : 10
    ```
    
For more information, see the [Marathon-Autoscale GitHub](https://github.com/mesosphere/marathon-autoscale) repository.

 [1]: /docs/1.9/administration/installing/
