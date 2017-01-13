---
post_title: Authentication HTTP API Endpoint
---

You can make external calls to HTTP API endpoints in your DC/OS cluster.

You must first obtain an authentication token and then include it in your HTTP request.

Authentication tokens expire after 5 days. You can view the expiration time in the ["exp" (Expiration Time) Claim](https://tools.ietf.org/html/rfc7519#section-4.1.4) of the JSON Web Token (JWT). You can refresh your token by re-logging in to DC/OS.

# Obtain an authentication token

You can obtain your authentication token using the DC/OS CLI. When you log into the DC/OS CLI, you paste an OpenID Connect ID token into your terminal prompt. This OpenID Connect ID token logs you into the DC/OS CLI but does not allow you to access the HTTP API endpoints. You must obtain an authentication token to gain access to the HTTP API endpoints. Complete the following steps to obtain your authentication token.

[Log in to the DC/OS CLI](/docs/1.9/administration/id-and-access-mgt/managing-authentication#log-in-cli).

Logging into the DC/OS CLI causes your authentication token to be written to a configuration file. Type the following command to confirm that this write succeeded and view your authentication token.

```bash
$ dcos config show core.dcos_acs_token
```

# Passing your authentication token to DC/OS endpoints

DC/OS endpoints expect to find your authentication token in the `Authorization` field of your HTTP header as follows.

```http
Authorization: token=<authentication-token>
```

With cURL, you can use command substitution 
to extract the token value from your configuration file. The following examples illustrate this syntax.

**Sample Marathon request:**

```bash
$ curl --header "Authorization: token=$(dcos config show core.dcos_acs_token)" http://<master-host-name>/service/marathon/v2/apps
```

**Sample Mesos request:**

```bash
$ curl --header "Authorization: token=$(dcos config show core.dcos_acs_token)" http://<master-host-name>/mesos/master/state.json
```
