---
post_title: Graceful Node Shutdown
menu_order: 501
---

DC/OS supports a partial graceful shutdown of agent nodes. 

You can use these instructions to remove a DC/OS cluster node. 

1.  Add a [Mesos maintenance primitive](http://mesos.apache.org/documentation/latest/maintenance/) for the cluster node to be removed (via /machine/down). The machine will not be used for new tasks.
1.  Use the Mesos [KillPolicy](https://github.com/apache/mesos/blob/1.1.x/include/mesos/mesos.proto#L434-L461) to specify how long, in seconds, [Marathon](https://github.com/mesosphere/marathon/commit/4a6cd7afe66c91741d835a55933da67b72c331de) will wait after sending a SIGTERM before killing the process via SIGKILL.
1.  Write app to catch SIGHUP and SIGTERM to shutdown gracefully within the killpolicy window. 
1.  Kill the DC/OS node, wait 21 minutes before looping (to kill another node). DC/OS is configured to rate limit automatic agent removal to 1 every 20 minutes. Do not shrink a cluster faster than this. 
    **Important:** If you use maintenance primitives, the agent removal rate limit does not apply (`/mesos/master/machine/down`). However, taking a machine down by using the maintenance primitives will also ignore kill policies, and perform force-kills immediately.
1.  Wait 1 minutes, then delete the maintenance primitive.  