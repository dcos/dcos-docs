---
post_title: Troubleshooting your DC/OS installation
nav_title: Troubleshooting
menu_order: 400
---

# <a name="general"></a>General troubleshooting approach

1.  Verify that you have a valid IP detect﻿⁠⁠⁠⁠script, functioning DNS resolvers to bind the DC/OS services to, and that all nodes are synchronized with NTP.
    
    ## <a name="ip-detect-script"></a>IP detect script
    
    You must have a valid [ip-detect](/docs/1.9/administration/installing/custom/advanced/) script. You can manually run `ip-detect` on all the nodes in your cluster or check `/opt/mesosphere/bin/detect_ip` on an existing installation to ensure that it returns a valid IP address. A valid IP address does not have:
    
    - extra lines
    - white space
    - special or hidden characters 
    
    It is recommended that you use the `ip-detect` [examples](/docs/1.9/administration/installing/custom/advanced/).
      
    ## DNS resolvers
      
    You must have working DNS resolvers, specified in your [config.yaml](/docs/1.9/administration/installing/custom/configuration-parameters/#resolvers) file. It is recommended that you have forward and reverse lookups for FQDNs, short hostnames, and IP addresses. It is possible for DC/OS to function in environments without valid DNS support, but the following _must_ work to support DC/OS services, including Spark:
    
    - `hostname -f` returns the FQDN
    - `hostname -s` returns the short hostname
    
    You should sanity check the output of `hostnamectl` on all of your nodes as well.

    When troubleshooting problems with a DC/OS installation, you should explore the components in this sequence: 
    
    1. Exhibitor 
    1. Mesos master 
    1. Mesos DNS 
    1. DNS Dispatcher 
    1. DC/OS Marathon
    1. Jobs 
    1. Admin Router

    Be sure to check that all services are up and healthy on the masters before checking the agents.
    
    ### NTP
    
    Network Time Protocol (NTP) must be enabled on all nodes for clock synchronization. By default, during DC/OS startup you will receive an error if this is not enabled. You can check if NTP is enabled by running one of these commands, depending on your OS and configuration:
    
    ```bash
    $ ntptime
    $ adjtimex -p
    $ timedatectl
    ```

1. Ensure that firewalls and any other connection-filtering mechanisms are not interfering with cluster component communications. TCP, UDP, and ICMP must be permitted.
    
   Ensure that services that bind to port `53`, which is required by DNS Dispatcher (`dcos-spartan.service`), are disabled and stopped. For example: 
   
   ```bash
   sudo systemctl disable dnsmasq && sudo systemctl stop dnsmasq
   ```

1.  Verify that Exhibitor is up and running at`http://<MASTER_IP>:8181/exhibitor`. If Exhibitor is not up and running:

    -  [SSH](/docs/1.9/administration/access-node/sshcluster/) to your master node and enter this command to check the Exhibitor service logs:
        
        ```bash
        journalctl -flu dcos-exhibitor
        ```
    
    -  Verify that `/tmp` is mounted *without* `noexec`. If it is mounted with `noexec`, Exhibitor will fail to bring up ZooKeeper because Java JNI won't be able to `exec` a file it creates in `/tmp` and you will see multiple `permission denied` errors in the log. To repair `/tmp` mounted with `noexec`:
        
        1.  Enter this command: 
        
            ```bash
            mount -o remount,exec /tmp
            ```
        
        1.  Check the output of `/exhibitor/v1/cluster/status` and verify that it shows the correct number of masters and that all of them are `"serving"` but only one of them is designated as `"isLeader": true`
        
            For example, [SSH](/docs/1.9/administration/access-node/sshcluster/) to your master node and enter this command:
            
            ```bash
            $ curl -fsSL http://localhost:8181/exhibitor/v1/cluster/status | python -m json.tool
            [
                {
                    "code": 3,
                    "description": "serving",
                    "hostname": "10.0.6.70",
                    "isLeader": false
                },
                {
                    "code": 3,
                    "description": "serving",
                    "hostname": "10.0.6.69",
                    "isLeader": false
                },
                {
                    "code": 3,
                    "description": "serving",
                    "hostname": "10.0.6.68",
                    "isLeader": true
                }
            ]
            ```
        
            **Note:** Running this command in multi-master configurations can take up to 10-15 minutes to complete. If it doesn't complete after 10-15 minutes, you should carefully review the `journalctl -flu dcos-exhibitor` logs.

1.  Verify whether you can ping the DNS Dispatcher (`ready.spartan`). If not, review the DNS Dispatcher service logs: ﻿⁠⁠⁠⁠

    ```bash
    journalctl -flu dcos-spartan﻿⁠⁠⁠⁠
    ```
    
1.  Verify that you can ping `⁠⁠⁠⁠leader.mesos` and ﻿⁠⁠⁠⁠`master.mesos`. If not:

    -  Review the Mesos-DNS service logs with this command: ﻿

       ```bash
       ⁠⁠⁠⁠journalctl -flu dcos-mesos-dns﻿⁠⁠⁠⁠
       ```
    
    -  If you are able to ping `ready.spartan`, but not `leader.mesos`, review the Mesos master service logs by using this command: 
    
       ```bash
       ⁠⁠⁠⁠journalctl -flu dcos-mesos-master
       ```
       ﻿
       The Mesos masters must be up and running with a leader elected before Mesos-DNS can generate its DNS records from ﻿`⁠⁠⁠⁠/state`.﻿⁠⁠⁠⁠

# <a name="component-logs"></a>Component logs

During DC/OS installation, each of the components will converge from a failing state to a running state in the logs.

- [Admin Router](#admin-router)
- [DC/OS agent nodes](#dcos-agent-nodes)
- [DC/OS Marathon](#dcos-marathon)
- [gen_resolvconf](#gen-resolvconf)
- [Mesos DNS](#mesos-dns)
- [Mesos master process](#mesos-master-process)
- [ZooKeeper and Exhibitor](#zookeeper-and-exhibitor)

## <a name="admin-router"></a>Admin Router

The Admin Router is started on the master nodes. The Admin Router provides central authentication and proxy to DC/OS services within the cluster. This allows you to administer your cluster from outside the network without VPN or a SSH tunnel. For HA, an optional load balancer can be configured in front of each master node, load balancing port 80, to provide failover and load balancing.

**Troubleshooting:**

*   SSH to your master node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-adminrouter -b
    ```

    For example, here is a snippet of the Admin Router log as it converges to a successful state:

    ```bash
    systemd[1]: Starting A high performance web server and a reverse proxy server...
    systemd[1]: Started A high performance web server and a reverse proxy server.
    nginx[1652]: ip-10-0-7-166.us-west-2.compute.internal nginx: 10.0.7.166 - - [18/Nov/2015:14:01:10 +0000] "GET /mesos/master/state-summary HTTP/1.1" 200 575 "-" "python-requests/2.6.0 CPython/3.4.2 Linux/4.1.7-coreos"
    nginx[1652]: ip-10-0-7-166.us-west-2.compute.internal nginx: 10.0.7.166 - - [18/Nov/2015:14:01:10 +0000] "GET /metadata HTTP/1.1" 200 175 "-" "python-requests/2.6.0 CPython/3.4.2 Linux/4.1.7-coreos"
    ```

## <a name="dcos-agent-nodes"></a>DC/OS agent nodes

DC/OS private and public agent nodes are started. Deployed apps and services are run on the private agent nodes. You must have at least 1 private agent node.

Publicly accessible applications are run in the public agent node. Public agent nodes can be configured to allow outside traffic to access your cluster. Public agents are optional and there is no minimum. This is where you'd run a load balancer, providing a service from inside the cluster to the external public.

**Troubleshooting:**

*   You might not be able to SSH to agent nodes, depending on your cluster network configuration. We have made this a little bit easier with the DC/OS CLI. For more information, see [SSHing to a DC/OS cluster][6].

*   You can get the IP address of registered agent nodes from the **Nodes** tab in the [DC/OS web interface][7]. Nodes that have not registered are not shown.

*   SSH to your agent node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-mesos-slave -b
    ```

    For example, here is a snippet of the Mesos agent log as it converges to a successful state:

    ```bash
    mesos-slave[1080]: I1118 14:00:43.687366  1080 main.cpp:272] Starting Mesos slave
    mesos-slave[1080]: I1118 14:00:43.688474  1080 slave.cpp:190] Slave started on 1)@10.0.1.108:5051
    mesos-slave[1080]: I1118 14:00:43.688503  1080 slave.cpp:191] Flags at startup: --appc_store_dir="/tmp/mesos/store/appc" --authenticatee="crammd5" --cgroups_cpu_enable_pids_and_tids_count="false" --cgroups_enable_cfs="false" --cgroups_hierarchy="/sys/fs/cgroup" --cgroups_limit_swap="false" --cgroups_root="mesos" --container_disk_watch_interval="15secs" --containerizers="docker,mesos" --default_role="*" --disk_watch_interval="1mins" --docker="docker" --docker_kill_orphans="true" --docker_remove_delay="1hrs" --docker_socket="/var/run/docker.sock" --docker_stop_timeout="0ns" --enforce_container_disk_quota="false" --executor_environment_variables="{"LD_LIBRARY_PATH":"\/opt\/mesosphere\/lib","PATH":"\/usr\/bin","SASL_PATH":"\/opt\/mesosphere\/lib\/sasl2","SHELL":"\/usr\/bin\/bash"}" --executor_registration_timeout="5mins" --executor_shutdown_grace_period="5secs" --fetcher_cache_dir="/tmp/mesos/fetch" --fetcher_cache_size="2GB" --frameworks_home="" --gc_delay="2days" --gc_disk_headroom="0.1" --hadoop_home="" --help="false" --hostname_lookup="false" --image_provisioner_backend="copy" --initialize_driver_logging="true" --ip_discovery_command="/opt/mesosphere/bin/detect_ip" --isolation="cgroups/cpu,cgroups/mem" --launcher_dir="/opt/mesosphere/packages/mesos--30d3fbeb6747bb086d71385e3e2e0eb74ccdcb8b/libexec/mesos" --log_dir="/var/log/mesos" --logbufsecs="0" --logging_level="INFO" --master="zk://leader.mesos:2181/mesos" --oversubscribed_resources_interval="15secs" --perf_duration="10secs" --perf_interval="1mins" --port="5051" --qos_correction_interval_min="0ns" --quiet="false" --recover="reconnect" --recovery_timeout="15mins" --registration_backoff_factor="1secs" --resource_monitoring_interval="1secs" --resources="ports:[1025-2180,2182-3887,3889-5049,5052-8079,8082-8180,8182-32000]" --revocable_cpu_low_priority="true" --sandbox_directory="/mnt/mesos/sandbox" --slave_subsystems="cpu,memory" --strict="true" --switch_user="true" --systemd_runtime_directory="/run/systemd/system" --version="false" --work_dir="/var/lib/mesos/slave"
    mesos-slave[1080]: I1118 14:00:43.688711  1080 slave.cpp:211] Moving slave process into its own cgroup for subsystem: cpu
    mesos-slave[1080]: 2015-11-18 14:00:43,689:1080(0x7f9b526c4700):ZOO_INFO@check_events@1703: initiated connection to server [10.0.7.166:2181]
    mesos-slave[1080]: I1118 14:00:43.692811  1080 slave.cpp:211] Moving slave process into its own cgroup for subsystem: memory
    mesos-slave[1080]: I1118 14:00:43.697872  1080 slave.cpp:354] Slave resources: ports(*):[1025-2180, 2182-3887, 3889-5049, 5052-8079, 8082-8180, 8182-32000]; cpus(*):4; mem(*):14019; disk(*):32541
    mesos-slave[1080]: I1118 14:00:43.697916  1080 slave.cpp:390] Slave hostname: 10.0.1.108
    mesos-slave[1080]: I1118 14:00:43.697928  1080 slave.cpp:395] Slave checkpoint: true
    ```

## <a name="dcos-marathon"></a>DC/OS Marathon

DC/OS Marathon is started on the master nodes. The native Marathon instance that is the “init system” for DC/OS. It starts and monitors applications and services.

**Troubleshooting:**

*   Go to the **Services** tab on the [web interface](/docs/1.9/usage/webinterface) and view status.

*   SSH to your master node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-marathon -b
    ```
    
    For example, here is a snippet of the DC/OS Marathon log as it converges to a successful state:

    ```bash
    java[1288]: I1118 13:59:39.125041  1363 group.cpp:331] Group process (group(1)@10.0.7.166:48531) connected to ZooKeeper
    java[1288]: I1118 13:59:39.125100  1363 group.cpp:805] Syncing group operations: queue size (joins, cancels, datas) = (0, 0, 0)
    java[1288]: I1118 13:59:39.125121  1363 group.cpp:403] Trying to create path '/mesos' in ZooKeeper
    java[1288]: [2015-11-18 13:59:39,130] INFO Scheduler actor ready (mesosphere.marathon.MarathonSchedulerActor:marathon-akka.actor.default-dispatcher-5)
    java[1288]: I1118 13:59:39.147804  1363 detector.cpp:156] Detected a new leader: (id='1')
    java[1288]: I1118 13:59:39.147924  1363 group.cpp:674] Trying to get '/mesos/json.info_0000000001' in ZooKeeper
    java[1288]: I1118 13:59:39.148727  1363 detector.cpp:481] A new leading master (UPID=master@10.0.7.166:5050) is detected
    java[1288]: I1118 13:59:39.148787  1363 sched.cpp:262] New master detected at master@10.0.7.166:5050
    java[1288]: I1118 13:59:39.148952  1363 sched.cpp:272] No credentials provided. Attempting to register without authentication
    java[1288]: I1118 13:59:39.150403  1363 sched.cpp:641] Framework registered with cdcb6222-65a1-4d60-83af-33dadec41e92-0000
    ```

## <a name="gen-resolvconf"></a>gen_resolvconf

gen_resolvconf is started. This is a service that helps the agent nodes locate the master nodes. It updates `/etc/resolv.conf` so that agents can use the Mesos-DNS service for service discovery. gen_resolvconf uses either an internal load balancer, vrrp, or a static list of masters to locate the master nodes. For more information, see the `master_discovery` [configuration parameter][3].

**Troubleshooting:**

*   When gen_resolvconf is up and running, you can view `/etc/resolv.conf` contents. It should contain one or more IP addresses for the master nodes, and the optional external DNS server.

*   SSH to your master node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-gen-resolvconf -b
    ```

    For example, here is a snippet of the gen_resolvconf log as it converges to a successful state:

    ```bash
    systemd[1]: Started Update systemd-resolved for mesos-dns.
    systemd[1]: Starting Update systemd-resolved for mesos-dns...
    gen_resolvconf.py[1073]: options timeout:1
    gen_resolvconf.py[1073]: options attempts:3
    gen_resolvconf.py[1073]: nameserver 10.0.7.166
    gen_resolvconf.py[1073]: nameserver 10.0.0.2
    gen_resolvconf.py[1073]: Updating /etc/resolv.conf
    ```

## <a name="mesos-master-process"></a>Mesos master process

The Mesos master process starts on the master nodes. The `mesos-master` process runs on a node in the cluster and orchestrates the running of tasks on agents by receiving resource offers from agents and offering those resources to registered services, such as Marathon or Chronos. For more information, see the [Mesos Master Configuration][2] documentation.

**Troubleshooting:**

*   Go directly to the Mesos web interface and view status at `<master-hostname>/mesos`.
*   SSH to your master node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-mesos-master -b
    ```

    For example, here is a snippet of the Mesos master log as it converges to a successful state:

    ```bash
    mesos-master[1250]: I1118 13:59:33.890916  1250 master.cpp:376] Master cdcb6222-65a1-4d60-83af-33dadec41e92 (10.0.7.166) started on 10.0.7.166:5050
    mesos-master[1250]: I1118 13:59:33.890945  1250 master.cpp:378] Flags at startup: --allocation_interval="1secs" --allocator="HierarchicalDRF" --authenticate="false" --authenticate_slaves="false" --authenticators="crammd5" --authorizers="local" --cluster="pool-880dfdbf0f2845bf8191" --framework_sorter="drf" --help="false" --hostname_lookup="false" --initialize *driver_logging="true" --ip_discovery_command="/opt/mesosphere/bin/detect_ip" --log_auto_initialize="true" --log_dir="/var/log/mesos" --logbufsecs="0" --logging_level="INFO" --max* slave_ping_timeouts="5" --port="5050" --quiet="false" --quorum="1" --recovery_slave_removal_limit="100%" --registry="replicated_log" --registry_fetch_timeout="1mins" --registry_sto re_timeout="5secs" --registry_strict="false" --roles="slave_public" --root_submissions="true" --slave_ping_timeout="15secs" --slave_reregister_timeout="10mins" --user_sorter="drf" --version="false" --webui_dir="/opt/mesosphere/packages/mesos--30d3fbeb6747bb086d71385e3e2e0eb74ccdcb8b/share/mesos/webui" --weights="slave_public=1" --work_dir="/var/lib/mesos/mas ter" --zk="zk://127.0.0.1:2181/mesos" --zk_session_timeout="10secs" mesos-master[1250]: 2015-11-18 13:59:33,891:1250(0x7f14427fc700):ZOO_INFO@check_events@1750: session establishment complete on server [127.0.0.1:2181], sessionId=0x1511ae440bc0001, negotiated timeout=10000
    ```


## <a name="mesos-dns"></a>Mesos-DNS

Mesos-DNS is started on the DC/OS master nodes. Mesos-DNS provides service discovery within the cluster. Optionally, Mesos-DNS can forward unhandled requests to an external DNS server, depending on how the cluster is configured. For example, anything that does not end in `.mesos` will be forwarded to the external resolver.

**Troubleshooting:**

*   SSH to your master node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-mesos-dns -b
    ```

    For example, here is a snippet of the Mesos-DNS log as it converges to a successful state:

    ```bash
    mesos-dns[1197]: I1118 13:59:34.763885 1197 detect.go:135] changing leader node from "" -> "json.info_0000000001"
    mesos-dns[1197]: I1118 13:59:34.764537 1197 detect.go:145] detected master info: &MasterInfo{Id:*cdcb6222-65a1-4d60-83af-33dadec41e92,Ip:*2785476618,Port:*5050,Pid:*master@10.0.7.166:5050,Hostname:*10\.0.7.166,Version:*0\.25.0,Address:&Address{Hostname:*10\.0.7.166,Ip:*10\.0.7.166,Port:*5050,XXX_unrecognized:[],},XXX_unrecognized:[],}
    mesos-dns[1197]: VERY VERBOSE: 2015/11/18 13:59:34 masters.go:47: Updated leader: &MasterInfo{Id:*cdcb6222-65a1-4d60-83af-33dadec41e92,Ip:*2785476618,Port:*5050,Pid:*master@10.0.7.166:5050,Hostname:*10\.0.7.166,Version:*0\.25.0,Address:&Address{Hostname:*10\.0.7.166,Ip:*10\.0.7.166,Port:*5050,XXX_unrecognized:[],},XXX_unrecognized:[],}
    mesos-dns[1197]: VERY VERBOSE: 2015/11/18 13:59:34 main.go:76: new masters detected: [10.0.7.166:5050]
    mesos-dns[1197]: VERY VERBOSE: 2015/11/18 13:59:34 generator.go:70: Zookeeper says the leader is: 10.0.7.166:5050
    mesos-dns[1197]: VERY VERBOSE: 2015/11/18 13:59:34 generator.go:162: reloading from master 10.0.7.166
    mesos-dns[1197]: I1118 13:59:34.766005 1197 detect.go:219] notifying of master membership change: [&MasterInfo{Id:*cdcb6222-65a1-4d60-83af-33dadec41e92,Ip:*2785476618,Port:*5050,Pid:*master@10.0.7.166:5050,Hostname:*10\.0.7.166,Version:*0\.25.0,Address:&Address{Hostname:*10\.0.7.166,Ip:*10\.0.7.166,Port:*5050,XXX_unrecognized:[],},XXX_unrecognized:[],}]
    mesos-dns[1197]: VERY VERBOSE: 2015/11/18 13:59:34 masters.go:56: Updated masters: [&MasterInfo{Id:*cdcb6222-65a1-4d60-83af-33dadec41e92,Ip:*2785476618,Port:*5050,Pid:*master@10.0.7.166:5050,Hostname:*10\.0.7.166,Version:*0\.25.0,Address:&Address{Hostname:*10\.0.7.166,Ip:*10\.0.7.166,Port:*5050,XXX_unrecognized:[],},XXX_unrecognized:[],}]
    mesos-dns[1197]: I1118 13:59:34.766124 1197 detect.go:313] resting before next detection cycle
    ```

## <a name="zookeeper-and-exhibitor"></a>ZooKeeper and Exhibitor

ZooKeeper and Exhibitor start on the master nodes. The Exhibitor storage location must be configured properly for this to work. For more information, see the [exhibitor_storage_backend][1] parameter.

DC/OS uses ZooKeeper, a high-performance coordination service to manage the installed DC/OS services. Exhibitor automatically configures ZooKeeper on the master nodes during your DC/OS installation. For more information, see [Configuration Parameters][5].

*   Go to the Exhibitor web interface and view status at `<master-hostname>/exhibitor`.

*   SSH to your master node and enter this command to view the logs from boot time:

    ```bash
    $ journalctl -u dcos-exhibitor -b
    ```

    For example, here is a snippet of the Exhibitor log as it converges to a successful state:

    ```bash
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Automatic Instance Management will change the server list:  ==> 1:10.0.7.166 [ActivityQueue-0]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  State: serving [ActivityQueue-0]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Server list has changed [ActivityQueue-0]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Attempting to stop instance [ActivityQueue-0]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Attempting to start/restart ZooKeeper [ActivityQueue-0]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Kill attempted result: 0 [ActivityQueue-0]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Process started via: /opt/mesosphere/active/exhibitor/usr/zookeeper/bin/zkServer.sh [ActivityQueue-0]
    ERROR com.netflix.exhibitor.core.activity.ActivityLog  ZooKeeper Server: JMX enabled by default [pool-3-thread-1]         ERROR com.netflix.exhibitor.core.activity.ActivityLog  ZooKeeper Server: Using config: /opt/mesosphere/active/exhibitor/usr/zookeeper/bin/../conf/zoo.cfg [pool-3-thread-1]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  ZooKeeper Server: Starting zookeeper ... STARTED [pool-3-thread-3]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Cleanup task completed [pool-3-thread-6]
    INFO  com.netflix.exhibitor.core.activity.ActivityLog  Cleanup task completed [pool-3-thread-9]
    ```


 [1]: /docs/1.9/administration/installing/custom/configuration-parameters/#scrollNav-5
 [2]: https://open.mesosphere.com/reference/mesos-master/
 [3]: /docs/1.9/administration/installing/custom/configuration-parameters/#scrollNav-7
 [4]: /docs/1.9/overview/architecture/#boot
 [5]: /docs/1.9/administration/installing/custom/configuration-parameters
 [6]: /docs/1.9/administration/access-node/sshcluster/
 [7]: /docs/1.9/usage/webinterface/

