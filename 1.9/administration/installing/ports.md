---
post_title: DC/OS Ports
menu_order: 4
---

The following is a list of ports used by DC/OS [components](/docs/1.9/overview/architecture/components/) and their corresponding systemd unit.

## All nodes

### TCP

| Port | Component | systemd unit |
|---|---|
| 61003 | REX-Ray | `dcos-rexray.service` |
| 61053 | Mesos DNS | `dcos-mesos-dns.service` |
| 61420 | Erlang Port Mapping Daemon | `dcos-epmd.service` |
| 61421 | Minuteman | `dcos-minuteman.service` |
| 62053 | Spartan | `dcos-spartan.service` |
| 62080 | Navstar | `dcos-navstar.service` |
| 62501 | Spartan | `dcos-spartan.service` |
| 62502 | Navstar | `dcos-navstar.service` |
| 62503 | Minuteman | `dcos-minuteman.service` |

### UDP

| Port | Component | systemd unit |
|---|---|
| 62053 | Spartan | `dcos-spartan.service` |
| 64000 | Navstar | `dcos-navstar.service` |

## Master

### TCP

| Port | Component | systemd unit |
|---|---|
| 53    | Spartan | `dcos-spartan.service` |
| 80    | Admin Router | `dcos-adminrouter.service` |
| 443   | Admin Router | `dcos-adminrouter.service` |
| 1050  | DC/OS Diagnostics | `dcos-3dt.service` |
| 1801  | DC/OS Authentication | `dcos-oauth.service` |
| 2181  | Exhibitor and Zookeeper | `dcos-exhibitor.service` |
| 5050  | Mesos Master | `dcos-mesos-master.service` |
| 7070  | Cosmos | `dcos-cosmos.service` |
| 8080  | Marathon | `dcos-marathon.service` |
| 8123  | Mesos DNS | `dcos-mesos-dns.service` |
| 8181  | Exhibitor and Zookeeper | `dcos-exhibitor.service` |
| 9990  | Cosmos | `dcos-cosmos.service` |
| 15055 | DC/OS History | `dcos-history-service.service` |

### UDP

| Port | Component | systemd unit |
|---|---|
| 53 | Spartan | `dcos-spartan.service` |

## Agent

### TCP

| Port | Component | systemd unit |
|---|---|
| 5051  |  Mesos Agent | `dcos-mesos-slave.service` |
| 61001 |  Admin Router Agent | `dcos-adminrouter-agent` |
