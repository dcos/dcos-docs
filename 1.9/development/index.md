---
post_title: Development of DC/OS Services
nav_title: Development
menu_order: 4
---

## <a name="universe"></a>Package Repositories

In DC/OS, the [Universe][1] contains packages that are installable as services in a cluster. Everyone is welcome and encouraged to submit a package to Universe. Some packages are "selected" by Mesosphere and are identified as such in the DC/OS UI and DC/OS CLI.

All services in the Universe are required to meet a standard as defined by the DC/OS project team. For details on publishing a release of a DC/OS service, see [Publish a Package][2] in the Universe documentation.

For detailed information about the JSON files of a package, see the [Universe][1] docs.

## <a name="dcos-integration"></a>DC/OS Integration

When creating DC/OS Service there are several integration points that can be leveraged. The sections below provide detailed explanations on how to integrate with each respective component.

### <a name="adminrouter"></a>Admin Router

When a DC/OS Service is installed and ran on DC/OS, the service is generally deployed on a [private agent node][3]. In order to allow users to access a running instance of the service, Admin Router can functions as a reverse proxy for the DC/OS Service.

Admin Router currently supports only one reverse proxy destination.

#### Service Endpoints

Admin Router allows marathon tasks to define custom service UI and HTTP endpoints, which are made available as `/service/<service-name>`. Set the following marathon task labels to enable this:

```
"labels": {
    "DCOS_SERVICE_NAME": "<service-name>",
    "DCOS_SERVICE_PORT_INDEX": "0",
    "DCOS_SERVICE_SCHEME": "http"
  }
```

In this case, `http://<dcos-cluster>/service/<service-name>` would be forwarded to the host running the task using the first port allocated to the task.

In order for the forwarding to work reliably across task failures, we recommend co-locating the endpoints with the task. This way, if the task is restarted on another host and with different ports, Admin Router will pick up the new labels and update the routing. **Note:** Due to caching, there can be an up to 30-second delay before the new routing is working.

We recommend having only a single task setting these labels for a given service name. If multiple task instances have the same service name label, Admin Router will pick one of the task instances deterministically, but this might make debugging issues more difficult.

Since the paths to resources for clients connecting to Admin Router will differ from those paths the service actually has, ensure the service is configured to run behind a proxy. This often means relative paths are preferred to absolute paths. In particular, resources expected to be used by a UI should be verified to work through a proxy.

Tasks running in nested [marathon app groups](https://mesosphere.github.io/marathon/docs/application-groups.html) will be available only using their service name (i.e., `/service/<service-name>`), not by the marathon app group name (i.e., `/service/app-group/<service-name>`).


### <a name="dcos-ui"></a>DC/OS UI

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

### <a name="cli-subcommand"></a>CLI Subcommand

If you would like to publish a DC/OS CLI Subcommand for use with your service it is common to have the Subcommand communicate with the running Service by sending HTTP requests through Admin Router to the Service.

See [dcos-helloworld][6] for an example on how to develop a CLI Subcommand.

## Package Guidelines

The following are a set of guidelines that should be considered when creating a DC/OS Package.

### `package.json`

* Focus the description on the service. Assume that all users are familiar with DC/OS and Mesos.
* The `tags` parameter is used for user searches (`dcos package search <criteria>`). Add tags that distinguish the service in some way. Avoid the following terms: Mesos, Mesosphere, DC/OS, and datacenter. For example, the unicorns service could have: `"tags": ["rainbows", "mythical"]`.
* The `preInstallNotes` parameter gives the user information they'll need before starting the installation process. For example, you could explain what the resource requirements are for the service: `"preInstallNotes": "Unicorns take 7 nodes with 1 core each and 1TB of ram."`
* The `postInstallNotes` parameter gives the user information they'll need after the installation. Focus on providing a documentation URL, a tutorial, or both. For example: `"postInstallNotes": "Thank you for installing the Unicorn service.\n\n\tDocumentation: http://<service-url>\n\tIssues: https://github.com/"`
* The `postUninstallNotes` parameter gives the user information they'll need after an uninstall. For example, further cleanup before reinstalling again and a link to the details. A common issue is cleaning up ZooKeeper entries. For example: `postUninstallNotes": "The Unicorn DC/OS Service has been uninstalled and will no longer run.\nPlease follow the instructions at http://<service-URL> to clean up any persisted state" }`

 [1]: http://mesosphere.github.io/universe/
 [2]: http://mesosphere.github.io/universe/#publish-a-package-1
 [3]: /docs/1.9/administration/securing-your-cluster/
 [4]: https://github.com/mesosphere/universe
 [5]: http://mesosphere.github.io/universe/#submit-your-package
 [6]: https://github.com/mesosphere/dcos-helloworld
