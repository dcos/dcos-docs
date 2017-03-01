---
post_title: Enabling GPU Support
feature_maturity: experimental
menu_order: 110
---

DC/OS supports allocating GPUs (Graphics Processing Units) to your long-running DC/OS services. Adding GPUs to your service can dramatically accelerate big data workloads. [Learn more](http://www.nvidia.com/object/what-is-gpu-computing.html).

To get started, create a GPU-enabled DC/OS cluster.

- [Configure an AWS cluster](/docs/1.9/usage/gpu/aws-install/).
- [Configure a non-AWS cluster](/docs/1.9/usage/gpu/custom-install/).

After creating a GPU-enable DC/OS cluster you can utilize GPUs from a [marathon app](/docs/1.9/usage/marathon/gpus/).
