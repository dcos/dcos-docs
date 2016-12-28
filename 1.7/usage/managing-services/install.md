---
post_title: Installing Services
nav_title: Installing
menu_order: 000
---
 
## Installing a service using the CLI

The general syntax for installing a service with the CLI follows. 

```bash
$ dcos package install [--options=<config-file-name>.json] <servicename>
```

Use the optional `--options` flag to specify the name of the customized JSON file you created in [advanced configuration](/docs/1.7/usage/managing-services/config/).

For example, you would use the following command to install Chronos with the default parameters.
    
```bash
$ dcos package install chronos
```
    
## Installing a service using the web interface

1.  Navigate to the [**Universe**](/docs/1.7/usage/webinterface/#universe) page in the DC/OS UI.

2.  Choose your package and click **Install package**. 

3.  Confirm your installation or choose [**Advanced Installation**](/docs/1.7/usage/managing-services/config/).

## Verifying your installation

### CLI

```bash
$ dcos package list
```

### Web UI

Go to the **Services** tab and confirm that the service is running. For more information, see the UI [documentation](/docs/1.7/usage/webinterface/#services).

**Tip:** Some services from the "Community Packages" section of the Universe will not show up in the DC/OS service listing. For these, inspect the service's Marathon app in the Marathon UI to verify that the service is running and healthy.