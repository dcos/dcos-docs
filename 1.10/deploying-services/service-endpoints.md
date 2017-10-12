---
post_title: Service Endpoints
menu_order: 3.32
---

Containerized services can be placed anywhere in the cluster. Many DC/OS services provide endpoints to allow clients to find them.

# Discovering endpoints
You can find a service's endpoints, if available, from the DC/OS GUI. Click **Services**, then the name of your service. Click the **Endpoints** tab.

## Discovering endpoints for certified DC/OS services
The following services also offer CLI commands and an API to discover endpoints: Cassandra, Confluent Kafka, DSE, Elastic, and HDFS.

- CLI:
  - List endpoint types: `dcos <package-name> endpoints`
  - View endpoints for an endpoint type: `dcos <package-name> endpoints <endpoint>`
- API:
  - List endpoint types: `<dcos-url>/service/<service-name>/v1/endpoints`
  - View endpoints for an endpoint type: `<dcos-url>/service/<service-name>/v1/endpoints/<endpoint>`

# Returned endpoints

Returned endpoints will include the following:
- `.autoip.dcos.thisdcos.directory` hostnames for each instance that will follow them if they're moved within the DC/OS cluster.
- A HA-enabled VIP hostname for accessing any of the instances (optional).
- A direct IP address for accessing the service if `.autoip.dcos.thisdcos.directory` hostnames are not resolvable.
- If your service is on a virtual network such as the `dcos` overlay network, then the IP will be from the subnet allocated to the host that the task is running on. It will not be the host IP. To resolve the host IP use Mesos DNS (`<task>.<service>.mesos`).

In general, the `.autoip.dcos.thisdcos.directory` endpoints will only work from within the same DC/OS cluster. From outside the cluster, you can either use direct IPs or set up a proxy service that acts as a frontend to your service instance. For development and testing purposes, you can use [DC/OS Tunnel](/docs/1.10/developing-services/tunnel/) to access services from outside the cluster, but this option is not suitable for production use.

## Connecting clients to endpoints

Refer to [the "Connecting Clients" documentation](https://docs.mesosphere.com/service-docs/), if available, for the DC/OS service you are running.
