---
post_title: Deploying Services and Pods
menu_order: 130
---

DC/OS uses Marathon to manage processes and services. Marathon is the "init system" for DC/OS. Marathon starts and monitors your applications and services, automatically healing failures.

A native Marathon instance is installed as a part of DC/OS installation. After DC/OS has started, you can manage the native Marathon instance through the **Services** tab of the DC/OS web interface or from the DC/OS CLI with the `dcos marathon` command.

DC/OS services are Marathon applications that are deployed on DC/OS. DC/OS services are available from a package repository, such as the [Mesosphere Universe](/docs/1.9/overview/concepts/#mesosphere-universe), or you can create your own.

#  DC/OS Services

You can run DC/OS services you create or install a package from the [Universe package repository](/docs/1.9/gui/#-a-name-universe-a-universe). Both services you create and those you install from Universe appear on the **Services** tab of the DC/OS web interface when they are running.

Services you create yourself are administered by Marathon and can be configured and run [from the DC/OS CLI](/docs/1.9/cli/command-reference/) with `dcos marathon` subcommands (e.g. `dcos marathon app add <myapp>.json`) or via the DC/OS web interface.

# Universe Package Repository
Packaged DC/OS services created by Mesosphere or the community, like Spark or Kafka, appear on the **Universe** tab of the DC/OS web interface, or you can search for a package from [the DC/OS CLI](/docs/1.9/cli/command-reference/). You can configure and run Universe services from the DC/OS web interface or via the DC/OS CLI with the `dcos package install <package-name>` command. Visit the [Managing Services](/docs/1.9/deploying-services/) section to learn more about installing, configuring, and uninstalling services in Universe.