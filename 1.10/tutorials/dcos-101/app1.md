---
post_title: Deploying First Application
menu_order: 3
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.10/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.10/tutorials/dcos-101/cli/).
* [Redis](/docs/1.10/tutorials/dcos-101/redis-package/) deployed and running in your cluster.

<table class="table" bgcolor="#FAFAFA"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Important:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is to demonstrate capabilities, and may not be suited for use in a production environment. Before using a similar solution in your environment, you must adapt, validate, and test.</td> </tr> </table>

# Objective
You now have a working persistence layer - [Redis](https://redislabs.com/) - running in your cluster.
In this section you will deploy a simple app connecting to Redis. 

# Steps
* Review app
  * Let us first take a short look at the [app](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.py). It is very simple and just checks whether it can reach Redis and then prints the total number of keys stored there.
* Deploy app
  * The python script has a dependency on the [redis-py](https://pypi.python.org/pypi/redis) Python library, which you cannot assume to be present on all agent nodes. Because of this, you should run it in the `mesosphere/dcos-101` Docker container that provides all of the dependencies. Feel free to take a look at the [DOCKERFILE](https://github.com/joerg84/dcos-101/blob/master/app1/DOCKERFILE), which was used to create the `mesosphere/dcos-101` image.
  * Have a look at the [app definition](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json). The app definition is the configuration which Marathon will use to deploy and manage the application. This app definition will download the python script and then run it inside the `mesosphere/dcos-101` Docker container.
  * Add app1 to Marathon using the app definition: `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json`
* Check that app1 is running:
    * By looking at all DC/OS tasks: `dcos task`. Here you should look at the state this task is currently in, which probably is either *S*taging or *R*unning.
    * By looking at all Marathon apps: `dcos marathon app list`.
    * By checking the logs: `dcos task log app1`. Here you should see on which node and port app1 is running, and the output from the app showing the number of keys in Redis. The node and ports  might vary between different runs and even during the lifetime of the app, depending on events in the cluster.

# Outcome
You have deployed your first app inside a Docker container using Marathon.
You verified the app is running and successfully connected to the previously deployed Redis service.

# Deep Dive
You have just deployed your first app using [Marathon](https://mesosphere.github.io/marathon/) directly. Also note that the Redis service itself is running via Marathon.
Marathon is referred to as the init system of DC/OS, as its main job is to support long running services.
Marathon also allows for scaling or uninstalling of applications.
There are multiple options to deploy and maintain apps on Marathon besides the DC/OS GUI:

* DC/OS CLI: You have just used this option to deploy your app. To get more information on the marathon CLI use `dcos marathon app --help`.
* HTTP endpoints: Marathon also comes with an extensive [REST API](https://mesosphere.github.io/marathon/docs/generated/api.html)
