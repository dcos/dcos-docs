---
post_title: Quick Start
feature_maturity: experimental
menu_order: 0
---

### Prerequisites
- DC/OS [installed](/docs/1.9/administration/installing/)
- DC/OS CLI [installed](/docs/1.9/usage/cli/install/)

# Launching a pod from the DC/OS CLI

1.  Create a JSON application definition with contents similar to this example. In this example, we will call the file `simple-pod.json`. <!-- Validated. JSH 9/30/16 -->

    ```json
    {
        "id": "/simplepod",
        "scaling": { "kind": "fixed", "instances": 1 },
        "containers": [
            {
                "name": "sleep1",
                "exec": { "command": { "shell": "sleep 1000" } },
                "resources": { "cpus": 0.1, "mem": 32 }
            }
        ],
        "networks": [ {"mode": "host"} ]
    }
    ```

    **Note:** The pod ID (the `id` parameter in the pod specification above) is used for all interaction with the pod once it is created.

1.  Launch the pod on DC/OS with the following DC/OS CLI command:

    ```bash
    $ dcos marathon pod add simple-pod.json
    ```

1. Verify the status of your pod.

    ```
    dcos marathon pod show simplepod
    ```

# Launching a pod from the DC/OS UI

You can also launch a pod from the [**Services**](/docs/1.9/usage/webinterface) tab of the DC/OS web interface. Select **Services -> Services -> RUN A SERVICE -> Multi-container (Pod)**, then toggle to JSON mode and paste in the application definition supplied above.

If you already have other services running, go to **Services -> Services**, then click the **+** on the upper right hand side.

After you launch your pod, you’ll see your new pod on the **Services** tab of the DC/OS web interface. Click the pod to see information about the status of the containers in your pod.

![Pods UI](../img/pods-service-dashboard.png)
