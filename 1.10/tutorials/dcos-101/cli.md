---
post_title: First Steps
nav_title: First Steps
menu_order: 1
---

Welcome to part 1 of the DC/OS 101 Tutorial.

<table class="table" bgcolor="#FAFAFA"> <tr> <td align=justify style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;">**Important:** Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is purely to demonstrate capabilities, and it may not be suited for use in a production environment. Before using a similar solution in your environment, you should adapt, validate, and test.</td> </tr> </table>

# Prerequisites
To get started with this tutorial, you should have access to a running DC/OS cluster with at least a single master node and 3 agent nodes (of which one is a public agent node). If you don't have these requirements set up, please follow the [setup instructions](/docs/1.10/installing/) for various cloud providers, on-premise, or vagrant setups.
If you are unsure which option to choose, then we recommend using the <a href="https://downloads.dcos.io/dcos/stable/aws.html" target="_blank">AWS templates</a>.

**Note**: For this tutorial a setup with a single master node is sufficient, but for running production workloads you should have multiple master nodes.

# Objective
You have access to your cluster and have already taken a first look at the GUI. You can also access the cluster from your local machine via the DC/OS CLI.
By the end of this section you will have installed the DC/OS CLI and used it to explore your cluster.

# Steps
  * Install the DC/OS CLI
    * Follow the steps [here](/docs/1.10/cli/install/) or the `Install CLI` instruction in the lower left corner of the DC/OS GUI.
    * Make sure you are authorized to connect to your cluster by running `dcos auth login`. This is necessary to prevent access from unauthorized people to your cluster.
    * You can also add/invite friends and co-workers to your cluster. See [user management documentation](/docs/1.10/security/user-management/) for details

  * Explore the cluster:
      * Check the running services with `dcos service`. Unless you already installed additional services, there should be two services running on your cluster: Marathon (basically the DC/OS init system) and metronome (basically the DC/OS cron scheduler).
      * Check the connected nodes with `dcos node`. You should be able to see your connected agents nodes (i.e., not the master nodes) in your cluster.
      * Explore the logs of the leading mesos master with `dcos node log --leader`. Mesos is basically the kernel of DC/OS and this tutorial explores the Mesos logs at multiple times during this tutorial.
      * To explore more CLI options, enter the `dcos help` command. There are also help options of the individual commands available e.g., `dcos node --help`. Alternatively, check the [CLI documentation](/docs/1.10/cli/).

# Outcome
Congratulations! You have successfully connected to your cluster using the DC/OS CLI, and started exploring some of the CLI commands.
You will make further use of the CLI in the sections that follow.

# Deep Dive
You have already encountered several DC/OS components (including Mesos, Marathon, or Metronome) while experimenting with the DC/OS CLI.
But what other components make up DC/OS?

## DC/OS components
Here are the DC/OS components that are relevant to this tutorial. A full description of all components can be found in the [documentation](/docs/1.10/overview/architecture/components/).
* [Marathon](/docs/1.10/overview/architecture/components/#marathon) starts and monitors DC/OS applications and services.
* Apache [Mesos](/docs/1.10/overview/architecture/components/#apache-mesos) is the kernel of DC/OS and responsible for low-level task maintenance.
* [Mesos DNS](/docs/1.10/overview/architecture/components/#mesos-dns) provides service discovery within the cluster.
* [Minuteman](/docs/1.10/overview/architecture/components/#minuteman) is the internal layer 4 load balancer.
* [Admin Router](/docs/1.10/overview/architecture/components/#admin-router) is an open source NGINX configuration that provides central authentication and proxy to DC/OS services.
* [Universe](/docs/1.10/overview/architecture/components/#dcos-package-manager) is the package repository that holds the DC/OS services (e.g. Apache Spark or Apache Cassandra) that you can install on your cluster directly from the DC/OS GUI and CLI.

