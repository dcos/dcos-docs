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

- *Cluster* ... Two or more Cassandra instances that communicates over gossip protocol.

**Scope**:

In the following tutorial you will learn about how to use Cassandra on DCOS, from the simple first steps of launching a Cassandra cluster on DC/OS, immediately followed by a brief primer on connecting to Cassandra and performing CRUD operations.

# Installing

Assuming you have a DC/OS cluster up and running, the first step is to [install Cassandra](https://docs.mesosphere.com/manage-service/cassandra/). As the minimum cluster size for this tutorial I recommend at least three nodes with 2 CPUs and 2 GB of RAM available, each:

    $ dcos package install cassandra
    Installing Marathon app for package [cassandra] version [1.0.0-2.2.5]
    Installing CLI subcommand for package [cassandra] version [1.0.0-2.2.5]
    New command available: dcos cassandra
    DCOS Cassandra Service is being installed.

While the DC/OS command line interface (CLI) is immediately available it takes a few moments until Cassandra is actually running in the cluster. Let's first check the DC/OS CLI and its new subcommand `cassandra`:

    $ dcos cassandra --help
    Usage: dcos-cassandra cassandra [OPTIONS] COMMAND [ARGS]...
    
    Options:
      --info / --no-info
      --framework-name TEXT  Name of the Cassandra instance to query
      --help                 Show this message and exit.
    
    Commands:
      backup      Backup Cassandra data
      cleanup     Cleanup old token mappings
      connection  Provides connection information
      node        Manage Cassandra nodes
      restore     Restore Cassandra cluster from backup
      seeds       Retrieve seed node information

Now, let's check if Cassandra is running and healthy, in the cluster itself. For this, go to the DC/OS dashboard and you should see Cassandra there:

<TODO: Get the image>
![Cassandra in the dashboard](img/dcos-cassandra-dashboard.png)

# Using Cassandra to perform CRUD operations

Now that you've a Cassandra cluster up and running, it's time to connect to our Cassandra cluster and perform some CRUD operations. 

Let's retrieve the connection information using following command:

    $ dcos cassandra connection
    {
        "nodes": [
            "10.0.2.136:9042",
            "10.0.2.138:9042",
            "10.0.2.137:9042"
        ]
    }

Now, let's SSH into our DC/OS cluster, so that we can connect to our Cassandra cluster.

    $ dcos node ssh --master-proxy --master
    core@ip-10-0-6-153 ~ $ 

At this point, we are now inside our DC/OS cluster and can connect to Cassandra cluster directly. Let's connect to the cluster using cqlsh client. Here's the general usage of this command:

    core@ip-10-0-6-153 ~ $ docker run cassandra:2.2.5 cqlsh <HOST> <PORT>
    
Replace `<HOST>` and `<PORT>` with the actual host and port information that we retrieved by running `dcos cassandra node connection` command above. Example:

    core@ip-10-0-6-153 ~ $ docker run cassandra:2.2.5 cqlsh 10.0.0.47 9160
    cqlsh>
    
And, now we are connected to our Cassandra cluster. Let's create a sample keyspace called `demo`:

    cqlsh> CREATE KEYSPACE demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };
    
Next, let's create a sample table called `map` in our `demo` keyspace:

    cqlsh> USE demo;CREATE TABLE map (key varchar, value varchar, PRIMARY KEY(key));
    
Let's insert some data in our table:

    cqlsh> INSERT INTO demo.map(key, value) VALUES('Cassandra', 'Rocks!');
    cqlsh> INSERT INTO demo.map(key, value) VALUES('StaticInfrastructure', 'BeGone!');
    cqlsh> INSERT INTO demo.map(key, value) VALUES('Buzz', 'DC/OS is the new black!');
    
Now we have inserted some data, let's query it back to make sure it's persisted correctly:

    cqlsh> SELECT * FROM demo.map;
    
Let's delete some data:

    cqlsh> DELETE FROM demo.map where key = 'StaticInfrastructure';
    
Let's query again to ensure that the row was deleted successfully:

    cqlsh> SELECT * FROM demo.map;
    
**Further resources**:




