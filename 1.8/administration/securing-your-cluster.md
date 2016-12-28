---
post_title: Securing Your Cluster
nav_title: Securing Your Cluster
menu_order: 7
---

This topic discusses the security features in DC/OS and
best practices for deploying DC/OS securely.

## General security concepts

DC/OS is based on a Linux kernel and userspace. The same best practices for
securing any Linux system apply to securing DC/OS, including setting correct
file permissions, restricting root and normal user accounts, protecting
network interfaces with iptables or other firewalls, and regularly applying
updates from the Linux distribution used with DC/OS to ensure that system
libraries, utilities and core services like systemd and OpenSSH are secure.

## Security Zones

At the highest level we can distinguish three security zones in a DC/OS
deployment, namely the admin, private, and public security zones.

### Admin zone

The **admin** zone is accessible via HTTP/HTTPS and SSH connections, and
provides access to the master nodes. It also provides reverse proxy access to
the other nodes in the cluster via URL routing. For security, the DC/OS cloud
template allows configuring a whitelist so that only specific IP address
ranges are permitted to access the admin zone.

#### Steps for Securing Admin Router

By default, Admin Router will permit unencrypted HTTP traffic. This is not
considered secure, and you must provide a valid TLS certificate and redirect
all HTTP traffic to HTTPS in order to properly secure access to your cluster.

After you have a valid TLS certificate, install the certificate on each master.
Copy the certificate and private key to a well known location, such as under
`/etc/ssl/certs`. 

If you run HAProxy in front of Admin Router, you should secure the communication between them. For information about securing your communication, see the [documentation](/docs/1.8/administration/haproxy-adminrouter/).

### Private zone

The **private** zone is a non-routable network that is only accessible from
the admin zone or through the edge router from the public zone. Deployed
services are run in the private zone. This zone is where the majority of agent
nodes are run.

### Public zone

The optional **public** zone is where publicly accessible applications are
run. Generally, only a small number of agent nodes are run in this zone. The
edge router forwards traffic to applications running in the private zone.

The agent nodes in the public zone are labeled with a special role so that
only specific tasks can be scheduled here. These agent nodes have both public
and private IP addresses and only specific ports should be open in their
iptables firewall.

By default, when using the cloud-based installers such as the AWS
CloudFormation templates, a large number of ports are exposed to the Internet
for the public zone. In production systems, it is unlikely that you would
expose all of these ports. It's recommended that you close all ports except
80 and 443 (for HTTP/HTTPS traffic) and use
[Marathon-LB](/docs/1.8/usage/service-discovery/marathon-lb/) with HTTPS for
managing ingress traffic.

### Typical AWS deployment

A typical AWS deployment including AWS Load Balancers is shown below:

![Security Zones](../img/security-zones.jpg)

## Admin Router

Access to the admin zone is controlled by the Admin Router.

HTTP requests incoming to your DC/OS cluster are proxied through the Admin
Router (using [Nginx](http://nginx.org) with
[OpenResty](https://openresty.org) at its core). The Admin Router denies
access to most HTTP endpoints for unauthenticated requests. In order for a
request to be authenticated, it needs to present a valid authentication token
in its Authorization header. A token can be obtained by going through the
authentication flow, as described in the next section.

Authenticated users are authorized to perform arbitrary actions in their
cluster. That is, there is currently no fine-grained access control in DC/OS
besides having access or not having access to services.

See the [Security Administrator's Guide](/docs/1.8/administration/id-and-access-mgt/) for more information.
