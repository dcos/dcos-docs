---
post_title: Docker Containerizer
menu_order: 10
---

Use the Docker containerizer if you need specific features of the Docker package. Refer to the [features matrix](/docs/1.8/usage/containerizers/) to see if the Docker containerizer is the correct choice for your task.

To specify the Docker containerizer, add the following parameter to your Marathon application definition:

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
- [Learn more about launching Docker containers on Marathon](http://mesosphere.github.io/marathon/docs/native-docker.html).
- [Follow a Docker app tutorial](/docs/1.8/usage/managing-services/creating-services/deploy-docker-app/).
- [View the Mesos docs for the Docker containerizer](http://mesos.apache.org/documentation/latest/docker-containerizer/).
