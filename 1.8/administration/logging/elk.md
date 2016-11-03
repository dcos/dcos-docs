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
*   The `ulimit` of open files must be set to `unlimited` for your user with root access.

# <a name="all"></a>Step 1: All Nodes

For all nodes in your DC/OS cluster:

1.  Install Elastic's [logstash-forwarder][2]. The project is written in Go and is compiled for most platforms.
2.  Download the HTTPS certificate for your ELK stash. In our examples, we assume the certificate is named `elk.crt`.

# <a name="master"></a>Step 2: Master Nodes

For each Master node in your DC/OS cluster:

1.  Create a `logstash.conf` configuration file for `logstash-forwarder` that sends `stdin` data directly to your ELK server.

        {
            "network": {
                    "servers": [ "<elk-hostname>:<elk-port>" ],
                    "timeout": 15,
                    "ssl ca": "elk.crt"
            },
            "files": [
                {
                    "paths": [ "-" ]
                }
            ]
        }

2.  Create a `logstash.sh` bash script to pipe DC/OS service logs from `journalctl` to `logstash-forwarder`.

            #!/bin/bash

            journalctl --since="now" -f             \
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
                | ./logstash-forwarder -config logstash.conf

3.  Run `logstash.sh` as a service.

    **Important:** If any of these DC/OS services are restarted, you must restart this script.

# <a name="agent"></a>Step 3: Agent Nodes

For each Agent node in your DC/OS cluster:

1.  Create a `logstash.conf` configuration file for `logstash-forwarder` that sends `stdin` data directly to your ELK server.

        {
            "network": {
                "servers": [ "<elk-hostname>:<elk-port>" ],
                "timeout": 15,
                "ssl ca": "elk.crt"
            },
            "files": [
                {
                    "paths": [
                        "-",
                        "/var/lib/mesos/slave/slaves/*/frameworks/*/executors/*/runs/latest/stdout",
                        "/var/lib/mesos/slave/slaves/*/frameworks/*/executors/*/runs/latest/stderr"
                    ]
                }
            ]
        }

2.  Create a `logstash.sh` bash script to pipe DC/OS service logs from `journalctl` to `logstash-forwarder`.

            #!/bin/bash

            journalctl --since="now" -f                  \
                -u dcos-3dt.service                      \
                -u dcos-logrotate-agent.timer            \
                -u dcos-3dt.socket                       \
                -u dcos-mesos-slave.service              \
                -u dcos-adminrouter-agent.service        \
                -u dcos-minuteman.service                \
                -u dcos-adminrouter-reload.service       \
                -u dcos-navstar.service                  \
                -u dcos-adminrouter-reload.timer         \
                -u dcos-rexray.service                   \
                -u dcos-cfn-signal.service               \
                -u dcos-setup.service                    \
                -u dcos-download.service                 \ 
                -u dcos-signal.timer                     \
                -u dcos-epmd.service                     \
                -u dcos-spartan-watchdog.service         \
                -u dcos-gen-resolvconf.service           \
                -u dcos-spartan-watchdog.timer           \
                -u dcos-gen-resolvconf.timer             \
                -u dcos-spartan.service                  \
                -u dcos-link-env.service                 \
                -u dcos-vol-discovery-priv-agent.service \
                -u dcos-logrotate-agent.service          \
                | ./logstash-forwarder -config logstash.conf

3.  Run `logstash.sh` as a service.

    **Important:** If any of these DC/OS services are restarted, you must restart this script.

### Known Issue

*   The agent node logstash configuration expects tasks to write logs to `stdout` and `stderr`. Some DC/OS services, including Cassandra and Kafka, do not write logs to `stdout` and `stderr`. If you want to log these services, you must customize your agent node logstash configuration.

# What's Next

For details on how to filter your logs with ELK, see [Filtering DC/OS logs with ELK][3].

 [2]: https://github.com/elastic/logstash-forwarder
 [3]: ../filter-elk/
