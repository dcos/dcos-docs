---
post_title: Original Mesos Containerizer
menu_order: 0
---

The Mesos Containerizer is the original container runtime in Mesos. It does not support Docker containers, though it supports a range of isolators that can be composed to create a container. The Mesos Containerizer also does not support container images. Refer to the [features matrix](/docs/1.9/deploying-services/containerizers/) to see if the original Mesos containerizer is the correct choice for your task.

# Specify the Mesos Containerizer from the DC/OS Web Interface

To specify the Docker Containerizer from the web interface, go to **Services**  > **Run a Service** > **Single Container** > **More Settings**. In the **Container Runtime** section, choose the **Mesos Runtime** radio button.

# Specify the Mesos Containerizer from the DC/OS CLI

To specify the Mesos containerizer from the DC/OS CLI, add the following parameter to your Marathon application definition:

```json
{  
   "id":"/simple-service",
   "instances":1,
   "container":{  
      "type":"MESOS"
   },
   "cpus":0.1,
   "mem":128,
   "cmd":"sleep 10"
}
```

- [View the Mesos docs for the Mesos containerizer](http://mesos.apache.org/documentation/latest/mesos-containerizer/).
