---
post_title: >
    Design: Installation
nav_title: Installation
menu_order: 4
---

Building, installing and operating DC/OS must be a repeatable process. Even small error rates are unacceptable when you’re working with 10,000 hosts. Because DC/OS is comprised of more than 30 different libraries, services and support packages, a non-standard approach is required. Trying to treat each of those components as independent artifacts to install and configure on target hosts would introduce failures that would get in the way of relying on the system.

Inspired by the approaches of many mature operating systems, it is possible to build a system that is bulletproof. Once the build process is complete, you end up with a single artifact that contains all the components required to install and run. This looks very similar to the ISO that you end up using to install your favorite Linux distribution.

Having a single artifact allows us to make some assumptions and guarantees. 

- The bits are identical on every host, they just have different roles and use a different subset of components. 
- Upgrades are atomic and don’t end up having odd component incompatibilities. 
- Downloads do not depend on multiple different sources since there is just a single file that is trivial to verify for completion and corruption.


## Design Goals

Before we jump into how everything works, let’s make the design goals explicit. It is important to understand the constraints you’re working with to get to the end architecture and design.

- Dependencies on the host OS should be minimized. This enables DC/OS to run in as many environments as possible.
- The host OS should be fully customizable. Everyone has a different set of tools that they are currently using. Those tools should work without any changes or porting. This is particularly important when it comes to hardware specific things like kernel modules.
- Dependencies on the host should be minimized. It is hard to orchestrate the order with which dependent hosts come up (master, agents). They should be able to come up in any order and only start working when their dependencies are taken care of and provided to the cluster.
- The minimum external infrastructure should be required. It is rare for external infrastructure such as PXE boot images and NFS storage to exist.
- There should be a choice of method for deployment. You’re comfortable with your existing system, there’s no need to go and learn a new one. The integration should have a clean interface and be as minimal as possible.
- Integration between DC/OS and existing systems such as config management tools and CloudFormation should be as easy as possible. The integration interface must be simple and well documented.
- All dependencies and libraries should be bundled as a single artifact. Normal lifecycle processes will upgrade or downgrade libraries and dependencies entirely outside of DC/OS. By not relying on these, the system becomes less fragile and more stable.
- Users should be able to modify code and configuration in a live system, if necessary. While this is an anti-pattern, it is one that can occasionally help with keeping your infrastructure up at critical times.
- Installs must work as close to 100% as possible. Even 1% failures ends up causing 10 failure cases that require manual intervention when you’re operating a 1000 host cluster.
- Upgrade and rollback of upgrades must be atomic at a host level.
- The state of the cluster must be auditable. When running large clusters, it is easy to get into a situation that makes it hard to rely on the state of a single host.


## Packaging

We chose tarballs for the packaging format because it works everywhere. A tarball is a compressible file format that bundles a number of files together into a single archive. While there are a lot of common packaging formats out there (deb, rpm, wheel, gem, jar, etc), they all are really just tarballs under the covers. Unfortunately almost all the common formats are built around a single distribution or language, making them hard to use across distros and languages. Some features like pre-install and post-install scripts are really handy to help nudge a system into the right “state”. That isn’t worth the possibility of having unpredictable results and/or untested corner cases. As such, we simplified and made the package installation one step: tarball extraction. No arbitrary code execution and guaranteed reproducibility.

All of the components in DC/OS are built into a single tarball that eventually gets extracted to `/opt/mesosphere` on the host system. Inside that directory, you end up with something that looks a lot like `/usr/local`. Each component lives in its own package directory and then has the important files linked to the important directories like `bin` and `lib`.


## Building

The master artifact must be assembled somehow. Because the DC/OS build is made up of a changing list of components, the build tooling ends up looking like its own little package manager. Each component must be built from source, configured in a repeatable fashion and then added into the master artifact.

A DC/OS package is defined by two files: [`build`][1] and [`buildinfo.json`][2]. These state what must be downloaded and how to build it. At build time, the toolchain takes care of building, packaging and including all the artifacts required into the master tarball.


## Installing

Now that there’s a single package containing all the built components to run DC/OS, each installation must be configured before being placed on hosts. By keeping this configuration small and immutable, you can be sure that every host in your cluster will act the same way.

With the configuration tool, all components are built into a package that contains everything to get the cluster running. You’ll pick from a small list of details like DNS configuration and bootstrap information. This then gets added to the single tarball that was built previously. You then have a package that is customized for your hardware and will repeatably create clusters of any size over and over.

Orchestrating the rollout of an installation is difficult, particularly when you are required to do things in a specific order. To keep everything as simple as possible, at the host level DC/OS makes no assumptions about the state of the cluster. You can install agents and then masters or even install both at the same time!

Once your package is built, you can get going by running `dcos_install.sh` on every host. This script only does three things:

- Downloads the package to the current host.
- Extracts the package into `/opt/mesosphere`.
- Initiates installation using the [DC/OS Component Package Manager (Pkgpanda)](/docs/1.9/overview/architecture/components/#dcos-component-package-manager).

That’s really it! Once the ZooKeeper cluster reaches quorum on the masters and Mesos comes up, every agent will join the cluster and you’ll be ready to go. We’ve kept the steps minimal to make sure they’re as reliable as possible.


## Tradeoffs

Obviously, there are other ways that this could have been architected. Let us take a look at some of the common questions and why the current decisions were made.


## Immutable Configuration

The configuration for each cluster is generated at the beginning and becomes immutable. This allows us to guarantee that the configuration is correct on every host after install. Remember, you will be doing this for thousands of nodes. These guarantees around configuration reduce the amount of documentation required to run DC/OS and make it more easily supportable.

With an immutable configuration, there is no chance of a host getting part of its configuration updated / changed. Many of the production issues we’ve encountered are ameliorated by this design decision. Take a look at Joe Smith’s presentation on [Running Mesos in Production at Twitter](https://www.youtube.com/watch?v=nNrh-gdu9m4) if you’d like more context.

### What IP should I bind to?

Deciding the IP and network interface that has access to the network and the Mesos master is non-trivial. Here are examples of environments that we cannot make default assumptions in:

- In split horizon environments like AWS, the hostname might resolve to an external IP address instead of internal.
- In environments without DNS, we need you to tell us what IP it is.
- In environments with multiple interfaces, we’re unable to automatically pick which interface to use.
- Not all machines have resolvable hostnames, so you can’t do a reverse lookup

Because of these constraints, we’ve struggled to produce a solid default. To make it as configurable as possible, we have a script that can be written to return the IP address we should bind to on every host. There are multiple examples in the documentation of how to write `ip-detect` for different environments which should cover most use cases. For those that the default doesn’t work, you will be able to write your own `ip-detect` and integrate it with your configuration. `ip-detect` is the most important part of the configuration and the only way your clusters will be able to come up successfully.

### Single vs. Multiple Packages, Per-Provider Packages (RPM, DEB, etc)

Instead of having all the packages bundled together into a single image, we could have gone the default route that most use today and install them all separately. There are a couple problems that come from this immediately:

- Moving between distributions requires porting and testing the packages.
- Package installs have non-zero failure rates. We have seen 10-20% failure rates when trying to install packages. This prevents the cluster coming up successfully and makes it harder to operate.
- Shipping multiple packages is far more difficult than having a single tarball to hand out. There’s overhead in ensuring multiple packages are robust.
- Upgrades must be atomic. It is much more difficult to ensure this across multiple packages.

### Tarball vs. Container

It would be possible to package DC/OS as a plethora of containers (or a single container with multiple processes). This combines the drawbacks of multiple packages with the instability of the Docker daemon. We’ve found that the Docker daemon crashes regularly and while that is acceptable for some applications, it isn’t something you want from the base infrastructure.

### Installation Method

We could support any installation method under the sun. The plethora of configuration and package management that is currently used is intimidating. We’ve seen everything from Puppet to custom built internal tools. We want to enable these methods by providing a simple interface that works with as many tools as possible. The lowest common denominator here is bash.

As it is difficult to maintain bash, we simplified the installation method as far as possible. The “image” that is built can be placed on top of a running host and operate independently. To install this, it only requires extraction. That’s a small, simple bash script that can work everywhere and integrate easily with other tooling. The entire exposed surface is minimal, and doesn’t give access to internals which if changed would make your cluster unsupportable and void the warranty.

### Host Images

It is possible to bake an entire host image that has been configured instead of a tarball that goes on top. Let’s look at why this doesn’t make sense as the sole method for installation:

- We end up being in the distribution update game. Every time RHEL releases a package update, we would be required to test, bundle and distribute that. This becomes even harder with CoreOS as we’d end up actually forking the project.
- You want to choose their distribution. Some have existing support contracts with Canonical and some with RedHat.
- You want to configure the base OS. There are security policies and configuration that must be applied to the host.

Host images are a great way to distribute and install DC/OS. By providing the bash install method, it is just as easy to create a new host image for your infrastructure as it would be to integrate with a tool like Puppet.

### Exposing config files directly to the user

The components included in DC/OS have a significant amount of configuration options. We have spent a long time piecing the correct ones together. These are guaranteed to give you the best operations in production at scale. If we were to expose these options, it would increase the amount of knowledge required to run an DC/OS cluster.

Remember that clusters most look almost the same for package install to work. As soon as configuration parameters that the frameworks rely on change, we cannot guarantee that a package can install or run reliably.

[1]: https://github.com/dcos/dcos/blob/master/packages/mesos/build
[2]: https://github.com/dcos/dcos/blob/master/packages/mesos/buildinfo.json
