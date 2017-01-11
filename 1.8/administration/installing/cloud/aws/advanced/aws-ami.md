---
post_title: Installing Using a Custom AMI
nav_title: Custom AMI
feature_maturity: preview
menu_order: 101
---

You can use customized [Amazon Machine Images (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) based on CentOS 7 or CoreOS to launch DC/OS with the advanced templates. 

- A custom AMI can be used to integrate DC/OS installation with your own in-house configuration management tools.
- A custom AMI can be used if you want kernel or driver customization.

To get started, build a custom AMI and then install DC/OS by using the advanced templates. 

# Build a custom AMI
This is the recommend method to building your own AMI.

## Test that you can build the DC/OS cloud_images AMI 

1.  Use the DC/OS [cloud_images](https://github.com/dcos/dcos/tree/master/cloud_images) scripts as a template. These scripts build a CentOS7 AMI with all of the DC/OS prerequisites installed. 

    **Important:**
    
    - Verify that you can build and deploy an AMI using these scripts as-is, without modification. 
    - An AMI must be deployed to every region where a cluster will be launched. The DC/OS Packer build script [create_dcos_ami.sh](https://github.com/dcos/dcos/blob/master/cloud_images/centos7/create_dcos_ami.sh) can deploy the AMI to multiple regions by setting the environment variable `DEPLOY_REGIONS` before running the script.

1.  Launch the DC/OS advanced template using the AWS CloudFormation web console and specify the DC/OS cloud_images AMI. Verify that the cluster launched successfully. For more information, see the QuickStart [documentation](/docs/1.8/administration/installing/cloud/aws/advanced/quickstart/#launch).

## Modify the DC/OS cloud_images AMI for your environment

After you have successfully built and deployed the unmodified DC/OS cloud_images AMI using the AWS CloudFormation web console:

1.  Modify the DC/OS [cloud_images](https://github.com/dcos/dcos/tree/master/cloud_images) AMI scripts with your own AMI customizations. 

    **Important:** Your AMI must satisfy all of the DC/OS AMI prerequisites as shown in the template.

1.  Launch the DC/OS advanced templates using the AWS CloudFormation web console and specify your customized AMI. Verify that DC/OS starts as expected and that services can be launched on the DC/OS cluster. 

    **Troubleshooting:**
    
    - Familiarize yourself with the DC/OS service startup [process](/docs/1.8/overview/architecture/#boot). 
    - See the installation troubleshooting [documentation](/docs/1.8/administration/installing/custom/troubleshooting/). To troubleshoot you must have [SSH access](/docs/1.8/administration/access-node/sshcluster/) to all of the cluster nodes. 
    - The [DC/OS Slack](/docs/1.8/support/) community is another a good place to get help.

