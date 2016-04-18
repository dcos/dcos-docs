---
post_title: How to use Apache Cassandra
nav_title: Cassandra
---

[Apache Cassandra](https://cassandra.apache.org/) is a decentralized structured distributed storage system. Cassandra clusters are highly available, scalable, performant, and fault tolerant. DC/OS Cassandra allows you to quickly configure, install and manage Apache Cassandra. Multiple Cassandra clusters can also be installed on DC/OS and managed independently, so you can offer Cassandra as a managed service to your organization.

**Terminology**:

- **Node**: A running Cassandra instance.
- **Cluster**: Two or more Cassandra instances that communicates over gossip protocol.
- **Keyspace**: A keyspace in Cassandra is a namespace that defines how data is replicated on nodes.

**Scope**:

In this tutorial you will learn:
* How to install the Cassandra service
* How to use the enhanced DC/OS CLI operations for Cassandra
* How to validate that the service is up and running
* How to connect to Cassandra and perform CRUD operations

**Table of Contents**:

- [Prerequisites](#prerequisites)
- [Installing Cassandra](#installing-cassandra)

  - [Typical installation](#typical-installation)
  - [Custom manual installation procedure](#custom-manual-installation-procedure)
  - [Manual installation via the web interface](#manual-installation-via-the-web-interface)
  - [Validate installation](#validate-installation)

- [Cassandra CRUD operations](#cassandra-crud-operations)
- [Cleanup](#cleanup)

## Prerequisites

- A running DC/OS cluster with three nodes, each with 2 CPUs and 2 GB of RAM available
- [DC/OS CLI](/docs/1.7/usage/cli/install/) installed

## Installing Cassandra

Assuming you have a DC/OS cluster up and running, the first step is to [install Cassandra](https://docs.mesosphere.com/manage-service/cassandra/)

### Typical installation

Install Cassandra using the DC/OS CLI:

```bash
$ dcos package install cassandra
Installing Marathon app for package [cassandra] version [1.0.0-2.2.5]
Installing CLI subcommand for package [cassandra] version [1.0.0-2.2.5]
New command available: dcos cassandra
DC/OS Cassandra Service is being installed.
```

While the DC/OS command line interface (CLI) is immediately available it takes a few moments until Cassandra is actually running in the cluster.

### Custom manual installation procedure

1. Verify existing DC/OS repositories:

    ```bash
    $ dcos package repo list
    Universe: https://universe.mesosphere.com/repo
    ```

1. Identify available versions for the Cassandra service

    You can either list all available versions for Cassandra:

    ```bash
    $ dcos package list cassandra
    ```

    Or you can search for a particular one:

    ```bash
    $ dcos package search cassandra
    ```

1. Install a specific version of the Cassandra package:

    ```bash
    $ dcos package install --yes --force --package-version=<package_version> Cassandra
    ```

### Manual installation via the web interface

You can also install the Cassandra service from DC/OS Universe via `http://<dcos-master-dns>/#/universe/packages/`.

### Validate installation

Validate that the installation added the enhanced DC/OS CLI for Cassandra:

```bash
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
```

Now, let's validate that the Cassandra service is running and healthy. For this, go to the DC/OS dashboard and you should see Cassandra there:

![Cassandra in the dashboard](img/cassandra-dashboard.png)

## Cassandra CRUD operations

Now that you've a Cassandra cluster up and running, it's time to connect to our Cassandra cluster and perform some CRUD operations.

Let's retrieve the connection information using following command:

```bash
$ dcos cassandra connection
{
    "nodes": [
        "10.0.2.136:9042",
        "10.0.2.138:9042",
        "10.0.2.137:9042"
    ]
}
```

Now, let's SSH into our DC/OS cluster, so that we can connect to our Cassandra cluster.

```
$ dcos node ssh --master-proxy --leader
core@ip-10-0-6-153 ~ $
```

At this point, we are now inside our DC/OS cluster and can connect to Cassandra cluster directly. Let's connect to the cluster using cqlsh client. Here's the general usage of this command:

```bash
core@ip-10-0-6-153 ~ $ docker run cassandra:2.2.5 cqlsh <HOST>
```

Replace `<HOST>` with the actual host, information that we retrieved by running `dcos cassandra node connection` command above. Example:

```bash
core@ip-10-0-6-153 ~ $ docker run -ti cassandra:2.2.5 cqlsh 10.0.2.136
cqlsh>
```

And, now we are connected to our Cassandra cluster. Let's create a sample keyspace called `demo`:

```sql
cqlsh> CREATE KEYSPACE demo WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };
```

Next, let's create a sample table called `map` in our `demo` keyspace:

```sql
cqlsh> USE demo;CREATE TABLE map (key varchar, value varchar, PRIMARY KEY(key));
```

Let's insert some data in our table:

```sql
cqlsh> INSERT INTO demo.map(key, value) VALUES('Cassandra', 'Rocks!');
cqlsh> INSERT INTO demo.map(key, value) VALUES('StaticInfrastructure', 'BeGone!');
cqlsh> INSERT INTO demo.map(key, value) VALUES('Buzz', 'DC/OS is the new black!');
```

Now we have inserted some data, let's query it back to make sure it's persisted correctly:

```sql
cqlsh> SELECT * FROM demo.map;
```

Let's delete some data:

```sql
cqlsh> DELETE FROM demo.map where key = 'StaticInfrastructure';
```

Let's query again to ensure that the row was deleted successfully:

```sql
cqlsh> SELECT * FROM demo.map;
```

## Cleanup

### Uninstalling

```bash
$ dcos package uninstall cassandra
```

### Clean up persisted state

[Cassandra uninstall](https://docs.mesosphere.com/usage/services/cassandra/#uninstall)

**Further resources**

1. [DC/OS Cassandra Official Documentation](https://docs.mesosphere.com/usage/services/cassandra/)
1. [DataStax Cassandra Documentation](http://docs.datastax.com)
