---
post_title: Install DC/OS on Azure
nav_title: Azure
---

This document explains how to install DC/OS via the [Azure Marketplace](https://azure.microsoft.com/en-us/marketplace/).

TIP: In order to get support on Azure Marketplace-related questions, you can join the respective [Slack community](http://join.marketplace.azure.com).

# System requirements

## Hardware

In order to [use](/docs/1.7/usage/) all of the services offered in DC/OS you should choose at least five Mesos Agents using `Standard_D2` [Virtual Machines](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/), which is the default size in the DC/OS Azure Marketplace offering.

Selecting smaller-sized VMs is not recommended, and selecting fewer VMs will likely cause certain resource-intensive services such as distributed datastores not to work properly (from installation issues to operational limitations).

## Software

You will need an active [Azure subscription](https://azure.microsoft.com/en-us/pricing/purchase-options/) to install DC/OS via the Azure Marketplace.

Also, in order to access nodes in the DC/OS cluster you will need `ssh` installed and configured.

# Install DC/OS

## Step 1: Deploying the template

In order to deploy DC/OS using an [Azure Resource Manager](https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/) template, first go to [portal.azure.com](https://portal.azure.com/), click on `+ New` and enter `DC/OS`:

![Searching for DC/OS template](../img/dcos-azure-marketplace-step1a.png)

In the search result page, pick `DC/OS on Azure`:

![Selecting DC/OS template](../img/dcos-azure-marketplace-step1b.png)

In the template, click on `Create`:

![Creating deployment using DC/OS template](../img/dcos-azure-marketplace-step1c.png)

Complete the installation wizard steps. Note: you only need to fill in the `Basic` section, rest is optional, however you it is strongly recommended to create a new resource group (simplifies also cluster teardown):

![Filling in DC/OS template](../img/dcos-azure-marketplace-step1d.png)

After you've clicked on the final `Create` button you should see something like the below. The default 5 node configuration takes about 15 minutes to deploy.

![Deploying DC/OS template](../img/dcos-azure-marketplace-step1e.png)

Once the deployment succeeded, click on the resource group (`mydcoscluster` here) and you should get to the resource group. If you don't see it, try searching for your research group and if the deployment failed, delete the deployment as well as the resource group and start again:

![DC/OS template successfully deployed](../img/dcos-azure-marketplace-step1f.png)

Now you have deployed DC/OS using an Azure Resource Manager template, congrats! Next we will have a look at accessing the cluster.

## Step 2: Accessing DC/OS

Due to security considerations the DC/OS cluster in Azure is locked down per default. You need to use an `ssh` tunnel to access the DC/OS Dashboard.

First, look up `MASTERFQDN` in the outputs of the deployment. To find that, click on the link under `Last deployment` (which is `4/15/2016 (Succeeded)` here) and you should see this:

![Deployment history](../img/dcos-azure-marketplace-step2a.png)

Click on the latest deployment and copy the value of `MASTERFQDN` in the `Outputs` section:

![Deployment output](../img/dcos-azure-marketplace-step2b.png)

Use the value of `MASTERFQDN` you found in the `Outputs` section in the previous step and paste it in the following command:

```bash
$ ssh azureuser@masterfqdn -p 2200 -L 8000:localhost:80
```

For example, in my case:

```bash
$ ssh azure@dcosmaster.westus.cloudapp.azure.com -p 2200 -L 8000:localhost:80
```

Now you can visit `http://localhost:8000` on your local machine and find the DC/OS Dashboard there.

### Caveats

Some caveats around SSH access:

- For connections to `http://localhost:8000` to work, the SSH command must be run on your local machine, and not inside a Virtual Machine.
- In the example above, port `8000` is assumed to be available on your local machine.
- Above commands only work on Mac or Linux; for Windows use [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) with a similar port-forwarding configuration, see also [How to Use SSH with Windows on Azure](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-ssh-from-windows/).
- If you want to learn more about SSH key generation check out this [GitHub tutorial](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

The DC/OS Web UI will not show the correct IP address or CLI install commands when connected via an SSH tunnel.

Note that the following commands can be used to run the DC/OS CLI directly on the master node:

    # Connect to master node with ssh
    $ ssh -p2200 azureuser@MASTER_LOAD_BALANCER -L 8000:localhost:80
    
    # Install virtualenv
    $ sudo apt-get -y install virtualenv
    
    # Install CLI on the master node and configure with http://localhost
    $ mkdir -p dcos && cd dcos && 
    $ curl -O https://downloads.dcos.io/dcos-cli/install-optout.sh && \
       bash ./install-optout.sh . http://localhost && \
       source ./bin/env-setup
    
    # Now you can use the DC/OS CLI:   
    $ dcos package search

## Tear Down the DC/OS cluster

If you've created a new resource group in the deployment step, it is as easy as this to tear down the cluster and release all resources: just delete the resource group. If you have deployed the cluster into an existing resource group, you'll need to identify all resources that belong to the DC/OS cluster and manually delete them, step by step.

## Next steps

- [Add users to your cluster][10]
- [Install the DC/OS Command-Line Interface (CLI)][1]
- [Use your cluster][4]
- [Scaling considerations][2]

[1]: /docs/1.7/usage/cli/install/
[3]: https://azure.microsoft.com/en-us/documentation/articles/best-practices-auto-scaling/
[4]: /docs/1.7/usage/
[10]: /docs/1.7/administration/user-management/
