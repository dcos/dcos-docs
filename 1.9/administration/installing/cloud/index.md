---
post_title: DC/OS Cloud Installation Options
nav_title: Cloud
menu_order: 1
---

Looking to install DC/OS on your cloud of choice? Look no further! You can use a template or use our advanced custom installer.

# Amazon Web Services

You can use CloudFormation to create an entire DC/OS cluster in about 10 minutes. To get started, check out the [instructions][1].

- [AWS Installation Guide][1]

# Azure

You can create a cluster in Azure by using the Resource Manager. To get started, check out the [instructions][2].

- [Azure Installation Guide][2]

# Other

Not all clouds have template support, but not worry, you can still configure the instances you have in the cloud as your own cluster. Pick the [custom install method][3] in this case. While this method is more advanced than using CloudFormation or Resource Manager, it is better suited for use in production. You can pick everything in the cluster and configure it exactly the way you'd like.

- [Custom Installation Guides][3]

[1]: /docs/1.9/administration/installing/cloud/aws/
[2]: /docs/1.9/administration/installing/cloud/azure/
[3]: /docs/1.9/administration/installing/custom/
