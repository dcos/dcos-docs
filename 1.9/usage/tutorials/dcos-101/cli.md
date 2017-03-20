---
post_title: First Steps
nav_title: First Steps
menu_order: 1
---

Welcome to part 1 of the DC/OS 101 Tutorial.

# Prerequisites
To get started with this tutorial, you should have access to a running DC/OS cluster with a minimum of one single master node, two private agent nodes, and one public agent node. If you don't have these requirements set up, please follow the [setup instructions](/docs/1.9/administration/installing/).
If you are unsure which option to choose, we recommend starting with the <a href="https://downloads.dcos.io/dcos/stable/aws.html" target="_blank">AWS templates</a>.

**Note**: For this tutorial, a setup with a single master node is sufficient, but for running production workloads you should have multiple master nodes.

# Objective
To install the DC/OS CLI and explore your DC/OS cluster.

# Steps
  * Install the DC/OS CLI
    * Follow the steps [here](/docs/1.9/usage/cli/install/) or click the **Install CLI** instruction in the upper-left corner of the DC/OS UI.
    * Make sure you are authorized to connect to your cluster by running `dcos auth login`. This is necessary to prevent unauthorized access to your cluster.
    * You can also add/invite users to your cluster. See [user management documentation](/docs/1.9/administration/id-and-access-mgt/user-management/) for details

  * Explore the cluster:
      * View the running services with the `dcos service` command. By default, there are two services running on your cluster: Marathon (basically the DC/OS init system) and metronome (basically the DC/OS cron scheduler).
      
        ```bash
        $ dcos service
        NAME          HOST     ACTIVE  TASKS  CPU  MEM  DISK  ID                                         
        marathon   10.0.7.225   True     0    0.0  0.0  0.0   b365e1fb-7fa6-4c34-888b-c1e6459374c7-0001  
        metronome  10.0.7.225   True     0    0.0  0.0  0.0   b365e1fb-7fa6-4c34-888b-c1e6459374c7-0000
        ```
      * View the connected agent nodes with the `dcos node` command. You should see all of the agent nodes in your cluster.
      
        ```bash
        $ dcos node
         HOSTNAME      IP                        ID                    
        10.0.3.89  10.0.3.89  b365e1fb-7fa6-4c34-888b-c1e6459374c7-S1  
        10.0.7.77  10.0.7.77  b365e1fb-7fa6-4c34-888b-c1e6459374c7-S0 
        10.0.5.64  10.0.5.64  b365e1fb-7fa6-4c34-888b-c1e5439374z7-S2 
        ```
      * Explore the logs of the leading mesos master with `dcos node log --leader`. Mesos is the kernel of DC/OS and we will explore Mesos logs at multiple times during this tutorial.
      
        ```bash
        $ dcos node log --leader
        I0320 16:01:14.000000  3230 http.cpp:420] HTTP GET for /master/state-summary from 10.0.7.225:55244 with User-Agent='python-requests/2.10.0'
        I0320 16:01:16.000000  3225 http.cpp:420] HTTP GET for /master/slaves from 10.0.7.225:46492 with User-Agent='Go-http-client/1.1'
        I0320 16:01:16.000000  3228 http.cpp:420] HTTP GET for /master/state-summary from 10.0.7.225:55268 with User-Agent='python-requests/2.10.0'
        ```
      * To explore more CLI options, enter the `dcos help` command. There are also help options of the individual commands available e.g., `dcos node --help`. For more information, see the [CLI documentation](/docs/1.9/usage/cli/).

# Outcome
Congratulations! We have successfully connected to your cluster using the DC/OS CLI, and started exploring some of the CLI commands.
We will make further use of the CLI in the sections that follow.

# Deep Dive
We have already encountered several DC/OS components (including Mesos, Marathon, or Metronome) while experimenting with the DC/OS CLI.
But what other components make up DC/OS?

## DC/OS components
DC/OS includes a number of components, but here are the most relevant components for this tutorial. 
* Marathon starts and monitors DC/OS applications and services.
* Mesos is the kernel of DC/OS and responsible for low-level task maintenance.
* Mesos DNS provides service discovery within the cluster.
* Minuteman is the internal layer 4 load balancer.
* Admin Router is an open source NGINX configuration that provides central authentication and proxy to DC/OS services.
* Universe is the package repository that holds the DC/OS services (e.g., Apache Spark of Apache Cassandra) that you can install on your cluster directly from the DC/OS UI and CLI.

For a description of all components, see the components [documentation](/docs/1.9/overview/components/).

## DC/OS Terminology
* Master: aggregates resource offers from all agent nodes and provides them to registered frameworks.
* Agent: runs a discrete Mesos task on behalf of a framework. The synonym of agent node is worker or slave node.
* Scheduler: the scheduler component of a service, for example, the Marathon scheduler.
* Task: a unit of work scheduled by a Mesos framework and executed on a Mesos agent.
