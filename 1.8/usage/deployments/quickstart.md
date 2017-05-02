---
post_title: Blue Green Deployments
menu_order: 5
---

This guide provides an introduction to DC/OS service deployments. It will show you how to deploy new versions of a DC/OS service without downtime.

Blue-green deployments allow you to safely deploy applications that are serving live traffic. Blue-green deployment eliminates application downtime and allows you to quickly roll back to the blue version of the application if necessary.

The basic methodology is that you have two versions of an application: blue and green. One version of your application is live (e.g. blue) and the other is in staging (e.g. green) as you prepare a new release. 

For example, if blue is live and green is staging, when you are ready to deploy a new version of the application you follow this sequence:
 
 1.  Drain all traffic, requests, and pending operations from the blue version of the application.
 1.  Switch to the green version.
 1.  Turn off the blue version. 

Blue-green deployments give you the flexibility to rollback deployments if anything goes wrong.

[Marathon-LB](/docs/1.8/usage/service-discovery/marathon-lb/) provides an implementation of the blue-green deployment method with the `zdd.py` script. 

- Specify the `HAPROXY_DEPLOYMENT_GROUP` and `HAPROXY_DEPLOYMENT_ALT_PORT` labels in your app definition.

    - `HAPROXY_DEPLOYMENT_GROUP`: This label uniquely identifies a pair of apps belonging to a blue/green deployment. This value is used as the app name in the HAProxy configuration.
    - `HAPROXY_DEPLOYMENT_ALT_PORT`: You must specify an alternate service port because service ports must be unique across all apps.
    
- Only use 1 service port: multiple ports are not yet implemented
- The `zdd.py` script makes API calls to Marathon and uses the HAProxy stats endpoint to gracefully terminate instances
- The marathon-lb container must be run in privileged mode (to execute iptables commands) due to the issues outlined in [this blog post](http://engineeringblog.yelp.com/2015/04/true-zero-downtime-haproxy-reloads.html) by the Yelp engineering team.
- If you have long-lived TCP connections using the same HAProxy instances, it may cause the deploy to take longer than necessary. The script will wait up to 5 minutes (by default) for connections to drain from HAProxy between steps, but any long-lived TCP connections will cause old instances of HAProxy to stick around.

**Prerequisites:**

*  [DC/OS](/docs/1.8/administration/installing/) installed with at least one [private agents](/docs/1.8/overview/concepts/).
*  [DC/OS CLI](/docs/1.8/usage/cli/install/) installed.
*  [Marathon-LB](/docs/1.8/usage/service-discovery/marathon-lb/) is deployed and running.
*  The CLI JSON processor [jq](https://github.com/stedolan/jq/wiki/Installation) installed.

In this procedure, a deployed app (blue) is replaced with a new version (green).

1.  

1.  Create an app named `myapp` and deploy on DC/OS. This is your blue app. This deploys an app that runs a simple Python web server, deployed in a Docker container.

    ```bash
    {
      "id": "/myapp",
      "cmd": "python3 -m http.server 8080",
      "cpus": 0.5,
      "mem": 32,
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "python:3",
          "network": "BRIDGE",
          "portMappings": [
            {
              "containerPort": 8080,
              "hostPort": 0
            }
          ],
        "healthChecks": [{
          "protocol": "HTTP",
          "path": "/",
          "portIndex": 0,
          "timeoutSeconds": 10,
          "gracePeriodSeconds": 10,
          "intervalSeconds": 2,
          "maxConsecutiveFailures": 10
      }]
        }
      }
    }
    ```

1.  Create an app named `myapp-green` and deploy on DC/OS. This is your green app and is identical to the blue app, except for the ID.

    ```bash
    {
      "id": "/myapp-green",
      "cmd": "python3 -m http.server 8080",
      "cpus": 0.5,
      "mem": 32,
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "python:3",
          "network": "BRIDGE",
          "portMappings": [
            {
              "containerPort": 8080,
              "hostPort": 0
            }
          ],
        "healthChecks": [{
          "protocol": "HTTP",
          "path": "/",
          "portIndex": 0,
          "timeoutSeconds": 10,
          "gracePeriodSeconds": 10,
          "intervalSeconds": 2,
          "maxConsecutiveFailures": 10
      }]
        }
      }
    }
    ```

1.  After `myapp` is running and healthy on DC/OS, scale the app to 2 or more instances. No traffic will arrive yet because the app has not been registered with the load balancer.

    1.  Select the gear icon and select **Scale**.
    1.  Specify the number of instances and select **SCALE SERVICE**.
    
        ![Scale app UI](/docs/1.9/img/health-check-green-scale.png)

        **Tip:** From the CLI, you can use this command to scale:
        
        ```bash
        dcos marathon app update /myapp-green instances=2
        ```
    
1.  Wait until all tasks are healthy.

    ![Green app healthy](/docs/1.9/img/health-check-green-app.png)

1.  Add the new task instances from the GREEN app to the load balancer pool.

1.  Pick one or more task instances from the current (BLUE) version of the app.

1.  Update the load balancer configuration to remove the task instances above from the BLUE app pool.

1.  Wait until the task instances from the BLUE app have 0 pending operations. Use the metrics endpoint in the application to determine the number of pending operations.







