---
post_title: Components
nav_title: Components
menu_order: 4
---

DC/OS is composed of many open source microservice components meticulously tuned and configured to work together.

![DC/OS Components](/docs/1.9/overview/architecture/img/dcos-components-1.9.png)

From the top, DC/OS is a batteries-included container platform that handles container orchestration, package management, and security.

From the bottom, DC/OS is an operating system built on top of [Apache Mesos](http://mesos.apache.org/) that handles cluster management and software defined networking while simplifying logging and metrics collection.


# Cluster Management

DC/OS provides a way to view and operate a large number of individual machine-level systems as a single cluster-level system. It hides the complexity of Mesos, the distributed systems kernel, with higher level abstractions, interfaces, and tools. Cluster management is the core of that functionality, including the kernel, its dependencies, and its user interfaces.

<div data-role="collapsible">
<h2>Apache Mesos</h2>
<div>
<p><strong>Description:</strong> Mesos manages resources and tasks as a distributed systems kernel. Mesos Master exposes scheduler, executor, and operator interfaces to facilitate cluster management. Mesos Agent manages individual executors, tasks, and resources on each <a href="/docs/1.9/overview/concepts/#dcos-agent-node">DC/OS agent node</a>. Mesos Agent Public is a Mesos Agent configured to run on <a href="/docs/1.9/overview/concepts/#public-agent-node">DC/OS public agent nodes</a>.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-mesos-master.service</code></li>
    <li><code class="nowrap">dcos-mesos-slave.service</code></li>
    <li><code class="nowrap">dcos-mesos-slave-public.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="http://mesos.apache.org/">Documentation</a></li>
    <li><a href="https://github.com/apache/mesos">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Apache Zookeeper</h2>
<div>
<p><strong>Description:</strong> Zookeeper provides consistent, highly available, distributed key-value storage for configuration, synchronization, name registration, and cluster state storage.</p>
<p><strong>System Service(s):</strong> N/A - Zookeeper is supervised by Exhibitor.</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://zookeeper.apache.org/">Documentation</a></li>
    <li><a href="https://github.com/apache/zookeeper">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Exhibitor</h2>
<div>
<p><strong>Description:</strong> Exhibitor supervises Zookeeper and provides a management web interface.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-exhibitor.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/soabase/exhibitor/wiki">Documentation</a></li>
    <li><a href="https://github.com/dcos/exhibitor">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS Installer</h2>
<div>
<p><strong>Description:</strong> The DC/OS Installer (dcos_generate_config.sh) generates install artifacts and installs DC/OS. As part of the install process on each node, the DC/OS Download service downloads the install artifacts from the bootstrap machine and the DC/OS Setup service installs components using the DC/OS Component Package Manager (Pkgpanda).</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-download.service</code></li>
    <li><code class="nowrap">dcos-setup.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="/docs/1.9/administration/installing/">Documentation</a></li>
    <li><a href="https://github.com/dcos/dcos">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS GUI</h2>
<div>
<p><strong>Description:</strong> The DC/OS GUI (web interface) is a browser-based system dashboard and control center.</p>
<p><strong>System Service(s):</strong> N/A - The GUI is served by Admin Router.</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="/docs/1.9/usage/webinterface/">Documentation</a></li>
    <li><a href="https://github.com/dcos/dcos-ui">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS CLI</h2>
<div>
<p><strong>Description:</strong> The DC/OS CLI is a terminal-based remote client.</p>
<p><strong>System Service(s):</strong> N/A - The CLI is a user downloadable binary.</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="/docs/1.9/usage/cli/">Documentation</a></li>
    <li><a href="https://github.com/dcos/dcos-cli">Source</a></li>
  </ul>
</p>
</div>
</div>


# Container Orchestration

Container orchestration is the continuous, automated scheduling, coordination, and management of containerized processes and the resources they consume.

DC/OS includes built-in orchestration of the most commonly used high level container-based abstractions: jobs and services. Many use cases are handled directly by these basic abstractions, but they also enable the deployment of custom schedulers for tasks that require more flexible programmatic lifecycle management automation.

<div data-role="collapsible">
<h2>Marathon</h2>
<div>
<p><strong>Description:</strong> Marathon orchestrates long-lived containerized services (apps and pods).</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-marathon.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://mesosphere.github.io/marathon/">Documentation</a></li>
    <li><a href="https://github.com/mesosphere/marathon">Source</a></li>
  </ul>
</p>
</div>
</div>

<a name="metronome"></a>
<a name="dcos-jobs"></a>
<div data-role="collapsible">
<h2>DC/OS Jobs (Metronome)</h2>
<div>
<p><strong>Description:</strong> DC/OS Jobs (Metronome) orchestrates short-lived, scheduled or immediate, containerized jobs.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-metronome.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="/docs/1.9/usage/jobs/">Documentation</a></li>
    <li><a href="https://github.com/dcos/metronome">Source</a></li>
  </ul>
</p>
</div>
</div>


# Container Runtimes

Container runtimes execute and manage machine level processes in isolated operating system level environments.

DC/OS supports multiple container runtimes using [Mesos' containerizer abstraction](http://mesos.apache.org/documentation/latest/containerizer/).

<div data-role="collapsible">
<h2>Universal Container Runtime</h2>
<div>
<p><strong>Description:</strong> Universal Container Runtime (Mesos Containerizer) is a logical component built-in to the Mesos Agent, not technically a separate process. It containerizes Mesos tasks with configurable isolators. Universal Container Runtime supports multiple image formats, including Docker images without using Docker Engine.</p>
<p><strong>System Service(s):</strong> N/A - Universal Container Runtime is part of Mesos Agent.</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="http://mesos.apache.org/documentation/latest/mesos-containerizer/">Mesos Containerizer Documentation</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Docker Engine</h2>
<div>
<p><strong>Description:</strong> Docker Engine is not installed by the DC/OS Installer, but rather is a system dependency that runs on each node. Mesos Agent also includes a separate logical component called Docker Containerizer which delegates the containerization of Mesos task to Docker Engine.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">docker.service</code> - Docker Engine is not installed by the DC/OS installer.</li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="http://mesos.apache.org/documentation/latest/docker-containerizer/">Docker Containerizer Documentation</a></li>
    <li><a href="https://docs.docker.com/engine/">Docker Engine Documentation</a></li>
    <li><a href="https://github.com/docker/docker/">Docker Engine Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Docker GC</h2>
<div>
<p><strong><em>NEW IN 1.9.0</em></strong></p>
<p><strong>Description:</strong> Docker GC periodically garbage collects Docker containers and images.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-docker-gc.service</code></li>
    <li><code class="nowrap">dcos-docker-gc.timer</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/spotify/docker-gc">Source</a></li>
  </ul>
</p>
</div>
</div>


# Logging and Metrics

No software runs perfectly, especially not the first time. Distribute tasks across a cluster and the normal patterns of analyzing and debugging these services become tedious and painful. So DC/OS includes several components to help ease the pain of debugging distributed systems by aggregating, caching, and streaming logs, metrics, and cluster state metadata.

<div data-role="collapsible">
<h2>DC/OS Diagnostics (3DT)</h2>
<div>
<p><strong>Description:</strong> DC/OS Diagnostics (3DT) aggregates and exposes component health. DC/OS Diagnostics is also known as DC/OS Distributed Diagnostics Tool (3DT).</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-3dt.service</code></li>
    <li><code class="nowrap">dcos-3dt.socket</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/3dt">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS Log</h2>
<div>
<p><strong><em>NEW IN 1.9.0</em></strong></p>
<p><strong>Description:</strong> The DC/OS Log service exposes node, component, and container (task) logs.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-log-master.service</code></li>
    <li><code class="nowrap">dcos-log-master.socket</code></li>
    <li><code class="nowrap">dcos-log-agent.service</code></li>
    <li><code class="nowrap">dcos-log-agent.socket</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos-log">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Logrotate</h2>
<div>
<p><strong>Description:</strong> Logrotate manages rotation, compression, and deletion of historical log files.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-logrotate-master.service</code></li>
    <li><code class="nowrap">dcos-logrotate-master.timer</code></li>
    <li><code class="nowrap">dcos-logrotate-agent.service</code></li>
    <li><code class="nowrap">dcos-logrotate-agent.timer</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="http://www.linuxcommand.org/man_pages/logrotate8.html">Documentation</a></li>
    <li><a href="https://github.com/logrotate/logrotate">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS Metrics</h2>
<div>
<p><strong><em>NEW IN 1.9.0</em></strong></p>
<p><strong>Description:</strong> The DC/OS Metrics service exposes node, container, and application metrics.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-metrics-master.service</code></li>
    <li><code class="nowrap">dcos-metrics-master.socket</code></li>
    <li><code class="nowrap">dcos-metrics-agent.service</code></li>
    <li><code class="nowrap">dcos-metrics-agent.socket</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos-metrics">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS Signal</h2>
<div>
<p><strong>Description:</strong> The DC/OS Signal service reports cluster telemetry and analytics to help improve DC/OS. Administrators can <a href="/docs/1.9/administration/installing/opt-out/#telemetry">opt-out of telemetry</a> at install time.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-signal.service</code></li>
    <li><code class="nowrap">dcos-signal.timer</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos-signal">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>DC/OS History</h2>
<div>
<p><strong>Description:</strong> The DC/OS History service caches and exposes historical system state to facilitate cluster usage statistics in the GUI.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-history.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos/tree/master/packages/dcos-history/extra">Source</a></li>
  </ul>
</p>
</div>
</div>


# Networking

In a world where machines are are given numbers instead of names, tasks are scheduled automatically, dependencies are declaratively defined, and services run in distributed sets, network administration also needs to be elevated from plugging in cables to configuring software-defined networks. To accomplish this, DC/OS includes a fleet of networking components for routing, proxying, name resolution, virtual IPs, load balancing, and distributed reconfiguration.

<div data-role="collapsible">
<h2>Admin Router</h2>
<div>
<p><strong>Description:</strong> Admin Router exposes a unified control plane proxy for components and services using <a href="https://www.nginx.com/">NGINX</a>. Admin Router Agent proxies node-specific health, logs, metrics, and package management internal endpoints.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-adminrouter.service</code></li>
    <li><code class="nowrap">dcos-adminrouter-reload.service</code></li>
    <li><code class="nowrap">dcos-adminrouter-reload.timer</code></li>
    <li><code class="nowrap">dcos-adminrouter-agent.service</code></li>
    <li><code class="nowrap">dcos-adminrouter-agent-reload.service</code></li>
    <li><code class="nowrap">dcos-adminrouter-agent-reload.timer</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/adminrouter">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Mesos DNS</h2>
<div>
<p><strong>Description:</strong> Mesos DNS provides domain name based service discovery within the cluster.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-mesos-dns.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="http://mesosphere.github.io/mesos-dns/">Documentation</a></li>
    <li><a href="https://github.com/mesosphere/mesos-dns">Source</a></li>
  </ul>
</p>
</div>
</div>

<a name="spartan"></a>
<a name="dns-forwarder"></a>
<div data-role="collapsible">
<h2>DNS Forwarder (Spartan)</h2>
<div>
<p><strong>Description:</strong> DNS Forwarder (Spartan) forwards DNS requests to multiple DNS servers. Spartan Watchdog restarts Spartan when it is unhealthy.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-spartan.service</code></li>
    <li><code class="nowrap">dcos-spartan-watchdog.service</code></li>
    <li><code class="nowrap">dcos-spartan-watchdog.timer</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/spartan">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Generate resolv.conf</h2>
<div>
<p><strong>Description:</strong> Generate resolv.conf configures network name resolution by updating <code class="nowrap">/etc/resolv.conf</code> to facilitate DC/OS's software defined networking.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-gen-resolvconf.service</code></li>
    <li><code class="nowrap">dcos-gen-resolvconf.timer</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos/blob/master/packages/spartan/extra/gen_resolvconf.py">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Minuteman</h2>
<div>
<p><strong>Description:</strong> Minuteman provides distributed <a href="https://en.wikipedia.org/wiki/Transport_layer">Layer 4</a> virtual IP load balancing.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-minuteman.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="/docs/1.9/usage/service-discovery/load-balancing-vips/">Documentation</a></li>
    <li><a href="https://github.com/dcos/minuteman">Source</a></li>
  </ul>
</p>
</div>
</div>

<div data-role="collapsible">
<h2>Navstar</h2>
<div>
<p><strong>Description:</strong> Navstar orchestrates virtual overlay networks using <a href="https://en.wikipedia.org/wiki/Virtual_Extensible_LAN">VXLAN</a>.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-navstar.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/navstar">Source</a></li>
  </ul>
</p>
</div>
</div>

<a name="epmd"></a>
<a name="erlang-port-mapping-daemon"></a>
<div data-role="collapsible">
<h2>Erlang Port Mapping Daemon (EPMD)</h2>
<div>
<p><strong>Description:</strong> Erlang Port Mapping Daemon (EPMD) facilitates communication between distributed Erlang programs.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-epmd.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/erlang/epmd">Source</a></li>
  </ul>
</p>
</div>
</div>


# Package Management

Just as machine operating systems need package management to install, upgrade, configure, and remove individual applications and services, a datacenter operating system needs package management to do the same for distributed services. In DC/OS there are two levels of package management: machine-level for components; and cluster-level for user services.

<a name="cosmos"></a>
<a name="dcos-package-manager"></a>
<div data-role="collapsible">
<h2>DC/OS Package Manager (Cosmos)</h2>
<div>
<p><strong>Description:</strong> DC/OS Package Manager (Cosmos) installs and manages DC/OS packages from <a href="/docs/1.9/usage/repo/">DC/OS package repositories</a>, such as the <a href="https://github.com/mesosphere/universe">Mesosphere Universe</a>.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-cosmos.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/cosmos">Source</a></li>
  </ul>
</p>
</div>
</div>

<a name="pkgpanda"></a>
<a name="dcos-component-package-manager"></a>
<div data-role="collapsible">
<h2>DC/OS Component Package Manager (Pkgpanda)</h2>
<div>
<p><strong>Description:</strong> DC/OS Component Package Manager (Pkgpanda) installs and manages DC/OS components.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-pkgpanda-api.service</code></li>
    <li><code class="nowrap">dcos-pkgpanda-api.socket</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos/tree/master/pkgpanda">Source</a></li>
  </ul>
</p>
</div>
</div>


# IAM and Security

Identity management in DC/OS is delegated to external identity providers, taking advantage of existing infrastructure to reduce the cost and time to market. Security is provided via OpenID Connect authentication and enforced at the edge by Admin Router's reverse proxy.

<div data-role="collapsible">
<h2>DC/OS Authentication</h2>
<div>
<p><strong>Description:</strong> The DC/OS Authentication (OAuth) service authenticates DC/OS users using [OpenID Connect](http://openid.net/connect/) and [Auth0](https://auth0.com/).</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-oauth.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="https://github.com/dcos/dcos-oauth">Source</a></li>
  </ul>
</p>
</div>
</div>


# Storage

DC/OS provides multiple different ways to provision and allocate disk space and volumes to tasks. One of those methods, external persistent volumes, is managed by its own component.

<div data-role="collapsible">
<h2>REX-Ray</h2>
<div>
<p><strong>Description:</strong> REX-Ray orchestrates provisioning, attachment, and mounting of external persistent volumes.</p>
<p>
  <strong>System Service(s):</strong>
  <ul>
    <li><code class="nowrap">dcos-rexray.service</code></li>
  </ul>
</p>
<p>
  <strong>See Also:</strong>
  <ul>
    <li><a href="http://rexray.readthedocs.io/">Documentation</a></li>
    <li><a href="https://github.com/codedellemc/rexray">Source</a></li>
  </ul>
</p>
</div>
</div>


# Legacy Component Changes

The **Cluster ID service** was removed in DC/OS 1.9.0. The universally unique identifier (UUID) for each cluster is now generated by the DC/OS Setup service.

The **Mesos Persistent Volume Discovery service** was removed in DC/OS 1.9.0. Detection of [mounted disk resources](/docs/1.9/administration/storage/mount-disk-resources/) is now handled by the DC/OS Setup service.


# Sockets and Timers

Several components are configured to use [systemd sockets](https://www.freedesktop.org/software/systemd/man/systemd.socket.html) which allows them to be started on-demand when a request comes in, rather than running continuously and consuming resources unnecessarily. While these sockets are separate [systemd units](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) they are not considered separate components.

Several components are configured to use [systemd timers](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) which allows them to be periodically executed or restarted. Periodic execution avoids continuous execution and consuming resources unnecessarily. Periodic restarting allows for picking up new configurations from downstream dependencies, like time-based DNS cache expiration. While these timers are separate [systemd units](https://www.freedesktop.org/software/systemd/man/systemd.unit.html) they are not considered separate components.


# Component Installation

DC/OS components are installed, upgraded, and managed by [DC/OS Component Package Manager (Pkgpanda)](https://github.com/dcos/dcos/tree/master/pkgpanda), a package manager for systemd units.

To see the full list of packages managed by the DC/OS installer, see the [packages directory of the DC/OS source repository](https://github.com/dcos/dcos/tree/master/packages).


# Systemd Services

Most DC/OS components run as [systemd services](/docs/1.9/overview/concepts/#systemd-service) on the DC/OS nodes.

To see a list of the systemd components running on any particular node, list the contents of the `/etc/systemd/system/dcos.target.wants/` directory or execute `systemctl | grep dcos-` to see their current status.

## Master Node

```
[vagrant@m1 ~]$ ls /etc/systemd/system/dcos.target.wants/
dcos-3dt.service                 dcos-mesos-dns.service
dcos-adminrouter-reload.service  dcos-mesos-master.service
dcos-adminrouter-reload.timer    dcos-metrics-master.service
dcos-adminrouter.service         dcos-metrics-master.socket
dcos-cosmos.service              dcos-metronome.service
dcos-epmd.service                dcos-navstar.service
dcos-exhibitor.service           dcos-oauth.service
dcos-gen-resolvconf.service      dcos-pkgpanda-api.service
dcos-gen-resolvconf.timer        dcos-pkgpanda-api.socket
dcos-history.service             dcos-signal.service
dcos-log-master.service          dcos-signal.timer
dcos-log-master.socket           dcos-spartan.service
dcos-logrotate-master.service    dcos-spartan-watchdog.service
dcos-logrotate-master.timer      dcos-spartan-watchdog.timer
dcos-marathon.service
```

## Private Agent Node

```
[vagrant@a1 ~]$ ls /etc/systemd/system/dcos.target.wants/
dcos-3dt.service                       dcos-logrotate-agent.timer
dcos-3dt.socket                        dcos-mesos-slave.service
dcos-adminrouter-agent-reload.service  dcos-metrics-agent.service
dcos-adminrouter-agent-reload.timer    dcos-metrics-agent.socket
dcos-adminrouter-agent.service         dcos-navstar.service
dcos-docker-gc.service                 dcos-pkgpanda-api.service
dcos-docker-gc.timer                   dcos-pkgpanda-api.socket
dcos-epmd.service                      dcos-rexray.service
dcos-gen-resolvconf.service            dcos-signal.timer
dcos-gen-resolvconf.timer              dcos-spartan.service
dcos-log-agent.service                 dcos-spartan-watchdog.service
dcos-log-agent.socket                  dcos-spartan-watchdog.timer
dcos-logrotate-agent.service
```

## Public Agent Node

```
[vagrant@p1 ~]$ ls /etc/systemd/system/dcos.target.wants/
dcos-3dt.service                       dcos-logrotate-agent.timer
dcos-3dt.socket                        dcos-mesos-slave-public.service
dcos-adminrouter-agent-reload.service  dcos-metrics-agent.service
dcos-adminrouter-agent-reload.timer    dcos-metrics-agent.socket
dcos-adminrouter-agent.service         dcos-navstar.service
dcos-docker-gc.service                 dcos-pkgpanda-api.service
dcos-docker-gc.timer                   dcos-pkgpanda-api.socket
dcos-epmd.service                      dcos-rexray.service
dcos-gen-resolvconf.service            dcos-signal.timer
dcos-gen-resolvconf.timer              dcos-spartan.service
dcos-log-agent.service                 dcos-spartan-watchdog.service
dcos-log-agent.socket                  dcos-spartan-watchdog.timer
dcos-logrotate-agent.service
```
