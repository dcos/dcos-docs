---
post_title: Performance Monitoring
menu_order: 1
---

Here are some recommendations for monitoring a DC/OS cluster. You can use any monitoring tools. The endpoints listed below will help you troubleshoot when issues occur.

Your monitoring tools should leverage historic data points so that you can track changes and deviations. You should monitor your cluster when it is known to be in a healthy state as well as unhealthy. This will give you a baseline for what is “normal” in the DC/OS environment. With this historical data, you can fine tune your tools and set appropriate thresholds and conditions. When these thresholds are exceeded, you can send alerts to administrators.

Mesos and Marathon expose the following types of metrics:

*   Gauges are metrics that provide the current state at the moment it was queried. 
*   Counters have metrics that are additive and include past and present results. These metrics are not persisted across failover.

Marathon has a timer metric that determines how long an event has taken place. Timer does not exist for Mesos observability metrics.

## Marathon metrics

Marathon provides a number of [metrics][1] for monitoring. Here are the ones that are particularly useful to DC/OS.

**Lifetime metrics**

*   `service.mesosphere.marathon.uptime` (gauge) This metric provides the uptime, in milliseconds, of the reporting Marathon process. Use this metric to diagnose stability problems that can cause Marathon to restart.
*   `service.mesosphere.marathon.leaderDuration` (gauge) This metric provides the amount of time, in milliseconds, since the last leader election occurred. Use this metric to diagnose stability problems and determine the frequency of leader election.

**Running tasks**

*   `service.mesosphere.marathon.task.running.count` (gauge) This metric provides the number of tasks that are running.

**Staged tasks**

*   `service.mesosphere.marathon.task.staged.count` (gauge) This metric provides the number of tasks that are staged. Tasks are staged immediately after they are launched. A consistently high number of staged tasks indicates a high number of tasks are being stopped and restarted. This can be caused by either:
    
    *   A high number of app updates or manual restarts.
    *   Apps with stability problems that are automatically restarted frequently.

**Task update status**

*   `service.mesosphere.marathon.core.task.update.impl.ThrottlingTaskStatusUpdateProcessor.queued` (gauge) This metric provides the number of queued status updates.
*   `service.mesosphere.marathon.core.task.update.impl.ThrottlingTaskStatusUpdateProcessor.processing` (gauge) This metric provides the number of status updates that are currently in process.
*   `service.mesosphere.marathon.core.task.update.impl.TaskStatusUpdateProcessorImpl.publishFuture` (timer) This metric calculates how long it takes Marathon to process status updates.

**App and group count**

*   `service.mesosphere.marathon.app.count` (gauge) This metric provides the number of apps that are defined. The number of apps defined affects the performance of Marathon: the more apps that are defined, the lower the Marathon performance. 
*   `service.mesosphere.marathon.group.count` (gauge) This metric provides the number of groups that are defined. The number groups that are defined affects the performance of Marathon: the more groups that are defined, the lower the Marathon performance. 

**Communication between Marathon and Mesos**

If healthy, these metrics should always be increasing.

*   `service.mesosphere.marathon.core.launcher.impl.OfferProcessorImpl.incomingOffers` This metric provides the number of offers that Mesos is receiving from Marathon.
*   `service.mesosphere.marathon.MarathonScheduler.resourceOffers` This [Dropwizard](http://metrics.dropwizard.io/3.1.0/manual/core/) metric measures the number of resource offers that Marathon receives from Mesos.
*   `service.mesosphere.marathon.MarathonScheduler.statusUpdate` This [Dropwizard](http://metrics.dropwizard.io/3.1.0/manual/core/) metric measures the number of status updates that Marathon receives from Mesos.

## Mesos metrics

Mesos provides a number of [metrics][2] for monitoring. Here are the ones that are particularly useful to DC/OS.

### Master

**These metrics should not increase over time**

If these metrics increase, something is probably wrong.

*   `master/slave_reregistrations` (counter) This metric provides the number of agent re-registrations and restarts. Use this metric along with historical data to determine deviations and spikes of when a network partition occurs. If this number drastically increases, then the cluster has experienced an outage but has reconnected.
*   `master/slave_removals` (counter) This metric provides the number of agents removed for various reasons, including maintenance. Use this metric to determine network partitions after a large number of agents have disconnected. If this number greatly deviates from the previous number, your system administrator should be notified (PagerDuty etc).
*   `master/tasks_error` (counter) This metric provides the number of invalid tasks.
*   `master/tasks_failed` (counter) This metric provides the number of failed tasks.
*   `master/tasks_killed` (counter) This metric provides the number of killed tasks.
*   `master/tasks_lost` (counter) This metric provides the number of lost tasks. A lost task means a task was killed or disconnected by an external factor. Use this metric when a large number of task deviate from the previous historic number.
*   `master/slaves_disconnected` (gauge) This metric provides the number of disconnected agents. This metric is helpful along with `master/slave_removals`. If an agent disconnects this number will increase. If an agent reconnects, this number will decrease.
*   `master/messages_kill_task` (counter) This metric provides the number of kill task messages.
*   `master/slave_removals` (counter) This metric provides the number of agents that were not re-registered during master failover. This is a broad endpoint that combines `../reason_unhealthy`, `../reason_unregistered`, and `../reason_registered`. You can monitor this explicitly or leverage `master/slave_removals/reason_unhealthy`, `master/slave_removals/reason_unregistered`, and `master/slave_removals/reason_registered` for specifics.
*   `master/slave_removals/reason_unhealthy` (counter) This metric provides the number of agents failed because of failed health checks. This endpoint returns the total number of agents that were unhealthy.
*   `master/slave_removals/reason_unregistered` (counter) This metric provides the number of agents unregistered. If this number increases drastically, this indicates that the master or agent is unable to communicate properly. Use this endpoint to determine network partition.
*   `master/slave_removals/reason_registered` (counter) This metric provides the number of agents that were removed when new agents were registered at the same address. New agents replaces old agents. This should be a rare event. If this number increases, your system administrator should be notified (PagerDuty etc).

**These metrics should not decrease over time**

*   `master/slaves_active` (counter) This metric provides the number of active agents. The number of active agents is calculated by adding `slaves_connected` and `slave_disconnected`.
*   `master/slaves_connected` (counter) This metric provides the number of connected agents. This number should equal the total number of Mesos agents (`slaves_active`). Use this metric to determine the general health of your cluster as a percentage of the total.
*   `master/elected` (gauge) This metric indicates whether this is the elected master. This metric should be fetched from all masters, and add up to 1. If this number is not 1 for a period of time, your system administrator should be notified (PagerDuty etc).
*   `master/uptime_secs` (gauge) This metric provides the master uptime, in seconds. This number should be at least 5 minutes (300 seconds) to indicate a stable master. You can use this metric to detect "flapping". For example, if the master has an uptime of less than 1 minute (60 seconds) for more than 10 minutes, it has probably restarted 10 or more times.
*   `master/messages_decline_offers` (counter) This metric provides the number of declined offers. This number should equal the number of agents x the number of frameworks. If this number drops to a low value, something is probably getting starved.

### Agent

**These metrics should not decrease over time**

*   `slave/uptime_secs` (gauge) This metric provides the agent uptime, in seconds. This number should be always increasing. The moment this number resets to `0`, this indicates that the agent process has been rebooted. You can use this metric to detect "flapping". For example, if the agent has an uptime of less than 1 minute (60 seconds) for more than 10 minutes, it has probably restarted 10 or more times.
*   `slave/registered` (gauge) This metric indicates whether this agent is registered with a master. This value should always be `1`. A `0` indicates that the agent is looking to join a new master.

## General

*   Check the Marathon App Health API [endpoint][3] for critical applications API endpoint.
*   Check for agents being shut down: 
    *   Tail /var/log/mesos warning logs and watch for `Shutting down`
    *   Mesos endpoint that indicates how many agents have been shut down increases
*   Check for mesos masters having short uptimes, which is exposed in Mesos metrics.
*   Change mom-marathon-service logging level from `WARN` to `INFO`.
*   Modify the `mesos-master` log rotation configuration to store the complete logs for at least one day.
    
    *   Make sure the master nodes have plenty of disk space.
    *   Change the `logrotation` option from `rotate 7` to `maxage 14` or more. For example:
        
        ```
        ...
        /var/log/mesos/* {
            olddir /var/log/mesos/archive
            maxsize 2000k
            daily
            maxage 14
            copytruncate
            postrotate
                find  /var/log/mesos /var/log/mesos/archive -mtime +14 -delete
            endscript
        }
        EOF
        ...
        ```
            

See the Apache Mesos [documentation](http://mesos.apache.org/documentation/latest/monitoring/) for Mesos basic alerts.

 [1]: https://mesosphere.github.io/marathon/docs/metrics.html
 [2]: http://mesos.apache.org/documentation/latest/monitoring/
 [3]: https://mesosphere.github.io/marathon/docs/generated/api.html#v2_apps_get