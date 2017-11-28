---
post_title: Deploying native Applications
nav_title: Native Applications
menu_order: 5
---

Welcome to part 5 of the DC/OS 101 Tutorial

<table class="table" bgcolor="#FAFAFA"> <tr> <td align=justify style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;">**Important:** Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is purely to demonstrate capabilities, and it may not be suited for use in a production environment. Before using a similar solution in your environment, you should adapt, validate, and test.</td> </tr> </table>

# Prerequisites
* A [running DC/OS cluster](/docs/1.11/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.11/tutorials/dcos-101/cli/).
* [app1](/docs/1.11/tutorials/dcos-101/app1/) deployed and running in your cluster.

# Objective
[Earlier](https://dcos.io/docs/1.11/tutorials/dcos-101/app1/) in this tutorial you deployed an app that operates internally in your cluster, interfacing with other applications in the cluster as opposed to interacting externally. In this part you will deploy an app which provides a web GUI to users. You will also deploy this app natively, without relying on Docker as a dependency and therefore reducing complexity.

# Steps
  * Understand the application
    * Take a short look at [app2](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go). App2 is a [Go](https://golang.org/) based HTTP server that exposes a very simple interface to Redis.
  * Deploy app2
    * Take a short look at the [app definition](https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json). In this case, the app is a binary without external dependencies.
    Because of this, you no longer need to deploy it in a Docker container. 
    * Deploy app2: `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json`
  * You have multiple options to check app 2 is sucessfully running:
    * By looking at all DC/OS tasks: `dcos task`
    * By looking at all Marathon apps: `dcos marathon app list`
    * Curl the http server from within the cluster (in this case from the leading master):
       * `dcos node ssh --master-proxy --leader`
       * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`
      
      This should return you the raw HTML response from app2's webserver.
  

Accessing the app from within the cluster and viewing the raw HTML response proves our application is running, but in the real world you want to expose the app to the public. In the next part of this tutorial you will do exactly that. 

# Outcome
 You have deployed a second app that uses the native Mesos containerizer.

# Deep Dive
You have now deployed apps in two different ways: 

1. Using Docker (app1).
1. Using the native Universal Container Runtime (app2).

Let's explore the differences in some more detail.

DC/OS uses [containerizers](/docs/1.11/deploying-services/containerizers/) to run tasks in containers. Running tasks in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically. DC/OS supports two types of containerizers - the DC/OS Universal Container Runtime, and the Docker containerizer.

For your first app, you used a Docker container image to package app1's dependencies ( Remember: never rely on dependencies being installed on an agent! ) and then used the Docker containerizer to execute it. Because the Docker containerizer internally uses the [Docker runtime](https://docs.docker.com/engine/userguide/intro/), you also used the Docker runtime.

For your second app, you did not have any dependencies and therefore could rely on the default DC/OS Universal Container Runtime. Internally, both runtimes use the same OS features for isolation, namely [cgroups](https://en.wikipedia.org/wiki/Cgroups) and [namespaces](https://en.wikipedia.org/wiki/Linux_namespaces).
This actually makes it possible to use the DC/OS Universal Container Runtime for running Docker images - check the [DC/OS Universal Container Runtime](/docs/1.11/deploying-services/containerizers/) documentation for details.
