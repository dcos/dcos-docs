---
post_title: Using Mesos Containerizers
nav_title: Mesos Containerizers
menu_order: 3.5
---

Containerizers allow you to run tasks in containers. Running tasks in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically.

DC/OS supports the Mesos containerizer types [Mesos containerizer](http://mesos.apache.org/documentation/latest/containerizer/#Mesos) and [Docker containerizer](http://mesos.apache.org/documentation/latest/containerizer/#Docker).

# Mesos Containerizer

While other containerizers play well with DC/OS, the Mesos containerizer does not depend upon other container technologies and can therefore take advantage of more Mesos features.

The Mesos containerizer supports provisioning [Docker](https://docker.com/) and [AppC](https://github.com/appc/spec) container images (the ["unified containerizer"](http://mesos.apache.org/documentation/latest/container-image)). This means that you can use both the Mesos containerizer and other container image types in DC/OS.

The Mesos containerizer removes your dependency on the Docker daemon. The Docker daemon can hang when there are too many containers, making troubleshooting difficult. In addition, Docker must be installed on each of your agent nodes in order to use the Docker containerizer. This means you need to upgrade Docker on the agent nodes each time a new version of Docker comes out. The Mesos containerizer is more stable and allows deployment at scale.

## Provisioning Docker or AppC Containers with the Mesos Containerizer (Experimental)

To run Docker or AppC containers with the Mesos containerizer, specify the container type `MESOS` and a `docker` or `appc` object.

The Mesos containerizer provides a `credential`, with a `principal` and an optional `secret` field to authenticate when downloading the Docker or AppC image.

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
	
For the moment, you can only use these features of the Mesos containerizer via a JSON app definition, not through the DC/OS web interface.

# Docker Containerizer

Use the Docker containerizer if you need specific features of the Docker package. To specify the Docker containerizer, add the following to your Marathon application definition:
    
    {
      "container": {
        "type": "DOCKER",
        "docker": {
          "network": "HOST",
          "image": "<my-image>"
        },
        "args": ["<my-arg>"],
        ]
      }
    }

[Learn more about launching Docker containers on Marathon](http://mesosphere.github.io/marathon/docs/native-docker.html).