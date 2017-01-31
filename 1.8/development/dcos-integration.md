---
post_title: DC/OS Integration
nav_title: DC/OS Integration
menu_order: 20
---

You can leverage several integration points when creating DC/OS Service. The sections below provide detailed explanations on how to integrate with each respective component.

# <a name="adminrouter"></a>Admin Router

When a DC/OS Service is installed and ran on DC/OS, the service is generally deployed on a [private agent node][3]. In order to allow users to access a running instance of the service, Admin Router can functions as a reverse proxy for the DC/OS Service.

Admin Router currently supports only one reverse proxy destination.

## Service Endpoints

Admin Router allows marathon tasks to define custom service UI and HTTP endpoints, which are made available as `/services/<service-name>`. This can be achieved by setting the following marathon task labels:

```
"labels": {
    "DCOS_SERVICE_NAME": "service-name",
    "DCOS_SERVICE_PORT_INDEX": "0",
    "DCOS_SERVICE_SCHEME": "http"
  }
```

In this case `http://<dcos-cluster>/services/service-name` would be forwarded to the host running the task using the first port allocated to the task.

In order for the forwarding to work reliably across task failures, we recommend co-locating the endpoints with the task. This way, if the task is restarted on a potentially other host and with different ports, Admin Router will pick up the new labels and update the routing. NOTE: Due to caching there might be an up to 30-second delay until the new routing is working.

We would recommend having only a single task setting these labels for a given service-name.
In the case of multiple task instances with the same service-name label, admin router will pick one of the tasks instances deterministically, but this might make debugging issues more difficult.

Since the paths to resources for clients connecting to Admin Router will differ from those paths the Service actually has, ensure the Service is friendly to running behind a proxy. This often means relative paths are preferred to absolute paths. In particular, resources expected to be used by a UI should be verified to work through a proxy.

Tasks running in nested [marathon app groups](https://mesosphere.github.io/marathon/docs/application-groups.html) will be available only using their service name (i.e, `/services/<service-name>`) and not considering the marathon app group name (i.e., `/services/app-group/<service-name>`).

# <a name="dcos-ui"></a>DC/OS UI

Service health check information can be surfaced in the DC/OS services UI tab by:

1. Defining one or more healthChecks in the Service's Marathon template, for example:

        "healthChecks": [
            {
                "path": "/",
                "portIndex": 1,
                "protocol": "HTTP",
                "gracePeriodSeconds": 5,
                "intervalSeconds": 60,
                "timeoutSeconds": 10,
                "maxConsecutiveFailures": 3
            }
        ]

2. Defining the label `DCOS_PACKAGE_FRAMEWORK_NAME` in the Service's Marathon template, with the same value that will be used when the framework registers with Mesos. For example:

         "labels": {
            "DCOS_PACKAGE_FRAMEWORK_NAME": "unicorn"
          }

3. Setting `.framework` to true in `package.json`

<!--
#### TODO: Add non-framework label based explanation here
-->

# <a name="cli-subcommand"></a>CLI Subcommand

If you would like to publish a DC/OS CLI Subcommand for use with your service it is common to have the Subcommand communicate with the running Service by sending HTTP requests through Admin Router to the Service.

See [dcos-helloworld][6] for an example on how to develop a CLI Subcommand.

[3]: /docs/1.8/administration/securing-your-cluster/
[6]: https://github.com/mesosphere/dcos-helloworld
