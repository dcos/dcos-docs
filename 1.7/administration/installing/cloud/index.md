---
post_title: DC/OS Cloud Installation Options
nav_title: Cloud
---

Looking to install DC/OS on your cloud of choice? Look no further! You can either use a template or do something a little bit more custom with our custom installer.

# Amazon Web Services

You can use CloudFormation to create an entire DC/OS cluster in only 10 minutes. To get started, check out the [instructions][1]

- [AWS Installation Guide][1]

# Azure

To create a cluster in Azure, you can use Resource Manager. There are [instructions][2] that you can get through quickly.

- [Azure Installation Guide][2]

# Other

Not all clouds have template support. Even then, you'll be able to treat the instances you have in the cloud as your own cluster. Pick the [install method][3] that you'd like to use in this case. While this method is more involved than using CloudFormation or Resource Manager, it is a little bit better suited for use in production. This is because you'll be able to pick everything in the cluster and configure it exactly the way you'd like.

- [Custom Installation Guides][3]

[1]: aws/
[2]: azure/
[3]: ../custom/
