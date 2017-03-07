---
post_title: Configure Your AWS Cluster
nav_title: Configure Your AWS Cloud Cluster
feature_maturity: experimental
menu_order: 0
---

#  Prerequisites
- The AWS DC/OS advanced template [system requirements](https://dcos.io/docs/1.9/administration/installing/cloud/aws/advanced/system-requirements/).
- The `zen.sh` script copied to your local machine. The script and instructions are [here](/docs/1.9/administration/installing/cloud/aws/advanced/quickstart/).

## Create Dependencies

1. Run the `zen.sh` script to create the Zen template dependencies. These dependencies will be used as input to create your stack in CloudFormation.
  ```
  bash ./zen.sh <stack-name>
  ```
  **Important:** You must run the `zen.sh` script before performing the next steps.

1. Follow the instructions [here](/docs/1.9/administration/installing/cloud/aws/advanced/quickstart/) to create a cluster with advanced AWS templates, but use the following GPU-specific configuration.

1. On the **Create Stack** > **Specify Details** page, specify your stack information and click **Next**. Here are the GPU-specific settings.
  - **CustomAMI** - Specify the custom AMI for your region:

      - us-west-2: `ami-9b5d97fb`
      - us-east-1: `ami-e10e50f6`
      - ap-southeast-2: `ami-37b28f54`
  - **MasterInstanceType** - Accept the default master instance type (e.g. `m3.xlarge`).
  - **PrivateAgentInstanceType** - Specify a machine type of `g2.2xlarge`. This is the GPU-supported machine type.
  - **PublicAgentInstanceType** - Specify a machine type of `g2.2xlarge`. This is the GPU-supported machine type.

1. On the **Options** page, accept the defaults and click Next.

    **Tip**: You can choose whether to rollback on failure. By default this option is set to **Yes**.

1. On the **Review** page, check the acknowledgement box, then click **Create**.

    **Tip**: If the **Create New Stack** page is shown, either AWS is still processing your request or you’re looking at a different region. Navigate to the correct region and refresh the page to see your stack.

1. Create [an application definition that employs GPUs](/docs/1.9/usage/gpu/gpu-app-definition).
