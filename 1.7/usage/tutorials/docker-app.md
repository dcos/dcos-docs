---
post_title: Deploying a Docker-based Service to Marathon
nav_title: Docker Service
menu_order: 05
---

In this tutorial, a custom Docker app is created and added to Marathon.

### Prerequisites

*   [Docker][1] installed on your workstation
*   [Docker Hub][2] account
*   [DC/OS][3] installed
*   [DC/OS CLI][4] installed

## Create a custom Docker container

1.  In the `dcos` directory created by the DC/OS CLI installation script, create a new directory named `simple-docker-tutorial` and navigate to it:

    ```bash
    $ mkdir simple-docker-tutorial
    $ cd simple-docker-tutorial
    ```

2.  Create a file named `index.html` by using nano, or another text editor of your choice:

    ```bash
    $ nano index.html
    ```

3.  Paste the following markup into `index.html` and save:

    ```html
    <html>
        <body>
        <h1> Hello brave new world! </h1>
        </body>
    </html>
    ```

4.  Create and edit a Dockerfile by using nano, or another text editor of your choice:

    ```bash
    $ nano Dockerfile
    ```

5.  Paste the following commands into it and save:

    ```dockerfile
    FROM nginx:1.9
    COPY index.html /usr/share/nginx/html/index.html
    ```

6.  Build the container, where `<username>` is your Docker Hub username:

    ```bash
    $ docker build -t <username>/simple-docker .
    ```

7.  Log in to Docker Hub:

    ```bash
    $ docker login
    ```

8.  Push your container to Docker Hub, where `<username>` is your Docker Hub username:

    ```bash
    $ docker push <username>/simple-docker
    ```

## Add your Docker app to Marathon

1.  Create a file named `nginx.json` by using nano, or another text editor of your choice:

    ```bash
    $ nano nginx.json
    ```

2.  Paste the following into the `nginx.json` file. If you’ve created your own Docker container, replace the image name mesosphere with your Docker Hub username:

    ```json
    {
        "id": "nginx",
        "container": {
        "type": "DOCKER",
        "docker": {
              "image": "mesosphere/simple-docker",
              "network": "BRIDGE",
              "portMappings": [
                { "hostPort": 80, "containerPort": 80, "protocol": "tcp"}
              ]
            }
        },
        "acceptedResourceRoles": ["slave_public"],
        "instances": 1,
        "cpus": 0.1,
        "mem": 64
    }
    ```

    This file specifies a simple Marathon application called “nginx” that runs one instance of itself on a public node.

3.  Add the NGINX Docker container to Marathon by using the DC/OS command:

    ```bash
    $ dcos marathon app add nginx.json
    ```

    If this is added successfully, there is no output.

4.  Verify that the app is added:

    ```bash
    $ dcos marathon app list
    ID      MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD
    /nginx   64  0.1    0/1    ---      scale       DOCKER   None
    ```

 [1]: https://www.docker.com
 [2]: https://hub.docker.com
 [3]: /docs/1.7/administration/installing/
 [4]: /docs/1.7/usage/cli/install/
