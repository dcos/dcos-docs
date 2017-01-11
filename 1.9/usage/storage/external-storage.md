---
post_title: External Persistent Volumes
menu_order: 1
feature_maturity: experimental
---

Use external volumes when fault-tolerance is crucial for your app. If a host fails, the native Marathon instance reschedules your app on another host, along with its associated data, without user intervention. External volumes also typically offer a larger amount of storage.

Marathon applications normally lose their state when they terminate and are relaunched. In some contexts, for instance, if your application uses MySQL, you’ll want your application to preserve its state. You can use an external storage service, such as Amazon's Elastic Block Store (EBS), to create a persistent volume that follows your application instance.

An external storage service enables your apps to be more fault-tolerant. If a host fails, Marathon reschedules your app on another host, along with its associated data, without user intervention.

## Configuring External Volumes

To use external volumes with DC/OS, you must enable them during installation. If you're installing DC/OS from the [AWS cloud templates][1], then your cluster will be configured to use Amazon EBS and you can skip this section. Otherwise, install DC/OS using the [CLI][2] or [Advanced][3] installation method with these special configuration settings:

1.  Specify your REX-Ray config in the `rexray_config` parameter in your `genconf/config.yaml` file. Consult the [REX-Ray documentation][4] for more information on how to create your configuration.
    
        rexray_config:
          rexray:
            loglevel: info
            modules:
              default-admin:
                host: tcp://127.0.0.1:61003
            storageDrivers:
            - ec2
            volume:
              unmount:
                ignoreusedcount: true

    This example configures REX-Ray to use Amazon's EBS for storage and IAM for authorization.
    
    **Note:** Setting `rexray.modules.default-admin.host` to `tcp://127.0.0.1:61003` is recommended to avoid port conflicts with tasks running on agents.

2.  If your cluster will be hosted on Amazon Web Services and REX-Ray is configured to use IAM, assign an IAM role to your agent nodes with the following policy:
    
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": [
                        "ec2:CreateTags",
                        "ec2:DescribeInstances",
                        "ec2:CreateVolume",
                        "ec2:DeleteVolume",
                        "ec2:AttachVolume",
                        "ec2:DetachVolume",
                        "ec2:DescribeVolumes",
                        "ec2:DescribeVolumeStatus",
                        "ec2:DescribeVolumeAttribute",
                        "ec2:CreateSnapshot",
                        "ec2:CopySnapshot",
                        "ec2:DeleteSnapshot",
                        "ec2:DescribeSnapshots",
                        "ec2:DescribeSnapshotAttribute"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                }
            ]
        }
        
    
    Consult the [REX-Ray documentation][5] for more information.
        

## Scaling your App

Apps that use external volumes can only be scaled to a single instance because a volume can only attach to a single task at a time. This may change in a future release.

If you scale your app down to 0 instances, the volume is detached from the agent where it was mounted, but it is not deleted. If you scale your app up again, the data that was associated with it is still be available.

## Create an Application with External Volumes

### Create an Application with a Marathon App Definition

You can specify an external volume in your Marathon app definition. [Learn more about Marathon application definitions][6].

#### Using a Mesos Container


    {
      "id": "hello",
      "instances": 1,
      "cpus": 0.1,
      "mem": 32,
      "cmd": "/usr/bin/tail -f /dev/null",
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
    

In the app definition above:

*   `containerPath` specifies where the volume is mounted inside the container. For Mesos external volumes, this must be a single-level path relative to the container; it cannot contain a forward slash (`/`). For more information, see [the REX-Ray documentation on data directories][7].

*   `name` is the name that your volume driver uses to look up your volume. When your task is staged on an agent, the volume driver queries the storage service for a volume with this name. If one does not exist, it is [created implicitly][8]. Otherwise, the existing volume is reused.

*   The `external.options["dvdi/driver"]` option specifies which Docker volume driver to use for storage. The only Docker volume driver provided with DC/OS is `rexray`. [Learn more about REX-Ray][9].

*   You can specify additional options with `container.volumes[x].external.options[optionName]`. The dvdi provider for Mesos containers uses `dvdcli`, which offers the options [documented here][10]. The availability of any option depends on your volume driver.

*   Create multiple volumes by adding additional items in the `container.volumes` array.

*   Volume parameters cannot be changed after you create the application.
    
    **Important:** Marathon will not launch apps with external volumes if `upgradeStrategy.minimumHealthCapacity` is greater than 0.5, or if `upgradeStrategy.maximumOverCapacity` does not equal 0.

#### Using a Docker Container

Below is a sample app definition that uses a Docker container and specifies an external volume:

    {
      "id": "/test-docker",
      "instances": 1,
      "cpus": 0.1,
      "mem": 32,
      "cmd": "/usr/bin/tail -f /dev/null",
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
    

*   The `containerPath` must be absolute for Docker containers.

**Important:** Refer to the [REX-Ray documentation][11] to learn which versions of Docker are compatible with the REX-Ray volume
driver.

### Create an Application with External Volumes from the DC/OS Web Interface

1. Click the **Services** tab, then **Deploy Service**.

1. If you are using a Docker Container, click **Container Settings** and configure your Docker container.

1. Click **Volumes** and enter your Volume Name and Container Path.
 
1. Click **Deploy**.

<a name="implicit-vol"></a>

### Implicit Volumes

The default implicit volume size is 16 GB. If you are using the Mesos containerizer, you can modify this default for a particular volume by setting `volumes[x].external.size`. You cannot modify this default for a particular volume if you are using the Docker containerizer. For both the Mesos and Docker containerizers, however, you can modify the default size for all implicit volumes by [modifying the REX-Ray configuration][4].

## Potential Pitfalls

*   You can only assign one task per volume. Your storage provider might have other limitations.

*   The volumes you create are not automatically cleaned up. If you delete your cluster, you must go to your storage provider and delete the volumes you no longer need. If you're using EBS, find them by searching by the `container.volumes.external.name` that you set in your Marathon app definition. This name corresponds to an EBS volume `Name` tag.

*   Volumes are namespaced by their storage provider. If you're using EBS, volumes created on the same AWS account share a namespace. Choose unique volume names to avoid conflicts.

* If you are using Docker, you must use a compatible Docker version. Refer to the [REX-Ray documentation][11] to learn which versions of Docker are compatible with the REX-Ray volume driver.

*   If you are using Amazon's EBS, it is possible to create clusters in different availability zones (AZs). If you create a cluster with an external volume in one AZ and destroy it, a new cluster may not have access to that external volume because it could be in a different AZ.

*   Launch time might increase for applications that create volumes implicitly. The amount of the increase depends on several factors which include the size and type of the volume. Your storage provider's method of handling volumes can also influence launch time for implicitly created volumes.

*   For troubleshooting external volumes, consult the agent or system logs. If you are using REX-Ray on DC/OS, you can also consult the systemd journal.

 [1]: /docs/1.9/administration/installing/cloud/aws/
 [2]: /docs/1.9/administration/installing/custom/cli/
 [3]: /docs/1.9/administration/installing/custom/advanced/
 [4]: https://rexray.readthedocs.io/en/v0.3.3/user-guide/config/
 [5]: http://rexray.readthedocs.io/en/v0.3.3/user-guide/storage-providers/
 [6]: https://mesosphere.github.io/marathon/docs/application-basics.html
 [7]: https://rexray.readthedocs.io/en/v0.3.3/user-guide/config/#data-directories
 [8]: #implicit-vol
 [9]: https://rexray.readthedocs.io/en/v0.3.3/user-guide/schedulers/
 [10]: https://github.com/emccode/dvdcli#extra-options
 [11]: https://rexray.readthedocs.io/en/v0.3.3/user-guide/schedulers/#docker-containerizer-with-marathon
