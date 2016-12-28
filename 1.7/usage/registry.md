---
post_title: Deploying a private Docker registry using VIPs
nav_title: Private Docker Registry
menu_order: 40
---

You can use a number of (hosted) [options](https://mesosphere.com/blog/2015/10/14/docker-registries-the-good-the-bad-the-ugly/) to store and manage your Docker images, but you can also set up a private Docker registry yourself and run it within your DC/OS cluster. This private registry is based on the [Docker registry image](https://docs.docker.com/registry/) and stores images in a system using one of the available storage drivers.

The advantages of a private Docker registry are:

- They can be securely deployed in your local environment (DC/OS cluster).
- Reduced latency for pushing and pulling images, leading to faster deployments.

This article describes how to set up a private Docker registry in a DC/OS cluster and make it accessible through a [VIP](/docs/1.7/usage/service-discovery/virtual-ip-addresses/). 

## Security options

Before you set up a private registry, you should decide how you want to set up security. There are three basic options for configuring security in a private registry. 

1. __Trusted Certificate Authority__ This is the recommended option for production workloads. This option requires requesting a certificate from a trusted CA and existing naming configurations to resolve the registry. As an added benefit, you do not have to configure the Docker daemons to trust the certificate.
1. __Self-signed Certificate__ This option provides decent security and is more manageable.
1. __Insecure__ This option should be avoided when possible. It may even conflict with Docker-in-Docker containers such as Jenkins.

For more information on setting up a Docker Trusted registry see [deploying a registry server](https://docs.docker.com/registry/deploying/) via the Docker docs.

## Naming and discovery options

After the registry is deployed clients will need to access it. When you create the certificate, you should consider the naming and discovery approach used to access the service.  You can use any of the [service discovery](/docs/1.7/usage/service-discovery/) options available in DC/OS:

- __Mesos-DNS__ with host port mapping is an easy option, but requires that ports are managed as resources in the cluster.
- __Minuteman__ provides a stable endpoint and you can use either the VIP or a DNS entry that references the VIP. A DNS entry can add a bit more complexity but improves consumption of the service.
- __Marathon-LB__ is another alternative that will work, but is better suited for north-south ingress traffic.

Note: if you are using a port other than `443`, the port will have to be specified when the service is accessed.

All of these options work fine, however in this tutorial we focus on using a self-signed certificate via VIPs (Minuteman).

## Deploy a Docker registry using a self-signed certificate

At a high level, here are the three steps required to set up a private Docker registry:

1. Create a self-signed certificate with the correct common name and subject alternative names.
1. Configure the Docker Registry service with the public and private key for the certificate.
1. Configure Docker daemons to trust the self-signed certificates.

Open an SSH connection to a master node in the cluster with credentials forwarding enabled (option `-A`), so that an SSH connection can be made to other nodes in the cluster. Note: this tutorial uses [jq](https://stedolan.github.io/jq/), but you can also carry out the steps using, for example, `grep`.

Apply this workaround for minuteman to all of your cluster nodes so that you can push and pull images to and from the registry.

```bash
$ for i in $(curl -sS master.mesos:5050/slaves | jq '.slaves[] | .hostname' | tr -d '"'); do ssh "$i" -oStrictHostKeyChecking=no "sudo sysctl -w net.netfilter.nf_conntrack_tcp_be_liberal=1"; done
```

### Create a self signed cert

The first step is to create a self-signed certificate to secure a Docker registry. It’s important that the common name used in the certificate matches the domain name that is used to access the registry.

You can create a self-signed certificate to secure a registry by using OpenSSL. This command creates a certificate that uses a minuteman VIP to access the registry. 

```bash
$ cp /usr/lib/ssl/openssl.cnf ./openssl.cnf
$ sed -i "/\[ v3_ca \]/a subjectAltName = IP:192.168.0.1" ./openssl.cnf
$ openssl req -config ./openssl.cnf -newkey rsa:2048 -nodes -keyout domain.key -x509 -days 365 -out domain.crt -subj "/C=US/ST=WA/L=Mill Creek/O=flak.io/CN=192.168.0.1"
```

Creating a self-signed certificate using a VIP that works with Docker is a bit more complicated, because the OpenSSL configuration must be modified to include the VIP in the subject alternative name.

Note: alternatively, a certificate could be created using either the Mesos-DNS name for the service, or a name that references the minuteman VIP.

Below are the steps needed to use Mesos DNS:

```bash
$ openssl req -config ./openssl.cnf -newkey rsa:2048 -nodes -keyout domain.key -x509 -days 365 -out domain.crt -subj "/C=US/ST=WA/L=Mill Creek/O=flak.io/CN=registry.marathon.mesos"
```

Hostname referencing a minuteman VIP:

```bash
$ openssl req -config ./openssl.cnf -newkey rsa:2048 -nodes -keyout domain.key -x509 -days 365 -out domain.crt -subj "/C=US/ST=WA/L=Mill Creek/O=flak.io/CN=reg.flak.io"
```

The remainder of the walkthrough focuses on using VIPs.

### Copy the certificate and key to the agents

All of the Docker daemons in your cluster must be configured to trust the self-signed certificate. To configure this, you must distribute the public certificate on every agent node running Docker, and on the masters that will connect to the registry.

The Docker registry itself requires the certificate and the private key. You can embed these in the Docker image by building a new Docker image from `registry:2` and including the certificate files. You can also use a configuration management tool or script to copy these files to every agent in the cluster that the registry service is scheduled on. The files could also come from a file share mounted to all of the nodes, like Azure Files.

You can use the following commands to copy the certificate and keys to all agents in the cluster:

```bash
$ MESOS_AGENTS=$(curl -sS master.mesos:5050/slaves | jq '.slaves[] | .hostname' | tr -d '"');
$ for i in $MESOS_AGENTS; do ssh "$i" -oStrictHostKeyChecking=no "sudo mkdir --parent /etc/privateregistry/certs/"; done
$ for i in $MESOS_AGENTS; do scp -o StrictHostKeyChecking=no ./domain.* "$i":~/; done
$ for i in $MESOS_AGENTS; do ssh "$i" -oStrictHostKeyChecking=no "sudo mv ./domain.* /etc/privateregistry/certs/"; done
```

You must configure the Docker daemon on all machines that require registry access to trust the self-signed certificate. You must  create a folder that matches the FQDN in the `certs.d` folder and copy the certificate to the folder using the name `ca.crt`. You can use the following script to create the folders and copy the files into the appropriate locations:

```bash
$ MESOS_AGENTS=$(curl -sS master.mesos:5050/slaves | jq '.slaves[] | .hostname' | tr -d '"');
$ for i in $MESOS_AGENTS; do ssh "$i" -oStrictHostKeyChecking=no "sudo mkdir --parent /etc/docker/certs.d/192.168.0.1"; done
$ for i in $MESOS_AGENTS; do ssh "$i" -oStrictHostKeyChecking=no "sudo cp /etc/privateregistry/certs/domain.crt /etc/docker/certs.d/192.168.0.1/ca.crt"; done
$ for i in $MESOS_AGENTS; do ssh "$i" -oStrictHostKeyChecking=no "sudo systemctl restart docker"; done
```

### Docker in Docker

When running Docker in Docker on cluster agents that contain the certificate, you can simply map the `/etc/docker/certs.d/` path on the host to the same path in the container so that it trusts the self-signed certificate.

## Deploy the registry using Marathon

Now that you have copied the certificates to the nodes, you can deploy a Docker registry using the certificates. The following steps deploy a registry instance using the self-signed certificates. You must have a storage backend configured using one of the supported [storage drivers](https://docs.docker.com/registry/storage-drivers/).

```bash
$ cat registry.json
{
  "id": "/registry",
  "cpus": 0.5,
  "mem": 128,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "volumes": [
      {
        "containerPath": "/certs/",
        "hostPath": "/etc/privateregistry/certs/",
        "mode": "RO"
      }
    ],
    "docker": {
      "image": "registry:2",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 0,
          "servicePort": 10000,
          "protocol": "tcp",
          "labels": {
            "VIP_0": "192.168.0.1:443"
          }
        }
      ],
      "privileged": false,
      "parameters": [],
      "forcePullImage": false
    }
  },
  "env": {
    "REGISTRY_HTTP_TLS_CERTIFICATE": "/certs/domain.crt",
    "REGISTRY_HTTP_TLS_KEY": "/certs/domain.key",
    "REGISTRY_HTTP_SECRET": "248345asecret"
  },
  "portDefinitions": [
    {
      "port": 10000,
      "protocol": "tcp",
      "labels": {}
    }
  ]
}

$ dcos marathon app add registry.json
```

## Test the deployment

Now that the registry is deployed you can push an image and deploy a new Marathon application by using it as follows:

1. Connect to one of the nodes that has the Docker daemon configured to trust the self-signed certificate.
1. Pull the `flakio httpenv` image from docker hub using the following command: `sudo docker pull flakio/httpenv:1`
1. Add a new tag to the image allowing us to push it to our private registry: `sudo docker tag flakio/httpenv:1 192.168.0.1/httpenv:1`
1. Push the image to the registry we just deployed: `sudo docker push 192.168.0.1/httpenv:1`
1. Create a new Marathon app with the image from the private registry, using `192.168.0.1/httpenv:1` for the `"image"` field.

## More information

Find out how to [use a private Docker registry](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html) with Marathon. 