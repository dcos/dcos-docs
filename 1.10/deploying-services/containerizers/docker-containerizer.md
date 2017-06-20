---
post_title: Docker Containerizer
menu_order: 20
---

Use the Docker containerizer if you need specific features of the Docker package. Refer to the [features matrix](/docs/1.10/deploying-services/containerizers/) to see if the Docker containerizer is the correct choice for your task.

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

- [Follow a Docker app tutorial](/docs/1.10/deploying-services/creating-services/deploy-docker-app/).
- [View the Mesos docs for the Docker containerizer](http://mesos.apache.org/documentation/latest/containerizer/#Docker).
