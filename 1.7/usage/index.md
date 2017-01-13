---
post_title: Usage
menu_order: 3
---

# Getting Started
After you have [installed](/docs/1.7/administration/installing/) DC/OS and set up the CLI on your local machine, familiarize yourself with the DC/OS UI [Dashboard](/docs/1.7/usage/webinterface/) and DC/OS [CLI](/docs/1.7/usage/cli/).

You can then launch a production-grade, highly available, containerized NGINX web server with a single command from the DC/OS CLI. DC/OS keeps your web server running if it crashes, allows you to scale it via the user interface and update its config at runtime, and much more!

1.  Run this command to launch a containerized [sample](/docs/1.7/usage/nginx.json) app on DC/OS.

    ```bash
    $ dcos marathon app add https://dcos.io/docs/1.7/usage/nginx.json
    ```

1.  Go to the "Services" tab of the DC/OS Dashboard to see the NGINX web server up and running and ready to serve traffic!

Now try these additional tutorials based on your role.

## Beginners

If you have a DevOps role:

- Running [Tomcat](/docs/1.7/usage/tutorials/tomcat/)

If you have a data engineering or data scientists role:

- Running [Spark](/docs/1.7/usage/tutorials/spark/)
- Running [Cassandra](/docs/1.7/usage/tutorials/cassandra/)
- Running [Kafka](/docs/1.7/usage/tutorials/kafka/)

If you have a DC/OS administrator role:

- [Managing users](/docs/1.7/administration/user-management/)
- [Monitoring](/docs/1.7/administration/monitoring/)


## Intermediate or Advanced

If you've been playing around with DC/OS for a bit and want a deeper dive, see these tutorials.

If you want to learn more about how DC/OS works:

- Check out the [DC/OS Architecture](/docs/1.7/overview/architecture/)
- Learn how [High Availability](/docs/1.7/overview/high-availability/) is achieved in DC/OS
- Understand [Network Security](/docs/1.7/administration/securing-your-cluster/) in DC/OS

If you have a DevOps role:

- Research all the [service discovery](/docs/1.7/usage/service-discovery/) options in DC/OS
- How to run [ArangoDB](/docs/1.7/usage/tutorials/arangodb/)

If you have a DC/OS administrator role:

- [Logging](/docs/1.7/administration/logging/) with DC/OS
- [Auto-scaling](/docs/1.7/usage/tutorials/autoscaling/) with DC/OS
- [Load-balancing](/docs/1.7/usage/service-discovery/marathon-lb/) with DC/OS

If you are now a seasoned DC/OS user and want to adapt or extend DC/OS, you can learn how to [contribute](/contribute)!
