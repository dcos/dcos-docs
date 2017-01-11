---
post_title: Components
nav_title: Components
menu_order: 4
---

What are the core DC/OS components?
<!--more-->
By components, we're referring to the services which work together to bring the DC/OS ecosystem alive. The core component is of course [Apache Mesos](http://mesos.apache.org/) but the DC/OS is actually made of of *many* more services than just this.

If you log into any host in the DC/OS cluster, you can view the currently running services by inspecting `/etc/systemd/system/dcos.target.wants/`.

```
ip-10-0-6-126 system # ls dcos.target.wants/
dcos-adminrouter-reload.service  dcos-exhibitor.service        dcos-marathon.service
dcos-adminrouter-reload.timer    dcos-gen-resolvconf.service   dcos-mesos-dns.service
dcos-adminrouter.service         dcos-gen-resolvconf.timer     dcos-mesos-master.service
dcos-cluster-id.service          dcos-history-service.service  dcos-minuteman.service
dcos-cosmos.service              dcos-signal.service           dcos-ddt.service
dcos-logrotate.service           dcos-signal.timer             dcos-epmd.service
dcos-logrotate.timer             dcos-spartan.service
```

## Admin Router Service
Admin Router is our core internal load balancer. Admin Router is a customized [Nginx](https://www.nginx.com/resources/wiki/) which allows us to proxy all the internal services on :80.

Without Admin Router being up, you could not access the DC/OS UI. Admin Router is a core component of the DC/OS ecosystem.


## Cluster ID Service
The cluster-id service allows us to generate a UUID for each cluster. We use this ID to track cluster health remotely (if enabled). This remote tracking allows our support team to better assist our customers.

The cluster-id service runs an internal tool called `zk-value-consensus` which uses our internal ZooKeeper to generate a UUID that all the masters agree on. Once an agreement is reached, the ID is written to disk at `/var/lib/dcos/cluster-id`. We write it to `/var/lib/dcos` so the ID is ensured to persist cluster upgrades without changing.


## Cosmos Service
The Cosmos service is our internal packaging API service. You access this service everytime you run `dcos package install...` from the CLI. This API allows us to deploy DC/OS packages from the DC/OS universe to your DC/OS cluster.


## Diagnostics (DDT) Service
The diagnostics service (also known as 3DT or dcos-ddt.service, no relationship to the pesticide!) is our diagnostics utility for DC/OS systemd components. This service runs on every host, tracking the internal state of the systemd unit. The service runs in two modes, with or without the `-pull` argument. If running on a master host, it executes `/opt/mesosphere/bin/3dt -pull` which queries Mesos-DNS for a list of known masters in the cluster, then queries a master (usually itself) `:5050/statesummary` and gets a list of agents.

From this complete list of cluster hosts, it queries all 3DT health endpoints (`:1050/system/health/v1/health`). This endpoint returns health state for the DC/OS systemd units on that host. The master 3DT processes, along with doing this aggregation also expose `/system/health/v1/` endpoints to feed this data by `unit` or `node` IP to the DC/OS user interface.


## Distributed DNS Proxy
Distributed DNS Proxy is our internal DNS dispatcher. It conforms to RFC5625 as a DNS forwarder for DC/OS cluster services.

## Downloads Service
This component (`dcos-download.service`) downloads the DC/OS installation tarball on first boot.

## Erlang Port Mapper (EPMD) Service
The erlang port mapper is designed to support our internal layer 4 load balancer we call `minuteman`.


## Exhibitor Service
Exhibitor is a project from [netflix](https://github.com/Netflix/exhibitor) that allows us to manage and automate the deployment of ZooKeeper.


## Generate resolv.conf (gen-resolvconf) Service
The gen-resolvconf service allows us to dynamically provision `/etc/resolv.conf` for your cluster hosts.


## History Service
The history service provides a simple service for storing stateful information about your DC/OS cluster. This data is stored on disk for 24 hours. Along with storing this data, the history service also exposes a HTTP API for the DC/OS user interface to query. All DC/OS cluster stats which involve memory, CPU and disk usage are driven by this service (including the donuts!).


## Logrotate Service
This service does what you think it does: ensures DC/OS services don't blow up cluster hosts with too much log data on disk.


## Marathon Service
Marathon shouldn't need any introduction, it's the distributed init system for the DC/OS cluster. We run an internal Marathon for packages and other DC/OS services.


## Mesos-DNS Service
Mesos-DNS is the internal DNS service for the DC/OS cluster. Mesos-DNS provides the namespace `$service.mesos` to all cluster hosts. For example, you can login to your leading mesos master with `ssh leader.mesos`.


## Minuteman Service
This is our internal layer 4 loadbalancer.


## Signal Service
The DC/OS signal service queries the diagnostics service `/system/health/v1/report` endpoint on the leading master and sends this data to SegmentIO for use in tracking metrics and customer support.
