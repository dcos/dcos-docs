---
post_title: Using a Private Docker Registry
menu_order: 004.5
---

To supply credentials to pull from a private Docker registry, create an archive of your Docker credentials, then add it as a URI in your service or pod definition. In Enterprise DC/OS, you can also [upload your private Docker registry credentials to the DC/OS Secret store](#secret-store-instructions) and reference it in your service or pod definition.

<a name="uri-instructions"></a>
# Referencing private Docker registry credentials as a URI

## Step 1: Compress Docker credentials

1. Log in to the private registry manually. Login creates a `.docker` folder and a `.docker/config.json` file in your home directory.

    ```bash
      docker login some.docker.host.com
      Username: foo
      Password:
      Email: foo@bar.com
    ```

1. Compress the `.docker` folder and its contents.

    ```bash
    cd ~
    tar -czf docker.tar.gz .docker
    ```
1. Verify that both files are in the archive.

    ```bash
      tar -tvf ~/docker.tar.gz

      drwx------ root/root         0 2015-07-28 02:54 .docker/
      -rw------- root/root       114 2015-07-28 01:31 .docker/config.json
    ```

1. Put the archive file in a location that is accessible to your application definition.

    ```bash
    cp docker.tar.gz /etc/
    ```

    **Important:** The URI must be accessible by all nodes that will start your application. You can distribute the file to the local filesystem of all nodes, for example via RSYNC/SCP, or store it on a shared network drive like [Amazon S3](http://aws.amazon.com/s3/). Consider the security implications of your chosen approach carefully.

## Step 2: Add URI path to service definition

1. Add the path to the archive file login credentials to your service definition.

    ```bash
    "fetch": [
      {
        "uri": "file:///etc/docker.tar.gz"
      }
    ]
    ```

    For example:

    ```json
    {  
      "id": "/some/name/or/id",
      "cpus": 1,
      "mem": 1024,
      "instances": 1,
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "some.docker.host.com/namespace/repo"
        }
      },
      "fetch": [
        {
          "uri": "file:///etc/docker.tar.gz"
        }
      ]
    }
    ```

    The Docker image will now pull using the provided security credentials.

<a name="secret-store-instructions"></a>
# Referencing private Docker registry credentials in the secrets store (Enterprise DC/OS only)

Follow these steps to add your Docker registry credentials to the [Enterprise DC/OS secrets store](https://docs.mesosphere.com/1.10/security/secrets/), and then reference that secret in your service definition.

**Note:** This functionality is available only with the [Universal Containerizer Runtime](/docs/1.10/deploying-services/containerizers/ucr/). If you need to use the Docker Engine, follow the [URI instructions](#uri-instructions) above.

## Step 1: Create a credentials file

1.  Manually log in to your private registry. This creates a `~/.docker` directory and a `~/.docker/config.json` file.

    ```bash
    docker login some.docker.host.com
    Username: foo
    Password:
    Email: foo@bar.com
    ```

1.  Check that you have the `~/.docker/config.json` file.

    ```bash
    ls ~/.docker
    config.json
    ```

    Your `config.json` file should look like this, where value of `auth` is a base64-encoded `username:password` string.

    ```json
    {
      "auths": {
          "https://index.docker.io/v1/": {
              "auth": "XXXXX",
              "email": "<your-email>"
          }
      }
    }
    ```

    **Note:** If you are using Mac OSX, you will need to manually encode your `username:password` string and modify your `config.json` to match the snippet above.

1. Add the `config.json` file to the DC/OS secret store. [Learn more about creating secrets](https://docs.mesosphere.com/1.9/security/secrets/create-secrets/).

   **Note:** As of DC/OS version 1.10.0, you can add a file to the secret store only using the DC/OS CLI.

   ```bash
   dcos security secrets create --value-file=config.json <path/to/secret>
   ```

   If you plan to follow the example below, enter the following command to add the secret:

   ```bash
   dcos security secrets create --value-file=config.json mesos-docker/pullConfig
   ```

## Step 2: Add the secret to your service or pod definition

### For a service

1. Add a location for the secret in the `secrets` parameter and a reference to the secret in the `docker.pullConfig` parameter.

   **Note:** This functionality is _only_ supported with the Universal Container Runtime: `container.type` must be `MESOS`.

   ```json
   {
      "id": "/mesos-docker",
      "container": {
        "docker": {
          "image": "<your/private/image>",
          "pullConfig": {
            "secret": "pullConfigSecret"
          }
        },
        "type": "MESOS"
      },
      "secrets": {
        "pullConfigSecret": {
          "source": "/mesos-docker/pullConfig"
        }
      },
      "args": ["hello"],
      "cpus": 0.2,
      "mem": 16.0,
      "instances": 1
   }
   ```

1. Add the service to DC/OS. If you are using the example above, `<svc-name>` is `mesos-docker`.

   ```
   dcos marathon app add <svc-name>.json
   ```

   The Docker image will now pull using the provided security credentials.

### For a pod

1. Add a location for the secret in the `secrets` parameter and a reference to the secret in the `containers.image.pullConfig` parameter.

   **Note:** This functionality is only supported if `image.kind` is set to `DOCKER`.

   ```json
   {
        "id":"/simple-pod",
        "containers":[
           {
             "name":"simpletask1",
             "exec":{
                 "command":{
                   "shell":"env && sleep 1000"
                 }
               },
             "resources":{
               "cpus":0.1,
               "mem":32
           },
           "image":{
               "kind":"DOCKER",
               "id":"<your/private/image>",
               "pullConfig":{
                 "secret":"pullConfigSecret"
              }
           }
        }
     ],
     "networks":[
         {
           "mode":"host"
         }
     ],
     "secrets":{
         "pullConfigSecret":{
           "source":"/pod/pullConfig"
        }
     }
   }
   ```

1. Add the pod to DC/OS. If you are using the example above, `<pod-name>` is `simple-pod`.

      ```
      dcos marathon pod add <pod-name>.json
      ```

   The Docker image will now pull using the provided security credentials.
