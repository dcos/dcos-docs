---
post_title: Developing DC/OS Services
nav_title: Developing Services
menu_order: 160
---

This section describes the developer-specific DC/OS components, explaining what is necessary to package and provide your own service on DC/OS.

The Mesosphere Datacenter Operating System (DC/OS) provides the optimal user experience possible for orchestrating and managing a datacenter. If you are an Apache Mesos developer, you are already familiar with developing a framework. DC/OS extends Apache Mesos by including a web interface for health checks and monitoring, a command-line, a service packaging description, and a [repository](/docs/1.9/administering-clusters/repo/) that catalogs those packages.

# <a name="universe"></a>Package Repositories

The DC/OS Universe contains all of the services that are installable on DC/OS. For more information on DC/OS Universe, see the [GitHub Universe repository](https://github.com/mesosphere/universe).

All packaged services are required to meet a certain standard as defined by Mesosphere. For details on submitting a DC/OS service, see [Getting Started with Universe](https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md).

# <a name="adminrouter"></a>Admin Router and web interface integration

By default, a DC/OS service is deployed on a [private agent node](/docs/1.9/overview/concepts/#private-agent-node). To allow configuration control or monitoring of a service by a user, the Admin Router proxies calls on the master node to the service in a private node on the cluster. The HTTP service endpoint requires relative paths for artifacts and resources. The service endpoint can provide a web interface, a RESTful endpoint, or both. When creating a DC/OS CLI subcommand, it is common to have a RESTful endpoint to communicate with the scheduler service.

The integration to the Admin Router is automatic when a framework scheduler registers a `webui_url` during the registration process with the Mesos master. There are a couple of limitations:

*   The URL must NOT end with a forward slash (/). For example, this is good `internal.dcos.host.name:10000`, and this is bad `internal.dcos.host.name:10000/`.
*   DC/OS supports 1 URL and port.

When the `webui_url` is provided, the service is listed on the DC/OS web interface as a service with a link. That link is the Admin Router proxy URL name that is based on a naming convention of: `/service/<service_name>`. For example, `<dcos_host>/service/unicorn` is the proxy to the `webui_url`. If you provide a web interface, it will be integrated with the DC/OS web interface and users can click the link for quick access to your service.

Service health check information is provided from the DC/OS service tab when:

*   There are service health checks defined in the `marathon.json` file. For example:

```json
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
```

*   The `framework-name` property in the `marathon.json` file is valid. For example:
    
          "id": "{{kafka.framework-name}}"
        

*   The framework property in the `package.json` file is set to true. For example:
    
          "framework": true
        

You can provide public access to your service through the Admin Router or by deploying your own proxy or router to the public agent node. It is recommend to use the Admin Router for scheduler configuration and control, allowing integration with the DC/OS web interface. You can also provide a [CLI subcommand](/docs/1.9/developing-services/cli-spec/) for command-line control of a RESTful service endpoint for the scheduler.

# DC/OS service structure

Each DC/OS service in the Universe repo is comprised of JSON configuration files. These files are used create the packages that are installed on DC/OS.

| Filename               | Description                                                                                              | Required |
|------------------------|----------------------------------------------------------------------------------------------------------|----------|
| `config.json`            | Specifies the supported configuration properties, represented as a JSON-schema.                          | No       |
| `marathon.json.mustache` | Specifies a mustache template that creates a Marathon app definition capable of running your service.    | No       |
| `package.json`           | Specifies the high level metadata about the package.                                                     | Yes      |
| `resource.json`          | Specifies all of the required externally hosted resources (e.g. Docker images, HTTP objects and images). | No       |

For more information, see [Getting Started with Universe](https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md).
