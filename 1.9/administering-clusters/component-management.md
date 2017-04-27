---
post_title: Component Management
menu_order: 5.5
---

The component management API controls installation and management of DC/OS component services. It is used by the DC/OS installer during install, upgrade, and uninstall. It is not designed for interaction by DC/OS users.

## Component Package Manager

The DC/OS Component Package Manager (Pkgpanda) implements the component management API and runs on all DC/OS nodes.

[Pkgpanda](https://github.com/dcos/dcos/tree/master/pkgpanda) consists of two parts: a package builder and a package manager.

- The **package builder** builds and bundles component packages from source code and pre-compiled artifacts as part of the DC/OS release building process.
- The **package manager** is included as part of DC/OS an runs on each node, managing the installed and activated component packages on that node.

Component packages built by the package builder are distributed as part of the DC/OS installer for each release. The installer ships the component packages to each node and orchestrates the component management API to install them. The component packages contain one or more systemd service definitions, binaries, and configuration files.


## Component health

Component health is monitored by the DC/OS Diagnostics (3DT) component. For more information about component monitoring, see [Monitoring](/docs/1.9/monitoring/).


## Component logs

Component logs are sent to journald and exposed by the DC/OS Log component. For more infromation about component logs, see [Logging](/docs/1.9/monitoring/logging/).


## Routes

The component management API is exposed through Admin Router and Admin Router Agent under the `/pkgpanda/` path on all nodes.


## Resources

<div class="swagger-section">
  <div id="message-bar" class="swagger-ui-wrap message-success" data-sw-translate=""></div>
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.9/api/pkgpanda.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>
