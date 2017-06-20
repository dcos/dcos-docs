---
post_title: DC/OS API Reference
nav_title: API Reference
menu_order: 150
---

The DC/OS API is a collection of routes backed by [DC/OS components](/docs/1.9/overview/architecture/components/) that are made available through an API gateway called [Admin Router](/docs/1.9/overview/architecture/components/#admin-router).

<!-- Use html img for horizontal centering -->
<img src="/docs/1.9/img/dcos-api-routing.png" alt="DC/OS API Routing" style="display:block;margin:0 auto"/>


# API Gateway

Admin Router is an API gateway built on top of NGINX with the following goals:

- Present a unified control plane for the DC/OS API
- Proxy API requests to component services on master and agent nodes
- Enforce user authentication
- Serve up the DC/OS GUI

Admin Router runs on each DC/OS node in one of two configurations:

- **Admin Router Master** exposes the [Master Routes](/docs/1.9/api/master-routes/).

  This configuration runs on each master node and serves as the primary API gateway for interaction with DC/OS components.

- **Admin Router Agent** exposes the [Agent Routes](/docs/1.9/api/agent-routes/).

  This configuration runs on each agent node and provides routes for monitoring, debugging, and administration.

  Some agent routes, like logs and metrics, are proxied through the master Admin Router to allow external access.
Other routes, like component management, are for internal use only.

# Route Types

Admin Router exposes several types of routes:

- **Proxy Routes** retrieve resources from another URL.
- **File Routes** retrieve static files.
- **Lua Routes** execute Lua code to generate responses.
- **Redirect Routes** redirect to another URL.
- **Rewrite Routes** translate routes into other routes.


# Cluster Access

To determine the URL of your cluster, see [Cluster Access](/docs/1.9/api/access/).


# Versioning

Sections of the DC/OS API are versioned by component, route, or resource.

For details on the versioning mechanisms, see [Versioning](/docs/1.9/api/versioning/).


# Authentication

Some routes are unauthenticated, but most require an authentication token.

For details on how to obtain and use an authentication token, see [Authentication HTTP API Endpoint](/docs/1.9/security/iam-api/).


# Route Usage

- To determine the full URL of a API resource through a **proxy route**, join the cluster URL, route, and backend component resource path.

    ```
    <cluster-url>/<route>/<resource-path>
    ```

    For example, get the Mesos version from: `https://dcos.example.com/mesos/version`

- **File routes** have no backend component, but may serve a directory of files or a single file. So for file routes, specify the file path instead of the backend component resource path.

    ```
    <cluster-url>/<route>/<file-path>
    ```

    For example, get the DC/OS version of the cluster from: `https://dcos.example.com/dcos-metadata/dcos-version.json`

- **Lua routes** immediately execute code in Admin Router without proxying to an external backend component. So for Lua routes, no path is required after the route.

    ```
    <cluster-url>/<route>
    ```

     For example, get the public IP of the master node and cluster ID from: `https://dcos.example.com/metadata`

- **Rewrite and redirect routes** may pass through one or more other URLs or routes before returning a resource. So for those routes, follow the chain of URLs and routes to find the endpoint. The resource path will depend on the final endpoint.

    Most rewrites and redirects terminate in another DC/OS API route, with the notable exception of `/login`, which uses OpenID Connect to authorize with an external identity provider and then redirects back to the DC/OS API.
