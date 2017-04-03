---
post_title: Metrics API
feature_maturity: preview
menu_order: 1
---

The Metrics API exposes node, container, and application metrics.

The Metrics API is backed by the [DC/OS Metrics component](/docs/1.9/overview/architecture/components/#dcos-metrics), which runs on all nodes in the cluster.

For more information about using the Metrics API, see [Metrics](/docs/1.9/administration/monitoring/metrics/).


## Routes

Access to the Metrics API is proxied through the Admin Router on each node using the following route:

```
/system/v1/metrics/v0/
```

Access to the Metrics API of the agent nodes is also proxied through the master nodes, so that it can be accessed from outside of the cluster:

```
/system/v1/agent/{agent_id}/metrics/v0/
```

To determine the address of your cluster, see [Cluster Access](/docs/1.9/api/access/).


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
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.9/api/metrics.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>
