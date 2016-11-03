---
post_title: Log Management with ELK
nav_title: ELK
menu_order: 1
---
You can pipe system and application logs from a DC/OS cluster to your existing ElasticSearch, Logstash, and Kibana (ELK) server.

There are two ways to configue your system to ship these logs:

**Dump Journald to a Trackable File**
With this method, you configure journald to dump it's binary database of ogs to a file. At this point, you can use the basic file beat implementation, pointing it to the file, enabling file beat to ship the data in journal to your aggregated log tracking system.

**Use [JournalBeat](https://github.com/mheese/journalbeat)**
In this case, you log everyhing to journald as you usually would.  This method does not require any extra journald configuration. You can get logs out of journal directly using the JouranlBeat tool, which essentially tails th journal and sends those log lines to youraggregated solution. 

**Prerequisites**

These instructions are based on CoreOS 766.4.0 and might differ substantially from other Linux distributions. This document does not explain how to setup and configure an ELK server.

*   A recent ELK stack with an HTTPS interface and certificate.
*   All DC/OS nodes must be able to connect to your ELK server via HTTPS.
*		It's assumed you're running journald as the logging subsystem   

# Use FileBeats 
If you decide to use FilBeats, you'll want to configue journal to send the logs to a file you can point your FileBeat on each host at. 

## <a name="all"></a>Step 1: All Nodes

For all nodes in your DC/OS cluster:

1. Install Elastic's [FileBeats][2] 
2. Conigure your FileBeats to use SSL. We refer to yur cert as `elk.crt` in this tutorial.

## <a name="master"></a>Step 2: Master Nodes

For each Master node in your DC/OS cluster:

1. Create a logs dir for your DC/OS logs from journal:

	mkdir /var/log/dcos/

2. Create a systemd unit which uses `journalctl` to read logs from the journal and send them to a file:

```
ExecStart=/bin/bash /usr/bin/journalctl --no-tail -f \
                -u dcos-3dt.service                 \
                -u dcos-logrotate-master.timer      \
                -u dcos-adminrouter-reload.service  \
                -u dcos-marathon.service            \
                -u dcos-adminrouter-reload.timer    \
                -u dcos-mesos-dns.service           \
                -u dcos-adminrouter.service         \
                -u dcos-mesos-master.service        \
                -u dcos-cfn-signal.service          \
                -u dcos-metronome.service           \
                -u dcos-cosmos.service              \
                -u dcos-minuteman.service           \
                -u dcos-download.service            \
                -u dcos-navstar.service             \
                -u dcos-epmd.service                \
                -u dcos-oauth.service               \
                -u dcos-exhibitor.service           \
                -u dcos-setup.service               \
                -u dcos-gen-resolvconf.service      \
                -u dcos-signal.service              \
                -u dcos-gen-resolvconf.timer        \
                -u dcos-signal.timer                \
                -u dcos-history.service             \
                -u dcos-spartan-watchdog.service    \
                -u dcos-link-env.service            \
                -u dcos-spartan-watchdog.timer      \
                -u dcos-logrotate-master.service    \
                -u dcos-spartan.service             \
								> /var/log/dcos/dcos.log
ExecStartPre=/usr/bin/journalctl --vacuum-size=10M
```

Note that we trim the journal beforehand as the journal will continue to grow. 

3.  Create a `/etc/filebeat/filebeat.yml` configuration file which reads `/var/log/dcos/dcos.log` 
```	
filebeat.prospectors:
- input_type: log
	paths:
		- /var/log/dcos/dcos.log
```

4. Setup ElasticSearch output directive in FileBeat config file:
```
output.elasticsearch:
  hosts: ["192.168.1.42:9200"]
```
	
# What's Next
For details on how to filter your logs with ELK, see [Filtering DC/OS logs with ELK][3].

 [2]: https://www.elastic.co/guide/en/beats/filebeat/5.0/filebeat-getting-started.html 
 [3]: ../filter-elk/
