---
post_title: Package Repository
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->
[DC/OS services][1] are generally installed in one of two ways, either through Marathon directly or from a DC/OS package repository. By default, the [DC/OS Command-Line Interface][2] is configured to use the primary public package repository: [Mesosphere Universe][1].

## Install a Packaged Service

DC/OS services can be installed on your cluster with a single command from the DC/OS CLI:

```bash
$ dcos package install <service-name>
```

## Search for Packages

If you're looking for big data packages, use:

```bash
$ dcos package search "big data"
NAME VERSION FRAMEWORK SOURCE DESCRIPTION
spark 1.4.0-SNAPSHOT True https://github.com/mesosphere/universe/archive/version-1.x.zip Spark is a fast and general cluster computing system for Big Data
```

## List Repositories

By default, the DC/OS CLI is configured to use the Mesosphere Universe, but other package repositories may also be configured.

See which package repositories are currently configured:

```bash
$ dcos package repo list
Universe: https://universe.mesosphere.com/repo
```

## Add a Repository

Add a repo with the name `your-repo` and the repo archive URL `https://yourcompany/archive/stuff.zip`:

```bash
$ dcos package repo add your-repo https://yourcompany/archive/stuff.zip
```

## Remove a Repository

Remove the repo with the name `your-repo`:

```bash
$ dcos package repo remove your-repo
```

 [1]: /docs/1.7/usage/services/
 [2]: /docs/1.7/usage/cli/
