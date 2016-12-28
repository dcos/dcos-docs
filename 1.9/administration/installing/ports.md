---
post_title: DC/OS Ports
menu_order: 4
---

The following is a list of ports used by internal DC/OS [components](/docs/1.9/overview/components/), and their corresponding systemd unit.

## All roles

### TCP

|Port   |systemd unit   | 
|---|---|
|  61003 | REX-Ray (`dcos-rexray.service`) (default) |  
|  61053 |  Mesos DNS (`dcos-mesos-dns.service`) |
|  61420 | Erlang Port Mapping Daemon (`dcos-epmd.service`)  |
|61421 | Layer 4 Load Balancer (`dcos-minuteman.service`)  |  
|62053 |  DNS Dispatcher (`dcos-spartan.service`) |  
|62080 |  Virtual Network Service (`dcos-navstar.service`)  |  
|62501 |  DNS Dispatcher (`dcos-spartan.service`)  |  
|62502 | Virtual Network Service (`dcos-navstar.service`)  |  
|62503 | Layer 4 Load Balancer (`dcos-minuteman.service`)  |  

### UDP

|Port   |systemd unit   | 
|---|---|
|  62053 |  DNS Dispatcher (`dcos-spartan.service`) |
|  64000 |  DCOS Overlay |

## Master

### TCP

|Port   |systemd unit   | 
|---|---|
|  53 |  DNS Dispatcher (`dcos-spartan.service`) |  
|  80 |  Admin Router Service (`dcos-adminrouter.service`) |  
|  443 |  Admin Router Service (`dcos-adminrouter.service`) |  
|  1050 |  Diagnostics (`dcos-3dt.service`) |  
| 1801  |  OAuth (`dcos-oauth`) |  
|  2181 |  Exhibitor (`dcos-exhibitor.service`) |  
|  5050 |  Mesos Master (`dcos-mesos-master.service`) |  
|  7070 |  Package service (`dcos-cosmos.service`) |  
|  8080 |  Marathon (`dcos-marathon.service`) |  
|  8123 |  Mesos DNS (`dcos-mesos-dns.service`) |  
|  8181 |  Exhibitor (`dcos-exhibitor.service`) |  
|  9990 | Package service (`dcos-cosmos.service`) |  
|  15055 | History Service (`dcos-history-service.service`) |  

### UDP

|Port   |systemd unit   | 
|---|---|
|  53 |  DNS Dispatcher (`dcos-spartan.service`)  |

## Agent

### TCP

|Port   |systemd unit   | 
|---|---|
|  5051 |  Mesos Agent (`dcos-mesos-slave.service`) |  
|  61001 |  Admin Router Agent (`dcos-adminrouter-agent`) |  
  
