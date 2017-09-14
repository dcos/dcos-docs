---
post_title: Edge-LB Examples
menu_order: 6
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

# <a name="sample-certificates"></a>SSL/TLS Certificate Usage

This example demonstrates 3 different ways to get and use a certificate:

- Automatically generated self-signed certificate.
- DC/OS Secrets.
- (Insecure) Environment variables.

```yaml
---
pools:
  - name: sample-certificates
    count: 1
    autoCertificate: true
    secrets:
      - secret: mysecret
        file: mysecretfile
    environmentVariables:
      ELB_FILE_HAPROXY_CERT: |
        -----BEGIN CERTIFICATE-----
        foo
        -----END CERTIFICATE-----
        -----BEGIN RSA PRIVATE KEY-----
        bar
        -----END RSA PRIVATE KEY-----
    haproxy:
      frontends:
        - bindPort: 443
          protocol: HTTPS
          certificates:
            - $AUTOCERT
          linkBackend:
            defaultBackend: host-httpd
        - bindPort: 444
          protocol: HTTPS
          certificates:
            - $SECRETS/mysecretfile
          linkBackend:
            defaultBackend: host-httpd
        - bindPort: 445
          protocol: HTTPS
          certificates:
            - $ENVFILE/ELB_FILE_HAPROXY_CERT
          linkBackend:
            defaultBackend: host-httpd
      backends:
        - name: host-httpd
          protocol: HTTP
          servers:
            - framework:
                value: marathon
              task:
                value: host-httpd
              port:
                name: web
```

# <a name="http-path"></a>HTTP/HTTPS URL Path Routing

This example sets the following HTTP/HTTPs paths:

- `http://<public-ip>/` - The `default-svc` service.
- `http://<public-ip>/foo` - The `foo-svc` service.
- `http://<public-ip>/bar` - The `bar-svc` service.

```yaml
---
pools:
  - name: sample-path-routing
    count: 1
    haproxy:
      frontends:
        - bindPort: 80
          protocol: HTTP
          linkBackend:
            defaultBackend: backend-default
            map:
              - pathBeg: /foo
                backend: backend-foo
              - pathBeg: /bar
                backend: backend-bar
      backends:
        - name: backend-foo
          protocol: HTTP
          rewriteHttp:
            # The paths specified here means that "foo-svc" will see
            # traffic coming in at "/" rather than at "/foo"
            path:
              fromPath: /foo
              toPath: /
          servers:
            - framework:
                value: marathon
              task:
                value: foo-svc
              port:
                name: foo-port
        - name: backend-bar
          protocol: HTTP
          rewriteHttp:
            # The paths specified here means that "bar-svc" will see
            # traffic coming in at "/" rather than at "/bar"
            path:
              fromPath: /bar
              toPath: /
          servers:
            - framework:
                value: marathon
              task:
                value: bar-svc
              port:
                name: bar-port
        - name: backend-default
          protocol: HTTP
          servers:
            - framework:
                value: marathon
              task:
                value: default-svc
              port:
                name: default-port
```

# <a name="http-vhost"></a>HTTP/HTTPS Virtual Host (VHost) Routing

This example sets the following VHost routes:

- `http://foo.example.com` - The `foo-svc` service.
- `http://bar.example.com` - The `bar-svc` service.

```yaml
---
pools:
  - name: sample-vhost-routing
    count: 1
    haproxy:
      frontends:
        - bindPort: 80
          protocol: HTTP
          linkBackend:
            map:
              - hostEq: foo.example.com
                backend: backend-foo
              - hostEq: bar.example.com
                backend: backend-bar
      backends:
        - name: backend-foo
          protocol: HTTP
          servers:
            - framework:
                value: marathon
              task:
                value: foo-svc
              port:
                name: foo-port
        - name: backend-bar
          protocol: HTTP
          servers:
            - framework:
                value: marathon
              task:
                value: bar-svc
              port:
                name: bar-port
```

# <a name="http-healthcheck"></a>HTTP Healthcheck

All services have TCP healthchecks enabled by default.

This example customizes the healthcheck in the following ways:
- Enables HTTP healthcheck.
- HTTP healthcheck does a HTTP `GET` request on `/health/check/endpoint`.

```yaml
---
pools:
  - name: sample-health-check
    count: 1
    haproxy:
      frontends:
        - bindPort: 80
          protocol: HTTP
          linkBackend:
            defaultBackend: backend-default
      backends:
        - name: backend-default
          protocol: HTTP
          customCheck:
            httpchk: true
            # More on configuring httpchkMiscStr:
            # https://cbonte.github.io/haproxy-dconv/1.7/configuration.html#option%20httpchk
            httpchkMiscStr: GET /health/check/endpoint
          servers:
            - framework:
                value: marathon
              task:
                value: default-svc
              port:
                name: default-port
```
