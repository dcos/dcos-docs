---
post_title: Usage
menu_order: 3
---

It looks like you've just [installed](/install/) DC/OS. Welcome aboard! Now that you have the DC/OS CLI set up on your local machine, you might be looking at the DC/OS Dashboard wondering, 'What now?'.

You probably already know how to use `docker run ...` to launch a web server, right? You can do the same thing with DC/OS but in a way that is production ready, right off the bat. DC/OS will keep your web server running if it crashes, and allow you to scale it via CLI or the UI, update its config at runtime and much more!

Ready? Let's launch a production-grade containerized web server with this command from the DC/OS CLI:

```bash
$ dcos marathon app add https://dcos.io/docs/1.7/usage/nginx.json
```

Now go to the DC/OS Dashboard and open the Marathon service and you should see the web server up and running and ready to serve traffic.

## Beginners

Once you've had a good look around in the DC/OS Dashboard and familiarized yourself with the DC/OS CLI, here are a few more exercises that you might want to try.

If you have a DevOps role:

- How to run a [Ruby on Rails app](/docs/1.7/usage/tutorials/ruby-on-rails/) app
- How to run [Tomcat](/docs/1.7/usage/tutorials/tomcat/)

If you have a data engineering or data scientists role:

- How to run [Spark](/docs/1.7/usage/tutorials/spark/)
- How to run [Cassandra](/docs/1.7/usage/tutorials/cassandra/)
- How to run [Kafka](/docs/1.7/usage/tutorials/kafka/)

If you a DC/OS administrator role:

- How to [manage users](/docs/1.7/administration/user-management/)
- How to [monitor](/docs/1.7/administration/monitoring/)

## Intermediate

Check these out if you've been playing around with DC/OS for a bit and want a deeper dive.

If you want to learn more about how DC/OS works:

- Check out the [DC/OS Architecture](/docs/1.7/overview/architecture/)
- Learn how [High Availability](/docs/1.7/overview/high-availability/) is achieved in DC/OS
- Understand [Network Security](/docs/1.7/overview/network-security/) in DC/OS

If you have a DevOps role:

- Research all the [service discovery](/docs/1.7/usage/service-discovery/) options in DC/OS
- How to run [PostgreSQL](/docs/1.7/usage/tutorials/postgres/)
- How to run [ArangoDB](/docs/1.7/usage/tutorials/arangodb/)

If you a DC/OS administrator role:

- How to handle [logging](/docs/1.7/administration/logging/)
- How to handle [auto-scaling](/docs/1.7/usage/tutorials/autoscaling/)
- How to handle [load-balancing](/docs/1.7/usage/service-discovery/marathon-lb/)

## Advanced

Check these out if you are now a seasoned DC/OS user and want to adapt, extend and learn how to [contribute](/contribute) to DC/OS.

We hope you have a good time with DC/OS and enjoy using it as much as we are having creating it.
