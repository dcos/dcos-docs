
# Challenge
So we have redis working in our cluster now, let us make write and deploy and app connecting to it.


# Steps
  * Deploy App
    * Short look at app [here](https://github.com/joerg84/dcos-101/blob/master/app2/app2.go). Some details will follow in future parts of this tutorial.
    * Get app definition `wget https://raw.githubusercontent.com/joerg84/dcos-101/master/app2/app2.json`
    * Add app `dcos marathon app add app2.json`
  * Check that is running
    * `dcos task`
    * `dcos marathon app list`
    * Curl it from within cluster (in this case from the leading master)
       * `dcos node ssh --master-proxy --leader`
       * `curl dcos-101app2.marathon.l4lb.thisdcos.directory:10000`
    * Make it available to the public. Curling the app from within the cluster is one thing, but we want to expose it to the public nodes.
       * Install marathon-lb `dcos package install marathon-lb`
       * Check that it is running via `dcos task` and identify the public node it running on
       * Check webapp on `publicNode:10000`
       * Add new Key:Value pair
       * Check key count via app1 `dcos task log app1`

    Note that we will explore the loadbalancing aspects of marathon-lb further in one of the next sections.
     EXPLAIN SINGLE POINT OF FAILURE AND WHY WE NEED ELB IN FRONT.

# Outcome
 We have deployed our second App which is using the native Mesos Containerizer. We exposed the app UI via marathon-lb.

# Deep Dive
  Mesos vs. Docker Containerizer
