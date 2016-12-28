---
post_title: Authentication Architecture
menu_order: 1
---


An authentication operation via the DC/OS UI proceeds as follows:

1. The user opens the cluster front page URL in their browser.
2. If the user has a valid [authentication token](/docs/1.9/administration/id-and-access-mgt/managing-authentication#log-in-cli) cookie (checked by Admin Router)
   they may proceed to the cluster front page. If not, they are redirected to
   the login page.
3. The login page in the DC/OS UI loads the login page at `dcos.auth0.com` in an iframe,
   which presents the user a choice of identity providers, including Google,
   GitHub, and Microsoft account.
4. The user selects an identity provider and completes the OAuth protocol flow
   in a popup window that returns an RS256-signed JWT for the user. The
   token is currently issued to be valid for 5 days, based on the standard
   `exp` claim.
5. The login page dispatches a request with the user token to the
   `http://<master-host-name>/acs/api/v1/auth/login` Admin Router endpoint which forwards it to the
   [dcos-oauth](https://github.com/dcos/dcos-oauth) service. If the user is the
   first user accessing the cluster, an account is automatically created. Any
   subsequent users must be added by any other user in the cluster as described
   in the [User Management](/docs/1.9/administration/id-and-access-mgt/user-management/) page.
   If the user logging into the cluster is determined to be valid, they are
   issued with a HS256-signed JWT containing a `uid` claim which is specific to
   the cluster they are logging in to.

For the dcos-oauth service to validate tokens it receives during login operations,
it needs to have access to `dcos.auth0.com` to fetch required public keys via
HTTPS. Using a proxy to make this request is not currently supported.

The shared secret used to sign the cluster-specific tokens with the HS256
algorithm is generated during cluster boot and stored at
`/var/lib/dcos/auth-token-secret` on each master node and in the
`/dcos/auth-token-secret` znode in ZooKeeper.

As noted above, to ease the setup process, DC/OS automatically adds the first
user that logs in to the DC/OS cluster. Be sure to restrict network
access to the cluster until the first user has been configured. A future release
will allow users to be provisioned at installation time.

Be sure to protect authentication tokens, as an unauthorized
third party may use them to log in to your cluster if obtained. Invalidation
of individual tokens is not currently supported. In case a token is exposed,
it is recommended that the affected user be removed from the cluster.

The [JWT.IO](https://jwt.io) service can be used to decode JWTs to inspect
their contents.
