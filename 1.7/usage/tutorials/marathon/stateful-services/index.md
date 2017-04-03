---
post_title: Running Stateful Services on DC/OS via Marathon
nav_title: Stateful Services
menu_order: 3
---

A stateful service acts on persistent data. Simple, stateless services in Marathon run in an empty sandbox each time they are launched. In contrast, stateful services on Marathon make use of persistent volumes that reside on agents in a cluster until explicitly destroyed.

These persistent volumes are mounted into a task's Mesos sandbox and are therefore continuously accessible to a service. Marathon creates persistent volumes for each task and all resources required to run the task are dynamically reserved. That way, Marathon ensures that a service can be relaunched and can reuse its data when needed. This is useful for databases, caches, and other data-aware services.

If the service you intend to run does not replicate data on its own, you need to take care of backups or have a suitable replication strategy.

Stateful services leverage 2 underlying Mesos features:

- [Dynamic reservations](http://mesos.apache.org/documentation/latest/reservation/) with reservation labels
- [Persistent volumes](http://mesos.apache.org/documentation/latest/persistent-volume/)

**Time Estimate**:

Approximately 20 minutes.

**Target Audience**:

This tutorial is for developers who want to run stateful services on DC/OS. **Note:** The DC/OS persistent volume feature is still in beta and is not ready for production use without a data replication strategy to guard against data loss.

**Terminology**:

- **Dynamic reservation:** For stateful services, Marathon uses dynamic reservations that are created for a role at runtime if needed.
- **Persistent volume:** Persistent volumes are created by Mesos and reside on an agent until explicitly destroyed.

**Scope**:

This will teach you how to set up and manage a stateful service on DC/OS.

## Prerequisites

* [DC/OS installed][1]
* [DC/OS CLI installed][2]
* Cluster Size: at least one agent node with 1 CPU, 1 GB of RAM and 1000 MB of disk space available.

## Install a stateful service (PostgreSQL)

Take a look at a JSON configuration to start the official PostgreSQL docker image:

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
          "size": 100
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
      ]
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

You'll notice that we're creating a volume for postgres to use for its data. Even if the task dies and restarts, it will get that volume back. Next, add this [service][4] to your cluster:


```
dcos marathon app add https://dcos.io/docs/1.7/usage/tutorials/marathon/stateful-services/postgres.marathon.json
```

One the service has been scheduled and the docker container has downloaded, postgres will become healthy and be ready to use. You can see this by checking out what tasks are running on your cluster:

```
dcos marathon task list
APP        HEALTHY          STARTED              HOST     ID
/postgres    True   2016-04-13T17:25:08.301Z  10.0.1.223  postgres.f2419e31-018a-11e6-b721-0261677b407a
```

## Stop the service

Now, stop the service:

```
dcos marathon app stop postgres
```

This command scales the `instances` count down to 0 and kills all running tasks. If you inspect the tasks list again, you will notice that the task is still there, however, containing the information about which agent it was placed on and which persistent volume it had attached, but without a `startedAt` value:

```
dcos marathon task list
APP        HEALTHY  STARTED     HOST     ID
/postgres    True     N/A    10.0.1.223  postgres.f2419e31-018a-11e6-b721-0261677b407a
```

## Restart

Start the stateful service again:

```
dcos marathon app start postgres
```

The metadata of the previous `postgres` task is used to launch a new task that takes over the reservations and volumes of the previously stopped service. Inspect the running task again by repeating the command from the previous step. You will see that the same `persistenceId` is used and the running service task is using the same data as the previous one.

## Cleanup

In order to restore the state of your cluster as it was before installing the stateful service, you delete the service:

```
dcos marathon app remove postgres
```

## Appendix

For further information on stateful services in DC/OS on Marathon, see:

- [Marathon Documentation](https://mesosphere.github.io/marathon/docs/persistent-volumes.html) on stateful services with persistent volumes

[1]: /docs/1.7/administration/installing/
[2]: /docs/1.7/usage/cli/install/
[4]: postgres.marathon.json
