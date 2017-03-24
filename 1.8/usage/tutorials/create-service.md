---
post_title: Creating and Running a Service
nav_title: Running a Service
menu_order: 3
---

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
    dcos marathon app add my-app-cli.json
    ```

1. Run the following command to verify that your service is running:
    ```bash
    dcos marathon app list
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
    dcos marathon app list
    ```
1. In the **Services** tab of the DC/OS web interface, click the name of your service, then choose on of the task instances. Click **Logs**, then toggle to the **Output (stdout)** view to see the output of the service.
