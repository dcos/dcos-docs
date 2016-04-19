---
post_title: User Management
menu_order: 2
---

In the following, we will walk you through user management aspects of DC/OS: how to perform the initial authentication and how to give other users access to the cluster.

## Initial Authentication

After you have [installed](/docs/1.7/administration/installing/) your DC/OS cluster and opened the Dashboard URL you should see the following screen:

![First time accessing the Dashboard](../img/user-management-step1.png)

After you log in with one of the three single-sign-on options (Google, GitHub, or Microsoft), you will reach the Dashboard:

![Signed into DC/OS Dashboard](../img/user-management-step2.png)

**Note:** You can [opt out](/docs/1.7/administration/opt-out/) of the authentication process, though this is not recommended for security reasons.

### CLI Authentication

THe DC/OS CLI allows you to administer your cluster from the command line of your local machine. To install the DC/OS CLI and authenticate it against the cluster, click the identity (your email address) in the menu in the lower left corner. Select the `Install CLI` entry. You should see:

![Install DC/OS CLI](../img/user-management-step3.png)

Follow the instructions from above (fulfilling the prerequisites: Python, `cURL`, `pip`, and `virtualenv`) and you see the following screen:

![Installed DC/OS CLI](../img/user-management-step4.png)

Enter the following in the CLI to authenticate against your cluster:

    $ dcos auth login

The auth endpoint URL leads to a page with an auth token you should copy:

![Obtaining auth token](../img/user-management-step5.png)

In the next and last step, paste the auth token back into the terminal you opened in the previous step (where you typed `dcos auth login`):

![Applying auth token](../img/user-management-step6.png)

Note that in DC/OS everyone is an admin user,;there is no explicit concept of privileges.

You're now the owner of a brand new DC/OS cluster, have access to it from both the Dashboard and the CLI and are now ready to use it! Follow the steps in the next section to add more users.

## Adding Users

To give other users access to the DC/OS cluster, go to the `System` view and select the `Organization` tab. There, click on `+ New User` and enter the email of the user you want to add.

![Adding user](../img/user-management-step7.png)

The user you added will receive an email:

![User email confirmation](../img/user-management-step8.png)

With this, your colleague has access to the cluster and now she or you can repeat this step to invite others.

## Next Steps

- [Understand DC/OS security](/docs/1.7/overview/security/)
- [Learn how to monitor a DC/OS cluster](/docs/1.7/administration/monitoring/)
