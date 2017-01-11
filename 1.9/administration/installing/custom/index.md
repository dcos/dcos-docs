---
post_title: DC/OS Custom Installation Options
nav_title: Custom
menu_order: 1
---

You can install DC/OS on bare metal, virtual machines and every cloud. With the custom installers, you have the flexibility to configure each installation of DC/OS exactly how you like it.

# GUI

You can use a simple graphical interface to configure and install DC/OS on your cluster. This method takes care of installing all the prerequisites on each instance along with everything required for DC/OS. Note that only a subset of the configuration options are available with this method. It is, however the fastest way to try out DC/OS on your own cluster.

- [GUI DC/OS Installation Guide][1]

# CLI

For those who'd like a little bit more opportunity to configure things, the CLI installer is a great choice. It can take care of installing all the system requirements, just like the GUI installer. The advantage is that you're able to pick more options as to exactly how your cluster is configured. An example of this would be the storage Exhibitor uses to bootstrap.

- [CLI DC/OS Installation Guide][2]

# Advanced

When you're ready to integrate DC/OS with your configuration management tools or create an image to roll out datacenter wide, the advanced installer is for you. This method provides you will all the flexibility you need to pick the actual installation process, every configuration option available and a simple way to consistently add agents to the cluster on a regular basis.

- [Advanced DC/OS Installation Guide][3]

[1]: gui/
[2]: cli/
[3]: advanced/
