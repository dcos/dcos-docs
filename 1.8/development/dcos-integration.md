---
post_title: DC/OS Integration
nav_title: DC/OS Integration
menu_order: 20
---

You can leverage several integration points when creating DC/OS Service. The sections below provide detailed explanations on how to integrate with each respective component.

# <a name="adminrouter"></a>Admin Router

When a DC/OS Service is installed and ran on DC/OS, the service is generally deployed on a [private agent node][3]. In order to allow users to access a running instance of the service, Admin Router can functions as a reverse proxy for the DC/OS Service.

Admin Router currently supports only one reverse proxy destination.

In order to allow Admin Router to function as a reverse proxy for the DC/OS Service one of the following methods should be used

## Framework Web UI URL

If the DC/OS Service will register with Mesos as a framework, the `webui_url` framework property may be specified and will be used by Admin Router to proxy requests to the service.

* The URL must NOT end with a backslash (/). For example, this is good `internal.dcos.host.name:10000`, and this is bad `internal.dcos.host.name:10000/`.

Since the paths to resources for clients connecting to Admin Router will differ from those paths the Service actually has, ensure the Service is friendly to running behind a proxy. This often means relative paths are preferred to absolute paths. In particular, resources expected to be used by a UI should be verified to work through a proxy.

When the `webui_url` is provided, a link to the service will be available from the DC/OS UI. The link will be generated based on a convention of: `/service/<service_name>`. For example, `<dcos_host>/service/unicorn` is the proxy to the `webui_url`.

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