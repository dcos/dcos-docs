---
post_title: Choosing a Containerizer
nav_title: Containerizers
menu_order: 3.5
---

DC/OS supports both [the default Mesos containerizer and the Docker containerizer](http://mesos.apache.org/documentation/latest/containerizer/).

# Mesos Containerizer

While other containerizers play well with DC/OS, the Mesos containerizer does not depend upon other container technologies and can therefore take advantage of more Mesos features.

The Mesos containerizer now supports provisioning Docker and AppC container images (the ["universal containerizer"](http://mesos.apache.org/documentation/latest/container-image/_)), so you can take advantage of the Mesos containerizer and still launch an alternative container image. This support also removes your dependency on the Docker daemon.

This latest version of the Mesos containerizer introduces a new `credential`, with a "principal" and an optional "secret" field to authenticate when downloading the Docker or AppC image.

To run Docker or AppC containers directly from Mesos, specify the container type `MESOS` and a `docker` or `appc` object.
	
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

[Learn more about launching containers on Marathon](http://mesosphere.github.io/marathon/docs/native-docker.html).
