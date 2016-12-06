---
post_title: Install DC/OS on Azure
nav_title: Azure
menu_order: 1
---

This document explains how to install DC/OS 1.8 through the Azure Marketplace. You can also install directly by using the [Azure Resource Manager templates](https://downloads.dcos.io/dcos/stable/azure.html) provided.

To get support on Azure Marketplace-related questions, join the Azure Marketplace [Slack community](http://join.marketplace.azure.com).

# System requirements

## Hardware

- A standard D2 Microsoft Azure [virtual machine](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/)
- A minimum of five Mesos agents

Selecting fewer VMs will likely cause certain resource-intensive services such as distributed datastores not to work properly, ranging from installation issues to operational limitations.

## Software

- An active [Azure subscription](https://azure.microsoft.com/en-us/pricing/purchase-options/)
- SSH installed and configured. This is required for [accessing nodes](/docs/1.8/administration/access-node/) in the DC/OS cluster.

# Install DC/OS

**Important:** [REX-ray](https://github.com/codedellemc/rexray/issues/528) does not support Azure.

## Step 1: Deploying the template

To deploy DC/OS using an [Azure Resource Manager](https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/) template, first go to [portal.azure.com](https://portal.azure.com/), click on `+ New` and enter `DC/OS`:

![Searching for DC/OS template](../img/dcos-azure-marketplace-step1a.png)

In the search result page, pick `DC/OS on Azure`:

![Selecting DC/OS template](../img/dcos-azure-marketplace-step1b.png)

In the template, click on `Create`:

![Creating deployment using DC/OS template](../img/dcos-azure-marketplace-step1c.png)

Complete the installation wizard steps. Note: you are only required to fill in the `Basic` section, however it is strongly recommended that you create a new resource group (simplifies installation and cluster teardown). With the `Enable OAuth authentication` you can influence the [security](/docs/1.8/administration/id-and-access-mgt/) settings. By default, no user authentication is performed by DC/OS, and to enable OAuth-based authentication for your cluster, set it to `true`:

![Filling in DC/OS template](../img/dcos-azure-marketplace-step1d.png)

After you've clicked on the final `Create` button you should see something like the screen below. The deployment process should take about 10 minutes:

![Deploying DC/OS template](../img/dcos-azure-marketplace-step1e.png)

After the deployment succeeded, click on the resource group (`mydcoscluster` here) and you should get to the resource group. If you don't see it, try searching for your resource group and if the deployment failed, delete the deployment and the resource group and start again:

![DC/OS template successfully deployed](../img/dcos-azure-marketplace-step1f.png)

Congratulations, you have now deployed DC/OS by using an Azure Resource Manager template! Next we will show how to access the cluster.

## Step 2: Accessing DC/OS

Because of security considerations, the DC/OS cluster in Azure is locked down by default. You must use an `ssh` tunnel to access the DC/OS Dashboard.

First, look up `MASTERFQDN` in the outputs of the deployment. To find that, click on the link under `Last deployment` (which is `10/5/2016 (Succeeded)` here) and you should see something like this:

![Deployment history](../img/dcos-azure-marketplace-step2a.png)

Click on the latest deployment (here `mesosphere.dcosdcos-20160905094201`) and copy the value of `MASTERFQDN` in the `Outputs` section (in this case its `dcosmastersfjro3nzmohea.westus.cloudapp.azure.com`):

![Deployment output](../img/dcos-azure-marketplace-step2b.png)

Use the value of `MASTERFQDN` you found in the `Outputs` section in the previous step and paste it in the following command:

```bash
$ ssh azureuser@$MASTERFQDN -p 2200 -L 8000:localhost:80
```

For example, in my case:

```bash
$ export MASTERFQDN=dcosmastersfjro3nzmohea.westus.cloudapp.azure.com
$ ssh -p2200 azureuser@$MASTERFQDN -L 8000:localhost:80
The authenticity of host '[dcosmastersfjro3nzmohea.westus.cloudapp.azure.com]:2200 ([23.101.195.125]:2200)' can't be established.
ECDSA key fingerprint is SHA256:RD7nTZ4tzrKF/g4pvWvMFQk5GnCB6JqPA2MYycIoGGM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[dcosmastersfjro3nzmohea.westus.cloudapp.azure.com]:2200,[23.101.195.125]:2200' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04 LTS (GNU/Linux 4.4.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

azureuser@dcos-master-01234567-0:~$
```

Visit `http://localhost:8000` on your local machine to access the DC/OS Dashboard. Note that if you set `Enable OAuth authentication` to `true` you'll have to first [authenticate](/docs/1.8/administration/id-and-access-mgt/managing-authentication/) using one of the three default OAuth providers (Google, GitHub, Microsoft):

![Authenticate](../img/dcos-azure-marketplace-step2c.png)

Now you should see something like the following as a result:

![DC/OS Dashboard](../img/dcos-azure-marketplace-step2d.png)

### Caveats

Some caveats around SSH access:

- For connections to `http://localhost:8000` to work, the SSH command must be run on your local machine, and not inside a Virtual Machine.
- In the example above, port `8000` is assumed to be available on your local machine.
- The SSH commands shown only work on Mac or Linux. For Windows use [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) with a similar port-forwarding configuration, see also [How to Use SSH with Windows on Azure](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-ssh-from-windows/).
- If you want to learn more about SSH key generation check out this [GitHub tutorial](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/).

The DC/OS UI will not show the correct IP address or CLI install commands when connected by using an SSH tunnel.

The following commands can be used to run the DC/OS CLI directly from within the cluster, using the DC/OS Master node:

```bash
# Connect to master node with ssh
$ ssh -p2200 azureuser@MASTERFQDN -L 8000:localhost:80

# Install CLI
azureuser@dcos-master-01234567-0:~$ curl -fLsS --retry 20 -Y 100000 -y 60 https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos -o dcos && 
 sudo mv dcos /usr/local/bin && 
 sudo chmod +x /usr/local/bin/dcos && 
 dcos config set core.dcos_url http://localhost
```

## Tear Down the DC/OS cluster

If you've created a new resource group in the deployment step it is straightforward to tear down the cluster and release all of the resources. Just delete the resource group as follows:

![Tear down DC/OS cluster](../img/dcos-azure-marketplace-step2e.png)

If you have deployed the cluster into an existing resource group, you'll need to identify all resources that belong to the DC/OS cluster and manually delete them.

## Next steps

- [Add users to your cluster][10]
- [Install the DC/OS Command-Line Interface (CLI)][1]
- [Use your cluster][4]
- [Scaling considerations][3]

[1]: /docs/1.8/usage/cli/install/
[3]: https://azure.microsoft.com/en-us/documentation/articles/best-practices-auto-scaling/
[4]: /docs/1.8/usage/
[10]: /docs/1.8/administration/id-and-access-mgt/user-management/
