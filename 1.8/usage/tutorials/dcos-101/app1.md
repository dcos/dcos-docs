---
post_title: Deploying your First Application
nav_title: Deploying First Application
menu_order: 3
---


# Prerequisites
* A [running DC/OS cluster](/docs/1.8/usage/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.8/usage/tutorials/dcos-101/cli/).
* [redis](/docs/1.8/usage/tutorials/dcos-101/redis-package/) deployed and running in your cluster.

# Objective
We now have a working persistence layer -redis- running in our cluster.
In this section we deploy the first app connecting to redis. Note that we deliberately choose to focus on the principles and to deploy a very simple app with no further logic than connecting to redis.

# Steps
* Check out app1
  * Let us first take a short look at the [app](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.py). It is very simple and just checks whether it can reach redis and then prints the total number of keys stored in redis.
* Deploy app 1
  * The python script has several dependencies (python version and redis-python), which we cannot assume to be present on all agent nodes. Hence we will run it in the `mesosphere/dcos-101` docker container providing all these dependencies. Feel free to take a look at the [DOCKERFILE](https://github.com/joerg84/dcos-101/blob/master/app1/DOCKERFILE), which was used to create the `mesosphere/dcos-101` image.
  * Have a look at the [app definition](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json). This app definition will download the python script and then run it inside the `mesosphere/dcos-101` docker container.
  * Add app to Marathon: `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json`
* You have multiple options to check that app1 is running:
    * By looking at all DC/OS tasks: `dcos task`. Here you should look at the state this task is currently in, which probably is either *S*taging or *R*unning.
    * By looking at all marathon apps: `dcos marathon app list`.
    * By checking the logs: `dcos task log app1`. Here we should see on which node and port app1 is running. This might vary between different runs and even during the lifetime of the app.

# Outcome
We have deployed our first app inside a docker container using marathon.
We verified the app is running and successfully connected to the previously deployed redis service.

# Deep Dive
We have just deployed our first app using [Marathon](https://mesosphere.github.io/marathon/) directly. Also note that the redis service is running internally via Marathon.
Marathon is also referred to as the init system of DC/OS, as its main job to support long running services.
Marathon also allows for scaling or uninstalling of applications.
As such we have multiple options to deploy and maintain apps on Marathon besides the DC/OS UI:

* DC/OS CLI: We have just used that option to deploy our app1. To get more information check `dcos marathon app --help`.
* HTTP endpoints: Marathon also comes with an extensive [REST API](https://mesosphere.github.io/marathon/docs/generated/api.html) which can also be used to deploy apps
