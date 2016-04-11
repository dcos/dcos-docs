---
post_title: How to use Apache Cassandra
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

[Apache Cassandra](https://cassandra.apache.org/) is a distributed database that's scalable, performant and highly available. DC/OS Cassandra is 

**Terminology**:

- Cluster ... Two or more Cassandra instances that communicates over gossip protocol.


**Scope**:

In the following tutorial you will learn about how to use Cassandra on DCOS, from the simple first steps of launching a Cassandra cluster on DC/OS, immediately followed by a brief primer on connecting to Cassandra and performing CRUD operations.

# Installing

Assuming you have a DC/OS cluster up and running, the first step is to [install Cassandra](https://docs.mesosphere.com/manage-service/cassandra/). As the minimum cluster size for this tutorial I recommend at least three nodes with 2 CPUs and 2 GB of RAM available, each:

    $ dcos package install cassandra
    <TODO: Copy, paste the install command output>

While the DC/OS command line interface (CLI) is immediately available it takes a few moments until Cassandra is actually running in the cluster. Let's first check the DC/OS CLI and its new subcommand `cassandra`:

    $ dcos cassandra --help
    Usage:
        <TODO: Copy, paste command output>

Now, let's check if Cassandra is running and healthy, in the cluster itself. For this, go to the DC/OS dashboard and you should see Cassandra there:

![Cassandra in the dashboard](img/dcos-cassandra-dashboard.png)

# Using Cassandra to perform CRUD operations

Now that you've a Cassandra cluster up and running, it's time to connect to our Cassandra cluster and perform some CRUD operations. 

**Further resources**:




