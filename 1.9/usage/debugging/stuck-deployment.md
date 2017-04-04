---
post_title: Stuck Deployments
menu_order: 0
---

# How Offer Matching Works

DC/OS services or pods may fail to deploy because the Mesos resource offers are unable to match the resources requests coming from the service or pods [Marathon application definitions](/docs/1.9/usage/managing-services/creating-services/).

Here is an overview of the offer matching process.

1. You post a service or pod definition to Marathon either via the DC/OS CLI (`dcos marathon app add <my-service>.json`) or the DC/OS web interface. The app definition specifies resource requirements, placement constraints, and the number of instances to launch.

1. Marathon adds the new service or pod to the launch queue.

1. Every 5 seconds (by default), Mesos sends one offer per agent.

1. For each resource offer, Marathon checks if there is a service or pod in the launch queue whose requirements all match the offer. If Marathon finds a service or pod whose requirements match the offer, Marathon will launch the service or pod.

1. If a matching offer does not arrive that matches the requirements and constraints of a service or pod, Marathon is unable to launch the service or pod.

 **Note:** The required resources must all be available on a single host.

# Why Your Service or Pod is Stuck

There are several reasons why your service or pod may fail to deploy. Some possibilities include:

- Marathon isn't getting the resource offers it needs to launch the app.
  Use the [CLI](/docs/1.9/usage/debugging/cli-debugging/) debug subcommands or the [debugging page in the DC/OS web interface](/docs/1.9/usage/debugging/gui-debugging/) to troubleshoot unmatched or unaccepted resource offers from Mesos. You can also [consult the service and task logs](/docs/1.9/administration/logging/).

- The service's health check is failing.
  If a service has a health check, deployment does not complete until the health check passes. You can see the health of a service with Marathon health checks from [the DC/OS web interface](/docs/1.9/usage/debugging/gui-debugging/). To see more information about the health of a service with Marathon health checks, run `dcos marathon app list --json` from the DC/OS CLI.

- `docker pull` is failing.
  If your app runs in a Docker image, the Mesos agent node will first have to pull the Docker image. If this fails, your app could get stuck in a "deploying" state. The Mesos agent logs (`<dcos-url>/mesos/#/agents/`) will contain this information. You will see an error in the log similar to the following.

  ```
  6b50d4f5-05d6-4b99-bb63-115d5acd2aca-0000 failed to start: Failed to run 'docker -H unix:///var/run/docker.sock pull /mybadimage/fakeimage:latest': exited with status 1; stderr='Error parsing reference: "/mybadimage/fakeimage:latest" is not a valid repository/tag
  ```

- Your application or application group definition is otherwise badly configured.
  The DC/OS web interface performs some validation of Marathon application and pod definitions. You can also use the [marathon-validate](https://github.com/dcos-labs/marathon-validate) script to validate your app or group definition locally, before you deploy it to DC/OS.
