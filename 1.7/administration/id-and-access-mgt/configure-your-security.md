---
post_title: Configuring Your Security
menu_order: 1
---

### Using your own Auth0 account

For improved security, administrators can choose to configure their own Auth0
account or integrate directly with the OpenID Connect endpoints provided by
Google, GitHub, Microsoft Accounts, Azure Active Directory and many others.

If you are performing a custom advanced installation, you may configure DC/OS
to use an alternative Auth0 account by adding the following directive to
`genconf/config.yaml`:

```yaml
oauth_enabled: 'true'
oauth_issuer_url: https://youraccount.auth0.com/
oauth_client_id: <client id from application>
oauth_auth_redirector: https://youraccount.auth0.com
oauth_auth_host: https://youraccount.auth0.com
```

To obtain the client ID and use your own Auth0 account, complete the following steps:

1. Sign up for [Auth0](https://auth0.com/).
2. Create a new "Regular Web" application in your Auth0 dashboard.
3. Skip the Quick Start documentation and switch to the Settings tab to obtain
   the client ID.
4. Add `https://youraccount.auth0.com` to the Allowed Origins (CORS) setting.
5. Show Advanced Settings at the bottom of the Settings page and change the JWT Signature Algorithm in the OAuth tab to RS256.
6. In [Auth0's Hosted Pages](https://manage.auth0.com/#/login_page), create a custom Login Page using the HTML/JavaScript source of the [DC/OS login page](https://dcos.auth0.com/login?client=3yF5TOSzdlI45Q1xspxzeoGBe9fNxm9m).
7. In this custom Login Page you need to change the configuration encoded string in the `config` variable. You can use [DC/OS Custom Auth0 config Encoder](https://rohithzr.github.io/dcos-oauth-config/) to generate the string.
8. You will have to configure your own ClientID and Secret on the social provider. To do that, go to Social Connections expand the provider and configure the keys.

The custom login page is currently required to work with the current version
of the DC/OS UI. A future release will remove the need for a custom login page
when using your own Auth0 account or using another identity provider directly,
but will require configuring a callback URL specific to your cluster.

In the custom Login Page you can also override the default values by directly entering the custom values in the login page.
```javascript
var auth0 = new Auth0({
   domain: "mydomain.auth0.com",
   clientID: "myClientId",
   callbackURL: "",
   callbackOnLocationHash: true
 });
```

If you don't setup your own social provider keys you will get an error saying "Social provider API keys are required".

Similar functionality will be added to AWS and Azure in a future release.