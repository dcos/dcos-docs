---
post_title: Configure DC/OS for Proxy
nav_title: Configure Proxy
menu_order: 900
---

The DC/OS [Universe](https://github.com/mesosphere/universe) repository is hosted on the internet by default. You can also deploy the Universe [offline](/docs/1.8/administration/installing/deploying-a-local-dcos-universe/). If your DC/OS cluster is behind a corporate proxy, you must specify your proxy configuration in the [configuration file](/docs/1.8/administration/installing/custom/configuration-parameters/#use_proxy) file before installation. This will enable your cluster to connect to the Universe packages. 

**Important:** You should also configure an HTTP proxy for [Docker](https://docs.docker.com/engine/admin/systemd/#/http-proxy). 