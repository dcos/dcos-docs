---
post_title: Usage
post_excerpt: ""
layout: docs.jade
---

## Baby steps

It looks like you just [installed](https://dcos.io/install/) DC/OS. Welcome aboard! Now that you  have the DC/OS CLI set up on your local machine, you might be looking at the DC/OS Dashboard wondering, 'What now?'. You probably already know how to use `docker run ...` to launch a web server, right? You can  do the same thing with DC/OS, but with a deployment that is production-ready from the start. DC/OS will keep the web server running if it crashes, allow you to scale it, update the config at runtime, and much more!. Ready? Let's launch a production-grade containerized web server with command from the DC/OS CLI:

    $ dcos marathon app add https://dcos.io/docs/latest/usage/nginx.json

Now go to the DC/OS Dashboard and open the Marathon service. You should [see](img/usage_marathon_webserver.png) the web server up and running and ready to serve traffic.

## Beginners

Once you've had a good look around in the DC/OS Dashboard and familiarized yourself with the DC/OS CLI, here are a few more things that you might want to check out:

- DC/OS [FAQ](/usage/faq)
- If you have a DevOps role:
  - How to run [NGINX](/usage/tutorials/nginx/)
  - How to run a [Ruby on Rails](/usage/tutorials/ruby-on-rails/) app
  - How to run a [.NET](/usage/tutorials/asp-dot-net/) app
  - How to run [Tomcat](/usage/tutorials/tomcat/)
  - How to run [Jekyll](/usage/tutorials/jekyll/)
  - How to run [MySQL](/usage/tutorials/mysql/)
  - How to run [PostgreSQL](/usage/tutorials/postgres/)
  - How to run [Wordpress](/usage/tutorials/wordpress/)
  - How to run [Jenkins](/usage/tutorials/jenkins/)
- If you have a data engineering or data scientists role:
  - How to run [Spark](/usage/tutorials/spark/)
  - How to run [Cassandra](/usage/tutorials/cassandra/)
  - How to run [Kafka](/usage/tutorials/kafka/)
  - How to run [Elasticsearch](/usage/tutorials/elasticsearch/)
  - How to run [Redis](/usage/tutorials/redis/)
- If you a DC/OS administrator role:
  - How to [resize](/administration/resizing/) a DC/OS cluster
  - How to [upgrade](/administration/upgrading/) a DC/OS cluster
  - How to [monitor](/administration/monitoring/) a DC/OS cluster

## Intermediate

Check these out if you've been playing around with DC/OS for a bit and want a deeper dive.

- If you want to learn more about how DC/OS works:
  - Check out the [DC/OS Architecture](/overview/architecture/)
  - Check out the [High Availability](/overview/high-availability/) characteristics of DC/OS
  - Check out the [Security](/overview/security/) characteristics of DC/OS
  - Check out [Container Operations](/overview/container-operations/) using DC/OS
- If you have a DevOps role:
  - How to implement a [microservices](/usage/tutorials/microservices/) architecture
  - How to deal with [service discovery](/usage/tutorials/service-discovery/)
  - How to [debug](/usage/tutorials/debugging/) your app
  - How to run [MySQL HA](/usage/tutorials/mysql-ha/)
  - How to run [PostgreSQL HA](/usage/tutorials/postgres-ha/)
- If you a DC/OS administrator role:
  - How to run a [Docker registry](/usage/tutorials/docker-registry/)
  - How to run a [Vault](/usage/tutorials/vault/)
  - How to run [Consul](/usage/tutorials/consul/)
  - How to handle [logging](/usage/tutorials/logging/)
  - How to handle [monitoring](/usage/tutorials/monitoring/)
  - How to handle [auto-scaling](/usage/tutorials/autoscaling/)
  - How to handle [load-balancing](/usage/tutorials/load-balancing/)

## Advanced

Check these out if you are now a seasoned DC/OS user and want to adapt and extend DC/OS.

- Learn how to [contribute](/overview/contribution/) to DC/OS.
- If you have a DevOps role:
  - How to handle [stateful services](/usage/tutorials/stateful-services/)
  - How to [package](/usage/tutorials/packaging/) your service
  - How do I [migrate](/overview/migration/) an existing app to DC/OS
- If you a DC/OS administrator role:
  - Understand the [system components](/administration/system-components/) of DC/OS
  - Understand DC/OS [telemetry](/administration/telemetry/)
  - How to monitor DC/OS using [Nagios](/administration/monitoring/nagios/)
  - How to set up a [proxy](/administration/proxy/)
