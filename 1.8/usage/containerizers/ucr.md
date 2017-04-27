---
nav_title: Universal Container Runtime
post_title: Universal Container Runtime (UCR)
feature_maturity: experimental
menu_order: 20
---

The [Universal Container Runtime](http://mesos.apache.org/documentation/latest/container-image)(UCR) extends the Mesos containerizer to support provisioning [Docker](https://docker.com/) container images ([AppC](https://github.com/appc/spec) coming soon). This means that you can use both the Mesos containerizer and other container image types in DC/OS. You can still use the Docker container runtime directly with DC/OS, but the Universal Container Runtime supports running Docker images without depending on the Docker Engine, which allows for better integration with Mesos.

The Universal Container Runtime offers the following advantages:

* **Removes your dependency on the Docker daemon**: With previous versions of Docker, if the Docker daemon was not responsive, a restart to the daemon caused all containers to stop on the host. In addition, Docker must be installed on each of your agent nodes in order to use the Docker containerizer. This means that in order to use the Docker containerizer you need to upgrade Docker on the agent nodes each time a new version of Docker comes out.
* The UCR is more stable and allows deployment at scale.
* The UCR offers features not available in the Docker containerizer, such as GPU and CNI support.
* The UCR allows you to take advantage of continuing innovation within both the Mesos and DC/OS, including features such as IP per container, strict container isolation and more.

# Provisioning Containers with the Universal Container Runtime

To run containers with the UCR, specify the container type `MESOS` and the appropriate object in your [Marathon application definition](http://mesosphere.github.io/marathon/docs/application-basics.html). Here, we specify a Docker container with the `docker` object.

The Mesos containerizer provides a `credential`, with a `principal` and an optional `secret` field to authenticate when downloading the Docker image.

```json
{  
   "id":"mesos-docker",
   "container":{  
      "docker":{  
         "image":"mesosphere/inky",
         "credential":{  
            "principal":"<my-principal>",
            "secret":"<my-secret>"
         }
      },
      "type":"MESOS"
   },
   "args":[  
      "<my-arg>"
   ],
   "cpus":0.2,
   "mem":16.0,
   "instances":1
}
```

**Important:** If you leave the `args` field empty, the default entry point will be the launch command for the container. If your container does not have a default entry point, you must specify a command in the `args` field. If you do not, your service will fail to deploy.

# Limitations
- The UCR is considered [experimental](/docs/1.8/overview/feature-maturity/) in DC/OS 1.8.

- In DC/OS 1.8, you can only specify the UCR via a JSON service definition, not from the the DC/OS web interface. DC/OS 1.9 allows you to specify the UCR from the web interface.

# Further Reading
- [View the Mesos docs for the UCR](http://mesos.apache.org/documentation/latest/containerizer/#Mesos).
