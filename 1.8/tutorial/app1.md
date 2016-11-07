---
post_title: DC/OS 101 - First Steps
menu_order: 3
---


# Prerequisites
We expect you to have access to a running DC/OS OSS cluster and the DC/OS CLI installed and configured.
Furthermore, we expect you have installed redis in the previous step of this tutorial.

# Objective
We have a working persistence layer -redis- running in our cluster now.
Now, we deploy the first app connecting to it. Note that we deliberately choose to focus on the principles and to deploy a very simple app with no further logic than connecting to redis.

# Steps
  * Check App
    * Let us first take a short look at the [app](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.py). It is very simple and just checks whether it can reach redis and then prints the total number of keys stored in redis.
  * Deploy App
    * The python script has several dependencies (python version and redis-python), which we cannot assume to be present on all agent nodes. Hence we will run it in the `mesosphere/dcos-101` docker container providing all these dependencies. Feel free to take a look at the [DOCKERFILE](https://github.com/joerg84/dcos-101/blob/master/app1/DOCKERFILE) which was used to create the `mesosphere/dcos-101` image.
    * Have a look at the [app definition](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json). This app definition will download the python script and then run it inside the `mesosphere/dcos-101` docker container.
    * Add app to Marathon: `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json`
  * Check that app1 is running
      * By looking at all DC/OS tasks: `dcos task`. Here you should look at the State this task is currently in, which probably is either *S*taging or *R*unning.
      * By looking at all marathon apps: `dcos marathon app list`.
      * By checking the logs: `dcos task log app1`. Here we should see on which node and port app1 is running. This might vary between different runs and even during the lifetime of the app.

# Outcome
 We have deployed our first App inside a docker container using marathon.
 We verified the app is running and successfully connected to the previously deployed redis service.

# Deep Dive
  We have just deployed our first app using [Marathon](https://mesosphere.github.io/marathon/) directly. Note that also our redis service is internally is running via Marathon.
  Marathon is also referred to as the init system of DC/OS as its main job to support long running services.
  Marathon also allows for scaling or uninstalling of applications.
  As such we have multiple options to deploy and maintain apps on Marathon:

    * DC/OS CLI: We have just used that option to deploy our app1. To get more information check `dcos marathon app --help`.
    * HTTP endpoints: Marathon also comes with an extensive [REST API](https://mesosphere.github.io/marathon/docs/generated/api.html) which can also be used to deploy apps
