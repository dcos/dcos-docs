---
post_title: "An Introduction to DC/OS Components"
nav_title: Components
---

```
ip-10-0-6-126 system # ls dcos.target.wants/
dcos-adminrouter-reload.service  dcos-exhibitor.service        dcos-marathon.service
dcos-adminrouter-reload.timer    dcos-gen-resolvconf.service   dcos-mesos-dns.service
dcos-adminrouter.service         dcos-gen-resolvconf.timer     dcos-mesos-master.service
dcos-cluster-id.service          dcos-history-service.service  dcos-minuteman.service
dcos-cosmos.service              dcos-keepalived.service       dcos-signal.service
dcos-ddt.service                 dcos-logrotate.service        dcos-signal.timer
dcos-epmd.service                dcos-logrotate.timer          dcos-spartan.service
```

What are the core DC/OS components?
<!--more-->
By components, we're referring to the services which work together to bring the DC/OS ecosystem alive. The core component is of course [Apache Mesos](http://mesos.apache.org/) but the DC/OS is actually made of of *many* more services than just this.

If you log into any host in the DC/OS cluster, you can view the currently running services by inspecting `/etc/systemd/system/dcos.target.wants/`.

## Admin Router Service
Admin router is our core internal load balancer. Admin router is a customized [Nginx](https://www.nginx.com/resources/wiki/) which allows us to proxy all the internal services on :80.

Without admin router being up, you could not access the DC/OS UI. Admin router is a core component of the DC/OS ecosystem.

```
[Unit]
Description=Admin Router: A high performance web server and a reverse proxy server
After=dcos-gen-resolvconf.service
ConditionPathExists=/var/lib/dcos/cluster-id

[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
Type=forking
PIDFile=/opt/mesosphere/packages/adminrouter--1ec9969794ff4fcbde235d029652679b6a51e51e/nginx/logs/nginx.pid
PrivateDevices=yes
StandardOutput=journal
StandardError=journal
ExecStartPre=/bin/ping -c1 ready.spartan
ExecStartPre=/bin/ping -c1 marathon.mesos
ExecStartPre=/bin/ping -c1 leader.mesos
ExecStart=/opt/mesosphere/packages/adminrouter--1ec9969794ff4fcbde235d029652679b6a51e51e/nginx/sbin/nginx
ExecReload=/usr/bin/kill -HUP $MAINPID
KillSignal=SIGQUIT
KillMode=mixed
```

## Cluster ID Service
The cluster-id service allows us to generate a UUID for each cluster. We use this ID to track cluster health remotely (if enabled). This remote tracking allows our support team to better assist our customers.

The cluster-id service runs an internal tool called `zk-value-consensus` which uses our internal ZooKeeper to generate a UUID that all the masters agree on. Once an agreement is reached, the ID is written to disk at `/var/lib/dcos/cluster-id`. We write it to `/var/lib/dcos` so the ID is ensured to persist cluster upgrades without changing.

```
[Unit]
Description=Cluster ID: Generates anonymous DC/OS Cluster ID
[Service]
Type=oneshot
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/bin/mkdir -p /var/lib/dcos
ExecStart=/bin/sh -c "/opt/mesosphere/bin/python -c 'import uuid; print(uuid.uuid4())'  | /opt/mesosphere/bin/zk-value-consensus /cluster-id > /var/lib/dcos/cluster-id"
```

## Cosmos Service
The Cosmos service is our internal packaging API service. You access this service everytime you run `dcos package install...` from the CLI. This API allows us to deploy DC/OS packages from the DC/OS universe to your DC/OS cluster.

```
[Unit]
Description=Package Service: DC/OS Packaging API
After=dcos-mesos-master.service
After=dcos-gen-resolvconf.service

[Service]
Restart=always
StartLimitInterval=0
RestartSec=15
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/bin/ping -c1 ready.spartan
ExecStartPre=/opt/mesosphere/bin/exhibitor_wait.py
## CoreOS
ExecStartPre=-/usr/bin/mkdir -p /var/lib/cosmos
## Ubuntu
ExecStartPre=-/bin/mkdir -p /var/lib/cosmos
ExecStart=/opt/mesosphere/bin/java -Xmx2G -jar "/opt/mesosphere/packages/cosmos--e5b42c8cd703c1eb7b83868b1
```

## Diagnostics (DDT) Service
The diagnostics service (also known as 3DT or dcos-ddt.service, no relationship to the pesticide!) is our diagnostics utility for DC/OS systemd components. This service runs on every host, tracking the internal state of the systemd unit. The service runs in two modes, with or without the `-pull` argument. If running on a master host, it executes `/opt/mesosphere/bin/3dt -pull` which queries Mesos-DNS for a list of known masters in the cluster, then queries a master (usually itself) `:5050/statesummary` and gets a list of slaves.

From this complete list of cluster hosts, it queries all 3DT health endpoints (`:1050/system/health/v1/health`). This endpoint returns health state for the DC/OS systemd units on that host. The master 3DT processes, along with doing this aggregation also expose `/system/health/v1/` endpoints to feed this data by `unit` or `node` IP to the DC/OS user interface.

```
[Unit]
Description=Diagnostics: DC/OS Distributed Diagnostics Tool Master API and Aggregation Service
[Service]
EnvironmentFile=/opt/mesosphere/environment
Restart=always
StartLimitInterval=0
RestartSec=5
ExecStart=/opt/mesosphere/bin/3dt -pull
```

## Erlang Port Mapper (EPMD) Service
The erlang port mapper is designed to support our internal layer 4 load balancer we call `minuteman`.

```
[Unit]
Description=Erlang Port Mapping Daemon: DC/OS Erlang Port Mapping Daemon

[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
WorkingDirectory=/opt/mesosphere/packages/erlang--8035129e271fc5b27124e3e8e3d7b63395c5ef31
EnvironmentFile=/opt/mesosphere/environment
ExecStart=/opt/mesosphere/packages/erlang--8035129e271fc5b27124e3e8e3d7b63395c5ef31/bin/epmd -port 61420
Environment=HOME=/opt/mesosphere
```

## Exhibitor Service
Exhibitor is a project from [netflix](https://github.com/Netflix/exhibitor) that allows us to manage and automate the deployment of ZooKeeper.

```
[Unit]
Description=Exhibitor: ZooKeeper Supervisor Service
After=network-online.target
[Service]
StandardOutput=journal
StandardError=journal
Restart=always
StartLimitInterval=0
RestartSec=5
MountFlags=private
RuntimeDirectory=dcos_exhibitor
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=/opt/mesosphere/etc/dns_config
EnvironmentFile=/opt/mesosphere/etc/exhibitor
# run in new mount namespace to create custom resolv.conf
ExecStart=/usr/bin/unshare --mount /opt/mesosphere/packages/exhibitor--8b9dac1cdd3a5ea25ae5a2e66f18000ad72c3f26/usr/exhibitor/start_exhibitor.py
```

## Generate resolv.conf (gen-resolvconf) Serivce
The gen-resolvconf service allows us to dynamically provision `/etc/resolv.conf` for your cluster hosts.

```
[Unit]
Description=Generate Resolv.conf: Update systemd-resolved for Mesos-DNS
After=dcos-spartan.service

[Service]
Type=oneshot
StandardOutput=journal
StandardError=journal
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=/opt/mesosphere/etc/dns_config
EnvironmentFile=/opt/mesosphere/etc/dns_search_config
EnvironmentFile=-/opt/mesosphere/etc/dns_config_master
ExecStart=/opt/mesosphere/bin/gen_resolvconf.py /etc/resolv.conf
```

## History Service
The history service provides a simple service for storing stateful information about your DC/OS cluster. This data is stored on disk for 24 hours. Along with storing this data, the history service also exposes a HTTP API for the DC/OS user interface to query. All DC/OS cluster stats which involve memory, CPU and disk usage are driven by this service (including the donuts!).

```
[Unit]
Description=Mesos History: DC/OS Resource Metrics History Service/API
After=dcos-mesos-master.service
[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
EnvironmentFile=/opt/mesosphere/environment
Environment=HISTORY_BUFFER_DIR=/var/lib/mesosphere/dcos/history-service
ExecStart=/opt/mesosphere/bin/dcos-history
```

## Logrotate Service
This service does what you think it does: ensures DC/OS services don't blow up cluster hosts with to much log data on disk.

```
[Unit]
Description=Logrotate: Rotate various logs on the system
[Service]
Type=simple
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/usr/bin/mkdir -p /var/log/mesos/archive
ExecStart=/opt/mesosphere/packages/logrotate--52aee4fc02aab1082880abd4411d7825148ea024/bin/logrotate /opt/mesosphere/packages/logrotate--52aee4fc02aab1082880abd4411d7825148ea024/etc/logrotate.conf
```

## Marathon Service
Marathon shouldn't need any introduction, it's the distributed init system for the DC/OS cluster. We run an internal marathon for packages and other DC/OS services.

```
[Unit]
Description=Marathon: DC/OS Init System
After=dcos-mesos-master.service
[Service]
Restart=always
StartLimitInterval=0
RestartSec=15
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=-/opt/mesosphere/environment.ip.marathon
ExecStartPre=/opt/mesosphere/bin/exhibitor_wait.py
ExecStartPre=/bin/bash -c 'echo "HOST_IP=$($MESOS_IP_DISCOVERY_COMMAND)" > /opt/mesosphere/environment.ip.marathon'
ExecStartPre=/bin/bash -c 'echo "MARATHON_HOSTNAME=$($MESOS_IP_DISCOVERY_COMMAND)" >> /opt/mesosphere/environment.ip.marathon'
ExecStartPre=/bin/bash -c 'echo "LIBPROCESS_IP=$($MESOS_IP_DISCOVERY_COMMAND)" >> /opt/mesosphere/environment.ip.marathon'
ExecStart=/opt/mesosphere/bin/java -Xmx2G -jar "/opt/mesosphere/packages/marathon--fbc1c97b180500cd4ec6d26520c1db9e105879f8/usr/marathon.jar" --zk zk://localhost:2181/marathon --master zk://localhost:2181/mesos --hostname "$MARATHON_HOSTNAME" --default_accepted_resource_roles "*" --mesos_role "slave_public" --max_tasks_per_offer 100 --task_launch_timeout 86400000 --decline_offer_duration 300000 --revive_offers_for_new_apps --zk_compression --mesos_leader_ui_url "/mesos" --enable_features "vips,task_killing" --mesos_authentication_principal "marathon"
```

## Mesos-DNS Service
Mesos-DNS is the internal DNS service for the DC/OS cluster. Mesos-DNS provides the namespace `$service.mesos` to all cluster hosts. For example, you can login to your leading mesos master with `ssh leader.mesos`.

```
[Unit]
Description=Mesos-DNS: DNS based Service Discovery
After=dcos-mesos-master.service
[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
ExecStart=/opt/mesosphere/bin/mesos-dns --config=/opt/mesosphere/etc/mesos-dns.json -logtostderr=true
```

## Minuteman Service
This is our internal layer 4 loadbalancer.

```
[Unit]
Description=Layer 4 Load Balancer: DC/OS Layer 4 Load Balancing Service
After=dcos-gen-resolvconf.service
After=dcos-epmd.service
BindsTo=dcos-epmd.service

[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
WorkingDirectory=/opt/mesosphere/packages/minuteman--841ef0a5edaa8cffedf4946c47929e477a3aef92/minuteman
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/bin/ping -c1 ready.spartan
ExecStartPre=/bin/ping -c1 leader.mesos
ExecStartPre=/usr/bin/env mkdir -p /var/lib/dcos/minuteman/mnesia
ExecStartPre=/usr/bin/env mkdir -p /var/lib/dcos/minuteman/lashup
ExecStart=/opt/mesosphere/packages/minuteman--841ef0a5edaa8cffedf4946c47929e477a3aef92/minuteman/bin/env foreground
Environment=HOME=/opt/mesosphere
```

## Signal Service
The DC/OS signal service queries the diagnostics service `/system/health/v1/report` endpoint on the leading master and sends this data to SegmentIO for use in tracking metrics and customer support.

```
[Unit]
Description=Signal Service: DC/OS Telemetry and Support Utility
After=dcos-mesos-master.service
[Service]
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=-/opt/mesosphere/etc/cfn_signal_metadata
ExecStart=/opt/mesosphere/bin/dcos-signal --write_key=51ybGTeFEFU1xo6u10XMDrr6kATFyRyh
```

## Distributed DNS Proxy
Distributed DNS Proxy is our internal DNS dispatcher. It conforms to RFC5625 as a DNS forwarder for DC/OS cluster services.

```
[Unit]
Description=DNS Dispatcher: An RFC5625 Compliant DNS Forwarder
[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
WorkingDirectory=/opt/mesosphere/active/spartan/spartan
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=/opt/mesosphere/etc/dns_config
EnvironmentFile=/opt/mesosphere/etc/dns_search_config
EnvironmentFile=-/opt/mesosphere/etc/dns_config_master
ExecStartPre=/usr/bin/env modprobe dummy
ExecStartPre=-/usr/bin/env ip link add spartan type dummy
ExecStartPre=/usr/bin/env ip link set spartan up
ExecStartPre=-/usr/bin/env ip addr add 198.51.100.1/32 dev spartan
ExecStartPre=-/usr/bin/env ip addr add 198.51.100.2/32 dev spartan
ExecStartPre=-/usr/bin/env ip addr add 198.51.100.3/32 dev spartan
ExecStart=/opt/mesosphere/active/spartan/spartan/bin/spartan foreground
Environment=HOME=/opt/mesosphere
```
