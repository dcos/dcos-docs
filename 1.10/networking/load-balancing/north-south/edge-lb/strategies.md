---
post_title: Edge-LB Service Deployment Strategies
menu_order: 7
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

# <a name="blue-green-deployment"></a>Blue/Green Deployment

A blue/green deployment is a method of achieving zero downtime by running
two versions of the same service (a "blue" and a "green" version)
and having the load balancer switch between the two.

The idea is to have 2 fully scaled versions of the service so that if
something goes wrong with one, it can be quickly be switched to the other by
simply adjusting the load balancer.

### Use Case: Service Upgrade

1. The "web-server" service has "blue" and "green" versions that are running and
    the load balancer is routing traffic successfully to "blue".
1. The Edge-LB configuration is updated to route traffic to "green" and
    errors start occurring in the "green" service's logs.
1. The deployment is quickly rolled back by reverting Edge-LB to the original
    configuration.

## Prerequisites

* Edge-LB CLI is installed.

    ```
    dcos package install edgelb --cli
    ```

* Enough capacity on the DC/OS cluster for 2 fully deployed services.

## Example Deployment

Here, we use the example Edge-LB configuration from the quickstart and modify
it to load balance "svc-blue".

`sample-minimal.yaml`:

```yaml
---
pools:
  - name: sample-minimal
    count: 1
    haproxy:
      frontends:
        - bindPort: 80
          protocol: HTTP
          linkBackend:
            defaultBackend: svc
      backends:
        - name: svc
          protocol: HTTP
          servers:
            - framework:
                value: marathon
              task:
                value: svc-blue
              port:
                name: web
```

Here, we make a copy of the example service and rename it to "svc-blue".

`svc-blue.json`:

```json
{
    "id": "/svc-blue",
    "cmd": "/start $PORT0",
    "instances": 1,
    "cpus": 0.1,
    "mem": 32,
    "container": {
        "type": "DOCKER",
        "docker": {
            "image": "nlsun/httpd"
        }
    },
    "portDefinitions": [
        {
            "name": "web",
            "protocol": "tcp",
            "port": 0
        }
    ],
    "healthChecks": [
        {
            "portIndex": 0,
            "path": "/",
            "protocol": "HTTP"
        }
    ]
}
```

Here, we make another copy of the example service and rename it to "svc-green".

`svc-green.json`:

```json
{
    "id": "/svc-green",
    "cmd": "/start $PORT0",
    "instances": 1,
    "cpus": 0.1,
    "mem": 32,
    "container": {
        "type": "DOCKER",
        "docker": {
            "image": "nlsun/httpd"
        }
    },
    "portDefinitions": [
        {
            "name": "web",
            "protocol": "tcp",
            "port": 0
        }
    ],
    "healthChecks": [
        {
            "portIndex": 0,
            "path": "/",
            "protocol": "HTTP"
        }
    ]
}
```

1. First, upload the configuration to Edge-LB.

    ```
    dcos edgelb config sample-minimal.yaml
    ```

1. Next, start the service "svc-blue".

    ```bash
    dcos marathon svc add svc-blue.json
    ```

1. Now, "svc-blue" is exposed at `http://<public-ip>/`.
1. Next, we begin our blue/green deployment and we deploy service "svc-green".

    ```bash
    dcos marathon svc add svc-green.json
    ```

1. Once `svc-green` is up and healthy, modify the Edge-LB configuration to point to `svc-green`
    by changing:

    ```yaml
               task:
                 value: svc-blue
    ```

    to:

    ```yaml
               task:
                 value: svc-green
    ```

    so the end result is:

    ```yaml
    ---
    pools:
      - name: sample-minimal
        count: 1
        haproxy:
          frontends:
            - bindPort: 80
              protocol: HTTP
              linkBackend:
                defaultBackend: svc
          backends:
            - name: svc
              protocol: HTTP
              servers:
                - framework:
                    value: marathon
                  task:
                    value: svc-green
                  port:
                    name: web
    ```
1. Upload the modified configuration to Edge-LB.

    ```
    dcos edgelb config sample-minimal.yaml
    ```

1. Now, "svc-green" is exposed at `http://<public-ip>/`.
