---
post_title: Running PostgreSQL on DC/OS
nav_title: PostgreSQL
---

[PostgreSQL](http://www.postgresql.org/) is an object-relational database management system with an emphasis on extensibility and standards-compliance.

**Time Estimate**:

It will take around 10 minutes to complete this tutorial.

**Target Audience**:

This tutorial is for developers who want to test their software and use Postgres in DC/OS environment. This is a basic installation of PostgreSQL server and it does not include data backup and is not highly available. This is not meant for use in a production environment.

## Prerequisites

- A running DC/OS cluster with at least one agent node with 1 CPU, 1 GB of RAM and 1000 MB of disk space available
- [DC/OS CLI](/docs/1.7/usage/cli/install/) installed

## Install PostgreSQL

Create a Marathon app definition file named [postgres.marathon.json](postgres.marathon.json) with the following Marathon application descriptor. A Marathon app definition file specifies the required parameters for launching an app with Marathon. Specified in this app definition is the PostgreSQL Docker container, the PostgreSQL password, the resources required, Marathon health checks, and Marathon [upgrade strategy](https://mesosphere.github.io/marathon/docs/rest-api.html).

```json
{
  "id": "/postgres",
  "cpus": 1,
  "mem": 1024,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "volumes": [
      {
        "containerPath": "pgdata",
        "mode": "RW",
        "persistent": {
          "size": 10000
        }
      }
    ],
    "docker": {
      "image": "postgres:9.5",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 5432,
          "hostPort": 0,
          "protocol": "tcp",
          "labels": {
            "VIP_0": "5.4.3.2:5432"
          }
        }
      ],
    }
  },
  "env": {
    "POSTGRES_PASSWORD": "DC/OS_ROCKS",
    "PGDATA": "/mnt/mesos/sandbox/pgdata"
  },
  "healthChecks": [
    {
      "protocol": "TCP",
      "portIndex": 0,
      "gracePeriodSeconds": 300,
      "intervalSeconds": 60,
      "timeoutSeconds": 20,
      "maxConsecutiveFailures": 3,
      "ignoreHttp1xx": false
    }
  ],
  "upgradeStrategy": {
    "maximumOverCapacity": 0,
    "minimumHealthCapacity": 0
  }
}
```

Add the Marathon app definition to DC/OS with this CLI command:
    
    dcos marathon app add postgres.marathon.json

This command installs the PostgreSQL server on your DC/OS cluster and makes it available on VIP `5.4.3.2` and standard Postgres port `5432`.

## Cleanup

You can remove Postgres with this DC/OS CLI command:

    dcos marathon app remove postgres
