---
post_title: Developing DC/OS Services
nav_title: Developing Services
menu_order: 160
---

DC/OS includes a service packaging specification and a [repository](/docs/1.10/administering-clusters/repo/) that catalogs those packages. This section describes what is necessary to package and provide your own service on DC/OS.

# <a name="universe"></a>Universe package repository

The DC/OS Universe contains all of the services that are installable on DC/OS. For more information on DC/OS Universe, see the [GitHub Universe repository](https://github.com/mesosphere/universe).

# DC/OS service structure

Each DC/OS service in the Universe is comprised of JSON configuration files. These files are used create the packages that are installed on DC/OS.

| Filename               | Description                                                                                              | Required |
|------------------------|----------------------------------------------------------------------------------------------------------|----------|
| `config.json`            | Specifies the supported configuration properties, represented as a JSON-schema.                          | No       |
| `marathon.json.mustache` | Specifies a mustache template that creates a Marathon app definition capable of running your service.    | No       |
| `package.json`           | Specifies the high level metadata about the package.                                                     | Yes      |
| `resource.json`          | Specifies all of the required externally hosted resources (e.g. Docker images, HTTP objects and images). | No       |

For more information, see [Creating a DC/OS Package](https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md#step-3--creating-a-dcos-package).

# Publishing a package

All packaged services are required to meet a certain standard as defined by Mesosphere. For details on publishing a DC/OS service, see [Publish the package](https://github.com/mesosphere/universe/blob/version-3.x/docs/tutorial/GetStarted.md#step-5--publish-the-package).
