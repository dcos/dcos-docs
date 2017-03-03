---
post_title: Configure Your Service for GPUs
nav_title: Using GPUs
feature_maturity: experimental
menu_order: 75 
---

Once your cluster is [configured to support GPUs](/docs/1.9/administration/gpu/), add the `gpus` parameter to your [Marathon application definition](/docs/1.9/usage/marathon/application-basics/).

# Examples

## Simple GPU Application Definition
```
{
     "id": "simple-gpu-test",
     "acceptedResourceRoles":["slave_public", "*"],
     "cmd": "while [ true ] ; do nvidia-smi; sleep 5; done",
     "cpus": 1,
     "mem": 128,
     "disk": 0,
     "gpus": 1,
     "instances": 1
}
```

Once your service has deployed, check the contents of `stdout` to verify that the service is producing the proper output from the `nvidia-smi` command. You should see something like the following, repeated once every 5 seconds. Access the log [via the DC/OS CLI](/docs/1.9/administration/logging/quickstart/) or from the **Health** page for your service on the DC/OS dashboard.
```
+------------------------------------------------------+
| NVIDIA-SMI 352.79     Driver Version: 352.79         |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla M60           Off  | 0000:04:00.0     Off |                    0 |
| N/A   34C    P0    39W / 150W |     34MiB /  7679MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

You will also see an entry for **GPU** on the **Configuration** tab of the page for your service.

## Docker-Based Application Definition

**Important:** You must use the [DC/OS Universal Container Runtime](/docs/1.9/usage/containerizers/) to run a containerized application that uses GPUs. To use the Universal Container Runtime, set the container type to `MESOS`.
```
{
    "id": "docker-gpu-test",
    "acceptedResourceRoles":["slave_public", "*"],
    "cmd": "while [ true ] ; do nvidia-smi; sleep 5; done",
    "cpus": 1,
    "mem": 128,
    "disk": 0,
    "gpus": 1,
    "instances": 1,
    "container": {
      "type": "MESOS",
      "docker": {
        "image": "nvidia/cuda"
      }
    }
}
```

Once your service has deployed, check the contents of `stdout` to verify that the service is producing the proper output from the `nvidia-smi` command. You should see something like the following, repeated once every 5 seconds. Access the log [via the DC/OS CLI](/docs/1.9/administration/logging/quickstart/) or from the **Health** page for your service on the DC/OS dashboard.
```
+------------------------------------------------------+
| NVIDIA-SMI 352.79     Driver Version: 352.79         |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla M60           Off  | 0000:04:00.0     Off |                    0 |
| N/A   34C    P0    39W / 150W |     34MiB /  7679MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
```

You will also see an entry for **GPU** on the **Configuration** tab of the page for your service.

See [here for limitations and further information](/docs/1.9/usage/marathon/gpus/limitations/).
