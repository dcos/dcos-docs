---
post_title: External Persistent Volumes
menu_order: 20
feature_maturity: experimental
---

**Warning:** Volume size is specified in GiB.

Use external volumes when fault tolerance is crucial for your app. If a host fails, the native Marathon instance reschedules your app on another host, along with its associated data, without user intervention. External volumes also typically offer a larger amount of storage.

Marathon applications normally lose their state when they terminate and are relaunched. In some contexts, for instance, if your application uses MySQL, you’ll want your application to preserve its state. You can use an external storage service, such as Amazon's Elastic Block Store (EBS), to create a persistent volume that follows your application instance.

# Create an application with an external persistent volume

## Create an application with a Marathon app definition

You can specify an external volume in your [Marathon app definition][6].

### Using the Universal Container Runtime 

The `cmd` in this app definition appends the output of the `date` command to `test.txt`. You can verify that the external volume is being used correctly if you see that the logs of successive runs of the application show more and more lines of `date` output.

```json
{
  "id": "hello",
  "instances": 1,
  "cpus": 0.1,
  "mem": 32,
  "cmd": "date >> test-rexray-volume/test.txt; cat test-rexray-volume/test.txt",
  "container": {
    "type": "MESOS",
    "volumes": [
      {
        "containerPath": "test-rexray-volume",
        "external": {
          "size": 100,
          "name": "my-test-vol",
          "provider": "dvdi",
          "options": { "dvdi/driver": "rexray" }
          },
        "mode": "RW"
      }
    ]
  },
  "upgradeStrategy": {
    "minimumHealthCapacity": 0,
    "maximumOverCapacity": 0
  }
}
```

#### Volume configuration options

-  `containerPath`: The path where the volume is mounted inside the container. For Mesos external volumes, this must be a single-level path relative to the container; it cannot contain a forward slash (`/`). For more information, see [the REX-Ray documentation on data directories][7].
-  `mode`: The access mode of the volume. Currently, `"RW"` is the only possible value and will let your application read from and write to the volume.
-  `external.size`: The size of the volume in **GiB**.
-  `external.name`: The name that your volume driver uses to look up your volume. When your task is staged on an agent, the volume driver queries the storage service for a volume with this name. If one does not exist, it is [created implicitly][8]. Otherwise, the existing volume is reused.
-  `external.options["dvdi/driver"]`: which Docker volume driver to use for storage. The only Docker volume driver provided with DC/OS is `rexray`. Learn more about [REX-Ray][9].
-  You can specify additional options with `container.volumes[x].external.options[optionName]`. The dvdi provider for Mesos containers uses `dvdcli`, which offers the following [options][10]. The availability of any option depends on your volume driver.
-  Create multiple volumes by adding additional items in the `container.volumes` array.
-  You cannot change volume parameters after you create the application.
-  Marathon will not launch apps with external volumes if `upgradeStrategy.minimumHealthCapacity` is greater than 0.5, or if `upgradeStrategy.maximumOverCapacity` does not equal 0.

### Using a Docker Engine

Below is a sample app definition that uses a Docker Engine and specifies an external volume. The `cmd` in this app definition appends the output of the `date` command to `test.txt`. You can verify that the external volume is being used correctly if you see that the logs of successive runs of the application show more and more lines of `date` output. 

```json
{
  "id": "/test-docker",
  "instances": 1,
  "cpus": 0.1,
  "mem": 32,
  "cmd": "date >> /data/test-rexray-volume/test.txt; cat /data/test-rexray-volume/test.txt",
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "alpine:3.1",
      "network": "HOST",
      "forcePullImage": true
    },
    "volumes": [
      {
        "containerPath": "/data/test-rexray-volume",
        "external": {
          "name": "my-test-vol",
          "provider": "dvdi",
          "options": { "dvdi/driver": "rexray" }
        },
        "mode": "RW"
      }
    ]
  },
  "upgradeStrategy": {
    "minimumHealthCapacity": 0,
    "maximumOverCapacity": 0
  }
}
```

#### Volume configuration options

* `containerPath` must be absolute. 
*  Only certain versions of Docker are compatible with the REX-Ray volume driver. Refer to the [REX-Ray documentation][11].

## Create an application from the DC/OS web interface

1. Click the **Services** tab, then **RUN A SERVICE**.
1. If you are using a Docker container, click **Container Settings** and configure your container runtime.
1. Click **Volumes** and enter your Volume Name and Container Path.
1. Click **Deploy**.

<a name="implicit-vol"></a>

# Implicit volumes

The default implicit volume size is 16 GiB. If you are using the Universal Container Runtime, you can modify this default for a particular volume by setting `volumes[x].external.size`. You cannot modify this default for a particular volume if you are using the Docker Engine. For both runtimes, however, you can modify the default size for all implicit volumes by modifying the [REX-Ray configuration][4].

# Scaling your app

Apps that use external volumes can only be scaled to a single instance because a volume can only attach to a single task at a time.

If you scale your app down to 0 instances, the volume is detached from the agent where it was mounted, but it is not deleted. If you scale your app up again, the data that was associated with it is still be available.

# Potential pitfalls

*   You can assign only one task per volume. Your storage provider might have other limitations.
*   The volumes you create are not automatically cleaned up. If you delete your cluster, you must go to your storage provider and delete the volumes you no longer need. If you're using EBS, find them by searching by the `container.volumes.external.name` that you set in your Marathon app definition. This name corresponds to an EBS volume `Name` tag.
*   Volumes are namespaced by their storage provider. If you're using EBS, volumes created on the same AWS account share a namespace. Choose unique volume names to avoid conflicts.
*   If you are using Docker, you must use a compatible Docker version. Refer to the [REX-Ray documentation][11] to learn which versions of Docker are compatible with the REX-Ray volume driver.
*   If you are using Amazon's EBS, it is possible to create clusters in different availability zones (AZs). If you create a cluster with an external volume in one AZ and destroy it, a new cluster may not have access to that external volume because it could be in a different AZ.
*   Launch time might increase for applications that create volumes implicitly. The amount of the increase depends on several factors which include the size and type of the volume. Your storage provider's method of handling volumes can also influence launch time for implicitly created volumes.
*   For troubleshooting external volumes, consult the agent or system logs. If you are using REX-Ray on DC/OS, you can also consult the systemd journal.

[4]: https://rexray.readthedocs.io/en/v0.9.0/user-guide/config/
[5]: http://rexray.readthedocs.io/en/v0.9.0/user-guide/storage-providers/
[6]: /docs/1.10/deploying-services/creating-services/
[7]: https://rexray.readthedocs.io/en/v0.9.0/user-guide/config/#data-directories
[8]: #implicit-vol
[9]: https://rexray.readthedocs.io/en/v0.9.0/user-guide/schedulers/
[10]: https://github.com/emccode/dvdcli#extra-options
[11]: https://rexray.readthedocs.io/en/v0.9.0/user-guide/schedulers/#docker-containerizer-with-marathon
