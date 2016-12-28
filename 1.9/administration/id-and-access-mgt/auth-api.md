---
post_title: Authentication HTTP API Endpoint
---

You can make external calls to HTTP API endpoints in your DC/OS cluster.

You must first obtain an HTTP API token and then include it in your HTTP request.

HTTP API tokens expire after 5 days. You can view the expiration time in the ["exp" (Expiration Time) Claim](https://tools.ietf.org/html/rfc7519#section-4.1.4) of the JSON Web Token (JWT). You can refresh your token by re-logging in to DC/OS.

# Generate the HTTP API token

You can obtain your HTTP API token using DC/OS CLI. When you log into the DC/OS CLI, you paste an authentication token into your terminal prompt. This authentication token logs you into DC/OS CLI but does not authenticate you to the HTTP API endpoints. Complete the following steps to obtain your HTTP API token.

[Log in to the DC/OS CLI](/docs/1.9/administration/id-and-access-mgt/managing-authentication#log-in-cli).

Logging into the DC/OS CLI causes your HTTP API token to be written to a configuration file. Type the following command to confirm that this write succeeded and view your HTTP API token.

```bash
$ dcos config show core.dcos_acs_token
```

# Passing your HTTP API token to DC/OS endpoints

DC/OS endpoints expect to find your HTTP API token in the `Authorization` field of your HTTP header as follows.

```http
Authorization: token=<your-http-token>
```

When using cURL, you can use the following bash `$(dcos config show core.dcos_acs_token)` to extract the token value from your configuration file.

The following full command shows how to authenticate to the Marathon API using cURL.

```bash
$ curl --header "Authorization: token=$(dcos config show core.dcos_acs_token)" http://<master-host-name>/service/marathon/v2/apps
```

The following full command shows how to authenticate to the Mesos API using cURL.

```bash
$ curl --header "Authorization: token=$(dcos config show core.dcos_acs_token)" http://<master-host-name>/mesos/master/state.json
```
