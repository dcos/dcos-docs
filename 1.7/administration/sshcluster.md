---
post_title: SSHing into Nodes
menu_order: 5
---

These instructions explain how to set up an SSH connection to your DC/OS cluster from an outside network. If you are on the same network as your cluster or connected by using VPN, you can instead use the `dcos node ssh` command. For more information, see the [dcos node section][1] of the CLI reference.

*   [SSH to your DC/OS cluster on Unix/Linux (OS X, Ubuntu, etc)][2]
*   [SSH to your DC/OS cluster on Windows][3]

**Requirements:**

*   During [AWS DC/OS cluster creation][4], a `.pem` file is created. You will need this `.pem` file to SSH to your cluster.

### <a name="unix"></a>SSH to your DC/OS cluster on Unix/Linux (OS X, Ubuntu, etc)

1.  Change the permissions on the `.pem` file to owner read/write by using the `chmod` command.

    **Important:** Your `.pem` file must be located in the `~/.ssh` directory.

    ```bash
    chmod 600 <private-key>.pem
    ```

2.  SSH into the cluster.

    1.  From your terminal, add your new configuration to the `.pem` file, where `<private-key>` is your `.pem` file.

        ```bash
        ssh-add ~/.ssh/<private-key>.pem
        Identity added: /Users/<yourdir>/.ssh/<private-key>.pem (/Users/<yourdir>/.ssh/<private-key>.pem)
        ```

    *   **To SSH to a master node:**

        1.  From the DC/OS CLI, enter the following command:

            ```bash
            dcos node ssh --master-proxy --leader
            ```

            **Tip:** The default user is `core` for CoreOS. If you are using CentOS, enter:

            ```bash
            dcos node ssh --master-proxy --leader --user=centos
            ```

    *   **To SSH to an agent node:**

        1.  From the Mesos web interface, copy the agent node ID. You can find the IDs on the **Frameworks** (`<master-node-IPaddress>/mesos/#/frameworks`) or **Slaves** page (`<master-node-IPaddress>/mesos/#/slaves`).

            ![Mesos Sandbox](../img/mesos-sandbox-slave-copy.png)

        2.  From the DC/OS CLI, enter the following command, where `<mesos-id>` is your agent ID:

            ```bash
            dcos node ssh --master-proxy --mesos-id=<mesos-id>
            ```


### <a name="windows"></a>SSH to your DC/OS cluster on Windows

**Requirements:**

*   PuTTY SSH client or equivalent (These instructions assume you are using PuTTY, but almost any SSH client will work.)
*   PuTTYgen RSA and DSA key generation utility
*   Pageant SSH authentication agent

To install these programs, download the Windows installer <a href="http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html" target="_blank">from the official PuTTY download page.</a>

1.  Convert the `.pem` file type to `.ppk` by using PuTTYgen:

    1.  Open PuTTYgen, select **File > Load Private Key**, and choose your `.pem` file.

    2.  Select **SSH-2 RSA** as the key type, click **Save private key**, then choose the name and location to save your new .ppk key.

        ![Windows](../img/windowsputtykey.png)

    3.  Close PuTTYgen.

2.  SSH into the cluster.

    *   **To SSH to a master node:**

        1.  From the DC/OS web interface, copy the IP address of the master node. It will be the IP address that you used to connect to the GUI.

        2.  Open PuTTY and enter the master node IP address in the **Host Name (or IP address)** field.

            ![Putty Configuration](../img/windowsputtybasic.png)

        3.  In the **Category** pane on the left side of the PuTTY window, choose **Connection > SSH > Auth**, click **Browse**, locate and select your `.ppk` file, then click **Open**.

            ![Putty SSH Options](../img/windowsputtysshopt.png)

        4.  Login as user "core" if you're running CoreOS. The default user on CentOS is "centos".

            ![Windows Login](../img/windowscore.png)

    *   **To SSH to an agent node**

        **Prerequisite:** You must be logged out of your master node.

        1.  Enable agent forwarding in PuTTY.

            **Caution:** SSH agent forwarding has security implications. Only add servers that you trust and that you intend to use with agent forwarding. For more information on agent forwarding, see <a href="https://developer.github.com/guides/using-ssh-agent-forwarding/" target="_blank">Using SSH agent forwarding.</a>

            1.  Open PuTTY. In the **Category** pane on the left side of the PuTTY window, choose **Connection > SSH > Auth** and check the **Allow agent forwarding** box.

            2.  Click the **Browse** button and locate the `.ppk` file that you created previously using PuTTYgen.

                ![Windows Forwarding](../img/windowsforwarding.png)

        2.  Add the `.ppk` file to Pageant.

            1.  Open Pageant. If the Pageant window does not appear, look for the Pageant icon in the notification area in the lower right area of the screen next to the clock and double-click it to open Pageant's main window.

            2.  Click the **Add Key** button.

            3.  Locate the `.ppk` file that you created using PuTTYgen and click **Open** to add your key to Pageant.

                ![Windows Pageant](../img/windowspageant.png)

            4.  Click the **Close** button to close the Pageant window.

        3.  SSH into the master node.

            1.  From the DC/OS web interface, copy the IP address of the master node. The IP address is displayed beneath your cluster name.

            2.  In the **Category** pane on the left side of the PuTTY window, choose **Session** and enter the master node IP address in the **Host Name (or IP address)** field.

            4.  Login as user "core" if you're running CoreOS. The default user on CentOS is "centos".

                ![Windows Login](../img/windowscore.png)

        4.  From the master node, SSH into the agent node.

            1.  From the Mesos web interface, copy the agent node hostname. You can find hostnames on the **Frameworks** (`<master-node-IPaddress>/mesos/#/frameworks`) or **Slaves** page (`<master-node-IPaddress>/mesos/#/slaves`).

            2.  SSH into the agent node as the user `core` with the agent node hostname specified:

                    ssh core@<agent-node-hostname>

 [1]: /docs/1.7/usage/cli/command-reference/
 [2]: #unix
 [3]: #windows
 [4]: /docs/1.7/administration/installing/cloud/aws/


