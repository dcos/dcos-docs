---
post_title: Service and Pod Networking
menu_order: 0.5
---

This document describes how to specify networking modes and assign ports in the service definition for a DC/OS Service you are creating.

# VIPs

We recommend using [virtual addresses (VIPs)](/docs/1.9/usage/service-discovery/virtual-ip-addresses/) to make ports management easier. VIPs map traffic from a single virtual address to multiple IP addresses and ports. They simplify inter-app communication and implement a reliable service-oriented architecture.

# Networking Modes

DC/OS services and pods declare `networks` the same way. Three modes of networking are supported:

## `host` Networking

In `host` networking, an application shares the network namespace of the Mesos agent process, typically the host network namespace.

**Note:** The `Network.name` parameter cannot be used with `host` networking.

## `container` Networking

In container networking, an application should be allocated its own network namespace and IP address;
Mesos network isolators are responsible for providing backend support for this.
When using the Docker containerizer, this translates to a Docker "user" network. You can name your container network in the `networks.container` parameter of your service definition. If you do not provide a name for your container network, it will have the default container network name, `DEFAULT NAME`.

## `container/bridge` Networking

Similar to `container` networking, an application should be allocated its own network namespace and IP address;
Mesos CNI provides a special `mesos-bridge` that application containers are attached to.
When using the Docker containerizer, this translates to the Docker "default bridge" network.

Bridge mode networking allows you to map host ports to ports inside your containers. It is particularly useful if you are using a container image with fixed port assignments that you can't modify.

**Notes:**:

- The UCR and Docker Containerizer support all network modes.
- The `Network.name` parameter is only supported with `container` networking.

# Usage

* A service can join one or more `container` mode networks. When joining multiple container networks, additional restrictions are imposed on *port-mapping* entries (see *Port Mappings* for details).
* An application can only join one `host` mode network. `host` networking is the default if your service definition does not declare a `networks` field.
* An application can only join one `container/bridge` network.
* An application cannot mix networking modes. You must specify a single `host` network, a single `container/bridge` network, or one or more `container` networks.

# Ports for Services

DC/OS services declare ports differently than pods. The following section is only relevant to services.

## Terminology

### Port Types

#### *container-port*: Specifies a port within a container.

`containerPort` is specified as a field of a *port-mapping* or *endpoint* when using `container` or `container/bridge` mode networking.

#### *host-port*: Specifies a port to allocate from the resources offered by a Mesos agent.

`hostPort` is specified as a field of a *port-mapping* or *endpoint* when using `container` or `container/bridge` mode networking. `port` is specified as a field of a *port-definition* when using `host` mode networking.

**Note:** Only host ports are made available to a task through environment variables.

#### *service-port*: You can assign one or more service ports to a DC/OS service when you create it.

You can specify any valid port number as a service port or you can use `0` to indicate that Marathon should allocate free service ports to your service automatically.

If you choose your own service port, you must ensure that it is unique across all of your applications.
See [the port definition section](#port-definition) for more information.

**Note:** Pods (endpoints) do not support service ports.

### Declaring ports in an application

#### *endpoint*

Endpoints are declared only by the containers of a Pod. See the [pods](/docs/1.9/deploying-services/pods/) documentation.

#### *port-definition*

Port definitions are used only with `host` mode networking.
A *port-definition* (specifically its `port` field) is interpreted through the lens of the `requirePorts` parameter:

- When `requirePorts` is `false` (default), a port-definition's `port` is considered the *service-port* and a *host-port* is dynamically chosen by Marathon.
- When `requirePorts` is `true`, a port-definition's `port` is considered both a *host-port* and *service-port*.
- The special `port` value of `0` tells Marathon to select any *host-port* from a Mesos resource offer and any *service-port* from the configured service port range.

#### *port-mapping*

A *port-mapping* declares a *container-port* for a service, possibly linking that *container-port* to a *host-port* and *service-port*.

Marathon communicates *container-port*/*host-port* links ("mappings") to Mesos when launching instances of the application. Port-mappings are used with both `container` and `container/bridge` networking. Marathon ignores the value of `requirePorts` when interpreting a *port-mapping*.

* The special `containerPort` value of `0` tells Marathon to internally assign the (eventually) allocated *host-port* to `containerPort`.
* The special `hostPort` value of `0` tells Marathon to select any *host-port* from a Mesos resource offer.
* The special `servicePort` value of `0` tells Marathon to select any *service-port* from the configured *service-port* range.

## Port Definitions
You can specify the ports that are available through the `portDefinitions` array.

By default, `requirePorts` is set to false. This means that you need to use a service discovery solution such as HAProxy to proxy requests from service ports to host ports. If you don't use a service discovery solution to proxy requests from service ports to host ports, you can set `requirePorts` to `true`. This will tell Marathon to only schedule the service on agents that have these ports available.

You can specify a `protocol`, a `name`, and `labels` for each definition in the `portDefinitions` array. When starting new tasks, Marathon will pass this metadata to Mesos. Mesos will expose this information in the `discovery` field of the task. Custom network discovery solutions can consume this field.

### Summary

* Review *port-definition*, *host-port*, and *service-port* in [Terminology][#Terminology].
* Location in service definition: `{ "portDefinitions": [ <port-definition>... ], "requirePorts": <bool>, ... }`
* Used in conjunction with `host` mode networking.
* `requirePorts` applies to `portDefinitions`.
* If no `portDefinitions` are defined (or defined as `null`) at create time, default to `{ "portDefinitions": [ { "port": 0, "name": "default" } ], ... }`
    * Specify an empty array (`[]`) to indicate NO ports are used by the service; no default is injected in this case.
* Ignored when used in conjunction with other networking modes.
    * NOTE: Future versions of Marathon may fail to validate apps that declare `portDefinitions` with network modes other than `host`.

## Port Mappings

### Summary:

* Review *port-mapping*, *container-port*, and *host-port* in (Terminology)[#Terminology].
* Location in service definition: `{ "container": { "portMappings": [ <port-mapping>... ], ... }, ... }`
* Used in conjunction with `container` and `container/bridge` mode networking.
* When using `container/bridge` mode networking, an unspecified (`null`) value for `hostPort` is translated to `"hostPort": 0`.
* `requirePorts` does not apply to `portMappings`.
* If unspecified (`null`) at create-time, defaults to `{ "portMappings": [ { "containerPort": 0, "name": "default" } ], ... }`
    * Specify an empty array (`[]`) to indicate NO ports are used by the service; no default is injected in this case.
    * **NOTE:** When using `container/bridge` mode, the default *port-mapping* also sets `"hostPort: 0"`.
* Ignored when used in conjunction with other networking modes.
    * **NOTE:** Future versions of Marathon may fail to validate services that declare `container.portMappings` with network modes other than `container` or `container/bridge`.
* When used in conjunction with multiple container networks, each mapping entry that specifies a `hostPort` must also declare a `networkNames` value with a single item, identifying the network for which the mapping applies (a single `hostPort` may be mapped to only one container network, and `networkNames` defaults to all container networks for a pod or service).

## Referencing Ports

Once you have created your port mappings, you can reference the `host-port`s in a Dockerfile as follows:

```bash
CMD ./my-app --http-port=$PORT_HTTP --https-port=$PORT_HTTPS --monitoring-port=$PORT_MON
```

Alternatively, if you are not using Docker, or had specified a `cmd` in your service definition, it works in the same way:

```json
"cmd": "./my-app --http-port=$PORT_HTTP --https-port=$PORT_HTTPS --monitoring-port=$PORT_MON"
```

# Downward API

## Per-Task Environment Variables

If a port is named `NAME`, it will be accessible via the environment variable `$PORT_NAME`.

Every *host-port* value is also exposed to the running service instance via environment variables `$PORT0`, `$PORT1`, etc.

Each DC/OS service is given a single port by default, so `$PORT0` will normally be available, except for services that specifically declare "no ports".

Variables are generated for all services, regardless of whether the service uses the [UCR or Docker containerizer](/docs/1.9/deploying-services/containerizers/).

It is **highly recommended** to name the ports of a service to provide clarity with respect to the service configuration and intended use of each port.

When using `container` or `container/bridge` mode networking, you must bind your application to the `containerPort`s you have specified in your `portMapping`s.

If you have set `containerPort` to `0`, this will be the same as `hostPort` and you can use the `$PORTxxx` environment variables.

## Discovery Via Mesos

### `DiscoveryInfo` and port `labels`

* `labels` may be defined for items of `portDefinitions` as well as for items of `portMappings`. These labels are sent to Mesos via `DiscoveryInfo` protobufs at instance-launch time.
* Given a mapping or endpoint, Marathon generates a port `DiscoveryInfo` for every combination of specified protocols and associated networks. For instance, if an `Endpoint` specifies 2 protocols and is associated with 3 container networks, then a total of 6 `DiscoveryInfo` protobufs would be generated for that single `Endpoint`.
* Marathon injects a `network-scope` label into the port `DiscoveryInfo` to disambiguate between a *host-port* and *container-port*.
    * A scope value of `host` is used for *host-port* discovery.
    * A scope value of `container` is used for *container-port* discovery.
* For *container-port* discovery, Marathon also injects a `network-name` label into the respective port `DiscoveryInfo`.

### Virtual addresses

See the documentation for [virtual addresses (VIPs)](/docs/1.9/networking/load-balancing-vips/virtual-ip-addresses/).

# Examples

## `host` Mode

`host` mode networking is the default networking mode for all services. If your service uses Docker containers, it not necessary to `EXPOSE` ports in your `Dockerfile`.

### Using `host` Mode

Host mode is enabled by default for all services and all container types.
If you wish to be explicit, you can also specify it manually in the `networks` property:

```json
  "networks": [ { "mode": "host" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    }
  },
```

### Specifying Ports

You can specify the ports that are available through the `portDefinitions` array:

```json
    "portDefinitions": [
      {"port": 0, "name": "http"}, {"port": 0, "name": "https"}, {"port": 0, "name": "mon"}
    ],
```

In this example, we specify three dynamically assigned host ports, which would then be available to our command via the environment variables `$PORT_HTTP`, `$PORT_HTTPS` and `$PORT_MON`.

Marathon will also associate three dynamically selected service ports with these three host ports.

You can also specify specific service ports:

```json
    "portDefinitions": [
        {"port": 2001, "name": "http"}, {"port": 2002, "name": "https"}, {"port": 3000, "name": "mon"}
    ],
```

In this case, host ports `$PORT_HTTP`, `$PORT_HTTPS`, and `$PORT_MON` remain dynamically assigned.
However, the three service ports for this application are now `2001`, `2002` and `3000`.

In this example, as with the previous one, it is necessary to use a service discovery solution such as HAProxy to proxy requests from service ports to host ports.

If you want your service's service ports to be equal to its host ports, you can set `requirePorts` to `true` (`requirePorts` is `false` by default). This will tell Marathon to only schedule the service on agents that have these ports available. You may wish to do this if you don't use a service discovery solution to proxy requests from service ports to host ports.

```json
    "portDefinitions": [
        {"port": 2001, "name": "http"}, {"port": 2002, "name": "https"}, {"port": 3000, "name": "mon"}
    ],
    "requirePorts" : true
```

The service and host ports (including the environment variables `$PORT_HTTP`, `$PORT_HTTPS`, and `$PORT_MON`), are both now `2001`, `2002` and `3000`.

Each *port-definition* in a `portDefinitions` array allows you to specify a `protocol`, a `name`, and `labels` for each definition. When starting new tasks, Marathon will pass this metadata to Mesos. Mesos will expose this information in the `discovery` field of the task. Custom network discovery solutions can consume this field.

Example *port-definition* requesting a dynamic `tcp` port named `http` with the label `VIP_0` set to `10.0.0.1:80`:

```json
    "portDefinitions": [
        {
            "port": 0,
            "protocol": "tcp",
            "name": "http",
            "labels": {"VIP_0": "10.0.0.1:80"}
        }
    ],
```

The `port` field is mandatory.
The `protocol`, `name`, and `labels` fields are optional.

### Referencing Ports

You can reference the *host-port*s in the Dockerfile for our fictitious app as follows:

```bash
CMD ./my-app --http-port=$PORT_HTTP --https-port=$PORT_HTTPS --monitoring-port=$PORT_MON
```

Alternatively, if you are not using Docker, or had specified a `cmd` in your service definition, it works in the same way:

```json
"cmd": "./my-app --http-port=$PORT_HTTP --https-port=$PORT_HTTPS --monitoring-port=$PORT_MON"
```

## `container` and `container/bridge` Mode

Bridge mode networking allows you to map host ports to ports inside your containers.
It is particularly useful if you are using a container image with fixed port assignments that you can't modify.
**Note:** It is not necessary to `EXPOSE` ports in your Dockerfile when using Docker container images.

### Enabling `container/bridge` Mode

Specify `container/bridge` mode through the `networks` property:

```json
  "networks": [ { "mode": "container/bridge" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    }
  },
```

### Enabling `container` Mode

Specify `container` mode through the `network` property:

```json
  "networks": [ { "mode": "container", "name": "someUserNetwork" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    }
  }
```

If there is a `--default_network_name` configured for Marathon, then specifying a network name for the `container` network is optional:
`container` networks with an unspecified (`null`) `name` will inherit the value of the `--default_network_name` flag.

### Specifying Ports

Port mappings are similar to passing `-p` into the Docker command line and specify a relationship between a port on the host machine and a port inside the container.

In this case, the `portMappings` array is used **instead** of the `portDefinitions` array used in host mode.

Port mappings are specified inside a `container` object:

```json
  "networks": [ { "mode": "container/bridge" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    },
    "portMappings": [
      { "containerPort": 0, "hostPort": 0, "name": "http" },
      { "containerPort": 0, "hostPort": 0, "name": "https" },
      { "containerPort": 0, "hostPort": 0, "name": "mon" }
    ]
  }
```

In this example, we specify 3 mappings.
A value of `0` will ask Marathon to dynamically assign a value for `hostPort`.
In this case, setting `containerPort` to `0` will cause it to have the same value as `hostPort`.
These values are available inside the container as `$PORT_HTTP`, `$PORT_HTTPS` and `$PORT_MON` respectively.

Alternatively, if our process running in the container had fixed ports, we might do something like the following:

```json
  "networks": [ { "mode": "container/bridge" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    },
    "portMappings": [
      { "containerPort": 80, "hostPort": 0, "name": "http" },
      { "containerPort": 443, "hostPort": 0, "name": "https" },
      { "containerPort": 4000, "hostPort": 0, "name": "mon" }
    ]
  }
```

In this case, Marathon will randomly allocate host ports and map these to ports `80`, `443` and `4000` respectively.
The `$PORT_xxx` variables refer to the host ports.
In this case, `$PORT_HTTP` will be set to the value of `hostPort` for the first mapping, and so on.

#### Specifying Protocol

You can also specify the protocol for these port mappings.
The default is `tcp`:

```json
  "networks": [ { "mode": "container/bridge" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    },
    "portMappings": [
      { "containerPort": 80, "hostPort": 0, "name": "http", "protocol": "tcp" },
      { "containerPort": 443, "hostPort": 0, "name": "https", "protocol": "tcp" },
      { "containerPort": 4000, "hostPort": 0, "name": "mon", "protocol": "udp" }
    ]
  }
```

#### Specifying Service Ports

By default, Marathon will create associated service ports for each of these declared mappings and dynamically assign them values.
Service ports are used by service discovery solutions and it is often desirable to set these to well known values.
You can assign well-known *service-port* values by defining a `servicePort` for each mapping:

```json
  "networks": [ { "mode": "container/bridge" } ],
  "container": {
    "type": "MESOS",
    "docker": {
      "image": "my-image:1.0"
    },
    "portMappings": [
      { "containerPort": 80, "hostPort": 0, "name": "http", "protocol": "tcp", "servicePort": 2000 },
      { "containerPort": 443, "hostPort": 0, "name": "https", "protocol": "tcp", "servicePort": 2001 },
      { "containerPort": 4000, "hostPort": 0, "name": "mon", "protocol": "udp", "servicePort": 3000 }
    ]
  },
```

In this example, the host ports `$PORT_HTTP`, `$PORT_HTTPS` and `$PORT_MON` remain dynamically assigned.
However, the service ports for this application are now `2001`, `2002` and `3000`.
An external proxy, like HAProxy, may be configured to route from the service ports to the host ports.

#### Referencing Ports

If you set `containerPort` to `0`, then you should specify ports in the Dockerfile for our fictitious app as follows:

```bash
CMD ./my-app --http-port=$PORT_HTTP --https-port=$PORT_HTTPS --monitoring-port=$PORT_MON
```

However, if you have defined non-zero `containerPort` values, use the same values in the Dockerfile:

```bash
CMD ./my-app --http-port=80 --https-port=443 --monitoring-port=4000
```

Alternatively, you can specify a `cmd` in your Marathon application definition:

```json
"cmd": "./my-app --http-port=$PORT_HTTP --https-port=$PORT_HTTPS --monitoring-port=$PORT_MON"
```

Or, if you've used fixed values:

```json
"cmd": "./my-app --http-port=80 --https-port=443 --monitoring-port=4000"
```
