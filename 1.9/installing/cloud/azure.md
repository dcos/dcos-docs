---
post_title: Running DC/OS on Azure
nav_title: Azure
menu_order: 1
---

This document explains how to install DC/OS 1.9 using the Azure Resource Manager templates.

TIP: To get support on Azure Marketplace-related questions, join the Azure Marketplace [Slack community](http://join.marketplace.azure.com).

**Important:** Upgrades are not supported with this installation method.

# System requirements

## Hardware

To use all of the services offered in DC/OS, you should choose at least five Mesos Agents using `Standard_D2` [Virtual Machines](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/), which is the default size in the DC/OS Azure Marketplace offering.

Selecting smaller-sized VMs is not recommended, and selecting fewer VMs will likely cause certain resource-intensive services such as distributed datastores not to work properly (from installation issues to operational limitations).

## Software

You will need an active [Azure subscription](https://azure.microsoft.com/en-us/pricing/purchase-options/) to install DC/OS via the Azure Marketplace.

Also, to access nodes in the DC/OS cluster you will need `ssh` installed and configured.

# Install DC/OS

## Step 1: Deploying the template

To install DC/OS 1.9 on Azure, use the [Azure Resource Manager templates](https://downloads.dcos.io/dcos/stable/azure.html) provided.


## Step 2: Accessing DC/OS

Because of security considerations, the DC/OS cluster in Azure is locked down by default. You must set an inbound security rule and an inbound NAT rule.

Or, set oauthEnabled=true at deploy time ??

TODO

First, look up `MASTERFQDN` in the outputs of the deployment. To find that, click on the link under `Last deployment` (which is `4/15/2016 (Succeeded)` here) and you should see this:

![Deployment history](/docs/1.9/img/dcos-azure-marketplace-step2a.png)

Click on the latest deployment and copy the value of `MASTERFQDN` in the `Outputs` section:

![Deployment output](/docs/1.9/img/dcos-azure-marketplace-step2b.png)

Use the value of `MASTERFQDN` you found in the `Outputs` section in the previous step and access http://$MASTERFQDN in your website.

Note that the following commands can be used to run the DC/OS CLI directly on the master node:

```bash
# Connect to master node with ssh
ssh azureuser@$MASTERFQDN

# Install CLI on the master node and configure with http://localhost
curl https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.9/dcos -o dcos && 
sudo mv dcos /usr/local/bin && 
sudo chmod +x /usr/local/bin/dcos && 
dcos config set core.dcos_url http://localhost && 
dcos

# Now you can use the DC/OS CLI:
dcos package search
```

## Tear Down the DC/OS cluster

If you've created a new resource group in the deployment step, it is as easy as this to tear down the cluster and release all of the resources: just delete the resource group. If you have deployed the cluster into an existing resource group, you'll need to identify all resources that belong to the DC/OS cluster and manually delete them.

## Next steps

- [Add users to your cluster][1]
- [Install the DC/OS Command-Line Interface (CLI)][2]
- [Scaling considerations][4]

[1]: /docs/1.9/security/user-management/
[2]: /docs/1.9/cli/install/
[4]: https://azure.microsoft.com/en-us/documentation/articles/best-practices-auto-scaling/
