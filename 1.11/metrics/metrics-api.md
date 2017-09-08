---
post_title: Metrics API
feature_maturity: preview
menu_order: 1
---

You can use the Metrics API to periodically poll for data about your cluster, hosts, containers, and applications. You can then pass this data to a third party service of your choice to achieve informative charts, dashboards, and alerts.

The Metrics API is backed by the [DC/OS Metrics component](/docs/1.10/overview/architecture/components/#dcos-metrics), which runs on all nodes in the cluster.

## Routes

From within the cluster, you can access by using this path, where `<resource-path>` is the Metrics API resource path. This method requires [SSH access](/docs/1.10/administering-clusters/sshcluster/) to your cluster.

```bash
http://localhost:61001/system/v1/metrics/v0/<resource-path>
```

For example, to view host-level metrics, run this command from your agent node:

```bash
curl -s http://localhost:61001/system/v1/metrics/v0/node | jq
```

From outside of the cluster, you can access by using this path, where `<resource-path>` is the Metrics API resource path.

```bash
http://<cluster-url>/system/v1/agent/{agent_id}/metrics/v0/<resource-path>
```

For more examples, see the Metrics [Quick Start Guide](/docs/1.10/metrics/quickstart/).

## Format

The Metrics API request and response bodies are formatted in JSON.

Requests must include the accept header:

```
Accept: application/json
```

Responses will include the content type header:

```
Content-Type: application/json
```

## Resources

The following resources are available under both of the above routes:

<div class="swagger-section">
  <div id="message-bar" class="swagger-ui-wrap message-success" data-sw-translate=""></div>
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.10/api/metrics.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>
