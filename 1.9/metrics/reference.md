---
post_title: Metrics Reference
feature_maturity: preview
menu_order: 2
---

These metrics are automatically collected by DC/OS.

#  Node

### Metrics
   
| Metric            | Description                  |
|-------------------|------------------------------|
| cpu.cores         |    Percentage of cores used.     |
| cpu.idle         |     Percentage of CPUs idle.         |
| cpu.system         |    Percentage of system used.   |
| cpu.total         |   Percentage of CPUs used.  |
| cpu.user         |   Percentage of CPU used by the user.   |
| cpu.wait         |   Percentage idle while waiting for an operation to complete.    |
| load.1min         |     Load average for the past minute.       |
| load.5min         |   Load average for the past 5 minutes.        |
| load.15min         |    Load average for the past 15 minutes.        |
| memory.buffers         |   Number of memory buffers.     |
| memory.cached         |   Amount of cached memory.   |
| memory.free         |    Amount of free memory in bytes.   |
| memory.total         |   Total memory in bytes.   |
| processes         |  Number of processes that are running.          |
| swap.free         |  Amount of free swap space.   |
| swap.total         |  Total swap space.    |
| swap.used         |    Amount of swap space used.    |
| uptime          |   The system reliability and load average.    |
   
### Filesystems
   
| Metric            | Description                  |
|-------------------|------------------------------|
| filesystem.{{.Name}}.capacity.free    | Amount of available capacity in bytes. |
| filesystem.{{.Name}}.capacity.total    | Total capacity in bytes. |
| filesystem.{{.Name}}.capacity.used    |  Capacity used in bytes. |
| filesystem.{{.Name}}.inodes.free    | Amount of available inodes in bytes. |
| filesystem.{{.Name}}.inodes.total    | Total inodes in bytes. |
| filesystem.{{.Name}}.inodes.used    | Inodes used in bytes.  |

**Note:** `{{.Name}}` is part of a [go template](https://golang.org/pkg/html/template/) and is automatically populated based on the mount path of the local filesystem (e.g., `/`, `/boot`, etc).
      
### Network interfaces
   
| Metric            | Description                  |
|-------------------|------------------------------|
| network.{{.Name}}.in.bytes    | Number of bytes downloaded. |
| network.{{.Name}}.in.dropped    | Number of downloaded bytes dropped. |
| network.{{.Name}}.in.errors    | Number of downloaded bytes in error. |
| network.{{.Name}}.in.packets    | Number of packets downloaded. |
| network.{{.Name}}.out.bytes    | Number of bytes uploaded. |
| network.{{.Name}}.out.dropped    | Number of uploaded bytes dropped. |
| network.{{.Name}}.out.errors    | Number of uploaded bytes in error.  |
| network.{{.Name}}.out.packets    | Number of packets uploaded. |

**Note:** `{{.Name}}` is part of a [go template](https://golang.org/pkg/html/template/) and is automatically populated based on the mount path of the local filesystem (e.g., `/`, `/boot`, etc).
   
# Container

The following per-container resource utilization metrics are collected.

### CPU usage info
   <!-- https://github.com/apache/mesos/blob/1.0.1/include/mesos/v1/mesos.proto -->
   
| Metric            | Description                  |
|-------------------|------------------------------|
| cpus_limit    | The number of CPU shares allocated. |
| cpus_system_time_secs    | Total CPU time spent in kernel mode in seconds. |
| cpus_throttled_time_secs    | Total time, in seconds, that CPU was throttled. |
| cpus_user_time_secs    | Total CPU time spent in user mode. |

### Disk info
   
| Metric            | Description                  |
|-------------------|------------------------------|
| disk_limit_bytes    | Hard memory limit for disk in bytes. |
| disk_used_bytes    | Hard memory used in bytes.  |
   
### Memory info
   <!-- https://github.com/apache/mesos/blob/1.0.1/include/mesos/v1/mesos.proto -->
   
| Metric            | Description                  |
|-------------------|------------------------------|
| mem_limit_bytes    | Hard memory limit for a container. |
| mem_total_bytes    | Total memory of a process in RAM (as opposed to in Swap). |   
   
# Dimensions
   <!-- http://mesos.apache.org/documentation/latest/port-mapping-isolator -->
Dimensions are metadata about the metrics that are contained in a common message format and are broadcast to one or more metrics producers.
   
| Metric            | Description                  |
|-------------------|------------------------------|
| net_rx_bytes    | Bytes received. |
| net_rx_dropped    | Packets dropped on receive.  |
| net_rx_errors    | Errors reported on receive. |
| net_rx_packets    |  Packets received.  |
| net_tx_bytes    |  Bytes sent. |
| net_tx_dropped    | Packets dropped on send  |
| net_tx_errors    | Errors reported on send. |
| net_tx_packets    | Packets sent. |


For more information, see the [dcos-metrics repository](https://github.com/dcos/dcos-metrics).
