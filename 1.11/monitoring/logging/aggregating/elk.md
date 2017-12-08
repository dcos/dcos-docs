---
post_title: Log Management with ELK
menu_order: 1
enterprise: 'no'
---

You can pipe system and application logs from the nodes in a DC/OS cluster to an Elasticsearch server. This document describes how to send Filebeat output from each node to a centralized Elasticsearch instance. This document does not explain how to setup and configure an Elasticsearch server.

These instructions are based on CentOS 7 and might differ substantially from other Linux distributions.

**Important:**
- This document describes how to directly stream from Filebeat into Elasticsearch. Logstash is not used in this architecture. If you're interested in filtering, parsing and grok'ing the logs with an intermediate Logstash stage, see the Logstash [documentation][8] and the example in [Filtering logs with ELK][3].
- This document does not describe how to set up secure TLS communication between the Filebeat instances and Elasticsearch. For details on how to achieve this, see the [Filebeat][2] and [Elasticsearch][5] documentation.

**Prerequisites**

*   An existing Elasticsearch installation that can ingest data for indexing.
*   All DC/OS nodes must be able to connect to your Elasticsearch server on the port used for communication between Elasticsearch and Filebeat (9200 by default).

# <a name="all"></a>Step 1: All nodes

For all nodes in your DC/OS cluster:

1.  Install Elastic's [Filebeat][2].

    ```bash
    curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-x86_64.rpm
    sudo rpm -vi filebeat-5.0.0-x86_64.rpm
    ```

1.  Create the `/var/log/dcos` directory:

    ```bash
    sudo mkdir -p /var/log/dcos
    ```
1.  Move the default Filebeat configuration file to a backup copy:

    ```bash
    sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.BAK
    ```

1.  Populate a new `filebeat.yml` configuration file, including an additional input entry for the file `/var/log/dcos/dcos.log`. The additional log file will be used to capture the DC/OS logs in a later step. Remember to substitute the variables `$ELK_HOSTNAME` and `$ELK_PORT` below for the actual values of the host and port where your Elasticsearch is listening on.

    ```bash
    filebeat.prospectors:
    - input_type: log
      paths:
        - /var/lib/mesos/slave/slaves/*/frameworks/*/executors/*/runs/latest/stdout*
        - /var/lib/mesos/slave/slaves/*/frameworks/*/executors/*/runs/latest/stderr*
        - /var/log/mesos/*.log
        - /var/log/dcos/dcos.log
    tail_files: true
    output.elasticsearch:
      hosts: ["$ELK_HOSTNAME:$ELK_PORT"]
    ```

**Important:** The agent node Filebeat configuration expects tasks to write logs to `stdout` and `stderr`. Some DC/OS services, including Cassandra and Kafka, do not write logs to `stdout` and `stderr`. If you want to log these services, you must customize your agent node Filebeat configuration.

# <a name="all-2"></a>Step 2: All nodes

For all nodes in your DC/OS cluster:

1.  Create a script `/etc/systemd/system/dcos-journalctl-filebeat.service` that parses the output of the DC/OS master `journalctl` logs and funnels them to `/var/log/dcos/dcos.log`. 

    **Tip:** This script can be used with DC/OS and Enterprise DC/OS. Log entries that do not apply are ignored.

    ```bash
    sudo tee /etc/systemd/system/dcos-journalctl-filebeat.service<<-EOF
    [Unit]
    Description=DCOS journalctl parser to filebeat
    Wants=filebeat.service
    After=filebeat.service

    [Service]
    Restart=always
    RestartSec=5
    ExecStart=/bin/sh -c '/usr/bin/journalctl --since="5 minutes ago" --no-tail --follow --unit="dcos*.service" >> /var/log/dcos/dcos.log 2>&1'

    [Install]
    WantedBy=multi-user.target
    EOF
    ```

# <a name="all-3"></a>Step 3: All nodes

1.  For all nodes, start and enable the Filebeat log parsing services created above:

    ```bash
    sudo chmod 0755 /etc/systemd/system/dcos-journalctl-filebeat.service
    sudo systemctl daemon-reload
    sudo systemctl start dcos-journalctl-filebeat.service
    sudo systemctl enable dcos-journalctl-filebeat.service
    sudo systemctl start filebeat
    sudo systemctl enable filebeat
    ```


# <a name="all"></a>Step 3: ELK Node Notes

The ELK stack will receive, store, search and display information about the logs parsed by the Filebeat instances configured above for all nodes in the cluster.

**Important:** This document describes how to directly stream from Filebeat into ElasticSearch. Logstash is not used in this architecture. If you're interested in filtering, parsing and grok'ing the logs with an intermediate Logstash stage, please check the Logstash [documentation][8].

You must modify the default parameter values to prepare ElasticSearch to receive information. For example, edit the ElasticSearch configuration file (typically `/etc/elasticsearch/elasticsearch.yml`):

```bash
network.host = [IP address from the interface in your ElasticSearch node connecting to the Filebeat instances]
```

Other parameters in the file are beyond the scope of this document. For details, please check the ElasticSearch [documentation][5].


# <a name="all-4"></a>Step 4: All Nodes

You should configure logrotate on all of your nodes to prevent the file /var/log/dcos/dcos.log growing without limit and filling up your disk.
Your logrotate config should contain 'copytruncate' because otherwise the 'journalctl' pipe remains open and pointing to the same file even after it's been rotated.
Note: With using 'copytruncate' there is a very small time slice between copying the file and truncating it, so some logging data might be lost - you should balance pros and cons between filling up the disk and losing some lines of logs.

For example your logrotate configuration should look like this:

    ```
    /var/log/dcos/dcos.log {    
      size 100M
      copytruncate
      rotate 5
      compress
      compresscmd /bin/xz
    }
    ```

### Known Issue

The agent node Filebeat configuration expects tasks to write logs to `stdout` and `stderr`. Some DC/OS services, including Cassandra and Kafka, do not write logs to `stdout` and `stderr`. If you want to log these services, you must customize your agent node Filebeat configuration.

# What's Next

For details on how to filter your logs with ELK, see [Filtering DC/OS logs with ELK][3].

 [2]: https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html
 [3]: ../filter-elk/
 [4]: https://www.elastic.co/guide/en/elastic-stack/current/index.html
 [5]: https://www.elastic.co/guide/en/elasticsearch/reference/5.0/index.html
 [6]: https://www.elastic.co/guide/en/kibana/current/install.html
 [7]: https://www.elastic.co/guide/en/logstash/current/installing-logstash.html
 [8]: https://www.elastic.co/guide/en/logstash/current/index.html