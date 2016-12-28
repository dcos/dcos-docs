---
post_title: System Requirements for AWS Advanced Templates
nav_title: System Requirements
menu_order: 099
---

### Hardware

An Amazon EC2 <a href="https://aws.amazon.com/ec2/pricing/" target="_blank">m3.xlarge</a> instance. Selecting smaller-sized VMs is not recommended, and selecting fewer VMs will likely cause certain resource-intensive services, such as distributed datastores, to not work properly.

### Software

- The DC/OS advanced AWS [templates](/docs/1.9/administration/installing/cloud/aws/advanced/template-reference/).
- An Amazon Web Services account with root [IAM](https://aws.amazon.com/iam/) privileges. Advanced privileges are required to install the advanced templates. Contact your AWS admin for more information.
- An Amazon EC2 Key Pair for the same region as your cluster. Key pairs cannot be shared across regions. The AWS key pair uses public-key cryptography to provide secure login to your AWS cluster. For more information about creating an Amazon EC2 Key Pair, see the <a href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair" target="_blank">documentation</a>.
- AWS [Command Line Interface](https://aws.amazon.com/cli/)
- The CLI JSON processor [jq](https://github.com/stedolan/jq/wiki/Installation)
