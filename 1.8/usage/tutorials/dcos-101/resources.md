---
post_title: Understanding Resources
nav_title: Understanding Resources
menu_order: 8
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.8/usage/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.8/usage/tutorials/dcos-101/cli/).
* [app2](/docs/1.8/usage/tutorials/dcos-101/app2/) deployed and running in your cluster.

# Objective
In this section we will learn how to monitor and understand our resource utilization, how resource limits are enforced, and how to debug resource management issues.

# Steps
Resource management and resource isolation between tasks are core challenges for an operating system, which needs to manage resources.

* Deploy App
  * Let us have a second look at the defintion of [app2](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go).

```
  {
  "id": "/dcos-101/app2",
  "cmd": "chmod u+x app2 && ./app2",
  "args": null,
  "user": null,
  "env": null,
  "instances": 1,
  "cpus": 1,
  "mem": 128,
  "disk": 0,
  "gpus": 0,
  ...
```

  *Note:* The cpus, men, disk, and gpus parameters above specify the allocated resources and therefore define the maximum amount of resources a task can use. This number is not necessarily the same as the amount of resources a task actually uses. That number is usually lower.

  ## Scaling Applications

  When we need more resources for our app, we can scale in two dimensions: horizontally and vertically.

  ### Scale horizontally by increasing the instance count

  You can scale the instance count in two ways: scale an entire app group by a factor or directly set number of instances for an app.

  * Scale dcos-101 app group. This is useful if you want to scale multiple apps in a single group:
    * Scale up by factor 2: `dcos marathon group scale dcos-101 2`
    * Check that both app1 and app2 have scaled: <br/>
      `dcos marathon app list`.
    * Scale down again: `dcos marathon group scale dcos-101 0.5`
    * Check that both app1 and app2 have scaled: <br/>
      `dcos marathon app list`.
  * Set instance count for app2 directly. This is useful is you want to scale app a single app or if the factor-based scaling is not applicable:
    * `dcos marathon app update /dcos-101/app2 instances=3` Note that these are applied incrementally to an existing app definition.
    * Check that app2 has scaled `dcos marathon app update /dcos-101/app2 instances=1`.
    * Rescale app2 to 1 instance `dcos marathon app update /dcos-101/app2 instances=1`.
    * Check that app2 has scaled `dcos marathon app list`.

  ### Scale vertically by increasing allocated resources.

  **Note**: This causes a restart of the app!

  * Scale up: `dcos marathon app update /dcos-101/app2 cpus=2`.
  * Check that app2 has scaled `dcos marathon app list`.
  * Scale down: `dcos marathon app update /dcos-101/app2 cpus=1`.

  ## Debugging Resource Problems

  * Too few resources in cluster:
      * `dcos marathon app update /dcos-101/app2 instances=100` (potentially more if you have a large cluster).
      * Use `dcos marathon app list` to check that the `scale` deployment is stuck.
      * `dcos marathon deployment list`.
      * The problem here is that there no matching resources, for example, there might be resources left for the public-slave role, but not for the default role.
      * Solution: Add nodes or scale the app to a level at which resources are available `dcos marathon app update /dcos-101/app2 --force instances=1`. Note you have to use the `--force` flag here as the previous deployment is ongoing.
  * Too few resources on single node. As each app is started on a single node, task resources must fit onto a single node.
      * Update app2 to use 100 CPUs: `dcos marathon app update /dcos-101/app2 cpus=100`
      * Use `dcos marathon app list` to check that the `restart` deployment is stuck.
      * `dcos marathon deployment list`.
      * The problem here is that there are no resources offers large enough to match the request
      * Solution: Provision larger nodes or scale the app down to a level where it fits onto the free resources on a single node: `dcos marathon app update /dcos-101/app2 --force cpus=1`. Note that we have to use the force flag again.

  ## Debugging resource isolation

  What happens if an app tries to use more resources then it is allocated? The most common problem is memory consumption in conjunction with JVM-based applications.

  * Deploy [memory eater app](https://github.com/joerg84/dcos-101/blob/master/oomApp/oomApp.go)
      * `dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/oomApp/oomApp.json`
  * You will see it restarting over and over again...
  * Check the Marathon Log. Potentially we can see the oom already here, but unfortunately not always...
  * Problem here: The kernel is killing the app, which is not  necessarly visible to DC/OS.
  * SSH to an agent where the app has been running `dcos node ssh --master-proxy --mesos-id=$(dcos task oom-app --json | jq -r '.[] | .slave_id')`
  * Check kernel log `journalctl -f _TRANSPORT=kernel`
  * Here we see something like ` Memory cgroup out of memory: Kill process 10106 (oomApp) score 925 or sacrifice child; Killed process 10390 (oomApp) total-vm:3744760kB, anon-rss:60816kB, file-rss:1240kB, shmem-rss:0kB`
  * Solution: There are two potential reasons for your application using too much memory: Either your app uses too much memory by accident (e.g., a memleak), or you have allocated too little memory for it. So, check your app for correct behavior and/or increase the allocated memory.
  * Remove app `dcos marathon app remove /dcoc-101/oom-app`.


# Outcome
Congratulations! You've now learned how to deploy apps to DC/OS, network those apps, expose them to the outside of the cluster with a load-balancer, scale them, and debug potential resource issues! You're practically a pro!
