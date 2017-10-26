---
post_title: Marathon Health Checks
menu_order: 1
---

You can define health checks for your DC/OS services. Health checks are defined on a per-application basis, and are run against that application's tasks.

Health checks begin immediately when a task is launched. By default, health checks are run using the Marathon scheduler. Health checks with the Marathon scheduler only support the COMMAND protocol. Each app is limited to a single health check.

- The default health check leverages Mesos' knowledge of the task state `TASK_RUNNING => healthy`.
- Marathon provides a `health` member of the task resource via the [REST API](/docs/1.8/usage/managing-services/rest-api/) that you can add to your application definition.

A health check is considered passing if both of these conditions are met:
 
- The HTTP response code is between 200 and 399 inclusive
- The response is received within the `timeoutSeconds` period. If a task fails more than `maxConsecutiveFailures` health checks consecutively, that task is killed.

You can define health checks in your JSON application definition or by using the DC/OS GUI **Services** tab. 

# Health check options
When creating a service, you can configure JSON health checks in the DC/OS GUI or directly as JSON. This table shows the equivalent GUI fields and JSON options.

| GUI | JSON | Default | Description |
|----------------------|--------------------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **GRACE PERIOD** | `gracePeriodSeconds` | `15` | Specifies the amount of time (in seconds) to ignore health checks immediately after a task is started; or until the task becomes healthy for the first time. |
| **INTERVAL (S)** | `intervalSeconds` | `10` | Specifies the amount of time (in seconds) to wait between health checks. |
| **MAX FAILURES** | `maxConsecutiveFailures` | `3` | Specifies the number of consecutive health check failures that can occur before a task is killed. |
| **PROTOCOL** | `protocol` | `HTTP` | Specifies the protocol of the requests: `HTTP`, `HTTPS`, `TCP`, or `Command`. |
| **SERVICE ENDPOINT** | `path` | `\` | If `"protocol": "HTTP"`, this option specifies the path to the task health status endpoint. For example, `“/path/to/health”`. |
| N/A | `portIndex` | `0` | Specifies the port index in the ports array that is used for health requests. A port index allows the app to use any port, such as `“[0, 0, 0]”` and tasks could be started with port environment variables such as `$PORT1`. |
| **TIMEOUT (S)** | `timeoutSeconds` | `20` | Specifies the amount of time (in seconds) before a health check fails, regardless of the response. |

For example, here is the health check specified as JSON in an application definition.

```json
"healthChecks": [
  {
    "gracePeriodSeconds": 120,
    "intervalSeconds": 30,
    "maxConsecutiveFailures": 0,
    "path": "/admin/healthcheck",
    "portIndex": 0,
    "protocol": "HTTP",
    "timeoutSeconds": 5
  }
```
