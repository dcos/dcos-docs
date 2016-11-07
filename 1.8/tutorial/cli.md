---
post_title: DC/OS 101 - First Steps
menu_order: 3
---

Welcome to part 1 of the DC/OS 101 Tutorial.

# Prerequisites
We expect you to have acess to a running DC/OS OSS cluster. Check out https://dcos.io/install/ for setup instructions for various cloud providers, on-premise, or vagrant setups.
If you are unsure which way to choose, then we would recommend using the AWS templates.

# Objective
We have access to our cluster and already taken a first look at the UI.
But UI is not the only way to access the cluster and hence we want to install the CLI and start exploring our cluster using the CLI.

# Steps
  * Install the DC/OS CLI
    * Follow the steps [here](https://dcos.io/docs/1.8/usage/cli/install/) or the `Install CLI` instruction in the left lower corner of the DC/OS UI.
    * Make sure you are authorized to connect to your cluster by running `dcos auth login`. This is necessary to prevent access from unauthorized people to your cluster.
    * You can also add/invite friends and co-workers to your cluster, see [user management documentation](https://dcos.io/docs/1.8/administration/id-and-access-mgt/user-management/) for details

  * Explore the cluster:
      * Check the running services with `dcos service`. Unless you already installed additional services there should be two services running on your cluster: marathon (basically the DC/OS init system) and metronom (basically the DC/OS cron scheduler).
      * Check the connected nodes with `dcos node`. You should be able to see your connected agents nodes (i.e., not the master nodes) in your cluster.
      * Explore the logs of the leading mesos master with `dcos node log --leader`. Mesos is basically the kernel of DC/OS and hence we will explore Mesos logs at multiple times during this tutorial.
      * To explore even more options of the CLI, check `dcos help`. There are also help options of the individual commands available e.g., `dcos node --help`. Alternatively, check the [CLI documentation](https://dcos.io/docs/1.8/usage/cli/).

# Outcome
 We have successfully connected using the DC/OS CLI to our cluster and started exploring some of the options offered.
 In the consequitive sessions, we make further use of the CLI.

# Deep Dive
We have already encountered several DC/OS components (including Mesos, Marathon, or Metronome) while experimenting with the DC/OS CLI.
But what other components are there and how do they form DC/OS?

## DC/OS components
DC/OS includes a number of components, many of which you can safely ignore for now and hence we only list the most relevant components here.
A descrition of all components can be found [here](https://dcos.io/docs/1.8/overview/components/).
* Marathon starts and monitors DC/OS applications and services.
* Mesos is the kernel of DC/OS and responsible for low-level task maintenance.
* Mesos DNS provides service discovery within the cluster.
* Minuteman is the internal layer 4 load balancer.
* Admin Router is an open source NGINX configuration that provides central authentication and proxy to DC/OS services.
* Universe is the package repository from where you can install applications (e.g., Apache Spark or Apache Cassandra) on your cluster.

## DC/OS Terminology
Again we will focus on the most important terminology here. More can be found [here](https://dcos.io/docs/1.8/overview/architecture/).
* Master: aggregates resource offers from all agent nodes and provides them to registered frameworks.
* Agent: runs a discrete Mesos task on behalf of a framework. The synonym of agent node is worker or slave node.
* Scheduler: the scheduler component of a service, for example, the Marathon scheduler.
* Task: a unit of work scheduled by a Mesos framework and executed on a Mesos agent.
