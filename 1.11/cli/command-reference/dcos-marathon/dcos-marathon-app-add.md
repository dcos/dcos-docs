---
post_title: dcos marathon app add
menu_order: 1
---

# Description
Add an application.

# Usage

```bash
dcos marathon app add <app-resource> [OPTION]
```

# Options

None.

# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<app-resource>`   |             |  Path to a file or HTTP(S) URL that contains the app's JSON definition. If omitted, the definition is read from stdin. For a detailed description, see the [documentation](/docs/1.10/deploying-services/marathon-api/). |

# Parent command

| Command | Description |
|---------|-------------|
| [dcos marathon](/docs/1.10/cli/command-reference/dcos-marathon/) | Deploy and manage applications to DC/OS. |

# Examples

## Deploy a simple app

In this example, a simple app is deployed to DC/OS Marathon.

1.  Create an app definition file named `my-app.json` with these contents.

    ```bash
    {
        "id": "/my-app",
        "container": {
        "type": "DOCKER",
        "docker": {
              "image": "group/image",
              "network": "BRIDGE",
              "portMappings": [
                { "hostPort": 80, "containerPort": 80, "protocol": "tcp"}
              ]
            }
        },
        "instances": 1,
        "cpus": 0.1,
        "mem": 64
    }
    ```
    
1.  Add your app to Marathon:

    ```bash
    dcos marathon app add <my-app.json>
    ```
    
    If this is added successfully, there is no output.
    
1.  Verify that the app is added with this command:

    ```bash
    dcos marathon app list
    ```
    
    The output should look like this:
    
    ```bash
     ID     MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD
    /myApp   64  0.1    0/1    ---      scale       DOCKER   None
    ```