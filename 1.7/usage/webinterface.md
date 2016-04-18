---
post_title: DC/OS Web Graphical User Interface
nav_title: GUI
menu_order: 1
---

The DC/OS web interface provides a rich graphical view of your DC/OS cluster. With the web interface you can view the current state of your entire cluster and DC/OS services. The web interface is installed as a part of your DC/OS installation.

There are three major views in the DC/OS web interface: Dashboard, Services, and Nodes. Additionally, there are quick-launch icons on the lower-left navigation panel for starting the DC/OS CLI, chat sessions, and the DC/OS documentation.

# <a name="dashboard"></a>Dashboard

The dashboard is the home page of the DC/OS web interface and provides an overview of your DC/OS cluster.

![Dashboard](../img/dcos-gui-1.7.png)

From the dashboard you can easily monitor the health of your cluster.

*   The CPU Allocation panel provides a graph of the current percentage of available general compute units that are being used by your cluster.

*   The Memory Allocation panel provides a graph of the current percentage of available memory that is being used by your cluster.

*   The Task Failure Rate panel provides a graph of the current percentage of tasks that are failing in your cluster.

*   The Services Health panel provides an overview of the health of your services. Each service provides a healthcheck, run at intervals. This indicator shows the current status according to that healthcheck. A maximum of 5 services are displayed, sorted by priority of the most unhealthy. You can click the View all Services button for detailed information and a complete list of your services.

*   The Tasks panel provides the current number of tasks that are staged and running.

*   The Nodes panel provides a view of the nodes in your cluster.

# <a name="services"></a>Services

The Services page provides a comprehensive view of all of the services that you are running. You can view a graph that shows the allocation percentage rate for CPU, memory, or disk. You can filter services by health status or service name.

![Services](../img/dcos-services-1.7.png)

By default all of your services are displayed, sorted by service name. You can also sort the services by health status, number of tasks, CPU, memory, or disk space allocated.

Clicking the service name opens the Services side panel, which provides CPU, memory, and disk usage graphs and lists all tasks using the service. Use the dropdown or a custom filter to sort tasks and click on details for more information. For services with a web interface, you can click **Open Service** to view it. Click on a task listed on the Services side panel to see detailed information about the task’s CPU, memory, and disk usage and the task’s files and directory tree.

**Tip:** You can access the Mesos web interface at `<hostname>/mesos`.

# <a name="nodes"></a>Nodes

The Nodes page provides a comprehensive view of all of the nodes that are used across your cluster. You can view a graph that shows the allocation percentage rate for CPU, memory, or disk.

![Nodes](../img/dcos-nodes-1.7.png)

By default all of your nodes are displayed in **List** view, sorted by hostname. You can filter nodes by service type or hostname. You can also sort the nodes by number of tasks or percentage of CPU, memory, or disk space allocated.

You can switch to **Grid** view to see a "donuts" percentage visualization.

![Nodes](../img/dcos-donuts-1.7.png)

Clicking on a node opens the Nodes side panel, which provides CPU, memory, and disk usage graphs and lists all tasks on the node. Use the dropdown or a custom filter to sort tasks and click on details for more information. Click on a task listed on the Nodes side panel to see detailed information about the task’s CPU, memory, and disk usage and the task’s files and directory tree.
