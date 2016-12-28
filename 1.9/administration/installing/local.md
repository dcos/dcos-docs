---
post_title: Install DC/OS with Vagrant
nav_title: Local
menu_order: 3
---

This installation method uses Vagrant to create a cluster of virtual machines on your local machine that can be used for demos, development, and testing with DC/OS.

# 1. Download DC/OS Installer

First, it's necessary to download a [DC/OS Release](/releases/).

For example, to download the latest Early Access release:

    $ curl -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh

# 2. Install DC/OS Vagrant

DC/OS Vagrant installation and usage instructions are maintained in the dcos-vagrant GitHub repository.

- For the latest bug fixes, use the [master branch](https://github.com/dcos/dcos-vagrant/).
- For increased stability, use the [latest official release](https://github.com/dcos/dcos-vagrant/releases/latest/).
- For older releases on DC/OS, you may need to download an [older release of DC/OS Vagrant](https://github.com/dcos/dcos-vagrant/releases/).

Follow the the deploy instructions to set up your host machine correctly and to install DC/OS.

Note that you will require at least 5GB of free memory to run DC/OS via this method.
