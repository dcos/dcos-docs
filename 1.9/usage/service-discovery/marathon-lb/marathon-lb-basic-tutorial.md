---
post_title: Deploying an Externally Load Balanced App with Marathon-LB
nav_title:  Marathon-LB for Externally Load Balanced App
menu_order: 100 
---

This tutorial shows you how to use Marathon-LB to run a containerized DC/OS service that serves a website. Specifically, you will use Docker image that contains NGINX, which serves the dcos.io site.

In this tutorial, Marathon-LB is used as the edge load balancer and service discovery mechanism. Marathon-LB is run on a public-facing node to route ingress traffic. 

### Prerequisites
- [A DC/OS cluster](/docs/1.9/administration/installing/) with at least one [private](/docs/1.9/overview/concepts/#private) agent and one [public](/docs/1.9/overview/concepts/#public) agent.
- [DC/OS CLI](/docs/1.9/usage/cli/install/) is installed.
- Marathon-LB [installed](/docs/1.9/usage/service-discovery/marathon-lb/usage/).

# Configure and Run a Containerized Service on a Public Node

1.  Copy `dcos-website/dcos-website.json` from the [dcos-website](https://github.com/dcos/dcos-website/blob/develop/dcos-website.json) GitHub repository.
 
    1.  Go to the [mesosphere/dcos-website](https://hub.docker.com/r/mesosphere/dcos-website/tags/) Docker Hub repository and copy the latest image tag.
    
        ![Mesosphere Docker Hub](/docs/1.9/usage/tutorials/img/dockerhub.png)
        
    1.  Replace `<image-tag>` in the `docker:image` field with the tag. 
        
    1.  Locate and take note of [your public agent node](/docs/1.9/administration/locate-public-agent/) IP address.
    
    1. In the labels field, add an entry for `HAPROXY_0_VHOST` and assign it the value of your public agent IP. Remove the leading `http://` and the trailing `/` from the IP. Remember to add a comma after the preceding field.

    The complete JSON service definition file should resemble:
    
    ```json
    {
      "id": "dcos-website",
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "mesosphere/dcos-website:<image-tag>",
          "network": "BRIDGE",
          "portMappings": [
            { "hostPort": 0, "containerPort": 80, "servicePort": 10004 }
          ]
        }
      },
      "instances": 3,
      "cpus": 0.25,
      "mem": 100,
      "healthChecks": [{
          "protocol": "HTTP",
          "path": "/",
          "portIndex": 0,
          "timeoutSeconds": 2,
          "gracePeriodSeconds": 15,
          "intervalSeconds": 3,
          "maxConsecutiveFailures": 2
      }],
      "labels":{
        "HAPROXY_DEPLOYMENT_GROUP":"dcos-website",
        "HAPROXY_DEPLOYMENT_ALT_PORT":"10005",
        "HAPROXY_GROUP":"external",
        "HAPROXY_0_REDIRECT_TO_HTTPS":"true",
        "HAPROXY_0_VHOST": "<public-agent-ip>"
      }
    }
    ```

1.  Run the service from the DC/OS CLI using the following command:
    
    ```bash
    $ dcos marathon app add dcos-website.json
    ```

1.  Go to the **Services** tab of the DC/OS web interface to verify that your application is healthy.

    ![Healthy Service](/docs/1.9/usage/tutorials/img/healthy-dcos-website.png)

1.  Go to your public agent to see the site running.
