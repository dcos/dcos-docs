---
post_title: Network Security in DC/OS
nav_title: Network Security
---
DC/OS provides the admin, private, and public security zones.

![Security Zones](../img/security-zones.jpg)

# Admin zone

The **admin** zone is accessible via HTTP/HTTPS and SSH connections, and provides access to your master nodes. It also provides proxy access to the other nodes in your cluster via URL routing. For security, you can configure a whitelist during [cluster creation][1] so that only specific IP address ranges are permitted to access the admin zone. The DC/OS cloud templates creates 1 or 3 Mesos master nodes in the admin zone.

When setting a cluster up yourself, we recommend that you configure an admin zone similarly.

# Private zone

The **private** zone is a non-routable network that is only accessible from the admin zone or through the edge router from the public zone. Deployed apps and services are run in the private zone. This zone is where the majority of Mesos agent nodes are run. By default, the DC/OS cloud templates creates 5 Mesos agent nodes in the private zone.

# Public zone

The optional **public** zone is where publicly accessible applications are run. Generally, only a small number of agent nodes are run in this zone. An edge router forwards traffic to applications running in the private zone. By default, the DC/OS cloud templates creates 1 agent node in the public zone.

The agent nodes in the public zone are labeled with a special role so that only specific tasks can be scheduled here. These agent nodes have both public and private IP addresses and only specific ports are open in the firewall.

# Limitations

*   The DC/OS CLI and web interface do not currently use an encrypted channel for communication. However, you can upload your own SSL certificate to the masters and change your CLI and web interface configuration to use HTTPS instead of HTTP.
*   We recommend that you secure your cluster by using security rules. It is strongly recommended that you only allow internal traffic.
*   If there is sensitive data in your cluster, follow standard policies for accessing that data. Either set up a point to point VPN between your secure networks or run a VPN server inside your DC/OS cluster.

 [1]: /docs/1.7/administration/installing/
