---
post_title: How to use Jenkins on DC/OS
nav_title: Jenkins
---

[Jenkins](https://jenkins-ci.org/) is a popular automation server with hundreds of plugins (GitHub, Docker, etc.) available.

**Scope**:

In the following how-to you will learn about how to use Jenkins on DC/OS.

## Preparation

Assuming you have a DC/OS cluster up and running you want to [install a user-specific Marathon instance](https://docs.mesosphere.com/manage-service/marathon/) that acts as the deployment and upgrade platform for any new versions of the Docker images created by Jenkins:

```bash
$ dcos package install marathon
We recommend a minimum of one node with at least 2 CPU shares and 1GB of RAM available for the Marathon DC/OS Service.
Continue installing? [yes/no] yes
Installing Marathon app for package [marathon] version [0.15.3]
Marathon DC/OS Service has been successfully installed!

	Documentation: https://mesosphere.github.io/marathon
	Issues: https:/github.com/mesosphere/marathon/issue
```

## Using Jenkins for testing

For testing, the first step is to [install Jenkins](https://docs.mesosphere.com/manage-service/jenkins/) like so:

```bash
$ dcos package install jenkins
WARNING: Jenkins on DC/OS is currently in BETA. There may be bugs, incomplete
features, incorrect documentation, or other discrepancies.

If you didn't provide a value for `host-volume` in the CLI,
YOUR DATA WILL NOT BE SAVED IN ANY WAY.

Continue installing? [yes/no] yes
Installing Marathon app for package [jenkins] version [0.2.3]
Jenkins has been installed.
```

Marathon with Jenkins pinned to one host like described in http://mesosphere.github.io/jenkins-mesos/docs/configuration.html

## Using Jenkins in production

For production usage do the following. First, create a JSON file `options.json` with the following content:

```bash
$ cat options.json
{
    "jenkins": {
        "framework-name": "jenkins-prod",
        "host-volume": "/mnt/jenkins"
    }
}
```

Then, you can install Jenkins:

```bash
$ dcos package install jenkins --options=options.json
```

Now we will use a File Share for HA.

First, you need to create a [Storage Account](https://portal.azure.com/#create/Microsoft.StorageAccount-ARM), in my case `mh9storage`, in the same resource group that you have launched your DC/OS cluster in (`mh9` here):

![Azure Portal: Storage Account](img/azure-portal-storage.png)

Now you can create a file share (`jenkins` was what I chose):

![Azure Portal: File Service](img/azure-portal-storage-fileshare.png)

Next, log into the DC/OS master node: for that, look up SSH connection string labeled `SSHMASTER0` in the `Microsoft.Template` deployments `Outputs` section

![Azure Portal: Deployment Output](img/azure-portal-deployment-output.png)

Now we add the private SSH key locally:

```bash
$ ssh-add ~/.ssh/azure
Identity added: /Users/mhausenblas/.ssh/azure (/Users/mhausenblas/.ssh/azure)
```

And log into the master node (note that `-L 8000:localhost:80` is a port forward from the local machine):

```bash
$ ssh azureuser@jenkinsmgmt.westus.cloudapp.azure.com -A -p 2200 -L 8000:localhost:80
```

On this node you can now [mount the File Share](https://azure.microsoft.com/en-us/documentation/articles/storage-how-to-use-files-linux/) we created in the previous step. First, let's make 100% sure that the CIFS mount utils are available:

```bash
$ sudo apt-get update && sudo apt-get -y install cifs-utils
```

Now we can mount the file share:

```bash
azureuser@dcos-master-415F65E0-0:~$ sudo mkdir -p /mnt/jenkins
azureuser@dcos-master-415F65E0-0:~$ sudo mount -t cifs //mh9storage.file.core.windows.net/jenkins /mnt/jenkins -o vers=3.0,username=mh9storage,password=4VWsqPiYJa/JfVqkIBsDIudw5vI6W+ZxfhJPjg9C1rYi9d/dnUjAz0h8N2oc/gxyoIBmrxNCb4O6bCoiXK+DLA==,dir_mode=0777,file_mode=0777
```

The generic form of the command is `mount -t cifs //myaccountname.file.core.windows.net/mysharename /somedir -o vers=3.0,username=myaccountname,password=StorageAccountKeyEndingIn==,dir_mode=0777,file_mode=0777` and the password is the `KEY2` from the `Access keys` here:

![Azure Portal: Storage Account Access Keys](img/azure-portal-storage-accesskeys.png)

To check if the file share works, we upload a test file via the Azure portal:

![Azure Portal: Storage File Upload](img/azure-portal-storage-fileupload.png)

… and then list the content of the mounted file share on the DC/OS master node:

```bash
azureuser@dcos-master-415F65E0-0:~$ ls -al /mnt/jenkins
total 1
-rwxrwxrwx 1 root root 19 Mar 20 11:21 test.txt
```

### Automate file share mount

On the master:

```bash
$ sudo apt-get install pssh
$ cat pssh_agents
10.0.0.4
10.0.0.5
10.32.0.4

$ parallel-ssh -O StrictHostKeyChecking=no -l azureuser -h pssh_agents "if [ ! -d "/mnt/jenkins" ]; then mkdir -p "/mnt/jenkins" ; fi"
$ parallel-ssh -O StrictHostKeyChecking=no -l azureuser -h pssh_agents "mount -t cifs //mh9storage.file.core.windows.net/jenkins /mnt/jenkins -o vers=3.0,username=mh9storage,password=4VWsqPiYJa/JfVqkIBsDIudw5vI6W+ZxfhJPjg9C1rYi9d/dnUjAz0h8N2oc/gxyoIBmrxNCb4O6bCoiXK+DLA==,dir_mode=0777,file_mode=0777"
```
