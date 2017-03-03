---
post_title: Enabling GPU Support
feature_maturity: experimental
menu_order: 110
---

DC/OS supports allocating GPUs (Graphics Processing Units) to your long-running DC/OS services. Adding GPUs to your service can dramatically accelerate big data workloads. [Learn more](http://www.nvidia.com/object/what-is-gpu-computing.html).

To get started, create a GPU-enabled DC/OS cluster.

- [Configure an AWS cluster](/docs/1.9/administration/gpu/aws-install/).
- [Configure a non-AWS cluster](/docs/1.9/administration/custom-install/).

After creating a GPU-enabled DC/OS cluster, you can [configure your service to use GPUs](/docs/1.9/usage/gpus/).
