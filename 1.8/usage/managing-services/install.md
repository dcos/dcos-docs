---
post_title: Installing Services
nav_title: Installing
menu_order: 000
---

You can install DC/OS services from a package repository such as the [Mesosphere Universe](/docs/1.8/overview/concepts/#mesosphere-universe) or deploy your own user-created services.
 
# Installing Universe services

## CLI

The general syntax for installing a service with the CLI follows. 

```bash
$ dcos package install [--options=<config-file-name>.json] <servicename>
```

Use the optional `--options` flag to specify the name of the customized JSON file you created in [advanced configuration](/docs/1.8/usage/managing-services/config/).

For example, you would use the following command to install Chronos with the default parameters.
    
```bash
$ dcos package install chronos
```
    
## Web interface

From the DC/OS web interface you can install services from the **Services** or **Universe** tab. The Universe tab shows all of the available DC/OS services from package [repositories](/docs/1.8/usage/repo/). The Services tab provides a full featured interface to the native DC/OS Marathon instance.

-  **Universe tab**

   1.  Navigate to the [**Universe**](/docs/1.8/usage/webinterface/#universe) tab in the DC/OS web interface.
   2.  Choose your package and click **Install package**. 
   3.  Confirm your installation or choose [**Advanced Installation**](/docs/1.8/usage/managing-services/config/) to include a custom configuration.

-  **Services tab**

   1.  Navigate to the [**Services**](/docs/1.8/usage/webinterface/#services) tab in the DC/OS web interface.
   1.  Click **Deploy Service** and specify your Marathon app definition.
   1.  Click **Deploy**. 

## Verifying your installation

### CLI

```bash
$ dcos package list
```

### Web interface

Go to the **Services** tab and confirm that the service is running. For more information, see the web interface [documentation](/docs/1.8/usage/webinterface/#services).

**Tip:** Some services from the "Community Packages" section of the Universe will not show up in the DC/OS service listing. For these, inspect the service's Marathon app in the Marathon web interface to verify that the service is running and healthy.


# Installing user-created services

## CLI

The general syntax for installing a service with the CLI follows. 

```bash
$ dcos marathon app add <myapp.json>
```

For more information, see [CLI command reference](/docs/1.8/usage/cli/command-reference/).
    
## Web interface

From the DC/OS web interface you can install services from the **Services** tab. The Services tab provides a full featured interface to the native DC/OS Marathon instance.

1.  Navigate to the [**Services**](/docs/1.8/usage/webinterface/#services) tab in the DC/OS web interface.
1.  Click **Deploy Service** and specify your Marathon app definition.
1.  Click **Deploy**. 

## Verifying your installation

### CLI

```bash
$ dcos marathon app list
```

### Web interface

Go to the **Services** tab and confirm that the service is running. For more information, see the web interface [documentation](/docs/1.8/usage/webinterface/#services).