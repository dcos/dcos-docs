---
post_title: Scaling a Service
nav_title: Scaling
menu_order: 003.2
---

This tutorial shows how to scale a service using the DC/OS web interface and the CLI.

# Scale Your Service from the DC/OS Web Interface

1. From the **Services** tab, put your cursor over the name of the service you want to scale to reveal a gear symbol.
1. Click the gear symbol and choose **Scale**.
1. Enter the number of instances you would like, then click **Scale Service**.
1. Click the name of your service to see the number of instances you specified.

# Scale Your Service from the DC/OS CLI

1.  Enter the following command from the CLI:

    ```bash
    dcos marathon app update <app-id> instances=<number_of_desired_instances>
    ```
    
1.  Enter the following command to view information about your services. 

    ```bash
    dcos marathon app list
    ```