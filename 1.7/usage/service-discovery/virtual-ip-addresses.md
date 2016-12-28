---
post_title: Using Virtual IP Addresses
post_excerpt: ""
layout: docs.jade
---

[Ports management][1] in Marathon is a powerful and complex feature: many configurations are possible depending on the type of container and the specific requirements.

When you are running Marathon in a DC/OS cluster, you can use virtual addresses (VIPs) to make ports management easier. VIPs simplify inter-app communication and implement a reliable service-oriented architecture. VIPs map traffic from a single virtual address to multiple IP addresses and ports.

DC/OS can map traffic from a single Virtual IP (VIP) and port to multiple IP addresses and ports. A VIP contains 2 components:

 * Private virtual IP address
 * Port

The format for specifying a VIP is:

    <IP>:<port>

The IP should be allocated manually from the [private IPv4 address space][1].

You can assign a VIP and port to your application by using the DC/OS Marathon web interface. The values you enter in these fields are translated into the appropriate `portMapping` entry in your application definition. Toggle to `JSON mode` as you create your app to see and edit your application definition.

## Prerequisite:

*   A pool of VIP addresses that are unique to your application.

To create a VIP:

1.  From the DC/OS web interface, click on the **Services** tab and select **Marathon**.

    *   To create a new application, click **Create Application** and select the **Ports and Service Discovery** menu option.
    *   To edit an existing application, select your application and click the **Configuration** tab, then click **Edit**. You can then select the **Ports and Service Discovery** menu option.

        ![Marathon Ports](/docs/1.7/overview/img/ui-marathon-ports.gif)

2.  Enter the Port, Protocol, Name, and VIP address.

    **Tip:** Select **JSON Mode** to edit your application directly in JSON.

    For more information on port configuration, see the [ports documentation][2].

## Assigning Multiple VIPs to Your App

To assign multiple VIPs to your application, switch to JSON mode and add the additional VIPs to your `portDefinitions`. In this example, the additional VIP added is `"VIP_1": "172.16.0.1:5050"`:

    {
      "id": null,
      "cmd": "",
      "cpus": 1,
      "mem": 128,
      "disk": 0,
      "instances": 1,
      "ports": [
        0
      ],
      "portDefinitions": [
        {
          "port": 3333,
          "protocol": "tcp",
          "name": "test",
          "labels": {
            "VIP_0": "172.16.0.1:8080",
            "VIP_1": "172.16.0.1:5050"
          }
        },
        {
          "port": 0,
          "protocol": "tcp",
          "name": null,
          "labels": null
        }
      ]
    }
    
## Next steps

Learn how to easily deploy a [WordPress and MySQL](/docs/1.7/usage/tutorials/wordpress-mysql/) installation on a DC/OS cluster.

[1]: https://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
[2]: http://mesosphere.github.io/marathon/docs/ports.html