---
post_title: Managing Package Repositories
nav_title: Package Repository
menu_order: 50
---

DC/OS comes pre-configured with the [Mesosphere Universe](https://github.com/mesosphere/universe) package repository as the provider of DC/OS packages, but other package repositories can also be added.

You can use either the web interface or the CLI to:

* [Listing](#listing)
* [Searching](#finding-packages)
* [Adding](#adding)
* [Removing](#removing)

**Tip:** Before you can use the CLI, you need to [install it](/docs/1.7/usage/cli/install/).

## <a name="listing"></a>Listing repositories

To see which package repositories are currently configured from the DC/OS CLI as follows:

```bash
$ dcos package repo list
Universe: https://universe.mesosphere.com/repo
```

## <a name="finding-packages"></a>Searching for packages

The syntax for searching for packages follows.

```bash
$ dcos package search [--json <query>]
```

The following command will locate big data packages.

```bash
$ dcos package search "big data"
NAME VERSION FRAMEWORK SOURCE DESCRIPTION
spark 1.4.0-SNAPSHOT True https://github.com/mesosphere/universe/archive/version-1.x.zip Spark is a fast and general cluster computing system for Big Data
```

## <a name="adding"></a>Adding a Repository

Add a repo with the name `your-repo` and the repo URL `https://universe.yourcompany.com/repo`:

```bash
$ dcos package repo add your-repo https://universe.yourcompany.com/repo
```

For full instructions on how to build and run your own Universe repo see the [Universe Server Documentation](https://github.com/mesosphere/universe#universe-server)

## <a name="removing"></a>Removing a Repository

Remove the repo with the name `your-repo`:

```bash
$ dcos package repo remove your-repo
```
