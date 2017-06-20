---
post_title: Creating a Universe Package
nav_title: Creating a Universe Package
menu_order: 10
---

This page covers general advice and information about creating a DC/OS package that can be published to the Mesosphere Universe. Consult the [Publish a Package][2] page of the Universe documentation for full details.

Each DC/OS Universe package consists of 4 JSON files:

* `package.json` - High-level metadata about the package.
* `resource.json` - Contains all of the externally hosted resources (e.g. Docker images, HTTP objects and images) that are required to install the application.
* `config.json` - Configuration properties supported by the package, represented as a json-schema.
* `marathon.json.mustache` - A mustache template that, when rendered, creates a Marathon app definition capable of running your service.

# `package.json`

Every package in Universe must have a `package.json` file that specifies the highest-level metadata about the package (comparable to a package.json in Node.js or setup.py in Python).

Currently, a package can specify one of two values for `.packagingVersion`, either 2.0 or 3.0. The version declared will dictate which other files are required for the complete package as well as the schemas all the files must adhere to.

Consider the following guidelines when creating your `package.json` file:

* Focus the description on the service. Assume that all users are familiar with DC/OS and Mesos.
* The `tags` parameter is used for user searches (`dcos package search <criteria>`). Add tags that distinguish the service in some way. Avoid the following terms: Mesos, Mesosphere, DC/OS, and datacenter. For example, the unicorns service could have: `"tags": ["rainbows", "mythical"]`.
* The `preInstallNotes` parameter gives the user information they'll need before starting the installation process. For example, you could explain what the resource requirements are for the service: `"preInstallNotes": "Unicorns take 7 nodes with 1 core each and 1TB of ram."`
* The `postInstallNotes` parameter gives the user information they'll need after the installation. Focus on providing a documentation URL, a tutorial, or both. For example: `"postInstallNotes": "Thank you for installing the Unicorn service.\n\n\tDocumentation: http://<service-url>\n\tIssues: https://github.com/"`
* The `postUninstallNotes` parameter gives the user information they'll need after an uninstall. For example, further cleanup before reinstalling again and a link to the details. A common issue is cleaning up ZooKeeper entries. For example: `postUninstallNotes": "The Unicorn DC/OS Service has been uninstalled and will no longer run.\nPlease follow the instructions at http://<service-URL> to clean up any persisted state" }`

See [`package.json`](https://github.com/mesosphere/universe#packagejson) for details on what can be defined in `package.json`.

## Example `package.json`

```json
{
  "packagingVersion": "2.0", // use either 2.0 or 3.0
  "name": "foo", // your package name
  "version": "1.2.3", // the version of the package
  "tags": ["mesosphere", "framework"],
  "maintainer": "help@bar.io", // who to contact for help
  "description": "Does baz.", // description of package
  "scm": "https://github.com/bar/foo.git", 
  "website": "http://bar.io/foo", 
  "framework": true,
  "postInstallNotes": "Have fun foo-ing and baz-ing!"
}
```

# `resource.json`

This file declares all the externally hosted assets the package will need—for example: Docker containers, images, or native binary CLI.  See the [`resource.json`](https://github.com/mesosphere/universe#resourcejson) for details on what can be defined in resource.json.

## Example `resource.json`

```json
{
  "images": {
    "icon-small": "http://some.org/foo/small.png",
    "icon-medium": "http://some.org/foo/medium.png",
    "icon-large": "http://some.org/foo/large.png",
    "screenshots": [
      "http://some.org/foo/screen-1.png",
      "http://some.org/foo/screen-2.png"
    ]
  },
  "assets": {
    "uris": {
      "log4j-properties": "http://some.org/foo/log4j.properties"
    },
    "container": {
      "docker": {
        "23b1cfe8e04a": "some-org/foo:1.0.0"
      }
    }
  }
}
```

# `config.json`

This file declares the packages configuration properties, such as the amount of CPUs, number of instances, and allotted memory. The defaults specified in `config.json` will be part of the context when `marathon.json.mustache` is rendered. This file describes the configuration properties supported by the package, represented as a [json-schema](http://spacetelescope.github.io/understanding-json-schema/).

Each property should provide a default value, specify whether it's required, and provide validation (minimum and maximum values). Users can then override specific values at installation time by passing an options file to the DC/OS CLI or by setting config values through the DC/OS web interface.

## Example `config.json`

```json
{
  "type": "object",
  "properties": {
    "foo": {
      "type": "object",
      "properties": {
        "baz": {
          "type": "integer",
          "description": "How many times to do baz.",
          "minimum": 0,
          "maximum": 16,
          "required": false,
          "default": 4
        }
      },
      "required": ["baz"]
    }
  },
  "required": ["foo"]
}
```

# `marathon.json.mustache`

`marathon.json.mustache` is a [mustache template](http://mustache.github.io/) that, when rendered, creates a [Marathon](http://github.com/mesosphere/marathon) app definition capable of running your service.

Variables in the mustache template are evaluated from a union object created by merging three objects in the following order:

1. Defaults specified in `config.json`.

1. User-supplied options from either the DC/OS CLI or the DC/OS UI.

1. The contents of `resource.json`.

## Example `marathon.json.mustache`

```json
{
  "id": "foo",
  "cpus": "1.0",
  "mem": "1024",
  "instances": "1",
  "args": ["{{{foo.baz}}}"],
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "{{resource.assets.container.docker.foo23b1cfe8e04a}}",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 0,
          "servicePort": 0,
          "protocol": "tcp"
        }
      ]
    }
  }
}
```

# Testing and Distributing Your Package

To test your package, follow [these instructions](https://github.com/mesosphere/universe#universe-server) to build and run a Universe Server. After your Universe Server is up and running, install your package using either the DC/OS CLI or DC/OS UI.

After you have tested your package, follow the ["Submit Your Package"](https://github.com/mesosphere/universe#submit-your-package) instructions to submit it.
