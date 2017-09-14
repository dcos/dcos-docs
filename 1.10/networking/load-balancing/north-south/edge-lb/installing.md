---
post_title: Installing Edge-LB
menu_order: 4
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

Edge-LB is installed as a remote DC/OS package. After you add the remote Edge-LB repository, you can install Edge-LB with the following command from the DC/OS CLI:

```
dcos package install edgelb
```

**Important:** Edge-LB is not yet supported in strict [security mode](/1.10/overview/security/security-modes/).

**Prerequisites:**

-  [DC/OS CLI installed](/1.10/cli/install/) and be logged in as a superuser.
-  Access to [the remote Edge-LB repositories](https://support.mesosphere.com/hc/en-us/articles/213198586).
-  Depending on your [security mode](/1.10/overview/security/security-modes/), you may be able to configure Edge-LB with [service authentication](/1.10/security/ent/service-auth/) before installing and using with DC/OS, allowing you to control what actions your service can take on your cluster. For information on how to configure service authentication for Edge-LB, see the [documentation](/1.10/networking/edge-lb/auth).

   | Security mode | Service Account |
   |---------------|-----------------------|
   | Disabled      | Not available   |
   | Permissive    | Recommended (Optional)   |

# Add Edge-LB package repositories
Contact your sales representative or sales@mesosphere.io for access to this repository. Edge-LB is not available in the default Universe repository.

# <a name="create-json"></a>Create a configuration file for service authentication
If you have configured service authentication (recommended), you must create a JSON options file with your credentials. This file will be passed to DC/OS when you install Edge-LB.

In the file, specify the service account (`<service-account-id>`) and secret (`edge-lb/<secret-name>`) that you created earlier.

```json
{
  "service": {
    "principal": "<service-account-id>",
    "secret_name": "edge-lb/<secret-name>"
  }
}
```

Save the file with a meaningful name, such as  <edge-lb-options>.json.

# <a name="install-edge-lb"></a>Install Edge-LB
Install Edge-LB with this command:

```bash
dcos package install --options=<edge-lb-options>.json edgelb
```

Run this command and wait for the Edge-LB service to be ready.

```bash
until dcos edgelb ping; do sleep 1; done
```

You should receive this message when ready:

```bash
pong
```

- For more information about configuring Edge-LB, see the [Edge-LB Configuration](/1.10/networking/edge-lb/configuration) section.
- For more information about the available Edge-LB commands, see the [Edge-LB Command Reference](/1.10/cli/command-reference/dcos-edgelb/).
