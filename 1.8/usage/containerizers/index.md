---
post_title: Using Containerizers
menu_order: 40
---

A containerizer is a Mesos agent component responsible for launching containers, within which you can run a service. Running services in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically.

DC/OS supports the Mesos containerizer types:

- The [original Mesos containerizer](/docs/1.8/usage/containerizers/mesos-containerizer/).

- The [DC/OS Universal Container Runtime](/docs/1.8/usage/containerizers/ucr/).

- The [Docker containerizer](/docs/1.8/usage/containerizers/docker-containerizer/).
