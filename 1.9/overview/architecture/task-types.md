---
post_title: Task Types
nav_title: Task Types
menu_order: 2
---

DC/OS can run many different kinds of workloads, which are composed of tasks.

DC/OS tasks are [Mesos tasks](/docs/1.9/overview/concepts/#mesos-task) that have been scheduled by either a DC/OS built-in scheduler or a scheduler service running on DC/OS.

# Executors

Task are executed by a [Mesos Executor](/docs/1.9/overview/concepts/#mesos-executor) which gets specified by the [scheduler](/docs/1.9/overview/concepts/#dcos-scheduler) when it launches a task. In Mesos, the scheduler and it's executor(s) are called a [framework](/docs/1.9/overview/concepts/#mesos-framework), but within the broader context of DC/OS we'll often use the terms "scheduler", "executor", and "task" explicitly.

### Built-in executors

Mesos includes built-in executors that are available to all schedulers, but schedulers can also use their own executors.

- Command Executor - execute shell commands or Docker containers
- Default Executor (Mesos 1.1) - execute a group of shell commands or Docker containers

For more on Mesos executors, see the [Mesos Framework Development Guide](https://mesos.apache.org/documentation/latest/app-framework-development-guide/)

## Schedulers

Because the task system is so generic, users generally do not create or interact with tasks directly. Instead, schedulers often provide higher level abstractions.

### Built-in schedulers

DC/OS has two built-in schedulers:

- The Marathon scheduler provides **services** (Apps and Pods), which run continuously and in parallel.
- The Metronome scheduler provides **jobs**, which run immediately or on a defined schedule.

For more on Marathon services, see the [Services docs](/docs/1.9/usage/marathon/) or the [Marathon docs](https://mesosphere.github.io/marathon/docs/).

For more on Metronome jobs, see the [Jobs docs](/docs/1.9/usage/jobs/).

### User space schedulers

Additional schedulers can be installed as [scheduler services](/docs/1.9/overview/concepts/#dcos-scheduler-service) on Marathon, either from the [Mesosphere Universe](/docs/1.9/overview/concepts/#mesosphere-universe) or directly via Marathon.

Example user space schedulers:

- The Kakfa scheduler provides **Kakfa brokers**, which run as lifecycle managed Kafka nodes.
- The Cassandra scheduler provides **Cassandra nodes**, which run as lifecycle managed Cassandra nodes.
- The Spark scheduler (dispatcher) provides **Spark jobs**, which are themselves schedulers for Spark tasks.

For a full list of installable schedulers (and other packages), see the [Mesosphere Universe package list](https://universe.serv.sh/#/packages).
