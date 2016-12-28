---
post_title: Components
nav_title: Components
menu_order: 4
---

DC/OS is comprised of many individual open source components that are precisely configured to work together. 

You can log into any host in the DC/OS cluster and view the currently running services by inspecting the `/etc/systemd/system/dcos.target.wants/` directory. 

You can view the DC/OS component details in the <a href="https://github.com/dcos/dcos/">https://github.com/dcos/dcos/</a> repo in the packages directory. 


<table class="table">
  <tr>
    <th>Component</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>Admin Router Agent</td>
    <td>This component (<code>dcos-adminrouter-agent</code>)is a high performance web server and a reverse proxy server that lists all of the agent nodes in your cluster.</td>
  </tr>
  <tr>
    <td>Admin Router Master</td>
    <td>This component is a high performance web server and a reverse proxy server that lists all of the master nodes in your cluster.</td>
  </tr>
  <tr>
    <td>Admin Router Reloader</td>
    <td>This component (`dcos-adminrouter-reload.service`) restarts the Admin Router Nginx server so that it can pick up new DNS resolutions, for example `master.mesos` and `leader.mesos`.</td>
  </tr>
  <tr>
    <td>Admin Router Reloader Timer</td>
    <td>This component (`dcos-adminrouter-reload.timer`) sets the Admin Router Reloader interval at once per hour.</td>
  </tr>
  <tr>
      <td>Admin Router Service</td>
      <td>This component is an open-source Nginx configuration created by Mesosphere that provides central authentication and proxy to DC/OS services within the cluster. The Admin Router service (`dcos-adminrouter.service `) is the core internal load balancer for DC/OS. Admin Router is a customized <a href="https://www.nginx.com/resources/wiki/">Nginx</a> that proxies all of the internal services on port `80`.</td>
    </tr>
  <tr>
    <td>Cluster ID</td>
    <td>The cluster-id service generates a universally unique identifier (UUID) for each cluster. We use this ID to track cluster health remotely (if enabled). This remote tracking allows our support team to better assist our customers.</td>
  </tr>
  <tr>
    <td>Diagnostics</td>
    <td><p>This component (`dcos-3dt.service`) is the diagnostics utility for DC/OS systemd components. This service runs on every host, tracking the internal state of the systemd unit. The service runs in two modes: with or without the `-pull` argument. If running on a master host, it executes `/opt/mesosphere/bin/3dt -pull`, which queries Mesos-DNS for a list of known masters in the cluster, then queries a master (usually itself) `:5050/statesummary` and gets a list of agents.</p><p>From this complete list of cluster hosts, it queries all 3DT health endpoints (`:1050/system/health/v1/health`). This endpoint returns health state for the DC/OS systemd units on that host. The master 3DT processes, along with doing this aggregation, also expose `/system/health/v1/` endpoints to feed this data by `unit` or `node` IP to the DC/OS user interface.</p></td>
  </tr>
  <tr>
    <td>Diagnostics socket</td>
    <td>This component (`dcos-3dt.socket`) is the DC/OS Distributed Diagnostics Tool master API and aggregation socket.</td>
  </tr>
  <tr>
    <td>DNS Dispatcher</td>
    <td>This component (`dcos-spartan.service`) is an RFC5625 Compliant DNS Forwarder. It's job is to dual-dispatch DNS to multiple upstream resolvers, and to route DNS to the upstreams or Mesos DNS, depending on some rules.</td>
  </tr>
  <tr>
    <td>DNS Dispatcher Watchdog</td>
    <td>This component (dcos-spartan-watchdog.service) ensures that the DNS Dispatcher is running and healthy. If the DNS Dispatcher is unhealthy, this watchdog service kills it.</td>
  </tr>
  <tr>
    <td>DNS Dispatcher Watchdog Timer</td>
    <td>This component (`dcos-spartan-watchdog.timer`) wakes up the DNS Dispatcher Watchdog every 5 minutes, to see if DC/OS needs to restart DNS Dispatcher.</td>
  </tr>
  <tr>
    <td>Erlang Port Mapping Daemon</td>
    <td>This component (`dcos-epmd.service`) supports the internal DC/OS layer 4 load balancer that is called <a href="https://github.com/dcos/minuteman">Minuteman</a>.</td>
  </tr>
  <tr>
    <td>Exhibitor</td>
    <td>This component (`dcos-exhibitor.service`) is the Exhibitor supervisor for ZooKeeper. DC/OS uses Exhibitor, a project from <a href="https://github.com/Netflix/exhibitor">Netflix</a>, to manage and automate the deployment of <a href="/docs/1.9/overview/concepts/#exhibitorforzookeeper">ZooKeeper</a>.</td>
  </tr>
  <tr>
    <td>Generate resolv.conf</td>
    <td>This component (`dcos-gen-resolvconf.service`) dynamically provisions `/etc/resolv.conf` so that each cluster host can use Mesos-DNS to resolve task names to the IP and port addresses.</td>
  </tr>
  <tr>
    <td>Generate resolv.conf Timer</td>
    <td>This component (`dcos-gen-resolvconf.timer`) periodically updates the systemd-resolved for Mesos DNS.</td>
  </tr>
  <tr>
    <td>History Service</td>
    <td>This component (`dcos-history.service`) enables the DC/OS UI to display cluster usage statistics and stores the dashboard graph data for the UI. This data is stored on disk for 24 hours. Along with storing this data, the history service also exposes a HTTP API for the DC/OS user interface to query. All DC/OS cluster stats which involve memory, CPU and disk usage are driven by this service.</td>
  </tr>
  <tr>
    <td>Job</td>
    <td>This component (`dcos-metronome.service`) powers the DC/OS Jobs feature. For more information, see the <a href="/docs/1.9/usage/jobs/">documentation</a>.</td>
  </tr>
  <tr>
    <td>Layer 4 Load Balancer</td>
    <td>This component (`dcos-minuteman.service`), also known as <a href="https://github.com/dcos/minuteman">Minuteman</a>, is the DC/OS Layer 4 Load Balancer that enables multi-tier microservices architectures. For more information, see the <a href="/docs/1.9/usage/service-discovery/load-balancing-vips/">documentation</a>.</td>
  </tr>
  <tr>
    <td>Logrotate Mesos Master</td>
    <td>This component (`dcos-logrotate-master.service`) automatically manages compression, removal, and mailing of log files for Mesos master processes. This ensures DC/OS services don't overload cluster hosts with too much log data on disk.</td>
  </tr>
  <tr>
    <td>Logrotate Mesos Slave</td>
    <td>This component (`dcos-logrotate-agent.service/`) automatically rotates compression, removal, and mailing of log files for agent nodes.</td>
  </tr>
  <tr>
    <td>Logrotate Timer</td>
    <td>These components (`dcos-logrotate-agent.timer` and `dcos-logrotate-master.timer`) set the logrotate interval at 2 minutes.</td>
  </tr>
  <tr>
    <td>Marathon</td>
    <td>This component (`dcos-marathon.service`) is the DC/OS Marathon instance which starts and monitors DC/OS applications and services.</td>
  </tr>
  <tr>
    <td>Mesos Agent</td>
    <td>This component (`dcos-mesos-slave.service`) is the mesos-slave process for <a href="/docs/1.9/overview/concepts/#private">private</a> agent nodes.</td>
  </tr>
  <tr>
    <td>Mesos Agent Public</td>
    <td>This component (`dcos-mesos-slave-public.service`) is the mesos-slave process for <a href="/docs/1.9/overview/concepts/#public">public</a> agent nodes.</td>
  </tr>
  <tr>
    <td>Mesos DNS</td>
    <td>This component (`dcos-mesos-dns.service`) provides service discovery within the cluster. Mesos-DNS is the internal DNS service (`dcos-mesos-dns.service`) for the DC/OS cluster. <a href="/docs/1.9/overview/concepts/#mesos-dns">Mesos-DNS</a> provides the namespace `$service.mesos` to all cluster hosts. For example, you can login to your leading mesos master with `ssh leader.mesos`.</td>
  </tr>
  <tr>
    <td>History Service</td>
    <td>This component (`dcos-history-service.service`) enables the DC/OS web interface to display cluster usage statistics.</td>
  </tr>
  <tr>
    <td>Mesos Master</td>
    <td>This component (`dcos-mesos-master.service`) is the mesos-master process that orchestrates agent tasks.</td>
  </tr>
  <tr>
    <td>Mesos Persistent Volume Discovery</td>
    <td>This component (`dcos-vol-discovery-pub-agent.service`) connects to existing Mesos volume mounts on agent nodes during installation. For more information on Mesos Persistent Volumes, see the <a href="http://mesos.apache.org/documentation/latest/persistent-volume/">documentation</a>.</td>
  </tr>
  <tr>
    <td>Virtual Network Service</td>
    <td>This component (`dcos-navstar.service/`) is a daemon that provides virtual networking and DNS services. It is the network overlay orchestrator. For more information, see the <a href="https://github.com/dcos/navstar">documentation</a>.</td>
  </tr>
  <tr>
    <td>OAuth</td>
    <td>This component (`dcos-oauth.service`) provides the DC/OS authorization service.</td>
  </tr>
  <tr>
    <td>Package service</td>
    <td>This component (`dcos-cosmos.service `) is the internal packaging API service. This service is accessed every time that you run `dcos package install` from the CLI. This API deploys DC/OS packages from the DC/OS <a href="https://github.com/mesosphere/universe">Universe</a> to your DC/OS cluster.</td>
  </tr>
    <td>Signal</td>
    <td>This component (`dcos-signal.service`) sends a periodic ping back to Mesosphere with high-level cluster information to help improve DC/OS, and provides advanced monitoring of cluster issues. Signal queries the diagnostics service `/system/health/v1/report` endpoint on the leading master and sends this data to SegmentIO for use in tracking metrics and customer support.</td>
  </tr>
  <tr>
    <td>Signal Timer</td>
    <td>This component (`dcos-signal.timer`) sets the Signal component interval at once per hour.</td>
  </tr>
<tr>
      <td>REX-Ray</td>
      <td>This component (<code>dcos-rexray.service</code>) is the REX-Ray storage method for enabling external persistent volumes in Marathon.</td>
    </tr>
<tr>
      <td>System Package Manager API</td>
      <td>This component (`dcos-pkgpanda-api.service`) creates symlinks, installs systemd units, and sets up the roles for each host (master, private agent, public agent).</td>
    </tr>
    <tr>
      <td>System Package Manager API socket</td>
      <td>This component (`dcos-pkgpanda-api.socket`) is the System Package Manager API socket.</td>
    </tr>
  <tr>
</table>


