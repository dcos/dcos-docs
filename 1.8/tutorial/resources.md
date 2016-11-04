
# Challenge
When installing all these apps, we can see that the overall resource utilization goes up.
How does that happen, how are resource limits enforced. How can I debug issues arising in the context of resource utilization?

# Steps
  Resource Mangement and resource isolation between task is one of the core challenges of an operating system to manage   resources.

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
  Note this specifies the allocated resources and hence the upper limit of resources which can be used by the task. This is not necessarly the same as acutally used resources.
  We can scale our app in two dimensions: horizontally and vertically.
 * Scale horizontally by increasing the instance count
    * Two ways (scale an entire app group by a factor or directly set number of instances for an app)
      * Scale dcos-101 app group  (This is useful if you want to scale multiple apps in a single group)
        * Scale up by factor 2: `dcos marathon group scale dcos-101 2`
        * Check that both app1 and app2 have scaled `dcos marathon app list`
        * Scale down again: `dcos marathon group scale dcos-101 0.5`
        * Check that both app1 and app2 have scaled `dcos marathon app list`
      * Set instance count for app2 (This is useful is you want to scale app a single app or if the factor based scaling is not applicable
        * `dcos marathon app update /dcos-101/app2 instances=3` Note that these are applied incrementally to an existing app definition.
        * Check that app2 has scaled `dcos marathon app update /dcos-101/app2 instances=1`
        * Rescale app2 to 1 instance `dcos marathon app update /dcos-101/app2 instances=1`
        * Check that app2 has scaled `dcos marathon app list`
   * Scale vertically by increasing allocated resources. Note this causes a restart of the app!
       * Scale up: `dcos marathon app update /dcos-101/app2 cpus=2`
       *  Check that app2 has scaled `dcos marathon app list`
       * Scale down: `dcos marathon app update /dcos-101/app2 cpus=1`
 * Debugging Resource Problems
    * Too few resources in cluster
        * `dcos marathon app update /dcos-101/app2 instances=100` (potentially more if you have a large cluster)
        * Use `dcos marathon app list` to check that the `scale` deployment is stuck
        * `dcos marathon deployment list`
        * Check marathon logs: TODO Discuss the easiest way to get marathon logs. `dcos service log marathon` does not work...
        * The problem here is that there no matching resources (there might be for example resources left for the public-slace role, but not for *.
        * Solution: add nodes are scale app back to level at which resources are available `dcos marathon app update /dcos-101/app2 --force instances=1`. Note you have to use the `--force` flag here as the previous deployment is ongoing.
    * Too few resources on single node. Each app is started on a single node, hence resources must fit onto a single node.
        * `dcos marathon app update /dcos-101/app2 cpus=100`
        * Use `dcos marathon app list` to check that the `restart` deployment is stuck
        * `dcos marathon deployment list`
        * Check marathon logs: TODO Discuss the easiest way to get marathon logs
        * The problem here is that there no resource offer being large enough to match the offer.
        * Solution: Privision larger nodes or scale app down to level where it fits onto the free resources on a single node `dcos marathon app update /dcos-101/app2 --force cpus=1`. Note that we have to use the force flag again.
 * Debugging resource isolation
    * What happens if an app tries to use more resources then it is allocated. Most common problem is memory consumption in conjunction with JVM based applications.
    * Deploy [memory eater app](https://github.com/joerg84/dcos-101/blob/master/oomApp/oomApp.go)
        * `wget https://raw.githubusercontent.com/joerg84/dcos-101/master/oomApp/oomApp.json`
        * `dcos marathon app add oomApp.json`
        * You will see it restarting over and over again
        * Check marathon Log. Potentially we can see the oom already here.
        * Problem here: Kernel is killing the app which not necessarly visible to DC/OS.
        * SSH to an agent where the app has been running `dcos node ssh --master-proxy --mesos-id=$(dcos task oom-app --json | jq -r '.[] | .slave_id')'
        * Check Kernel log `journalctl -f _TRANSPORT=kernel`
        * Here we see something like ` Memory cgroup out of memory: Kill process 10106 (oomApp) score 925 or sacrifice child; Killed process 10390 (oomApp) total-vm:3744760kB, anon-rss:60816kB, file-rss:1240kB, shmem-rss:0kB`
        * Solution: Check app for correct behavior and/or increase the allocated memory
        * Remove app `dcos marathon app remove /dcoc-101/oom-app`


# Outcome
 We understand the meaning of allocated vs used resources and how to debug issues related to memory allocation.

# Deep Dive
   Mesos 2 level scheduling
