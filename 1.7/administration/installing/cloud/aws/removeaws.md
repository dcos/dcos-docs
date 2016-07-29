---
post_title: Uninstalling on Amazon Web Services
menu_order: 300
---
You can uninstall DC/OS from AWS with these instructions.

**You will continue to be charged AWS fees if:**

*   You delete only the individual EC2 instances, not the entire stack. If you delete only the individual instances, AWS will restart your DC/OS cluster.
*   Your stack fails to delete. You must monitor the stack deletion process to ensure it completes successfully.
*   Your S3 bucket is not empty.

To uninstall DC/OS on AWS:

1.  Select your cluster on the <a href="https://console.aws.amazon.com/cloudformation/home" target="_blank">Cloud Formation Management</a> page and click **Delete Stack**. For more information, see <a href="http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-delete-stack.html" target="_blank">Deleting a Stack on the AWS CloudFormation Console</a>.

2.  Navigate to the <a href="https://console.aws.amazon.com/s3/home" target="_blank">S3 Management Console</a> and delete your DC/OS buckets. For more information, see <a href="http://docs.aws.amazon.com/AmazonS3/latest/dev/delete-or-empty-bucket.html" target="_blank">Deleting or Emptying a Bucket</a>.