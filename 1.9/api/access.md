---
post_title: Cluster Access
menu_order: 1
---

You can get the cluster URL by using the following methods:

- Log into the DC/OS GUI and copy the scheme and domain name from the browser address bar.
- Log into the DC/OS CLI and type `dcos config show core.dcos_url` to get the cluster URL.


## API ports

On the master nodes, Admin Router is accessible through standard ports: `80` (HTTP) and `443` (HTTPS, if enabled).

On the agent nodes, Admin Router Agent is accessible through port `61001` (HTTP).


## Agent node access

You can find the hostname of a specific agent node by using the following methods:

- Log into the DC/OS GUI, navigate to the Nodes page, and copy the hostname of the desired node.
- Log into the DC/OS CLI, list the nodes with `dcos node`, and copy the hostname of the desired node.

To determine which agents are public agents, see [Finding a Public Agent IP](/docs/1.9/administering-clusters/locate-public-agent/).


## Ingress

In most production deployments, administrative access to the cluster should be routed through an external proxy to the DC/OS master nodes, distributing traffic load between the master nodes. For example, the default AWS templates configure an AWS Elastic Load Balancer.

Master nodes and private agent nodes are usually not publicly accessible. For security reasons, ingress to these nodes should be controlled by a router or firewall. To manage the cluster, administrators and operators should use a VPN server inside the firewall, on the same networks as the DC/OS nodes. Using VPN ensures that you can securely access the nodes directly from your workstation.

Public agent nodes are usually publicly accessible. [Marathon-LB](/docs/1.9/networking/marathon-lb/) running on the public agent nodes can serve as reverse proxy and load balancer to applications running on the private agent nodes. For additional security, use external load balancing, either to intermediate load balancers, applications on the public nodes, or directly to applications on the private nodes. If you want to allow public access to the public nodes, you should configure firewalls to block access to all ports except those required for your applications.

In development or local deployments, you usually have direct access to the nodes by IP.

For more information, see [Securing Your Cluster](/docs/1.9/administering-clusters/).
