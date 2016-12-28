---
post_title: Application Definitions
nav_title: Application Definitions
menu_order: 0
---

A Marathon application typically represents a long-running service, of which there would be many instances running on multiple hosts. An application instance is called a *task*. The *application definition* describes everything needed to start and maintain the tasks. A Marathon application definition creates a DC/OS _service_.

# Hello Marathon: An Inline Shell Script

### Prerequisites
- [A DC/OS cluster](/docs/1.7/administration/installing/)
- [The DC/OS CLI installed](/docs/1.7/usage/cli/install/)

Let's start with a simple example: an service that prints `Hello Marathon` to stdout and then sleeps for 5 sec, in an endless loop.
Use the following JSON application definition to describe the application. Create a file with the name of your choice. 

```json
{
    "id": "basic-0", 
    "cmd": "while [ true ] ; do echo 'Hello Marathon' ; sleep 5 ; done",
    "cpus": 0.1,
    "mem": 10.0,
    "instances": 1
}
```

`cmd` in the above example is the command that gets executed. Its value is wrapped by the underlying Mesos executor via `/bin/sh -c ${cmd}`.

Then, add the service to DC/OS

```bash
dcos marathon app add <your-service-name>.json
```

When you define and launch a service, Marathon hands over execution to Mesos. Mesos creates a sandbox directory for each task. The sandbox directory is a directory on each agent node that acts as an execution environment and contains relevant log files. The `stderr` and `stdout` streams are also written to the sandbox directory.

## Using Resources in Applications

To run any non-trivial application, you typically depend on a collection of resources: files or archives of files. To manage resource allocation, Marathon has the concept of URIs (uniform resource identifiers). URIs use the [Mesos fetcher](http://mesos.apache.org/documentation/latest/fetcher/) to do the legwork in terms of downloading (and potentially) extracting resources.

Before we dive into this topic, let's have a look at an example:

```json
{
    "id": "basic-1", 
    "cmd": "`chmod u+x cool-script.sh && ./cool-script.sh`",
    "cpus": 0.1,
    "mem": 10.0,
    "instances": 1,
    "uris": [
        "https://example.com/app/cool-script.sh"
    ]
}
```

The example above executes the `cmd`, downloads the resource `https://example.com/app/cool-script.sh` (via Mesos), and makes it available in the service instance's Mesos sandbox. You can verify that it has been downloaded by visiting the DC/OS web interface and clicking on an instance of `basic-1`, then on the **Files** tab. You should find `cool-script.sh` there.

**Note:** As of Mesos v0.22 and above, the fetcher code does not make downloaded files executable by default. In the example above, `cmd` first makes the file executable.

As already mentioned above, Marathon also [knows how to handle](https://github.com/mesosphere/marathon/blob/master/src/main/scala/mesosphere/mesos/TaskBuilder.scala) application resources that reside in archives. Currently, Marathon will (via Mesos and before executing the `cmd`) first attempt to unpack/extract resources with the following file extensions:

* `.tgz`
* `.tar.gz`
* `.tbz2`
* `.tar.bz2`
* `.txz`
* `.tar.xz`
* `.zip`

The following example shows you how this looks in practice. Assume you have an application executable in a zip file at `https://example.com/app.zip`. This zip file contains the script `cool-script.sh`, which you want to execute. Here's how:

```json
{
    "id": "basic-2", 
    "cmd": "app/cool-script.sh",
    "cpus": 0.1,
    "mem": 10.0,
    "instances": 1,
    "uris": [
        "https://example.com/app.zip"
    ]
}
```

In contrast to the example `basic-1` we now have a `cmd` with the value `app/cool-script.sh`. When the zip file gets downloaded and extracted, a directory `app` according to the file name `app.zip` is created and the content of the zip file is extracted into it.

You can specify more than one resource. For example, you could provide a Git repository and some resources from a CDN as follows:

```json
{
    "uris": [
        "https://git.example.com/repo-app.zip", "https://cdn.example.net/my-file.jpg", "https://cdn.example.net/my-other-file.css"
    ]
}
```

A typical pattern in the development and deployment cycle is to have your automated build system place the app binary in a location that's downloadable via an URI. Marathon can download resources from a number of sources. Marathon supports the following [URI schemes](http://tools.ietf.org/html/rfc3986#section-3.1):

* `file:`
* `http:`
* `https:`
* `ftp:`
* `ftps:`
* `hdfs:`
* `s3:`
* `s3a:`
* `s3n:`

## A Simple Docker-based Application

With Marathon it is straightforward to run applications that use Docker images.

In the following example, you will create a simple Docker app and deploy it to DC/OS using the Marathon REST API.

The Docker app is a Python-based web server that uses the image [python:3](https://registry.hub.docker.com/_/python/). Inside the container, the web server runs on port `8080` (the value of `containerPort`). `hostPort` is set to `0` so that Marathon assigns a random port on the Mesos agent, which is mapped to port 8080 inside the container.

Paste the following JSON into a file named `basic-3.json`.

```json
{
  "id": "basic-3",
  "cmd": "python3 -m http.server 8080",
  "cpus": 0.5,
  "mem": 32.0,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "python:3",
      "network": "BRIDGE",
      "portMappings": [
        { "containerPort": 8080, "hostPort": 0 }
      ]
    }
  }
}
```

Use the Marathon REST API to deploy the app `basic-3` from the DC/OS CLI:

```sh
 curl -H -X POST <master-IP>/service/marathon/v2/apps -d @basic-3.json -H "Content-type: application/json"
```

When you submit the above application definition to DC/OS, you should see your new service running from the **Services** tab of the DC/OS GUI.

Go to `<dcos-url>:3100` to see the contents of the Docker container's root directory.
