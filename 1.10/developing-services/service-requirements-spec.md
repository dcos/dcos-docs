---
post_title: Service Requirements Specification
menu_order: 2
---

**Disclaimer:** This document provides the DC/OS Service requirements, but is not the complete DC/OS service certification. For the complete DC/OS Service Specification, send an email to <a href="mailto:partnerships@mesosphere.io" target="_blank">partnerships@mesosphere.io</a>.

This document is intended for a developer creating a Mesosphere DC/OS Service. It is assumed the you are familiar with <a href="http://mesos.apache.org/documentation/latest/app-framework-development-guide/" target="_blank">Mesos framework development</a>.

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in <a href="https://www.ietf.org/rfc/rfc2119.txt" target="_blank">RFC 2119</a>.

By completing the requirements below, you can integrate with DC/OS and have your service certified by Mesosphere.

## Terminology

### Universe
DC/OS Universe contains all services that have been certified by Mesosphere. For more information on DC/OS Universe, see the [GitHub Universe repository](https://github.com/mesosphere/universe).

### Framework
A Mesos framework is the combination of a Mesos scheduler and an optional custom executor. A framework receives resource offers describing CPU, RAM, etc., and allocates them for discrete tasks that can be launched on Mesos agent nodes. Mesosphere-certified Mesos frameworks, called DCOS services, are packaged and available from public [GitHub package repositories](https://github.com/mesosphere/universe). DCOS services include Mesosphere-certified Mesos frameworks and other applications.

### DC/OS Marathon
The native Marathon instance that is the “init system” for DCOS. It starts and monitors DCOS applications and services.

### State abstraction
Mesos provides an abstraction for accessing storage for schedulers for Java and C++ only. This is the preferred method to access ZooKeeper.


# Service

### 01. Service MUST be able to install the service without supplying a configuration.

Your service must be installable by using default values. The `options.json` must not be required for installation. There are cases where a service might require a license to work. Your service must provide a CLI option to pass the license information to the service to enable it.

If the service isn’t running because it is missing license information, that fact MUST be logged through stdout or stderr.

### 02. Service MUST be uninstallable.

A DC/OS user can uninstall your service with this command:

    dcos package uninstall <service name>
    

# Packaging

### 03. Service MUST use standard DC/OS packaging.

A DC/OS user must be able to install your service by running this command:

    dcos package install <service name>
    

For this to work, the metadata for your service must be registered in the Mesosphere Universe package repository. The metadata format is defined in the <a href="https://github.com/mesosphere/universe#mesosphere-universe-" target="_blank">Universe repository README</a>.

### 04. Service SHOULD have a simple lowercase service name.

The name of the service is the name provided in Universe. That name should be a simple name without reference to Mesos or DC/OS. For example, the HDFS-Mesos framework is listed in the universe as `hdfs`. This name should also be the first level property of the <a href="https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/H/hdfs/0/config.json#L4" target="_blank">config.json</a> file.

### 05. Service package MUST include a Marathon deployment descriptor file.

Services in DC/OS are started and managed by the native DC/OS Marathon instance. Your DC/OS service package MUST include a Marathon descriptor file (usually named `marathon.json`) which is used to launch the service. The Scheduler must be designed so that it can be launched by Marathon.

*   You MUST supply a <a href="https://github.com/mesosphere/universe#marathonjsonmustache" target="_blank">marathon.json.mustache</a> file as part of your Service metadata.
*   Your long-running app MAY use a Docker image retrieved by using a Docker registry or a binary retrieved by using a CDN backed HTTP server.

All resource configurations MUST be parameterized.

### 06. Service package MUST specify install-time configuration in a config.json file.

The Marathon descriptor file (`marathon.json.mustache`) must be templatized, following the examples in the Universe repository. All variables must be defined in the `config.json` file.

Any components that are dynamically configured, for example the Mesos master or ZooKeeper configuration, MUST be available as command line parameters or environment variables to the service executable. This allows the parameters to be passed to the scheduler during package installation.

### 07. Service package MUST specify framework-name in a config.json file.

The `framework-name` property is required. The `framework-name` property:

*   MUST be a second-level property under the service property. For example, see the HDFS <a href="https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/H/hdfs/1/config.json#L11-L15" target="_blank">config.json</a> file.
*   MUST default to the service name.
*   SHOULD be used as the `app-id` in the `marathon.json` file. For example, see the Spark <a href="https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/S/spark/2/marathon.json.mustache#L2" target="_blank">marathon.json.mustache</a> file.

### 08. All URIs used by the scheduler and executor MUST be specified in config.json.

All URIs that are used by the service MUST be specified in the `config.json` file. Any URL that is accessed by the service must be overridable and specified in the `config.json` file, including:

*   URLs required in the `marathon.json` file
*   URLs that retrieve the executor (if not supplied by the scheduler)
*   URLs required by the executors, except for URLs that are for the scheduler; or a process launched by the scheduler for retrieving artifacts or executors that are local to the cluster.

All URLs that are used by the service must be passed in by using the command line or provided as environment variables to the scheduler at startup time.

### 09. Service MUST provide a package.json file.

The `package.json` file MUST have:

*   The [name field][1] in `package.json` must match the package name in Universe and the default value for the `framework-name` parameter in `config.json`. See the [Chronos package][2] in Universe as an example. 
*   Contact email address of owner
*   Description
*   Indication of whether this is a framework
*   Tags
*   All images 
*   License information
*   Pre-install notes that indicate required resources
*   Post-install notes that indicate documentation, tutorials, and how to get support
*   Post-uninstall notes that indicate any documentation for a full uninstallation

For a reference example, see the [Marathon package][3].

### 10. Service MAY provide a command.json file.

The `command.json` file is required when a command line subcommand is provided by the service. This file specifies a Python wheel package for subcommand installation. For a reference example, see the [Spark package][4].

### 11. Service MAY provide a resource.json file.

The `resource.json` file is specified in the [Universe repository][5].

# Scheduler

### 12. Scheduler MUST provide a health check.

The app running in Marathon to represent your service, usually the scheduler, MUST implement one or more [Marathon health checks][6].

The output from these checks is used by the DC/OS web interface to display your service health:

*   If ALL of your health checks pass, your service is marked in green as Healthy.
*   If ANY of your health checks fail, your service is marked in red as Sick. Your documentation must provide troubleshooting information for resolving the issue.
*   If your Service has no tasks running in Marathon, your service is marked in yellow as Idle. This state is normally temporary and occurs only when your service is launching. 

Your app MAY set `maxConsecutiveFailures=0` on any of your health checks to prevent Marathon from terminating your app if the failure threshold of the health check is reached.

Services must have Health checks configured in the `marathon.json` file.

### 13. Scheduler MUST distribute its own binaries for executor and tasks.

The scheduler MUST attempt to run executors/tasks with no external dependencies. If an executor/task requires custom dependencies, the scheduler should bundle the dependencies and configure the Mesos fetcher to download the dependencies from the scheduler or run executors/tasks in a preconfigured Docker image.

Mesos can fetch binaries by using HTTP[S], FTP[S], HDFS, or Docker pull. Many frameworks run an HTTP server in the scheduler that can distribute the binaries, or just rely on pulling from a public or private Docker registry. Remember that some clusters do not have access to the public internet.

URLs for downloads must be parameterized and externalized in the `config.json` file, with the exception of Docker images. The scheduler and executor MUST NOT use URLS without externalizing them and allowing them to be configurable. This requirement ensures that DC/OS supports on-prem datacenter environments which do not have access to the public internet.

### 14. Configuration MUST be via CLI parameters or environment variables.

If your service requires configuration, the scheduler and executors MUST implement this by passing parameters on the command line or setting environment variables.

Secret or sensitive information should NOT include passwords as command-line parameters, since those are exposed by `ps`. Storing sensitive information in environment variables, files, or otherwise is fine.

Secrets/tokens themselves may be passed around as URIs, task labels, or otherwise. A hook may place those credentials on disk somewhere and update the environment to point to the on-disk credentials.

### 15. Service MAY provide a DC/OS CLI Subcommand.

Your Service MAY provide a custom DC/OS subcommand. For the DC/OS CLI Specification, send an email to <a href="mailto:partnerships@mesosphere.io" target="_blank">partnerships@mesosphere.io</a>.

### 16. A Service with a DC/OS CLI Subcommand MUST implement the minimum command set.

If providing a custom DC/OS CLI subcommand, you must implement the minimum set of requirements.

### 17. A Service with DC/OS CLI MUST be driven by HTTP APIs.

Custom subcommands must interact with your service by using HTTP. The supported method of interaction with your service is through the [DC/OS Admin Router][7]. Your service will be exposed under the convention `<dcos>/service/<service-name>`.

### 18. In config.json all required properties MUST be specified as required.

Any property that is used by the `marathon.json` file that is required MUST be specified in its appropriate required block. For an example, see Marathon’s [optional HTTPS mode][8] which makes the `marathon.https-port` parameter optional.

ALL properties that are used in the `marathon.json` file that are not in a conditional block must be defined as required.

 [1]: https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/C/chronos/0/package.json#L2
 [2]: https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/C/chronos/0/config.json#L98
 [3]: https://github.com/mesosphere/universe/tree/version-3.x/repo/packages/M/marathon/0
 [4]: https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/S/spark/2/command.json
 [5]: https://github.com/mesosphere/universe#resourcejson
 [6]: https://mesosphere.github.io/marathon/docs/health-checks.html
 [7]: /docs/1.10/overview/architecture/components/
 [8]: https://github.com/mesosphere/universe/blob/version-3.x/repo/packages/M/marathon/4/marathon.json#L10-L12
