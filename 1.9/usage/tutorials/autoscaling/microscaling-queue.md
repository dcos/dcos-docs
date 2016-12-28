---
post_title: Microscaling based on queue length
nav_title: Microscaling
---

This tutorial walks through setting up a microscaling demonstration from [Microscaling Systems][2] on a DC/OS cluster. 

[Microscaling][1] adjusts the balance of tasks running within your compute cluster. 
This allows your infrastructure to automatically reallocate 
resources from lower to higher priority tasks, reacting within seconds to a change in demand. 
Microscaling monitors whether the higher priority task is meeting a performance target. In this tutorial, the performance target is maintaining the length of a configured queue value. The higher priority task is scaled up when the target is not met, 
and down when it is exceeded. The lower priority tasks can use the spare resources.  

**Time Estimate**:

If you already have the [prerequisites](#prerequisites) setup, you'll have the microscaling demo running in around 10-15 minutes. 

**Scope**:

In this demo, microscaling adjusts the balance between two tasks - one high priority and one background - based on the number of items in 
an Azure Storage Queue. 

![microscaling-queue.png](../img/microscaling-queue.png)

The demo creates four Marathon apps that run as Docker containers.

* **Producer** instances add items to the queue. The more producers there are, the faster the queue fills up. We start 3 producers on startup and you can scale these manually using the Marathon UI.
* **Consumer** instances remove items from the queue and are scaled by the Microscaling Engine.
* **Remainder** is a background task. Any spare capacity is used for this background task. You can change the Docker image to use your own using the Marathon UI.
* **Microscaling** is the engine that monitors the queue length, and scales the Consumer and Remainder tasks. It also sends data to our Microscaling-in-a-Box site so you can see what's happening.

# <a name="prerequisites"></a>Prerequisites

* A [Microsoft Azure][3] account. Your DC/OS cluster can be running anywhere (it doesn't have to be running on Azure) 
but the demo uses an Azure Storage Queue. If you don't already have an account you can get a [free trial][4]. 
* A [running DC/OS cluster][5]. If you don't already have one, you can follow these [instructions for setting up a DC/OS cluster on Azure][6]. 
* The Marathon REST API address. If you set up an [SSH tunnel on port 80 to your Marathon master node][7] you can access the Marathon REST API at `http://localhost/marathon`.
* [Ruby][8] on your local machine to run the demo scripts. 

# Set up an Azure Storage Account

* Sign in to the [Azure Portal][9].
* Navigate to New -> Data + Storage -> Storage Account.
* Create a storage account with the following settings:

![microscaling-azure-storage.png](../img/microscaling-azure-storage.png)

* **Name** - this must be globally unique across all Azure Storage Accounts. Make a note of this - you will use this as the environment variable `AZURE_STORAGE_ACCOUNT_NAME` later. 
* **Replication** - choose Locally-redundant storage for the queue.
* **Resource Group** - create a new resource group for the queue. 

After the storage account has been created, navigate to Settings -> Access Keys and make a note of your access key. You'll use this as the environment variable `AZURE_STORAGE_ACCOUNT_KEY` later. 

# Set up Microscaling-in-a-box

* Go to the [Microscaling-in-a-box][10] site and sign up for an account if you don't have one already.
* In Step 1, pick the Mesos / Marathon option

![microscaling-step-1.png](../img/microscaling-step-1.png)

* Skip through steps 2 & 3 to use the default values. 
* Navigate to the step 4 (Run) page and find your user ID and the default value for the queue we'll be using in the demo. You will use these as the values for environment variables `MSS_USER_ID` and `AZURE_STORAGE_QUEUE_NAME` later.

![microscaling-step-4.png](../img/microscaling-step-4.png)

# Get the microscaling scripts

We have prepared some scripts to configure and start the four apps in Marathon. Go to a terminal on your local machine and get these scripts with the following command.

``` bash
$ git clone http://github.com/microscaling/queue-demo
```

Move into the queue-demo directory.

``` bash
$ cd queue-demo
```

# Run the microscaling install script

Set up the following environment variables 

``` bash
$ export AZURE_STORAGE_ACCOUNT_NAME=<storage account name>
$ export AZURE_STORAGE_ACCOUNT_KEY=<storage account key>
$ export AZURE_STORAGE_QUEUE_NAME=<queue name>
$ export MSS_USER_ID=<user ID>
$ export MSS_MARATHON_API=http://localhost/marathon
```
You're now ready to run the demo: 
``` bash
$ ./marathon-install
```

This script starts all four tasks. You can view these in the DC/OS web interface.  

After Marathon has launched the apps, the results will start to appear in the Microscaling-in-a-Box UI. You'll see the Microscaling Engine scaling the consumer and remainder containers to maintain the target queue length.

![microscaling-chart-ui.png](../img/microscaling-chart-ui.png)

You can use the DC/OS web interface to scale the number of Producer tasks up or down and see how Microscaling reacts to keep the queue length under control. 

# Cleanup

## Uninstall the Marathon Apps

You can use the `marathon-uninstall` command to remove the demo apps from your cluster. (This command requires the `MSS_MARATHON_API` environment variable to be set as above.)

``` bash
$ ./marathon-uninstall
```

## Delete the Azure Resources

After you've finished with the demo you should delete the Azure resources so that you don't get charged. 

* Sign in to the [Azure Portal][9].
* Select Resource Groups from the left hand menu.
* Find and delete the Resource Group you created for the Azure Queue.
* If you created an ACS cluster for this demo, you'll want to delete the Resource Group for that too. 

# Appendix: Next Steps

- Try modifying some of the configuration settings in Step 3 of Microscaling-in-a-Box before you run the demo. You'll need to stop the tasks (manually or by running `./marathon-uninstall`) and restart them again with `./marathon-install` to pick up configuration changes. 
- See the settings for each of the Marathon apps in JSON files contained within the `marathon-apps` directory.
- Here's the [microscaling engine code][11]. 
- Find more information about microscaling on the [Microscaling Systems website][2].

[1]: http://microscaling.org
[2]: http://microscaling.com
[3]: http://azure.microsoft.com
[4]: https://azure.microsoft.com/en-us/pricing/free-trial/
[5]: /docs/1.9/administration/installing/
[6]: https://azure.microsoft.com/en-us/documentation/articles/container-service-deployment/
[7]: https://github.com/Azure/azure-quickstart-templates/blob/master/101-acs-dcos/docs/SSHKeyManagement.md#create-port-80-tunnel-to-the-master
[8]: https://www.ruby-lang.org/en/documentation/installation/
[9]: http://portal.azure.com
[10]: http://app.microscaling.com
[11]: http://github.com/microscaling/microscaling