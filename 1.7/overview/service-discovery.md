---
post_title: Service Discovery
menu_order: 8
---

There are two levels of service discovery in DC/OS. Along with every task that runs on DC/OS being provided a well known DNS name, anyone can request a well known VIP that enables clients to have a single configuration value.

# VIP

You can assign a VIP to one of your services by following these steps. For some more in depth instructions, check out [service discovery][1].

1.  From the DC/OS web interface, click on the **Services** tab and select **Marathon**.

    *   To create a new application, click **Create Application** and select the **Ports and Service Discovery** menu option.
    *   To edit an existing application, select your application and click the **Configuration** tab, then click **Edit**. You can then select the **Ports and Service Discovery** menu option.

    ![Marathon Ports](../img/ui-marathon-ports.gif)

2.  Enter the Port, Protocol, Name, and VIP address. Remember that a VIP includes the port, like `1.1.1.1:5000`.

    **Tip:** Select **JSON Mode** to edit your application directly in JSON.

    For more information on port configuration, see the [Marathon ports documentation][2].

3.  From inside the cluster, you will be able to use your VIP directly. You can [SSH][3] into the cluster and run this command to see it work:

        curl 1.1.1.1:5000

# Mesos-DNS

Every task started by DC/OS gets a well known DNS name. You can even enumerate every [DNS name][5] in your cluster. For a Marathon service named "testing", you can find where it is running via:

        dig testing.marathon.mesos

Take a look at the [mesos-dns documentation][4] for a more in-depth look at how Mesos-DNS is working and what it is doing for you.

[1]: /docs/1.7/usage/service-discovery/
[2]: https://mesosphere.github.io/marathon/docs/ports.html
[3]: /docs/1.7/administration/sshcluster/
[4]: /docs/1.7/usage/service-discovery/mesos-dns/
[5]: /docs/1.7/usage/service-discovery/mesos-dns/service-naming/
