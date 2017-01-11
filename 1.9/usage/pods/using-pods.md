---
post_title: Using Pods
feature_maturity: experimental
menu_order: 20
---

You can create and manage your pods via the DC/OS CLI or via the `/v2/pods/` endpoint of the [Marathon REST API](http://mesosphere.github.io/marathon/docs/generated/api.html).

# Using the Pods CLI

The following commands are available in the pods CLI:

* `dcos marathon pod add [<pod-resource>]`
* `dcos marathon pod list [--json]`
* `dcos marathon pod remove [--force] <pod-id>`
* `dcos marathon pod show <pod-id>`
* `dcos marathon pod update [--force] <pod-id>`

## Add a Pod

To add a pod, first create a JSON pod definition. Then, run the following command:
```bash
$ dcos marathon pod add <pod-json-file>
```

## List Pods
List pods and the number of containers they have with the following command:
```bash
$ dcos marathon pod list
```

## Remove a Pod
Remove a pod with the following command:
```bash
$ dcos marathon pod remove <pod-id>
```

If the pod is currently deploying, you will not be able to remove the pod. To remove the pod anyway, run the command with the `--force` flag.

## Show Pod JSON
To see the pod definition, run the following command:
```bash
$ dcos marathon pod show <pod-id>
```
You can use the `show` command to read data about the pod programmatically.

## Update Pod
To update a pod, first modify the JSON definition for the pod, then run the following command: 

```bash
$ dcos marathon pod update <pod-id> < <new-pod-definition>
```

If the pod is currently deploying, you will not be able to update the pod. To update the pod anyway, run the command with the `--force` flag.

# Using the REST API 

## Create

```bash
 $ curl -X POST -H "Content-type: application/json" -d@<mypod>.json http://<ip>:<port>/v2/pods
```

Sample response:

```json
{
    "containers": [
        {
            "artifacts": [],
            "endpoints": [],
            "environment": {},
            "exec": {
                "command": {
                    "shell": "sleep 1000"
                }
            },
            "healthCheck": null,
            "image": null,
            "labels": {},
            "lifecycle": null,
            "name": "sleep1",
            "resources": {
                "cpus": 0.1,
                "disk": 0,
                "gpus": 0,
                "mem": 32
            },
            "user": null,
            "volumeMounts": []
        }
    ],
    "environment": {},
    "id": "/simplepod2",
    "labels": {},
    "networks": [
        {
            "labels": {},
            "mode": "host",
            "name": null
        }
    ],
    "scaling": {
        "instances": 2,
        "kind": "fixed",
        "maxInstances": null
    },
    "scheduling": {
        "backoff": {
            "backoff": 1,
            "backoffFactor": 1.15,
            "maxLaunchDelay": 3600
        },
        "placement": {
            "acceptedResourceRoles": [],
            "constraints": []
        },
        "upgrade": {
            "maximumOverCapacity": 1,
            "minimumHealthCapacity": 1
        }
    },
    "secrets": {},
    "user": null,
    "volumes": []
}
```

## Status

Get the status of all pods:

```bash
curl -X GET http://<ip>:<port>/v2/pods/::status
```

Get the status of a single pod:

```bash
curl -X GET http://<ip>:<port>/v2/pods/<pod-id>::status
```

## Delete

```bash
curl -X DELETE http://<ip>:<port>/v2/pods/<pod-id>
```