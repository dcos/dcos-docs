---
post_title: DC/OS Ports
menu_order: 4
---

This topic lists the ports that are required to launch DC/OS. Additional ports may be required to launch the individual DC/OS services.

## All nodes

### TCP

|Port   |DC/OS [component](/docs/1.9/overview/architecture/components/)|  systemd unit   | 
|---|---|
| 61003 | REX-Ray | `dcos-rexray.service` |
| 61053 | Mesos DNS | `dcos-mesos-dns.service` |
| 61420 | Erlang Port Mapping Daemon (EPMD) | `dcos-epmd.service` |
| 61421 | Minuteman | `dcos-minuteman.service` |
| 62053 | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 62080 | Navstar | `dcos-navstar.service` |
| 62501 | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 62502 | Navstar | `dcos-navstar.service` |
| 62503 | Minuteman | `dcos-minuteman.service` |

### UDP

|Port   |DC/OS [component](/docs/1.9/overview/architecture/components/)|  systemd unit   | 
|---|---|
| 61053 | Mesos DNS | `dcos-mesos-dns.service`|
| 62053 | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 64000 | Navstar | `dcos-navstar.service` |

## Master

### TCP

|Port   |DC/OS [component](/docs/1.9/overview/architecture/components/)|  systemd unit   | 
|---|---|
| 53    | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 80    | Admin Router Master | `dcos-adminrouter.service` |
| 443   | Admin Router Master | `dcos-adminrouter.service` |
| 1050  | DC/OS Diagnostics (3DT) | `dcos-3dt.service` |
| 1801  | DC/OS Authentication | `dcos-oauth.service` |
| 2181  | Exhibitor and Zookeeper | `dcos-exhibitor.service` |
| 5050  | Mesos Master | `dcos-mesos-master.service` |
| 7070  | DC/OS Package Manager (Cosmos) | `dcos-cosmos.service` |
| 8080  | Marathon | `dcos-marathon.service` |
| 8123  | Mesos DNS | `dcos-mesos-dns.service` |
| 8181  | Exhibitor and Zookeeper | `dcos-exhibitor.service` |
| 9990  | DC/OS Package Manager (Cosmos) | `dcos-cosmos.service` |
| 15055 | DC/OS History | `dcos-history-service.service` |
| 15101 | Marathon libprocess | `dcos-marathon.service` |
| 15201 | DC/OS Jobs (Metronome) libprocess | `dcos-metronome.service`|
| Dynamic | DC/OS Jobs (Metronome) | `dcos-metronome.service`|
| Dynamic | DC/OS Component Package Manager (Pkgpanda) | `dcos-pkgpanda-api.service` |

### UDP

|Port   |DC/OS [component](/docs/1.9/overview/architecture/components/)|  systemd unit   |
|---|---|
| 53 | DNS Forwarder (Spartan) | `dcos-spartan.service` |

## Agent

### TCP

|Port   |DC/OS [component](/docs/1.9/overview/architecture/components/)|  systemd unit   | 
|---|---|
| 5051  |  Mesos Agent | `dcos-mesos-slave.service` |
| 61001 |  Admin Router Agent | `dcos-adminrouter-agent` |
|  61002 | DC/OS Diagnostics (3DT) | `dcos-3dt.service` |
|  1025-2180 | Default advertised port ranges (for Marathon health checks) |  
|   2182-3887| Default advertised port ranges (for Marathon health checks) |  
|  3889-5049| Default advertised port ranges (for Marathon health checks) |  
| 5052-8079| Default advertised port ranges (for Marathon health checks) |  
|8082-8180| Default advertised port ranges (for Marathon health checks) |  
|8182-32000 | Default advertised port ranges (for Marathon health checks) |


