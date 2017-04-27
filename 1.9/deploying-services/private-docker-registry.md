---
post_title: Using a Private Docker Registry 
menu_order: 004.5
---

To supply credentials to pull from a private Docker registry, create an archive of your Docker credentials, then add it as a URI in your application definition.

# Step 1: Compress Docker credentials

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
    $ cp docker.tar.gz /etc/
    ```

    **Important:** The URI must be accessible by all nodes that will start your application. You can distribute the
file to the local filesystem of all nodes, for example via RSYNC/SCP, or store it on a shared network drive like [Amazon
S3](http://aws.amazon.com/s3/). Consider the security implications of your chosen approach carefully.

# Step 2: Add URI path to app definition

1. Add the path to the archive file login credentials to your app definition.

    ```bash
    "uris": [
       "file:///etc/docker.tar.gz"
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
          "image": "some.docker.host.com/namespace/repo",
          "network": "HOST"
        }
      },
      "uris":  [
          "file:///etc/docker.tar.gz"
      ]
    }
    ```

1. The Docker image will now pull using the security credentials you specified.
