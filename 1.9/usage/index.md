---
post_title: Usage
menu_order: 3
---

# Getting Started
After you have [installed](/docs/1.9/administration/installing/) DC/OS and set up the CLI on your local machine, familiarize yourself with the DC/OS UI [Dashboard](/docs/1.9/usage/webinterface/) and DC/OS [CLI](/docs/1.9/usage/cli/).

You can then launch a production-grade, highly available, containerized NGINX web server with a single command from the DC/OS CLI. DC/OS keeps your web server running if it crashes, allows you to scale it via the user interface and update its config at runtime, and much more!

1.  Run this command to launch a containerized [sample](/docs/1.9/usage/nginx.json) app on DC/OS.

    ```bash
    $ dcos marathon app add https://dcos.io/docs/1.9/usage/nginx.json
    ```

1.  Go to the "Services" tab of the DC/OS Dashboard to see the NGINX web server up and running and ready to serve traffic!


