---
post_title: Configure a Non-AWS Cluster
nav_title: Configure a Non-AWS Cluster
feature_maturity: experimental
menu_order: 10
---

Follow the steps below to configure [a custom DC/OS installation](/docs/1.9/administration/installing/custom/) to run on bare metal, virtual machines, or on a cloud.

1. Install the [Nvidia Management Library (NVML)](https://developer.nvidia.com/nvidia-management-library-nvml) on each node of your cluster that has GPUs, unless it is already installed. Find detailed installation instructions [here](https://github.com/apache/mesos/blob/master/docs/gpu-support.md#external-dependencies).

1. Create [an application definition that employs GPUs](/docs/1.9/usage/gpu/gpu-app-definition).
