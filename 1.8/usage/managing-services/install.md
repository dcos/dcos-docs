---
post_title: Deploying Services
nav_title: Deploying
menu_order: 000
---

You can install and deploy DC/OS services from a package repository, such as the [Mesosphere Universe](/docs/1.8/overview/concepts/#mesosphere-universe) or deploy your own user-created services.

### In this topic:

- [Installing Universe services](#install-universe)
- [Installing user-created services](#installing-user-created)
 
# <a name="install-universe">Installing Universe services

## CLI

The general syntax for installing a service with the CLI follows. 

```bash
$ dcos package install [--options=<config-file-name>.json] <servicename>
```

Use the optional `--options` flag to specify the name of the customized JSON file you created in [advanced configuration](/docs/1.8/usage/managing-services/config-universe-service/).

For example, you would use the following command to install Chronos with the default parameters.
    
```bash
$ dcos package install chronos
```
    
## Web interface

From the DC/OS web interface, you can install services from the **Services** or **Universe** tab. The Universe tab shows all of the available DC/OS services from package [repositories](/docs/1.8/usage/repo/). The Services tab provides a full-featured interface to the native DC/OS Marathon instance.


-  **Universe tab**

   1.  Navigate to the [**Universe**](/docs/1.8/usage/webinterface/#universe) tab in the DC/OS web interface.
   2.  Choose your package and click **Install package**. 
   3.  Confirm your installation or choose [**Advanced Installation**](/docs/1.8/usage/managing-services/config-universe-service/) to include a custom configuration.

-  **Services tab**

   1.  Navigate to the [**Services**](/docs/1.8/usage/webinterface/#services) tab in the DC/OS web interface.
   1.  Click **Deploy Service** and specify your Marathon app definition.
   1.  Click **Deploy**. 

## Verifying your installation

### CLI

```bash
$ dcos package list
```

### Web interface

Go to the **Services** tab and confirm that the service is running. For more information, see the web interface [documentation](/docs/1.8/usage/webinterface/#services).

**Tip:** Some services from the "Community Packages" section of the Universe will not show up in the DC/OS service listing. For these, inspect the service's Marathon app in the Marathon web interface to verify that the service is running and healthy.


# <a name="installing-user-created">Installing user-created services

## CLI

The general syntax for installing a service with the CLI follows. 

```bash
$ dcos marathon app add <myapp>.json
```

For more information, see [CLI command reference](/docs/1.8/usage/cli/command-reference/).
    
## Web interface

From the DC/OS web interface you can install services from the **Services** tab. The Services tab provides a full-featured interface to the native DC/OS Marathon instance.

1.  Navigate to the [**Services**](/docs/1.8/usage/webinterface/#services) tab in the DC/OS web interface.
1.  Click **Deploy Service** and specify your Marathon app definition.
1.  Click **Deploy**. 

## Verifying your installation

### CLI

```bash
$ dcos marathon app list
```

### Web interface

Go to the **Services** tab and confirm that the service is running. For more information, see the web interface [documentation](/docs/1.8/usage/webinterface/#services).

# Example

This tutorial shows how to create and deploy a simple one-command service and a containerized service using both the DC/OS web interface and the CLI.

### Prerequisites
- [A DC/OS cluster](/docs/1.8/administration/installing/)
- [DC/OS CLI installed](/docs/1.8/usage/cli/install/)

## Create and Run a Simple Service from the DC/OS Web Interface

1. Click the **Services** tab of the DC/OS web interface, then click the **Deploy Service**.
1. Enter a name for your service in the **ID** field. In the **Command** field, enter `sleep 10`.
1. Click **Deploy**.

    ![Create a service in the DC/OS UI](/docs/1.8/usage/tutorials/img/deploy-svs-ui.png)

1. That's it! Click the name of your service in the **Services** view to see it running and monitor health.

    ![Running service in the DC/OS UI](/docs/1.8/usage/tutorials/img/svc-running-ui.png)

## Create and Run a Simple Service from the DC/OS CLI

1. Create a JSON file called `my-app-cli.json` with the following contents:

    ```json
    {
      "id": "/my-app-cli",
      "cmd": "sleep 10",
      "instances": 1,
      "cpus": 1,
      "mem": 128,
      "disk": 0,
      "gpus": 0,
      "backoffSeconds": 1,
      "backoffFactor": 1.15,
      "maxLaunchDelaySeconds": 3600,
      "upgradeStrategy": {
        "minimumHealthCapacity": 1,
        "maximumOverCapacity": 1
      },
      "portDefinitions": [
        {
          "protocol": "tcp",
          "port": 10000
        }
      ],
      "requirePorts": false
    }
    ```

1. Run the service with the following command.
    ```bash
    $ dcos marathon app add my-app-cli.json
    ```

1. Run the following command to verify that your service is running:
    ```bash
    $ dcos marathon app list
    ```
    You can also click the name of your service in the **Services** view of the DC/OS web interface to see it running and monitor health.

## Create and Run a Containerized Service from the DC/OS Web Interface

1. Go to the `hello-dcos` page of the [Mesosphere Docker Hub repository](https://hub.docker.com/r/mesosphere/hello-dcos/tags/) and note down the latest image tag.
1. Click the **Services** tab of the DC/OS web interface, then click the **Deploy Service**.
1. Enter a name for your service in the **ID** field.
1. Click the **Container Settings** tab and enter the following in the **Container Image** field: `mesosphere/hello-dcos:<image-tag>`. Replace `<image-tag>` with the tag you copied in step 1.

    ![Containerized service in the DC/OS UI](/docs/1.8/usage/tutorials/img/deploy-container-ui.png)

1. Click **Deploy**.
1. In the **Services** tab, click the name of your service, then choose on of the task instances. Click **Logs**, then toggle to the **Output (stdout)** view to see the output of the service.

    ![Running containerized service in the DC/OS UI](/docs/1.8/usage/tutorials/img/container-running-ui.png)

## Create and Run a Containerized Service from the DC/OS CLI

1. Go to the `hello-dcos` page of the [Mesosphere Docker Hub repository](https://hub.docker.com/r/mesosphere/hello-dcos/tags/) and note down the latest image tag.
1. Create a JSON file called `hello-dcos-cli.json` with the following contents. Replace `<image-tag>` in the `docker:image` field with the tag you copied in step 1.
    ```
    {
      "id": "/hello-dcos-cli",
      "instances": 1,
      "cpus": 1,
      "mem": 128,
      "disk": 0,
      "gpus": 0,
      "backoffSeconds": 1,
      "backoffFactor": 1.15,
      "maxLaunchDelaySeconds": 3600,
      "container": {
        "docker": {
          "image": "mesosphere/hello-dcos:<image-tag>",
          "forcePullImage": false,
          "privileged": false,
          "network": "HOST"
        }
      },
      "upgradeStrategy": {
        "minimumHealthCapacity": 1,
        "maximumOverCapacity": 1
      },
      "portDefinitions": [
        {
          "protocol": "tcp",
          "port": 10001
        }
      ],
      "requirePorts": false
    }
    ```
1. Run the service with the following command.
    ```bash
    dcos marathon app hello-dcos-cli.json
    ```
1. Run the following command to verify that your service is running:
    ```bash
    $ dcos marathon app list
    ```
1. In the **Services** tab of the DC/OS web interface, click the name of your service, then choose on of the task instances. Click **Logs**, then toggle to the **Output (stdout)** view to see the output of the service.


# Next Steps

Try out this service [tutorial](/docs/1.8/usage/tutorials/create-service/). 