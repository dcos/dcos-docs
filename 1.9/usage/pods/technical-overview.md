---
post_title: Technical Overview
feature_maturity: experimental
menu_order: 10
---

A pod is a special kind of Mesos task group, and the tasks or containers in the pod are the group members. A pod instance’s containers are launched together, atomically, via the [Mesos LAUNCH_GROUP](https://github.com/apache/mesos/blob/cfeabec58fb2a87076f0a2cf4d46cdd02510bce4/docs/executor-http-api.md#launch_group) call.

DC/OS handles and represents pods as single services. Containers in pods share networking namespace and ephemeral volumes.

You configure a pod via a pod definition, which is similar to a Marathon application definition. There are nonetheless some differences between pod and application definitions. For instance:
                                                                                                                                                                                 
- You must specify an endpoint (not a port number) in order for other applications to communicate with your pod.
- Pods have a separate REST API.
- Pods support only Mesos-level health checks.
You can create and manage pods with the DC/OS CLI or via the /v2/pods/ endpoint of the [Marathon REST API](http://mesosphere.github.io/marathon/docs/generated/api.html).

# Networking
Marathon pods only support the [DC/OS Universal container runtime](/docs/1.9/usage/containerizers/), which supports multiple image formats, including Docker.

The Universal container runtime simplifies networking by allowing the containers of each pod instance to share a network namespace and communicate over localhost. If you specify a container network without a name in a pod definition, it will be assigned to the default network.

If other applications need to communicate with your pod, specify an endpoint in your pod definition. Other applications will communicate with your pod by addressing those endpoints. See [the Examples section](/docs/1.9/usage/pods/examples/) for more information.

In your pod definition, you can declare a `host` or `container` network type. Pods created with `host` type share the network namespace of the host. Pods created with `container` type use virtual networking. If you specify the `container` network type and Marathon was not configured to have a default network name, you must also declare a virtual network name in the `name` field. See the [Examples](/docs/1.9/usage/pods/examples/) section for the full JSON.

# Ephemeral Storage
Containers within a pod share ephemeral storage. Volumes are declared at the pod-level and referenced by `name` when mounting them into specific containers.

# Pod Events and State

 When you update a pod that has already launched, the new version of the pod will only be available when redeployment is complete. If you query the system to learn which version is deployed before redeployment is complete, you may get the previous version as a response. The same is true for the status of a pod: if you update a pod, the change in status will not be reflected in a query until redeployment is complete.
 
 History is permanently tied to `pod_id`. If you delete a pod and then reuse the ID, even if the details of the pod are different, the new pod will have the previous history (such as version information).

# Pod Definitions
Pods are configured via a JSON pod definition, which is similar to a Marathon [application definition](/docs/1.9/usage/marathon/application-basics/). You must declare the resources required by each container in the pod because Mesos, not Marathon, determines how and when to perform isolation for all resources requested by a pod. See the [Examples](#examples) section for complete pod definitions.

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

## Containerizers

Marathon pods support the [DC/OS Universal container runtime](/docs/1.9/usage/containerizers/). The Universal container runtime [supports multiple images, such as Docker](http://mesos.apache.org/documentation/latest/container-image/).

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