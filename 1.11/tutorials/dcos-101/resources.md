---
post_title: Understanding Resources
nav_title: Understanding Resources
menu_order: 7
---

# Prerequisites
* A [running DC/OS cluster](/docs/1.10/tutorials/dcos-101/cli/) with [the DC/OS CLI installed](/docs/1.10/tutorials/dcos-101/cli/).
* [app2](/docs/1.10/tutorials/dcos-101/app2/) deployed and running in your cluster.

<table class="table" bgcolor="#FAFAFA"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Important:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is to demonstrate capabilities, and may not be suited for use in a production environment. Before using a similar solution in your environment, you must adapt, validate, and test.</td> </tr> </table>

# Objective

Resource management and resource isolation between tasks are core functions of any operating system. In this section, you will learn how to monitor and understand your resource utilization, how resource limits are enforced, and how to debug resource management issues.

# Steps

## Review App Definition

* Take another look at the app defintion for [app2](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go).

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

* The `cpus`, `mem`, `disk`, and `gpus` parameters above specify the allocated resources and therefore define the maximum amount of resources a task can use. This number is not necessarily the same as the amount of resources a task actually uses. That number is usually lower.

* You will notice that the id assigned in the app definitions for both [app1](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json) and [app2](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go) is prefixed by `/dcos-101/`. This defines the [application group](https://mesosphere.github.io/marathon/docs/application-groups.html) that the apps belong to. Application groups allow configuration and dependencies to be applied to a group of applications at the same time.
  
## Scaling Applications

When you need more resources for your app, you can scale in two dimensions - horizontally and vertically.

### Scale horizontally by increasing the instance count

Horizontal scaling involves increasing the number of instances of an application. You can scale the instance count in two ways:

1. Scale an entire app group by a factor. 
1. Directly set number of instances for an app.

**Scale dcos-101 application group:** 

Since both appl and app2 share the same app group, we can scale them together.

* Scale up by a factor of 2: 

`dcos marathon group scale dcos-101 2`
* Check that both app1 and app2 have scaled up:
  
`dcos marathon app list`
* Scale down again:

`dcos marathon group scale dcos-101 0.5`
* Check that both app1 and app2 have scaled down:
     
`dcos marathon app list`

**Set instance count for app2 directly:**

This is useful is you want to scale a single app independently
  
* Scale app2 to 3 instances: 

`dcos marathon app update /dcos-101/app2 instances=3` 
       
Note that these are applied incrementally to an existing app definition.
* Check that app2 has scaled: 

`dcos marathon app list`
* Rescale app2 to 1 instance: 

`dcos marathon app update /dcos-101/app2 instances=1`
* Check that app2 has scaled: 

`dcos marathon app list`

  
### Scale vertically by increasing allocated resources

Vertical scaling involves increasing the amount of resources like CPU or RAM allocated to an instance.
 
**Note**: This causes a restart of the app!

* Scale up to 2 CPU's for the app2 instance: 
     
`dcos marathon app update /dcos-101/app2 cpus=2`
* Check that app2 has scaled:

`dcos marathon app list`
* Scale back down to 1 CPU for the app2 instance: 

`dcos marathon app update /dcos-101/app2 cpus=1`

# Debugging Resource Problems

## Too few resources in the cluster

To simulate this:
  
* Increase app2 instances to 100

`dcos marathon app update /dcos-101/app2 instances=100` 

You may have to increase this number if you have a large cluster.
* Use `dcos marathon app list` to check that the `scale` deployment is stuck.
* `dcos marathon deployment list`

The problem here is that there no matching resources available. For example, there might be resources left for the public-slave role, but not for the default role.
   
Solution: 
    
* Add nodes or scale the app to a level at which resources are available. 

`dcos marathon app update /dcos-101/app2 --force instances=1`

Note you must use the `--force` flag here as the previous deployment is ongoing.

## Too few resources on a single node

As each app is started on a single node, task resources must also fit onto a single node.

To simulate this:

* Update app2 to use 100 CPUs:

`dcos marathon app update /dcos-101/app2 cpus=100`
* Use `dcos marathon app list` to check that the `restart` deployment is stuck.
* `dcos marathon deployment list`

The problem here is that there are no resource offers large enough to match the request.

Solution: 

* Provision larger nodes or scale the app down to a level where it fits onto the free resources on a single node:

`dcos marathon app update /dcos-101/app2 --force cpus=1`

Note that you must use the force flag again.

# Debugging resource isolation

What happens if an app tries to use more resources then it is allocated? The most common problem is memory consumption in conjunction with JVM-based applications.

To simulate this:

* Deploy the [memory eater](https://github.com/joerg84/dcos-101/blob/master/oomApp/oomApp.go) app.

`dcos marathon app add https://raw.githubusercontent.com/joerg84/dcos-101/master/oomApp/oomApp.json`

* You will see it restarting over and over again...
  
Check the Marathon log. Potentially you will see the Out of Memory error here, but unfortunately not always - since the kernel is killing the app, this may not always be visible to DC/OS.

* SSH to an agent where the app has been running:

`dcos node ssh --master-proxy --mesos-id=$(dcos task oom-app --json | jq -r '.[] | .slave_id')`
* Check the kernel log:

`journalctl -f _TRANSPORT=kernel`

Here you see something like:

```
    Memory cgroup out of memory: Kill process 10106 (oomApp) score 925 or sacrifice child; Killed process 10390 (oomApp) total-vm:3744760kB, anon-rss:60816kB, file-rss:1240kB, shmem-rss:0kB`
```

Solution: 

There are two potential reasons for your application using too much memory:

1. Your app uses too much memory by accident e.g. a memory leak in the code.
1. You have allocated too little memory for it. 

So, check your app for correct behavior and/or increase the allocated memory.
  
* Remove the app:

`dcos marathon app remove /dcoc-101/oom-app`

# Outcome

Congratulations! You've now learned how to deploy apps to DC/OS, network those apps, expose them to the outside of the cluster with a load-balancer, scale them, and debug potential resource issues! You're practically a pro!
