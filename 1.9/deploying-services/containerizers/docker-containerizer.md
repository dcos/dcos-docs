---
post_title: Docker Containerizer
menu_order: 20
---

Use the Docker containerizer if you need specific features of the Docker package. Refer to the [features matrix](/docs/1.9/deploying-services/containerizers/) to see if the Docker containerizer is the correct choice for your task.

# Provision a container with the Docker Engine

**Important:** 
* The default entry point is the launch command for the container. If the entry point accepts arguments, you can specify them in the `args` field of the Marathon app definition. If there is no default entry point, you must specify a command in the `cmd` field. It is invalid to supply both `cmd` and `args` for the same app.
* When you run a Docker image in the Docker Engine, the underlying Docker log files are not truncated or rotated. These files can become arbitrarily large (and often go to a system disk rather than a storage disk). This can cause a server with limited disk space to run out of disk space. Mesosphere recommends that you disable Docker logging if you are using Docker Engine. To do this, set the `log-driver` parameter to `none` in the `containers.docker.parameters` field of your app definition. If you are provisioning the container using the DC/OS web interface:
  1. Click the **JSON EDITOR** toggle.

     ![json editor](/docs/1.10/img/json-editor-toggle.png)

  1. Enter the `parameters` field in the JSON configuration.

# Specify the Docker Containerizer from the DC/OS Web Interface

To specify the Docker Containerizer from the web interface, go to **Services**  > **Run a Service** > **Single Container** > **More Settings**. In the **Container Runtime** section, choose the **Docker Engine** radio button.

# Specify the Docker Containerizer from the DC/CLI

To specify the Docker containerizer from the DC/OS CLI, add the following parameter to your Marathon application definition:

```json
{  
   "id":"docker",
   "container":{  
      "type":"DOCKER",
      "docker":{  
         "network":"HOST",
         "image":"<my-image>"
      }
   },
   "args":[  
      "<my-arg>"
   ]
}
```

- [Follow a Docker app tutorial](/docs/1.9/deploying-services/creating-services/deploy-docker-app/).
- [View the Mesos docs for the Docker containerizer](http://mesos.apache.org/documentation/latest/docker-containerizer/).
