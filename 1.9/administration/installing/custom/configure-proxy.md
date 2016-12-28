---
post_title: Configure DC/OS for Proxy
nav_title: Configure Proxy
menu_order: 900
---

By default the DC/OS [Universe](https://github.com/mesosphere/universe) repository is hosted on the internet. If your DC/OS cluster is behind a corporate proxy, you must specify your proxy configuration in the [configuration file](/docs/1.9/administration/installing/custom/configuration-parameters/#use_proxy) file before installation. This will enable your cluster to connect to the Universe packages. 

**Important:** You should also configure an HTTP proxy for [Docker](https://docs.docker.com/engine/admin/systemd/#/http-proxy). 