---
post_title: Generating Custom AWS CF Templates
nav_title: Custom CF Template
menu_order: 102
---

You can create custom advanced templates for DC/OS. You can then deploy and run DC/OS from your own private S3 bucket. 

**Prerequisites:**

* A node that meets custom installer bootstrap node [system requirements](/docs/1.9/administration/installing/custom/system-requirements/).
* Advanced template [system requirements](/docs/1.9/administration/installing/cloud/aws/advanced/system-requirements/).
* An Amazon S3 bucket with read-write access.
    * The S3 bucket must have a bucket policy that allows the launched AWS instances to download the files from the s3 bucket. Here is a sample policy that allows anyone to download:
    
      ```json
      {
        "Version":"2012-10-17",
        "Statement":[
          {
            "Sid":"AddPerm",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["arn:aws:s3:::<bucket_name>/<bucket_path>/*"]
          }
        ]
      }
      ```
      For more information about s3 bucket polices, see the [AWS Documentation](http://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html).
      

1.  Download the [dcos_generate_config.sh](https://dcos.io/releases/) to your bootstrap node.
1.  Create a directory named `genconf` in the home directory of your node and navigate to it.
    
    ```bash
    $ mkdir -p genconf
    ```
1.  Create a configuration file in the `genconf` directory and save as `config.yaml`. This configuration file specifies your AWS credentials and the S3 location to store the generated artifacts. These are the required parameters:

    ```bash
    aws_template_storage_bucket: <s3-bucket-name>
    aws_template_storage_bucket_path: <path-to-directory>
    aws_template_storage_region_name: <your-region>
    aws_template_upload: true
    aws_template_storage_access_key_id: <your-access-key-id>
    aws_template_storage_secret_access_key: <your-secret-access_key>
    ```
    
    **aws_template_storage_bucket**
    Specify the name of your S3 bucket. For example, `aws_template_storage_bucket: dcos-aws-advanced`.
    
    **aws_template_storage_bucket_path**
    Specify the S3 bucket storage path. For example, `aws_template_storage_bucket_path: templates/dcos`.
    
    **aws_template_storage_region_name**
    Specify the S3 region. For example, `aws_template_storage_region_name: us-west-2`
    
    **aws_template_upload**
    Specify whether to automatically upload the customized advanced templates to your S3 bucket. For example, `aws_template_upload: true`. If you specify `true`, you must also specify these parameters:
    
    *  **aws_template_storage_access_key_id**
       Specify the AWS [Access Key ID](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). For example, `aws_template_storage_access_key_id: AKIAIOSFODNN7EXAMPLE`  
        
    *  **aws_template_storage_secret_access_key**
       Specify the AWS [Secret Access Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). For example, `aws_template_storage_secret_access_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`.
    
1.  Run the DC/OS installer script with the AWS argument specified. This command creates and uploads a custom build of the DC/OS artifacts and templates to the specified S3 bucket.

    ```bash
    $ sudo bash dcos_generate_config.sh --aws-cloudformation
    ```

     The root URL for this bucket location is printed at the end of this step. You should see a message like this:
    
    ```bash
    AWS CloudFormation templates now available at: https://<amazon-web-endpoint>/<path-to-directory>
    ```
1.  Go to [CloudFormation](https://console.aws.amazon.com/cloudformation/home) and click **Create Stack**.
1.  On the **Select Template** page, specify the Amazon S3 template URL path to your Zen template. For example, `https://s3-us-west-2.amazonaws.com/user-aws/templates/config_id/14222z9104081387447be59e178438749d154w3g/cloudformation/el7-zen-1.json`.

### Template reference
For the complete advanced configuration options, see the template reference [documentation](/docs/1.9/administration/installing/cloud/aws/advanced/template-reference/).

    