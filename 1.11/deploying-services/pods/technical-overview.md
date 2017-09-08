---
post_title: Technical Overview
feature_maturity: preview
menu_order: 10
---

A pod is a special kind of Mesos task group, and the tasks or containers in the pod are the group members. A pod instance’s containers are launched together, atomically, via the [Mesos LAUNCH_GROUP](https://github.com/apache/mesos/blob/cfeabec58fb2a87076f0a2cf4d46cdd02510bce4/docs/executor-http-api.md#launch_group) call.

DC/OS handles and represents pods as single services. Containers in pods share networking namespace and ephemeral volumes.

You configure a pod via a pod definition, which is similar to a Marathon application definition. There are nonetheless some differences between pod and application definitions. For instance:

- You must specify an endpoint (not a port number) in order for other applications to communicate with your pod.
- Pods have a separate REST API.
- Pods support only Mesos-level health checks. with the DC/OS CLI or via the /v2/pods/ endpoint of the [Marathon REST API](/docs/1.10/deploying-services/marathon-api/).

# Networking
Marathon pods only support the [DC/OS Universal container runtime](/docs/1.10/deploying-services/containerizers/), which supports multiple image formats, including Docker.

The Universal container runtime simplifies networking by allowing the containers of each pod instance to share a network namespace and communicate over a VLAN or private network. If you specify a container network without a name in a pod definition, it will be assigned to the default network. If you have installed DC/OS using [AWS templates](/docs/1.10/installing/cloud/aws/), the default network is `dcos`.

If other applications need to communicate with your pod, specify an endpoint in your pod definition. Other applications will communicate with your pod by addressing those endpoints. See [the Examples section](/docs/1.10/deploying-services/pods/examples/) for more information.

In your pod definition, you can declare a `host` or `container` network type. Pods created with `host` type share the network namespace of the host. Pods created with `container` type use virtual networking. If you specify the `container` network type and Marathon was not configured to have a default network name, you must also declare a virtual network name in the `name` field. See the [Examples](/docs/1.10/deploying-services/pods/examples/) section for the full JSON.

# Ephemeral Storage
Containers within a pod share ephemeral storage. Volumes are declared at the pod-level and referenced by `name` when mounting them into specific containers.

# Pod Events and State

 When you update a pod that has already launched, the new version of the pod will only be available when redeployment is complete. If you query the system to learn which version is deployed before redeployment is complete, you may get the previous version as a response. The same is true for the status of a pod: if you update a pod, the change in status will not be reflected in a query until redeployment is complete.

 History is permanently tied to `pod_id`. If you delete a pod and then reuse the ID, even if the details of the pod are different, the new pod will have the previous history (such as version information).

# Pod Definitions
Pods are configured via a JSON pod definition, which is similar to a Marathon [application definition](/docs/1.10/deploying-services/creating-services/). You must declare the resources required by each container in the pod because Mesos, not Marathon, determines how and when to perform isolation for all resources requested by a pod. See the [Examples](#examples) section for complete pod definitions.

# Environment variables
Environment variables defined at the pod level are propagated to all pod containers. Pod-level environment variables are overridden by environment variables defined at the pod container level.

Environment variables for ports are defined using the pod container endpoint names ( i.e ENDPOINT_<ENDPOINT_NAME>=<PORT>)

Below are example environment variables reflecting the [multi-pod JSON pod definition example](/docs/1.10/deploying-services/pods/examples/#multi-pod).

```
MESOS_EXECUTOR_ID=instance-test-pod.c2b47e5c-d1f5-11e6-a247-a65e72d2dda4
MARATHON_CONTAINER_RESOURCE_DISK=32.0
SHLVL=1
EP_CONTAINER_HTTPENDPOINT=8080
PYTHON_PIP_VERSION=9.0.1
MARATHON_CONTAINER_RESOURCE_MEM=32.0
ENDPOINT_HTTPENDPOINT=8080
GPG_KEY=97FC712E4C024BBEA48A61ED3A5CA953F73C700D
EP_HOST_HTTPENDPOINT2=21529
MARATHON_APP_ID=/test-pod
EP_CONTAINER_HTTPENDPOINT2=8081
ENDPOINT_HTTPENDPOINT2=8081
MARATHON_CONTAINER_RESOURCE_CPUS=0.1
PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MESOS_SANDBOX=/mnt/mesos/sandbox
MARATHON_CONTAINER_RESOURCE_GPUS=0
HOST=10.0.1.60
PYTHON_VERSION=3.5.2
MARATHON_APP_VERSION=2017-01-03T20:46:54.497Z
MARATHON_APP_LABELS=
MARATHON_CONTAINER_ID=healthtask1
PWD=/mnt/mesos/sandbox
EP_HOST_HTTPENDPOINT=21528
```

## Executor Resources

The executor runs on each node to manage the pods. By default, the executor reserves 32 MB and .1 CPUs per pod for overhead. Take this overhead into account when declaring resource needs for the containers in your pod. You can modify the executor resources in the `executorResources` field of your pod definition.

```json
{
    "executorResources": {
        "cpus": 0.1,
        "mem": 64,
        "disk": 10mb
    }
}
```

## Secrets

Specify a secret in the `secrets` field of your pod definition. The argument should be the fully qualified path to the secret in the store.

```json
{
    "secrets": {
        "someSecretName": { "source": "/fully/qualified/path" }
    }
}
```

## Volumes

Pods support ephemeral volumes, which are defined at the pod level. Your pod definition must include a `volumes` field that specifies at least the name of the volume and a `volumeMounts` field that specifies at least the name and mount path of the volume.

```json
{
	"volumes": [
		{
			"name": "etc"
		}
	]
}
```

```json
{
	"volumeMounts": [
		{
			"name": "env",
			"mountPath": "/mnt/etc"
		}
	]
}
```

Pods also support host volumes. A pod volume parameter can declare a `host` field that references a pre-existing file or directory on the agent.
```json
{
	"volumes": [
		{
			"name": "local",
			"host": "/user/local"
		}
	]
}
```

**Note:** Data does not persist if pods are restarted.

## Containerizers

Marathon pods support the [DC/OS Universal container runtime](/docs/1.10/deploying-services/containerizers/). The Universal container runtime [supports multiple images, such as Docker](http://mesos.apache.org/documentation/latest/container-image/).

The following JSON specifies a Docker image for a pod:

```json
{  
   "image":{  
      "id":"mesosphere/marathon:latest",
      "kind":"DOCKER",
      "forcePull":false
   }
}
```

# Limitations

- Only Mesos-based health checks are currently supported.
- Readiness checks are not supported.
- Service ports are not supported.
- Dependencies cannot be configured.
- Generic environmental variables, such as `$PORT0`, are not passed.
