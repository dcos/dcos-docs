---
post_title: Listing Services Installed on your DC/OS cluster
nav_title: Listing
---

You can monitor the installed DC/OS services and their health through the DC/OS web interface or command line interface.

**Prerequisites:**

*   [DC/OS cluster][1] is up and running.
*   [DC/OS CLI][2] is installed and configured.

# Monitoring DC/OS services in the DC/OS web interface

From the DC/OS web interface, click the **Services** tab. In this example you can see the installed DC/OS services Cassandra, Chronos, and HDFS. All of the services are showing a status of Healthy.

![service list](../img/service-list.png)

*   **SERVICE NAME** Displays the DC/OS service name.
*   **HEALTH** Displays the [Marathon health check][3] status for the service.
*   **TASKS** Display the number of running tasks.
*   **CPU** Displays the percentage of CPU in use.
*   **MEM** Displays the amount of memory used.
*   **DISK** Displays the amount of disk space used.

For more information about the Services tab, see the DC/OS web interface [documentation][4].

# Monitoring DC/OS services in the DC/OS CLI

From the DC/OS CLI, enter the `dcos service` command. In this example you can see the native Marathon instance, and the installed DC/OS services Chronos, HDFS, and Kafka.

```bash
$ dcos service
NAME      HOST             ACTIVE  TASKS CPU   MEM     DISK   ID
chronos   <privatenode1>   True     0    0.0    0.0     0.0   <service-id1>
hdfs      <privatenode2>   True     1    0.35  1036.8   0.0   <service-id2>
kafka     <privatenode3>   True     0    0.0    0.0     0.0   <service-id3>
marathon  <privatenode3>   True     3    2.0   1843.0  100.0  <service-id4>
```

*   **NAME** Displays the DC/OS service name.
*   **HOST** Displays the private agent node where the service running.
*   **ACTIVE** Indicates whether the service is connected to a scheduler.
*   **TASK** Displays the number of running tasks.
*   **CPU** Displays the percentage of CPU in use.
*   **MEM** Displays the amount of memory used.
*   **DISK** Displays the amount of disk space used.
*   **ID** Displays the DC/OS service framework ID. This value is automatically generated and is unique across the cluster.

 [1]: /docs/1.7/administration/installing/
 [2]: /docs/1.7/usage/cli/install/
 [3]: https://mesosphere.github.io/marathon/docs/health-checks.html
 [4]: /docs/1.7/usage/webinterface/#scrollNav-2
