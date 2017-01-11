---
post_title: Using Mesos Containerizers
nav_title: Mesos Containerizers
feature_maturity: experimental
menu_order: 40 
---

Containerizers allow you to run tasks in containers. Running tasks in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically.

DC/OS supports the Mesos containerizer types [DC/OS Universal container runtime](http://mesos.apache.org/documentation/latest/containerizer/#Mesos) and [Docker containerizer](http://mesos.apache.org/documentation/latest/containerizer/#Docker).

# DC/OS Universal container runtime

The [Universal container runtime](http://mesos.apache.org/documentation/latest/container-image) extends the Mesos containerizer to support provisioning [Docker](https://docker.com/) container images ([AppC](https://github.com/appc/spec) coming soon). This means that you can use both the Mesos containerizer and other container image types in DC/OS. You can still use the Docker container runtime directly with DC/OS, but the Universal container runtime supports running Docker images without depending on the Docker Engine, which allows for better integration with Mesos.

The Universal container runtime offers the following advantages:

* **Removes your dependency on the Docker daemon**: With previous versions of Docker, if the Docker daemon was not responsive, a restart to the daemon caused all containers to stop on the host. In addition, Docker must be installed on each of your agent nodes in order to use the Docker containerizer. This means that in order to use the Docker containerizer you need to upgrade Docker on the agent nodes each time a new version of Docker comes out.
* The Universal container runtime is more stable and allows deployment at scale.
* The Universal container runtime offers features not available in the Docker containerizer, such as GPU and CNI support.
* The Universal container runtime allows you to take advantage of continuing innovation within both the Mesos and DC/OS, including features such as IP per container, strict container isolation and more.

## Provisioning Docker Containers with the Mesos Containerizer

To run Docker containers with the Universal container runtime, specify the container type `MESOS` and a `docker` object in your [Marathon application definition](http://mesosphere.github.io/marathon/docs/application-basics.html).

The Mesos containerizer provides a `credential`, with a `principal` and an optional `secret` field to authenticate when downloading the Docker image.

```json
{
	"id": "mesos-docker",
    "container": {
		"docker": {
			"image": "mesosphere/inky",
            "credential": {
				"principal": "<my-principal>",
                "secret": "<my-secret>"
			}
		},
		"type": "MESOS"
	},
	"args": ["<my-arg>"],
    "cpus": 0.2,
    "mem": 16.0,
    "instances": 1
}
```

For the moment, you can only use these features of the Mesos containerizer via a JSON app definition, not through the DC/OS web interface.

# Docker Containerizer

Use the Docker containerizer if you need specific features of the Docker package. To specify the Docker containerizer, add the following to your Marathon application definition:

```json
{
	"id": "docker",
    "container": {
		"type": "DOCKER",
        "docker": {
			"network": "HOST",
          	"image": "<my-image>"
        }
    },
    "args": ["<my-arg>"]
}
```
* [Learn more about launching Docker containers on Marathon](http://mesosphere.github.io/marathon/docs/native-docker.html).
* [Follow a Docker app tutorial](/docs/1.8/usage/tutorials/docker-app/).
