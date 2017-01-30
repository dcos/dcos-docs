---
post_title: Deploying Public Services
nav_title: Public Services
menu_order: 10
---

DC/OS agent nodes can be designated as [public](/docs/1.8/overview/concepts/#public) or [private](/docs/1.8/overview/concepts/#private) during [installation](/docs/1.8/administration/installing/). Public agent nodes provide public access to your DC/OS applications. By default apps are launched on private agent nodes. 

To launch an app on a public node, you must create a Marathon app definition with the `"acceptedResourceRoles":["slave_public"]` parameter specified.

**Prerequisite:**

* DC/OS is [installed](/docs/1.8/administration/installing/)
* DC/OS CLI is [installed](/docs/1.8/usage/cli/install/)


1.  Create a Marathon app definition with the `"acceptedResourceRoles":["slave_public"]` parameter specified. For example:

    ```json
    {
        "id": "/product/service/myapp",
        "container": {
        "type": "DOCKER",
        "docker": {
              "image": "group/image",
              "network": "BRIDGE",
              "portMappings": [
                { "hostPort": 80, "containerPort": 80, "protocol": "tcp"}
              ]
            }
        },
        "acceptedResourceRoles": ["slave_public"],
        "instances": 1,
        "cpus": 0.1,
        "mem": 64
    }
    ```

    For more information about the `acceptedResourceRoles` parameter, see the Marathon REST API [documentation](https://mesosphere.github.io/marathon/docs/rest-api.html).

1.  Add the your app to Marathon by using this command, where `myapp.json` is your app:

    ```bash
    $ dcos marathon app add myapp.json
    ```

    If this is added successfully, there is no output.
    
     **Tip:** You can also add your app by using the **Services** tab of DC/OS [GUI](/docs/1.8/usage/webinterface/#services). 

1.  Verify that the app is added with this command:

    ```bash
    $ dcos marathon app list
    ```
    
    The output should look like this:
    
    ```bash
    ID      MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD
        /myapp   64  0.1    0/1    ---      scale       DOCKER   None
    ```
    
    **Tip:** You can also view deployed apps by using the **Services** tab of DC/OS [GUI](/docs/1.8/usage/webinterface/#services).

 [1]: /docs/1.8/tutorials/containerized-app/
 [3]: /docs/1.8/administration/installing/
 [4]: /docs/1.8/usage/cli/install/
