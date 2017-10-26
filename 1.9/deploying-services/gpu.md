---
post_title: Using GPUs
feature_maturity: preview
menu_order: 110
---

DC/OS supports allocating GPUs (Graphics Processing Units) to your long-running DC/OS services. Adding GPUs to your services can dramatically accelerate big data workloads. 

With GPU-based scheduling, you can share cluster resources for traditional and machine learning workloads, as well as dynamically allocate GPU resources inside those clusters and free them when needed. You can reserve GPU resources for the workloads that need them, or pool these GPU-enabled resources with the rest of the infrastructure for higher overall utilization.

After installing DC/OS with GPUs enabled, you can specify GPUs in your application definitions with the `gpus` parameter.

# Installing DC/OS with GPUs Enabled
GPUs must be enabled during DC/OS installation. Follow the instructions below to enable GPUs based on your specific DC/OS deployment method.

## Custom DC/OS Installation with GPUs

1.  Install the [NVIDIA Management Library (NVML)](https://developer.nvidia.com/nvidia-management-library-nvml) on each node of your cluster that has GPUs. The minimum required NVIDIA driver version is 340.29. For detailed installation instructions, see the [Mesos GPU support documentation](http://mesos.apache.org/documentation/latest/gpu-support/#external-dependencies).
1.  Install DC/OS using the [custom advanced installation instructions](/docs/1.9/installing/custom/advanced/). Here are the GPU-specific configuration parameters:

    -  **enable_gpu_isolation**: Indicates whether to enable GPU support in DC/OS. By default, this is set to `enable_gpu_isolation: 'true'`. 
    -  **gpus_are_scarce**: Indicates whether to treat GPUs as a scarce resource in the cluster. By default, this is set to `gpus_are_scarce: 'true'`, which means DC/OS reserves GPU nodes exclusively for services that are configured to consume GPU resources. 
    
    For more information, see the [configuration parameter documentation](/docs/1.9/installing/custom/configuration/configuration-parameters/#enable_gpu_isolation) and Mesos [Nvidia GPU Support documentation](http://mesos.apache.org/documentation/latest/gpu-support/#external-dependencies). 

## AWS EC2 DC/OS Installation with GPUs

###  Prerequisites
- The AWS DC/OS advanced template [system requirements](/docs/1.9/installing/cloud/aws/advanced/).
- The `zen.sh` script copied to your local machine. The script and instructions are [here](/docs/1.9/installing/cloud/aws/advanced/).

### Create Dependencies

1. Run the `zen.sh` script to create the Zen template dependencies. These dependencies will be used as input to create your stack in CloudFormation.
  
   ```
   bash ./zen.sh <stack-name>
   ```
  
   **Important:** You must run the `zen.sh` script before performing the next steps.

1. Follow the instructions [here](/docs/1.9/installing/cloud/aws/advanced/) to create a cluster with advanced AWS templates, using the following GPU-specific configuration.

1. On the **Create Stack** > **Specify Details** page, specify your stack information and click **Next**. Here are the GPU-specific settings.
   
   - **CustomAMI** - Specify the custom AMI for your region:

      - us-west-2: `ami-9b5d97fb`
      - us-east-1: `ami-e10e50f6`
      - ap-southeast-2: `ami-37b28f54`
  
   - **MasterInstanceType** - Accept the default master instance type (e.g. `m3.xlarge`).
   - **PrivateAgentInstanceType** - Specify an [AWS GPU machine type](https://aws.amazon.com/ec2/instance-types/#p2) (e.g., `g2.2xlarge`).
   - **PublicAgentInstanceType** - Specify an [AWS GPU machine type](https://aws.amazon.com/ec2/instance-types/#p2) (e.g., `g2.2xlarge`).

1. On the **Options** page, accept the defaults and click **Next**.

   **Tip**: You can choose whether to rollback on failure. By default this option is set to **Yes**.

1. On the **Review** page, check the acknowledgement box, then click **Create**.

   **Tip**: If the **Create New Stack** page is shown, either AWS is still processing your request or you’re looking at a different region. Navigate to the correct region and refresh the page to see your stack.

# Using GPUs in Your Apps

You can specify GPUs in your application definitions with the `gpus` parameter.

-  You can only specify whole numbers of GPUs in your application definition. If a fractional amount is selected, launching the task will result in a `TASK_ERROR`.
-  NVIDIA GPU support is only available for tasks launched using the [DC/OS Universal container runtime](/docs/1.9/deploying-services/containerizers/). 

# Examples

## Simple GPU Application Definition
In this example, a simple sleep app is defined which uses GPUs.

1.  Create an an app definition named `simple-gpu-test.json`.

    ```json
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
  
1.  Launch your app using the DC/OS CLI:

    ```bash
    dcos marathon app add simple-gpu-test.json
    ```

    After your service has deployed, check the contents of `stdout` to verify that the service is producing the proper output from the `nvidia-smi` command. You should see something like the following, repeated once every 5 seconds. Access the log [via the DC/OS CLI](/docs/1.9/monitoring/logging/quickstart/) or from the **Health** page for your service on the DC/OS dashboard.
    
    ```bash
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

    You will also see an entry for **GPU** in the DC/OS GUI on the **Configuration** tab for your service.

## Docker-Based Application Definition
In this example, an app is deployed with GPUs that specifies a Docker container and the [DC/OS Universal Container Runtime (UCR)](/docs/1.9/deploying-services/containerizers/) (container type to `MESOS`). 

1.  Create an app definition named `docker-gpu-test.json`.

    ```json
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
    
1.  Launch your app using the DC/OS CLI:

    ```bash
    dcos marathon app add docker-gpu-test.json
    ```  

    After your service has deployed, check the contents of `stdout` to verify that the service is producing the proper output from the `nvidia-smi` command. You should see something like the following, repeated once every 5 seconds. Access the log [via the DC/OS CLI](/docs/1.9/monitoring/logging/quickstart/) or from the **Health** page for your service on the DC/OS dashboard.

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

## Learn More about GPUs

- [What is GPU Computing?](http://www.nvidia.com/object/what-is-gpu-computing.html)
- [Mesos NVIDIA GPU Support](https://github.com/apache/mesos/blob/master/docs/gpu-support.md).
- [Tutorial: Deep learning with TensorFlow, Nvidia and Apache Mesos (DC/OS)](https://dcos.io/blog/2017/tutorial-deep-learning-with-tensorflow-nvidia-and-apache-mesos-dc-os-part-1/index.html).
- Presentation: [Supporting GPUs in Docker Containers on Apache Mesos](https://docs.google.com/presentation/d/1FnuEW2ic5d-cpSyVOUMfUSM7WxJlZtTAAWt2dZXJ52A/edit#slide=id.p).
- Presentation: [GPU Support in Apache Mesos](https://www.youtube.com/watch?v=giJ4GXFoeuA).
- Presentation: [Adding GPU Support to Mesos](https://docs.google.com/presentation/d/1Y1IUlWV6g1HzD1wYIYXy6AmbfnczWfjvvmqqpeDFBic/edit#slide=id.p).