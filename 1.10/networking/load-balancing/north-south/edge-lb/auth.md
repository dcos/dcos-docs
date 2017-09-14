---
post_title: Configuring DC/OS Access for Edge-LB
menu_order: 3
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

This topic describes how to configure DC/OS access for Edge-LB. Depending on your [security mode](/1.10/overview/security/security-modes/), Edge-LB requires [service authentication](/1.10/security/ent/service-auth/) for access to DC/OS.

| Security mode | Service Account |
|---------------|-----------------------|
| Disabled      | Not available   |
| Permissive    | Recommended (optional) |

**Prerequisites:**

- [DC/OS CLI installed](/1.10/cli/install/) and be logged in as a superuser.
- [Enterprise DC/OS CLI 0.4.14 or later installed](/1.10/cli/enterprise-cli/#ent-cli-install).
- If your [security mode](/1.10/overview/security/security-modes/) is `permissive`, you must [get the root cert](/1.10/networking/tls-ssl/get-cert/) before issuing the curl commands in this section.

# <a name="create-a-keypair"></a>Create a Key Pair
In this step, a 2048-bit RSA public-private key pair is created using the Enterprise DC/OS CLI.

Create a public-private key pair and save each value into a separate file within the current directory.

```bash
dcos security org service-accounts keypair <private-key>.pem <public-key>.pem
```

**Tip:** You can use the [DC/OS Secret Store](/1.10/security/ent/secrets/) to secure the key pair.

# <a name="create-a-service-account"></a>Create a Service Account

## Permissive
From a terminal prompt, create a new service account (`<service-account-id>`) containing the public key (`<your-public-key>.pem`).

```bash
dcos security org service-accounts create -p <your-public-key>.pem -d "Edge-LB service account" <service-account-id>
```

**Tip:** You can verify your new service account using the following command.

```bash
dcos security org service-accounts show <service-account-id>
```

# <a name="create-an-sa-secret"></a>Create a Secret
Create a secret (`edge-lb/<secret-name>`) with your service account (`<service-account-id>`) and private key specified (`<private-key>.pem`).

**Tip:** If you store your secret in a path that matches the service name (e.g. service name and path are `edge-lb`), then only the service named `edge-lb` can access it.

## Permissive

```bash
dcos security secrets create-sa-secret <private-key>.pem <service-account-id> edge-lb/<secret-name>
```

**Tip:**
You can list the secrets with this command:

```bash
dcos security secrets list /
```

# <a name="give-perms"></a>Create and Assign Permissions
Use the following curl commands to rapidly provision the Edge-LB service account with the required permissions.

**Tips:**

- Any `/` character in a resource must be replaced with `%252F` before it can be passed in a curl command.
- When using the API to manage permissions, you must first create the permission and then assign it. Sometimes, the permission may already exist. In this case, the API returns an informative message. You can regard this as a confirmation and continue to the next command.

1.  Create the permission.

    ## Permissive

    ```bash
    curl -X PUT --cacert dcos-ca.crt \
    -H 'Content-Type: application/json' \
    -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:services:%252F \
    -d '{"description":"Allows access to any service launched by the native Marathon instance"}' \
    curl -X PUT --cacert dcos-ca.crt \
    -H 'Content-Type: application/json' \
    -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:admin:events \
    -d '{"description":"Allows access to Marathon events"}'
    ```

    ## Permissive

    ```bash
    curl -X PUT --cacert dcos-ca.crt \
    -H 'Content-Type: application/json' \
    -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:services:%252F \
    -d '{"description":"Allows access to any service launched by the native Marathon instance"}' \
    curl -X PUT --cacert dcos-ca.crt \
    -H 'Content-Type: application/json' \
    -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:admin:events \
    -d '{"description":"Allows access to Marathon events"}'
    ```    


1.  Grant the permissions and the allowed actions to the service account using the following commands.

    ## Permissive
    Run these commands.

    ```bash
    curl -X PUT --cacert dcos-ca.crt \
    -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:services:%252F/users/edgelb-principal/read
    curl -X PUT --cacert dcos-ca.crt \
    -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:admin:events/users/edgelb-principal/read
    ```

For more information about the available Edge-LB commands, see the [Edge-LB command reference](/1.10/cli/command-reference/dcos-edgelb/).
