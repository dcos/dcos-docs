---
post_title: How to use Apache Kafka on DC/OS
nav_title: Kafka
---

[Apache Kafka](https://kafka.apache.org/) is a distributed high-throughput publish-subscribe messaging system with strong ordering guarantees. Kafka clusters are highly available, fault tolerant, and very durable. DC/OS Kafka gives you direct access to the Kafka API so that existing producers and consumers can interoperate. You can configure and install DC/OS Kafka in moments. Multiple Kafka clusters can be installed on DC/OS and managed independently, so you can offer Kafka as a managed service to your organization.

Kafka uses [Apache ZooKeeper](https://zookeeper.apache.org/) for coordination. Kafka serves real-time data ingestion systems with high-throughput and low-latency. Kafka is written in Scala.

**Time Estimate**:

Approximately 10 minutes.

**Target Audience**:

- Anyone interested in Kafka

**Terminology**:

- **Broker:** A Kafka message broker that routes messages to one or more topics.
- **Topic:** A Kafka topic is message filtering mechanism in the pub/sub systems. Subscribers register to receive/consume messages from topics.
- **Producer:** An application that producers messages to a Kafka topic.
- **Consumer:** An application that consumes messages from a Kafka topic.

**Scope**:

In this tutorial you will learn how to:
* Install the Kafka service.
* Use the enhanced DC/OS CLI to create Kafka topics.
* Use Kafka on DC/OS to produce and consume messages.

## Table of Contents

  * [Prerequisites](#prerequisites)
  * [Install Kafka](#install-kafka)

    * [Typical installation](#typical-installation)
    * [Minimal installation](#minimal-installation)

  * [Topic Management](#topic-management)

     * [Add a topic](#add-a-topic)

  * [Produce and consume messages](#produce-and-consume-messages)

     * [List Kafka client endpoints](#list-kafka-client-endpoints)
     * [Produce a message](#produce-a-message)
     * [Consume a message](#consume-a-message)

  * [Cleanup](#cleanup)

     * [Uninstall](#uninstall)

  * [Kafka API Reference](#api-reference)

## Prerequisites

- A running DC/OS cluster with 3 nodes, each with 2 CPUs and 2 GB of RAM available.
- [DC/OS CLI](/docs/1.7/usage/cli/install/) installed.

## Install Kafka

### Typical installation

Install a Kafka cluster with 3 brokers using the DC/OS CLI:

```bash
$ dcos package install kafka
Installing Marathon app for package [kafka] version [1.0.0-0.9.0.1]
Installing CLI subcommand for package [kafka] version [1.0.0-0.9.0.1]
New command available: dcos kafka
DC/OS Kafka Service is being installed.

	Documentation: https://docs.mesosphere.com/kafka-1-7/
	Issues: https://docs.mesosphere.com/support/
```

While the DC/OS command line interface (CLI) is immediately available, it takes a few minutes for the Kafka service to start.

### Minimal installation

To start a minimal cluster with a single broker, create a JSON options file named `kafka-minimal.json`:
```json
{
    "brokers": {
        "count": 1,
        "mem": 512,
        "disk": 1000
    }
}
```
Install the Kafka cluster:
```bash
$ dcos package install kafka --options=kafka-minimal.json
```

## Topic management

### Add a topic:
```bash
$ dcos kafka topic create topic1 --partitions 1 --replication 1
```

## Produce and consume messages

### List Kafka client endpoints
```bash
$ dcos kafka connection
{
    "address": [
        "10.0.0.211:9843"
    ],
    "dns": [
        "broker-0.kafka.mesos:9843"
    ],
    "zookeeper": "master.mesos:2181/kafka"
}
```

### Produce a message
```bash
$ dcos node ssh --master-proxy --leader

core@ip-10-0-6-153 ~ $ docker run -it mesosphere/kafka-client

root@7d0aed75e582:/bin# echo "Hello, World." | ./kafka-console-producer.sh --broker-list 10.0.0.211:9843 --topic topic1
```

### Consume a message
```bash
root@7d0aed75e582:/bin# ./kafka-console-consumer.sh --zookeeper master.mesos:2181/kafka --topic topic1 --from-beginning
Hello, World.
```

## Cleanup

### Uninstall
```bash
$ dcos package uninstall --app-id=kafka
```

Then, use the [framework cleaner](https://docs.mesosphere.com/framework_cleaner/) script to remove your Kafka instance from Zookeeper and to destroy all data associated with it. The script requires several arguments, the values for which are derived from your service name:

`framework-role` is `kafka-role`
`framework-principal` is `kafka-principal`
`zk_path` is `kafka`

## Kafka API Reference

[https://kafka.apache.org/documentation.html](https://kafka.apache.org/documentation.html)
