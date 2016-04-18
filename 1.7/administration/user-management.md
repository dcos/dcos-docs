---
post_title: User Management
menu_order: 2
---

In the following, we will walk you through user management aspects of DC/OS: how to perform the initial authentication and how to give other users access to the cluster.

## Initial Authentication

So you've [installed](/docs/1.7/administration/installing/) your DC/OS cluster, opened the Dashboard URL in your favorite browser and now should be looking at something like this:

![First time accessing the Dashboard](../img/user-management-step1.png)

Let's log in with one of the three single-sign-on options (Google, GitHub, and Microsoft) listed now and we're in the Dashboard:

![Signed into DC/OS Dashboard](../img/user-management-step2.png)

Note that you can [opt out](/docs/1.7/administration/opt-out/) of the authentication process, however this is not recommended, for security reasons.

### CLI Authentication

Likely the next thing you want to do is to install the DC/OS CLI and authenticate it against the cluster. Have a look at the menu in the lower left corner. Click on the identity (your email address) and select the `Install CLI` entry. This is what you should see:

![Install DC/OS CLI](../img/user-management-step3.png)

Follow the instructions from above (fulfilling the prerequisites Python, `cURL`, `pip`, and `virtualenv`) and you should get something like this:

![Installed DC/OS CLI](../img/user-management-step4.png)

Now enter the following in the CLI to authenticate against your cluster:

    $ dcos auth login

Again, follow the steps outlined there—open the auth endpoint URL—and you'll find yourself on a page that offers an auth token you will want to copy:

![Obtaining auth token](../img/user-management-step5.png)

In the next and last step paste the auth token back into the terminal you opened in the previous step (where you typed `dcos auth login`):

![Applying auth token](../img/user-management-step6.png)

Note that in DC/OS everyone is an admin user, there is no explicit concept of privileges.

Yey, you did it! You're now the owner of a brand new DC/OS cluster, have access to it from both the Dashboard and the CLI and are now ready to use it. Or maybe you want to share the joy and add some of your colleagues? If so, follow the steps in the next section.

## Adding Users

To give other users access to the DC/OS cluster, go to the `System` view and select the `Organization` tab. There, click on `+ New User` and enter the email of the user you want to add.

![Adding user](../img/user-management-step7.png)

The user you added will get an email that looks something like this:

![User email confirmation](../img/user-management-step8.png)

With this, your colleague has access to the cluster and now she or yourself can repeat this step to invite others to the party.

## Next Steps

- [Understand DC/OS security](/docs/1.7/overview/security/)
- [Learn how to monitor a DC/OS cluster](/docs/1.7/administration/monitoring/)
