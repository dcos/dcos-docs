---
post_title: Install DC/OS on Azure
nav_title: Azure
menu_order: 1
---

This document explains how to install DC/OS 1.9 using the Azure Resource Manager templates.

TIP: To get support on Azure Marketplace-related questions, join the Azure Marketplace [Slack community](http://join.marketplace.azure.com).

# System requirements

## Hardware

To [use](/docs/1.9/usage/) all of the services offered in DC/OS, you should choose at least five Mesos Agents using `Standard_D2` [Virtual Machines](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/), which is the default size in the DC/OS Azure Marketplace offering.

Selecting smaller-sized VMs is not recommended, and selecting fewer VMs will likely cause certain resource-intensive services such as distributed datastores not to work properly (from installation issues to operational limitations).

## Software

You will need an active [Azure subscription](https://azure.microsoft.com/en-us/pricing/purchase-options/) to install DC/OS via the Azure Marketplace.

Also, to access nodes in the DC/OS cluster you will need `ssh` installed and configured.

# Install DC/OS

## Step 1: Deploying the template

To install DC/OS 1.9 on Azure, use the [Azure Resource Manager templates](https://downloads.dcos.io/dcos/EarlyAccess/azure.html) provided.


## Step 2: Accessing DC/OS

Because of security considerations, the DC/OS cluster in Azure is locked down by default. You must use an `ssh` tunnel to access the DC/OS Dashboard.

First, look up `MASTERFQDN` in the outputs of the deployment. To find that, click on the link under `Last deployment` (which is `4/15/2016 (Succeeded)` here) and you should see this:

![Deployment history](../img/dcos-azure-marketplace-step2a.png)

Click on the latest deployment and copy the value of `MASTERFQDN` in the `Outputs` section:

![Deployment output](../img/dcos-azure-marketplace-step2b.png)

Use the value of `MASTERFQDN` you found in the `Outputs` section in the previous step and paste it in the following command:

```bash
$ ssh azureuser@$MASTERFQDN -p 2200 -L 8000:localhost:80
```

For example, in my case:

```bash
$ ssh azureuser@dcosmaster.westus.cloudapp.azure.com -p 2200 -L 8000:localhost:80
```

Now you can visit `http://localhost:8000` on your local machine and view the DC/OS Dashboard.

![DC/OS dashboard](../img/ui-dashboard.gif)

### Caveats

Some caveats around SSH access:

- For connections to `http://localhost:8000` to work, the SSH command must be run on your local machine, and not inside a Virtual Machine.
- In the example above, port `8000` is assumed to be available on your local machine.
- The SSH commands shown only work on Mac or Linux. For Windows use [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) with a similar port-forwarding configuration, see also [How to Use SSH with Windows on Azure](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-ssh-from-windows/).
- If you want to learn more about SSH key generation check out this [GitHub tutorial](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

The DC/OS UI will not show the correct IP address or CLI install commands when connected by using an SSH tunnel.

Note that the following commands can be used to run the DC/OS CLI directly on the master node:

```bash
# Connect to master node with ssh
$ ssh -p2200 azureuser@$MASTERFQDN -L 8000:localhost:80

# Install virtualenv
$ sudo apt-get -y install virtualenv

# Install CLI on the master node and configure with http://localhost
$ mkdir -p dcos && cd dcos &&
$ curl -O https://downloads.dcos.io/dcos-cli/install-optout.sh && \
   bash ./install-optout.sh . http://localhost && \
   source ./bin/env-setup

# Now you can use the DC/OS CLI:
$ dcos package search
```

## Tear Down the DC/OS cluster

If you've created a new resource group in the deployment step, it is as easy as this to tear down the cluster and release all of the resources: just delete the resource group. If you have deployed the cluster into an existing resource group, you'll need to identify all resources that belong to the DC/OS cluster and manually delete them.

## Next steps

- [Add users to your cluster][1]
- [Install the DC/OS Command-Line Interface (CLI)][2]
- [Use your cluster][3]
- [Scaling considerations][4]

[1]: /docs/1.9/administration/id-and-access-mgt/user-management/
[2]: /docs/1.9/usage/cli/install/
[3]: /docs/1.9/usage/
[4]: https://azure.microsoft.com/en-us/documentation/articles/best-practices-auto-scaling/
