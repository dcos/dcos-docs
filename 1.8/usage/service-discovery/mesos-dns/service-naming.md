---
post_title: Service Naming
menu_order: 0
---

Mesos-DNS defines the DNS top-level domain `.mesos` for Mesos tasks that are running on DC/OS. Tasks and services are discovered by looking up A and, optionally, SRV records within this Mesos domain. 

- [A Records](#a-records)
- [SRV Records](#srv-records)
- [Other Records](#other-records)
- [Task and Service Naming Conventions](#naming-conventions)
- [Discovering Service DNS Names](#dns-naming)

# <a name="a-records"></a>A Records

An A record associates a hostname to an IP address.

When a task is launched by a DC/OS service, Mesos-DNS generates an A record for a hostname in the format `<task>.<service>.mesos` that provides one of the following:

*   The IP address of the [agent node][1] that is running the task
*   The IP address of the task's network container (provided by a Mesos containerizer)

For example, other DC/OS tasks can discover the IP address for a task named `search` launched by the `marathon` service with a lookup for `search.marathon.mesos`:

    $ dig search.marathon.mesos

    ; <<>> DiG 9.8.4-rpz2+rl005.12-P1 <<>> search.marathon.mesos
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24471
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;search.marathon.mesos.         IN  A

    ;; ANSWER SECTION:
    search.marathon.mesos.      60  IN  A   10.9.87.94

If the Mesos containerizer that launches the task provides a container IP `10.0.4.1` for the task `search.marathon.mesos`, then the lookup result is:

    $ dig search.marathon.mesos

    ; <<>> DiG 9.8.4-rpz2+rl005.12-P1 <<>> search.marathon.mesos
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24471
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;search.marathon.mesos.         IN  A

    ;; ANSWER SECTION:
    search.marathon.mesos.      60  IN  A   10.0.4.1

In addition to the `<task>.<service>.mesos` syntax shown above, Mesos-DNS also generates A records that contain the IP addresses of the agent nodes that are running the task: `<task>.<service>.slave.mesos`.

For example, a query of the A records for `search.marathon.slave.mesos` shows the IP address of each agent node running one or more instances of the `search` application on the `marathon` service.

# <a name="srv-records"></a>SRV Records

An SRV record specifies the hostname and port of a service.

For a task named `mytask` launched by a service named `myservice`, Mesos-DNS generates an SRV record `_mytask._protocol.myservice.mesos`, where `protocol` is `udp` or `tcp`.

For example, other Mesos tasks can discover a task named `search` launched by the `marathon` service with a query for `_search._tcp.marathon.mesos`:

    $ dig _search._tcp.marathon.mesos SRV

    ;  DiG 9.8.4-rpz2+rl005.12-P1 &lt;&lt;&gt;&gt; _search._tcp.marathon.mesos SRV
    ;; global options: +cmd
    ;; Got answer:
    ;; -&gt;&gt;HEADER&lt;&lt;- opcode: QUERY, status: NOERROR, id: 33793
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;_search._tcp.marathon.mesos.   IN SRV

    ;; ANSWER SECTION:
    _search._tcp.marathon.mesos.    60 IN SRV 0 0 31302 10.254.132.41.

Mesos-DNS supports the use of a task's DiscoveryInfo for SRV record generation.

On a DC/OS cluster, ports are offered by agent nodes in the same way as other resources such as CPU and memory. If DiscoveryInfo is not available, Mesos-DNS uses the ports that were allocated for the task.

The following table shows the rules that govern SRV generation:

<table class="table">
  <thead>
    <tr>
      <th>
        Service
      </th>

      <th>
        Container IP Known
      </th>

      <th>
        DiscoveryInfo Provided
      </th>

      <th>
        Target Host
      </th>

      <th>
        Target Port
      </th>

      <th>
        A Record Target IP
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        _mytask._protocol.myservice.mesos
      </td>

      <td>
        No
      </td>

      <td>
        No
      </td>

      <td>
        mytask.myservice.slave.mesos
      </td>

      <td>
        Host Port
      </td>

      <td>
        Agent IP
      </td>
    </tr>

    <tr>
      <td>
        _mytask._protocol.myservice.mesos
      </td>

      <td>
        Yes
      </td>

      <td>
        No
      </td>

      <td>
        mytask.myservice.slave.mesos
      </td>

      <td>
        Host Port
      </td>

      <td>
        Agent IP
      </td>
    </tr>

    <tr>
      <td>
        _mytask._protocol.myservice.mesos
      </td>

      <td>
        No
      </td>

      <td>
        Yes
      </td>

      <td>
        mytask.myservice.mesos
      </td>

      <td>
        DiscoveryInfo Port
      </td>

      <td>
        Agent IP
      </td>
    </tr>

    <tr>
      <td>
        _mytask._protocol.myservice.mesos
      </td>

      <td>
        Yes
      </td>

      <td>
        Yes
      </td>

      <td>
        mytask.myservice.mesos
      </td>

      <td>
        DiscoveryInfo Port
      </td>

      <td>
        Container IP
      </td>
    </tr>

    <tr>
      <td>
        mytask.protocol.myservice.slave.mesos
      </td>

      <td>
        N/A
      </td>

      <td>
        N/A
      </td>

      <td>
        mytask.myservice.slave.mesos
      </td>

      <td>
        Host Port
      </td>

      <td>
        Agent IP
      </td>
    </tr>
  </tbody>
</table>

# <a name="other-records"></a>Other Records

Mesos-DNS generates a few special records:

*   For the leading master: A record (`leader.mesos`) and SRV records (`_leader._tcp.mesos` and `_leader._udp.mesos`)
*   For all service schedulers: A records (`myservice.mesos`) and SRV records (`_myservice._tcp.myservice.mesos`)
*   For every known DC/OS master: A records (`master.mesos`) and SRV records (`_master._tcp.mesos` and `_master._udp.mesos`)
*   For every known DC/OS agent: A records (`slave.mesos`) and SRV records (`_slave._tcp.mesos`)

**Important:** To query the leading master node, always query `leader.mesos`, not `master.mesos`. See [this FAQ entry][2] for more information.

There is a delay between the election of a new master and the update of leader/master records in Mesos-DNS.

Mesos-DNS also supports requests for SOA and NS records for the Mesos domain. DNS requests for records of other types in the Mesos domain will return `NXDOMAIN`. Mesos-DNS does not support PTR records needed for reverse lookups.

Mesos-DNS also generates A records for itself that list all the IP addresses that Mesos-DNS will answer lookup requests on. The hostname for these A records is `ns1.mesos`.

# <a name="naming-conventions"></a>Task and Service Naming Conventions

Mesos-DNS follows [RFC 952][3] for name formatting. All fields used to construct hostnames for A records and service names for SRV records must be 24 characters or shorter and can include letters of the alphabet (A-Z), numbers (0-9), and a dash (-). Names are not case sensitive. If the task name does not comply with these constraints, Mesos-DNS will shorten the name to 24 characters, remove all invalid characters, and replace periods (.) with a dash (-).

Note that there is a difference in the rules for service names and task names. For service names, periods (.) are allowed, but all other rules apply. For example, a task named `apiserver.myservice` launched by service `marathon.prod` will have A records associated with the name `apiserver-myservice.marathon.prod.mesos` and SRV records associated with the name `_apiserver-myservice._tcp.marathon.prod.mesos`.

Some services register with default names that are difficult to understand. For example, older versions of Marathon may register with names such as `marathon-0.7.5`, which will lead to a Mesos-DNS hostname such as `search.marathon-0.7.5.mesos`. You can avoid this problem by launching services with customized names. For example, launch Marathon with `--framework_name marathon` to register the service as `marathon`.

If you are using Marathon groups, the Mesos-DNS hostname is created from the app ID. For example, if you have an app named `nginx-router` and it is within the `mesosphere-tutorial` group with an app ID of `/mesosphere-tutorial/nginx-router`, then the DNS name will be `nginx-router-mesosphere-.marathon.mesos`. Note that Mesos-DNS truncated the hostname to 24 characters and substituted a dash for the slash between `mesosphere-tutorial` and `nginx-router`.

If a service launches multiple tasks with the same name, the DNS lookup will return multiple records, one per task. Mesos-DNS randomly shuffles the order of records to provide rudimentary load balancing between these tasks.

**Caution:** It is possible to have a name collision if *different* services launch tasks that have the same hostname. If different services launch tasks with identical Mesos-DNS hostnames, or if Mesos-DNS truncates app IDs to create identical Mesos-DNS hostnames, applications will communicate with the wrong agent nodes and fail unpredictably.

# <a name="dns-naming"></a>Discovering the DNS names for a service

You can get a comprehensive list of the apps running on your DC/OS cluster nodes.

**Prerequisites:** [DC/OS and DC/OS CLI](/docs/1.8/administration/installing/) are installed.

1.  SSH into your node. For example, use this CLI command to SSH to your master:
    
    ```bash
    $ dcos node ssh --leader --master-proxy
    ``` 
    
    For more information, see the SSH [documentation]/docs/1.8/administration/access-node/sshcluster/.

2.  Run this command from your master node to view the node details:
    
    ```bash
    $ curl http://master.mesos:8123/v1/enumerate
    ``` 
    
    In this example, Kafka and Chronos are installed:
    
    ```bash
       $ curl http://master.mesos:8123/v1/enumerate
         {
           "frameworks": [
            {
             "tasks": null,
             "name": "chronos"
            },
            {
             "tasks": null,
             "name": "kafka"
            },
            {
             "tasks": [
              {
               "name": "kafka",
               "id": "kafka.443d5d63-f527-11e5-81a5-2a8c0aaf83b5",
               "records": [
                {
                 "name": "kafka.marathon.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "kafka-7fdws-s0.marathon.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "kafka.marathon.slave.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "kafka-7fdws-s0.marathon.slave.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "_kafka._tcp.marathon.slave.mesos.",
                 "host": "kafka-7fdws-s0.marathon.slave.mesos.:14799",
                 "rtype": "SRV"
                },
                {
                 "name": "_kafka._udp.marathon.slave.mesos.",
                 "host": "kafka-7fdws-s0.marathon.slave.mesos.:14799",
                 "rtype": "SRV"
                },
                {
                 "name": "_kafka._tcp.marathon.mesos.",
                 "host": "kafka-7fdws-s0.marathon.mesos.:14799",
                 "rtype": "SRV"
                }
               ]
              },
              {
               "name": "chronos",
               "id": "chronos.40a4f462-f527-11e5-81a5-2a8c0aaf83b5",
               "records": [
                {
                 "name": "chronos.marathon.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "chronos-4dj75-s0.marathon.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "chronos.marathon.slave.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "chronos-4dj75-s0.marathon.slave.mesos.",
                 "host": "10.0.2.162",
                 "rtype": "A"
                },
                {
                 "name": "_chronos._tcp.marathon.slave.mesos.",
                 "host": "chronos-4dj75-s0.marathon.slave.mesos.:9106",
                 "rtype": "SRV"
                },
                {
                 "name": "_chronos._udp.marathon.slave.mesos.",
                 "host": "chronos-4dj75-s0.marathon.slave.mesos.:9106",
                 "rtype": "SRV"
                },
                {
                 "name": "_chronos._tcp.marathon.mesos.",
                 "host": "chronos-4dj75-s0.marathon.mesos.:9106",
                 "rtype": "SRV"
                }
               ]
              }
             ],
             "name": "marathon"
            }
           ]
    ```       





 [1]: /docs/1.8/overview/concepts/
 [2]: ../troubleshooting/#leader
 [3]: https://tools.ietf.org/html/rfc952
