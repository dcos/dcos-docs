---
post_title: Developing Services
menu_order: 4
---

This section describes the developer-specific DC/OS components, explaining what is necessary to package and provide your own service on DC/OS.

The Mesosphere Datacenter Operating System (DC/OS) provides the optimal user experience possible for orchestrating and managing a datacenter. If you are an Apache Mesos developer, you are already familiar with developing a framework. DC/OS extends Apache Mesos by including a web interface for health checks and monitoring, a command-line, a service packaging description, and a [repository](/docs/1.8/usage/repo/) that catalogs those packages.

# <a name="universe"></a>Package Repositories

The DC/OS Universe contains all of the services that are installable on DC/OS. For more information on DC/OS Universe, see the [GitHub Universe repository](https://github.com/mesosphere/universe).

All packaged services are required to meet a certain standard as defined by Mesosphere. For details on submitting a DC/OS service, see [Getting Started with Universe](https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md).

# DC/OS service structure

Each DC/OS service in the Universe repo is comprised of JSON configuration files. These files are used create the packages that are installed on DC/OS.

| Filename               | Description                                                                                              | Required |
|------------------------|----------------------------------------------------------------------------------------------------------|----------|
| `config.json`            | Specifies the supported configuration properties, represented as a JSON-schema.                          | No       |
| `marathon.json.mustache` | Specifies a mustache template that creates a Marathon app definition capable of running your service.    | No       |
| `package.json`          | Specifies the high level metadata about the package.                                                     | Yes      |
| `resource.json`          | Specifies all of the required externally hosted resources (e.g. Docker images, HTTP objects and images). | No       |

For more information, see the [Creating a Universe Package](/docs/1.8/development/create-package/).
