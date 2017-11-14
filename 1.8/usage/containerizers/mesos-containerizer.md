---
post_title: Original Mesos Containerizer
menu_order: 0
---

The Mesos Containerizer is the original container runtime in Mesos. It does not support Docker containers, though it supports a range of isolators that can be composed to create a container. The Mesos Containerizer also does not support container images.

To specify the original Mesos containerizer, add the following parameter to your Marathon application definition:

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
