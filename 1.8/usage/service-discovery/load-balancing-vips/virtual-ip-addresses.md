---
post_title: Using Virtual IP Addresses
menu_order: 10
---
DC/OS can map traffic from a single Virtual IP (VIP) to multiple IP addresses and ports. DC/OS VIPs are **name-based**, which means clients connect with a service address instead of an IP address. DC/OS automatically generates name-based VIPs that do not collide with IP VIPs, so you don’t have to worry about collisions. This feature allows name-based VIPs to be created automatically when the service is installed.

A named VIP contains 3 components:

 * Private virtual IP address
 * Port (a port which the service is available on)
 * Service name

You can assign a VIP to your application from the DC/OS web interface. The values you enter when you deploy a new service are translated into the appropriate `portDefininitions` or `portMappings` entry in your Marathon application definition.

* VIPs follow the naming convention `<service-name>.marathon.l4lb.thisdcos.directory:<port>`.

## Prerequisite:

*   A pool of VIP addresses that are unique to your application.

## Create a VIP:

1.  From the DC/OS [web interface](/docs/1.8/usage/webinterface/), click on the **Services** tab and either click your service name or click **Deploy Service** to create a new service.

    *   Select the **Network** tab.
    *   To edit an existing application, click **Edit**. You can then select the **Network** menu option.

2.  Check the **Load Balanced** checkbox, then fill in the **LB Port**, **Name**, and **Protocol** fields. As you fill in these fields, the service addresses that Marathon sets up will appear at the bottom of the screen. You can assign multiple VIPs to your app by clicking **+ Add an endpoint**.

    **Tip:** Toggle to **JSON Mode** to in the DC/OS web interface to edit the JSON directly and to see the application definition you have created.

    The resulting JSON includes a `portDefinitions` field with the VIP you specified:
    
    ```json
    {
      "id": "/my-service",
      "cmd": "sleep 10",
      "cpus": 1,
      "portDefinitions": [
        {
          "protocol": "tcp",
          "port": 5555,
          "labels": {
            "VIP_0": "/my-service:5555"
          },
          "name": "my-vip"
        }
      ]
    }
    ```

    In the example above, clients can access the service at `my-service.marathon.l4lb.thisdcos.directory:5555`.
    
    Alternatively, you can create a service with a VIP from the DC/OS CLI. Create a file with your application definition JSON, then launch the service on DC/OS:
    
    ```bash
    $ dcos marathon app add <service-name>.json
    ```
    
* Whether your application definition requires `portMappings` or `portDefinitions` depends on whether you are using BRIDGE or HOST networking. If you create your service in the DC/OS web interface, the appropriate field is selected for you. For more information on port configuration, see the [Marathon ports documentation][1].

## Using VIPs with DC/OS Services

Certain DC/OS services, such as Kafka, automatically create VIPs when you install them. The naming convention is: `broker.<service.name>.l4lb.thisdcos.directory:9092`.

To view the VIP for Kafka, run `dcos kafka connection` from the DC/OS CLI. 

```bash
$ dcos kafka connection
```
Here is a sample response:

```json
{
    "address": [
        "10.0.0.211:9843",
        "10.0.0.217:10056",
        "10.0.0.214:9689"
    ],
    "dns": [
        "broker-0.kafka.mesos:9843",
        "broker-1.kafka.mesos:10056",
        "broker-2.kafka.mesos:9689"
    ],
    "vip": "broker.kafka.l4lb.thisdcos.directory:9092",
    "zookeeper": "master.mesos:2181/dcos-service-kafka"
}
```

You can use this VIP to address any one of the Kafka brokers in the cluster.

 [1]: http://mesosphere.github.io/marathon/docs/ports.html
