---
post_title: Deploying a Docker-based Service
menu_order: 100
---

In this tutorial, you create a custom Docker image and deploy it to DC/OS.

## Prerequisites

*   [Docker][1] installed on your workstation
*   [Docker Hub][2] account
*   [DC/OS][3] installed
*   [DC/OS CLI][4] installed

# Create a custom Docker image

1.  Create a file named `index.html`. Paste the following markup into `index.html` and save:

    ```html
    <html>
        <body>
        <h1> Hello brave new world! </h1>
        </body>
    </html>
    ```

1.  Create a file named `Dockerfile`. Paste the following Docker commands into it and save:

    ```dockerfile
    FROM nginx:1.9
    COPY index.html /usr/share/nginx/html/index.html
    ```

1.  Build the Docker image, where `<username>` is your Docker Hub username:

    ```bash
    docker build -t <username>/simple-docker .
    ```
    
    The output should resemble:
    
    ```bash
    Sending build context to Docker daemon 3.072 kB
    Step 1 : FROM nginx:1.9
    1.9: Pulling from library/nginx
    51f5c6a04d83: Pull complete 
    a3ed95caeb02: Pull complete 
    640c8f3d0eb2: Pull complete 
    a4335300aa89: Pull complete 
    Digest: sha256:54313b5c376892d55205f13d620bc3dcccc8e70e596d083953f95e94f071f6db
    Status: Downloaded newer image for nginx:1.9
     ---> c8c29d842c09
    Step 2 : COPY index.html /usr/share/nginx/html/index.html
     ---> 61373621782c
    Removing intermediate container 225910aa385d
    Successfully built 61373621782c
    ```

1.  Log in to Docker Hub:

    ```bash
    docker login
    ```

1.  Push your image to Docker Hub, where `<username>` is your Docker Hub username:

    ```bash
    docker push <username>/simple-docker
    ```
    
    The output should resemble:
    
    ```bash
    The push refers to a repository [docker.io/<username>/simple-docker]
    6e2a0db36f4c: Pushed 
    5f70bf18a086: Mounted from library/nginx 
    49027b789c92: Mounted from library/nginx 
    20f8e7504ae5: Mounted from library/nginx 
    4dcab49015d4: Mounted from library/nginx 
    latest: digest: sha256:f733e23e1f5e83a29a223d0a7d30244b30c0d57d17aa0421d962019545d69c17 size: 2185
    ```

# Create a Docker app and deploy to DC/OS

1.  Create a Marathon app definition with the following contents and save as `hello-nginx.json`. In the `image` field, replace `<username>` with your Docker Hub username. In the `type` field, specify `MESOS` or `DOCKER` depending on which [containerizer runtime](/docs/1.11/deploying-services/containerizers/) you prefer.

    ```json
    {
      "id": "hello-nginx",
      "container": {
        "type": "[MESOS | DOCKER]",
        "docker": {
          "image": "<username>/simple-docker",
          "parameters": [
            {
              "key": "log-driver",
              "value": "none"
            } 
          ]
        },
        "portMappings": [
          { "hostPort": 80, "containerPort": 80, "protocol": "tcp" }
        ]
      },
      "networks": [
        {
          "mode": "container/bridge"
        }
      ],
      "acceptedResourceRoles": ["slave_public"],
      "instances": 1,
      "cpus": 0.1,
      "mem": 64
    }
    ```

    This file specifies a simple Marathon application called `hello-nginx` that runs one instance of itself on a public node.

3.  Add the `hello-nginx` application to Marathon by using the DC/OS command:

    ```bash
    dcos marathon app add hello-nginx.json
    ```

    If this is added successfully, there is no output.

4.  If you chose the MESOS runtime, you will see this when you verify that the app is added:

    ```bash
    dcos marathon app list
    ID            MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  WAITING  CONTAINER  CMD
    /hello-nginx   64  0.1    1/1    N/A       ---      False      MESOS    N/A
    ```
    
1.  If you used the [AWS CloudFormation templates](/docs/1.11/installing/cloud/aws/) to expose the app to the port specified in your app definition (e.g. port 80), you must reconfigure the health check on the public ELB. 
    1. In CloudFormation, check the checkbox next to your stack.
    2. Click the **Resources** tab.
    3. Search for **PublicSlaveLoadBalancer**.
    4. Click the link in the Physical ID column.
    5. Follow the instructions in [Update the Health Check Configuration](http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-healthchecks.html#update-health-check-config).

1.  Go to your public agent to see the site running. To find your public agent IP address, see [Finding a Public Agent IP](/docs/1.11/administering-clusters/locate-public-agent/).

    You should see the following message in your browser: 
    
    ![Hello Brave World](/docs/1.11/img/helloworld.png)
    
# Next steps

Learn how to load balance your app on a public node using [Marathon-LB](/docs/1.11/networking/marathon-lb/marathon-lb-basic-tutorial/).
    

 [1]: https://www.docker.com
 [2]: https://hub.docker.com
 [3]: /docs/1.11/installing/
 [4]: /docs/1.11/cli/install/
