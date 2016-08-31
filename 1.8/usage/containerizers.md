---
post_title: Choosing a Containerizer
nav_title: Containerizers
menu_order: 3.5
---

DC/OS supports both [the default Mesos containerizer and the Docker containerizer](http://mesos.apache.org/documentation/latest/containerizer/).

# Mesos Containerizer

While other containerizers play well with DC/OS, the Mesos containerizer does not depend upon other container technologies and can therefore take advantage of more Mesos features.

The Mesos containerizer now supports provisioning [Docker](https://docker.com/) and [AppC](https://github.com/appc/spec) container images (the ["unified containerizer"](http://mesos.apache.org/documentation/latest/container-image)), so you can take advantage of the Mesos containerizer and still launch an alternative container image.

This support also removes your dependency on the Docker daemon. The Docker daemon can hang when there are too many containers, making troubleshooting difficult. In addition, Docker must be installed on each of your agent nodes in order to use the Docker containerizer, which means you need to upgrade Docker on the agent nodes each time a new version of Docker comes out. The Mesos containerizer is more stable and built with an eye towards deployment at scale.

To run Docker or AppC containers directly from Mesos, specify the container type `MESOS` and a `docker` or `appc` object.

**Note:** This latest version of the Mesos containerizer introduces a new `credential`, with a `principal` and an optional `secret` field to authenticate when downloading the Docker or AppC image.

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
	
For the moment, you can only use these new features of the Mesos containerizer via a JSON app definition, not through the DC/OS web interface.

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
