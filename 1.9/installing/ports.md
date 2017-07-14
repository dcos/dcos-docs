---
post_title: DC/OS Ports
menu_order: 5
post_excerpt: ""
feature_maturity: ""
---

[DC/OS components](/docs/1.9/overview/architecture/components/) listen on multiple ports on each node. These ports must be available for installation to succeed.

DC/OS allocates additional ports to services running on top of DC/OS. These ports are required to be available when services are installed.

## All nodes

### TCP

| Port | DC/OS component | systemd unit |
|---|---|---|
| 61003 | REX-Ray | `dcos-rexray.service` |
| 61053 | Mesos DNS | `dcos-mesos-dns.service` |
| 61420 | Erlang Port Mapping Daemon (EPMD) | `dcos-epmd.service` |
| 62053 | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 62080 | Navstar | `dcos-navstar.service` |
| 62501 | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 62502 | Navstar | `dcos-navstar.service` |

### UDP

| Port | DC/OS component | systemd unit |
|---|---|---|
| 61053 | Mesos DNS | `dcos-mesos-dns.service`|
| 62053 | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 64000 | Navstar | `dcos-navstar.service` |

## Master

### TCP

| Port | DC/OS component | systemd unit |
|---|---|---|
| 53    | DNS Forwarder (Spartan) | `dcos-spartan.service` |
| 80    | Admin Router Master (HTTP) | `dcos-adminrouter.service` |
| 443   | Admin Router Master (HTTPS) | `dcos-adminrouter.service` |
| 1337  | DC/OS Secrets |  `dcos-secrets.service` (Enterprise DC/OS Only) | <!-- Enterprise -->
| 2181  | ZooKeeper | `dcos-exhibitor.service` |
| 3888  | Exhibitor, or ZooKeeper and Exhibitor | `dcos-exhibitor.service` |
| 5050  | Mesos Master | `dcos-mesos-master.service` |
| 7070  | DC/OS Package Manager (Cosmos) | `dcos-cosmos.service` |
| 8080  | Marathon | `dcos-marathon.service` |
| 8101  | DC/OS Identity and Access Manager | `dcos-bouncer.service` (Enterprise DC/OS Only) | <!-- Enterprise -->
| 8123  | Mesos DNS | `dcos-mesos-dns.service` |
| 8181  | Exhibitor and ZooKeeper | `dcos-exhibitor.service` |
| 8200  | Vault | `dcos-vault.service` (Enterprise DC/OS Only) |  <!-- Enterprise -->
| 8443  | Marathon SSL | `dcos-marathon.service` |
| 8888  | DC/OS Certificate Authority | `dcos-ca.service` (Enterprise DC/OS Only) | <!-- Enterprise -->
| 9090 | DC/OS Jobs (Metronome) | `dcos-metronome.service`|
| 9443 | DC/OS Jobs (Metronome) SSL | `dcos-metronome.service`|
| 9990  | DC/OS Package Manager (Cosmos) | `dcos-cosmos.service` |
| 15055 | DC/OS History | `dcos-history-service.service` |
| 15101 | Marathon libprocess | `dcos-marathon.service` |
| 15201 | DC/OS Jobs (Metronome) libprocess | `dcos-metronome.service`|
| 62500 | DC/OS Network Metrics | `dcos-networking_api.service` (Enterprise DC/OS Only) | <!-- Enterprise -->
| Ephemeral | DC/OS Component Package Manager (Pkgpanda) | `dcos-pkgpanda-api.service` |

### UDP

| Port | DC/OS component | systemd unit |
|---|---|---|
| 53 | DNS Forwarder (Spartan) | `dcos-spartan.service` |

## Agent

### TCP

| Port | DC/OS component | systemd unit |
|---|---|---|
| 5051  | Mesos Agent | `dcos-mesos-slave.service` |
| 61001 | Admin Router Agent (HTTP) | `dcos-adminrouter-agent` |
| 61002 | Admin Router Agent (HTTPS) | `dcos-3dt.service` |
| 1025-2180 | Default advertised port ranges (for Marathon health checks) | |
| 2182-3887 | Default advertised port ranges (for Marathon health checks) | |
| 3889-5049 | Default advertised port ranges (for Marathon health checks) | |
| 5052-8079 | Default advertised port ranges (for Marathon health checks) | |
| 8082-8180 | Default advertised port ranges (for Marathon health checks) | |
| 8182-32000 | Default advertised port ranges (for Marathon health checks) | |

