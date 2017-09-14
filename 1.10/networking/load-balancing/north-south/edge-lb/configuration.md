---
post_title: Edge-LB Configuration
menu_order: 2
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

# Swagger Specification

The specification below describes all possible configuration options. The majority of fields have sensible defaults and should be modified with caution. Use the tool at [swagger.io](http://editor.swagger.io/) to render this document in Swagger.

Consult the [Quickstart Guide](/1.10/networking/edge-lb/quickstart) for an example of a real-life Edge-LB configuration.

See the [Examples](/1.10/networking/edge-lb/examples) for more common use cases.

## Edge-LB v0.1.7

This information can also be found by running `dcos edgelb config --reference`

```yaml
swagger: '2.0'
definitions:
  Config:
    type: object
    description: >-
      * If a default is not set, then it will be left empty, even for objects.
      * Set defaults in the object that is furthest from the root object.
      * Always set a default for arrays.
      * The purpose of "x-nullable" is to allow the output JSON field to be set
        to the golang "zero value". Without "x-nullable", the field will be
        removed altogether from the resulting JSON.
      * Actual validation is done in the code, not expressed in swagger.
      * Since an empty boolean is interpreted as "false", don't set
        a default.
      * CamelCase
      * Swagger will only do enum validation if it is a top level definition!
    default: { "pools": [] }
    properties:
      pools:
        type: array
        description: The array of pools.
        items:
          $ref: '#/definitions/Pool'
  Pool:
    type: object
    description: >-
      The pool contains information on resources that the pool needs. Changes
      make to this section will relaunch the tasks.
    default:
      {
      "namespace": "dcos-edgelb/pools",
      "packageName": "edgelb-pool",
      "packageVersion": "stub-universe",
      "role": "slave_public",
      "cpus": 0.9,
      "cpusAdminOverhead": 0.1,
      "mem": 992,
      "memAdminOverhead": 32,
      "disk": 256,
      "count": 1,
      "constraints": "hostname:UNIQUE",
      "ports": [],
      "secrets": [],
      "virtualNetworks": [],
      "haproxy": {}
      }
    properties:
      name:
        type: string
        description: The pool name.
      namespace:
        type: string
        description: The DC/OS space (sometimes also referred to as a "group").
        x-nullable: true
      packageName:
        type: string
      packageVersion:
        type: string
      role:
        type: string
        description: >-
          Mesos role for load balancers. Defaults to "slave_public" so that
          load balancers will be run on public agents. Use "*" to run load
          balancers on private agents. Read more about Mesos roles at
          http://mesos.apache.org/documentation/latest/roles/
      cpus:
        type: number
      cpusAdminOverhead:
        type: number
      mem:
        type: integer
        description: "Memory requirements (in MB)"
        format: int32
      memAdminOverhead:
        type: integer
        description: "Memory requirements (in MB)"
        format: int32
      disk:
        type: integer
        description: "Disk size (in MB)"
        format: int32
      count:
        type: integer
        x-nullable: true
        format: int32
        description: 'Number of load balancer instances in the pool.'
      constraints:
        type: string
        x-nullable: true
        description: 'Marathon style constraints for load balancer instance placement.'
      ports:
        type: array
        description: >-
          Override ports to allocate for each load balancer instance.
          Defaults to {{haproxy.frontend.objs[].bindPort}} and
            {{haproxy.stats.bindPort}}.
          Use this field to pre-allocate all needed ports with or
            without the frontends present. For example: [80, 443, 9090].
          If the length of the ports array is not zero, only the
            ports specified will be allocated by the pool scheduler.
        items:
          type: integer
          format: int32
      secrets:
        type: array
        description: DC/OS secrets.
        items:
          type: object
          properties:
            secret:
              description: Secret name
              type: string
            file:
              description: >-
                File name.

                The file "myfile" will be found at "$SECRETS/myfile"
              type: string
      environmentVariables:
        type: object
        description: >-
          Environment variables to pass to tasks.

          Prefix with "ELB_FILE_" and it will be written to a file. For example,
          the contents of "ELB_FILE_MYENV" will be written to
          "$ENVFILE/ELB_FILE_MYENV".
        additionalProperties:
          type: string
      autoCertificate:
        type: boolean
        description: >-
          Autogenerate a self-signed SSL/TLS certificate. It is not generated
          by default.

          It will be written to "$AUTOCERT".
      virtualNetworks:
        type: array
        description: Virtual networks to join.
        items:
          type: object
          properties:
            name:
              description: The name of the virtual network to join.
              type: string
            labels:
              description: Labels to pass to the virtual network plugin.
              additionalProperties:
                type: string
      haproxy:
        $ref: '#/definitions/Haproxy'
  Haproxy:
    type: object
    default:
      {
      "stats": {},
      "frontends": [],
      "backends": []
      }
    properties:
      stats:
        $ref: '#/definitions/Stats'
      frontends:
        description: 'Array of frontends.'
        type: array
        items:
          $ref: '#/definitions/Frontend'
      backends:
        description: 'Array of backends.'
        type: array
        items:
          $ref: '#/definitions/Backend'
  Stats:
    type: object
    default:
      {
      "bindAddress": "0.0.0.0",
      "bindPort": 9090
      }
    properties:
      bindAddress:
        type: string
      bindPort:
        type: integer
        format: int32
  Frontend:
    type: object
    description: >-
      The Frontend maps to the HAProxy frontend. This includes
      information such as what addresses and ports to listen on, what
      SSL/TLS certificates to use, and which backends to route to.
    default:
      {
      "bindAddress": "0.0.0.0",
      "bindPort": -1,
      "certificates": [],
      "miscStrs": [],
      "linkBackend": {}
      }
    properties:
      name:
        description: 'Defaults to frontend_{{bindAddress}}_{{bindPort}}.'
        type: string
      bindAddress:
        description: >-
          Only use characters that are allowed in the frontend name. Known
          invalid frontend name characters include "*", "[", and "]".
        type: string
      bindPort:
        description: >-
          The port (e.g. 80 for HTTP or 443 for HTTPS) that this frontend will
          bind to.
        type: integer
        x-nullable: true
        format: int32
      bindModifier:
        description: "Additional text to put in the bind field"
        type: string
      certificates:
        type: array
        items:
          description: >-
            SSL/TLS certificates in the load balancer.

            For secrets, use "$SECRETS/my_file_name"
            For environment files, use "$ENVFILE/my_file_name"
            For autoCertificate, use "$AUTOCERT"
          type: string
      redirectToHttps:
        type: object
        default: { "except": [] }
        description: >-
          Setting this to the empty object is enough to redirect all traffic
          from HTTP (this frontend) to HTTPS (port 443).
        properties:
          except:
            type: array
            description: >-
              One may additionally set a whitelist of fields that must be
              matched to allow HTTP.
            items:
              type: object
              description: "Boolean AND will be applied with every selected value"
              properties:
                host:
                  type: string
                  description: "Match on host"
                pathBeg:
                  type: string
                  description: "Match on path"
      miscStrs:
        description: "Additional template lines inserted before use_backend"
        type: array
        items:
          type: string
      protocol:
        description: >-
          The frontend protocol is how clients/users communicate with HAProxy.
        $ref: '#/definitions/Protocol'
      linkBackend:
        type: object
        description: >-
          This describes what backends to send traffic to. This can be expressed
          with a variety of filters such as matching on the hostname or the
          HTTP URL path.
        default: { "map": [] }
        properties:
          defaultBackend:
            type: string
            description: >-
              This is default backend that is routed to if none of the other
              filters are matched.
          map:
            type: array
            description: >-
              This is an optional field that specifies a mapping to various
              backends. These rules are applied in order.
            items:
              type: object
              description: >-
                "backend" and at least one of the condition fields
                must be filled out. If multiple conditions are filled out they
                will be combined with a boolean "AND".
              properties:
                backend:
                  type: string
                hostEq:
                  description: "All lowercase."
                  type: string
                hostReg:
                  description: >-
                    All lowercase. It is possible for a port (e.g. "foo.com:80")
                    to be in this regex!
                  type: string
                pathBeg:
                  type: string
                pathEnd:
                  type: string
                pathReg:
                  type: string
  Backend:
    type: object
    default:
      {
      "miscStrs": [],
      "servers": [],
      "balance": "roundrobin",
      "rewriteHttp": {}
      }
    properties:
      name:
        type: string
        description: This is name that frontends refer to.
      protocol:
        description: >-
          The backend protocol is how HAProxy communicates with the
          servers it's load balancing.
        $ref: '#/definitions/Protocol'
      rewriteHttp:
        description: >-
          Manipulate HTTP headers. There is no effect unless the protocol is
          either HTTP or HTTPS.
        $ref: '#/definitions/RewriteHttp'
      balance:
        description: 'Load balancing strategy. e.g. roundrobin, leastconn, etc.'
        type: string
      customCheck:
        type: object
        description: 'This is used to specify alternate forms of healthchecks'
        properties:
          httpchk:
            type: boolean
          httpchkMiscStr:
            type: string
          sslHelloChk:
            type: boolean
          miscStr:
            type: string
      miscStrs:
        description: "Additional template lines inserted before servers"
        type: array
        items:
          type: string
      servers:
        description: 'Array of backend network sources / selectors.'
        type: array
        items:
          $ref: '#/definitions/Server'
  RewriteHttp:
    type: object
    default:
      {
      "request": {},
      "response": {}
      }
    properties:
      host:
        description: "Set the host header value"
        type: string
      path:
        type: object
        description: >-
          Rewrite the HTTP URL path. All fields required, otherwise it's
          ignored.
        properties:
          fromPath:
            type: string
          toPath:
            type: string
      request:
        $ref: '#/definitions/RewriteHttpRequest'
      response:
        $ref: '#/definitions/RewriteHttpResponse'
      sticky:
        type: object
        default: { "enabled": true }
        description: >-
          Sticky sessions via a cookie.

          To use the default values (recommended), set this field to the
          empty object.
        properties:
          enabled:
            type: boolean
            x-nullable: true
          customStr:
            type: string
  RewriteHttpRequest:
    description: >-
      Rewrite the request.

      To use the default values (recommended), set this field to the
      empty object.
    type: object
    default:
      {
      "forwardfor": true,
      "xForwardedPort": true,
      "xForwardedProtoHttpsIfTls": true,
      "setHostHeader": true,
      "rewritePath": true
      }
    properties:
      forwardfor:
        type: boolean
        x-nullable: true
      xForwardedPort:
        type: boolean
        x-nullable: true
      xForwardedProtoHttpsIfTls:
        type: boolean
        x-nullable: true
      setHostHeader:
        type: boolean
        x-nullable: true
      rewritePath:
        type: boolean
        x-nullable: true
  RewriteHttpResponse:
    description: >-
      Rewrite the response.

      To use the default values (recommended), set this field to the
      empty object.
    type: object
    default:
      { "rewriteLocation": true }
    properties:
      rewriteLocation:
        type: boolean
        x-nullable: true
  Server:
    type: object
    default:
      {
      "type": "AUTO_IP",
      "framework": {},
      "task": {},
      "check": {},
      "port": {}
      }
    properties:
      type:
        $ref: '#/definitions/ServerType'
      framework:
        type: object
        description: >-
          The Mesos framework. If unsure, the value should probably be
          "marathon".
        default: { "match": "EXACT" }
        properties:
          value:
            type: string
          match:
            $ref: '#/definitions/Match'
      task:
        type: object
        default: { "match": "EXACT" }
        properties:
          value:
            description: >-
              The Task name. This field is not needed for VIPs.
              For Marathon pods this is the container name NOT the pod name.
            type: string
          match:
            $ref: '#/definitions/Match'
      check:
        type: object
        default:
          { "enabled": true }
        description: >-
          Enable health checks. These are by default TCP health checks. For
          more options see "customCheck".

          These are required for DNS resolution (and hence VIPs) to function
          properly.
        properties:
          enabled:
            type: boolean
            x-nullable: true
          customStr:
            type: string
      port:
        $ref: '#/definitions/ServerPort'
      miscStr:
        description: Append arbitrary string to the "server" directive.
        type: string
  ServerPort:
    type: object
    properties:
      name:
        description: >-
          The name of the port. This is used for AUTO_IP, AGENT_IP and
          CONTAINER_IP.
        type: string
      all:
        description: >-
          For AUTO_IP, AGENT_IP and CONTAINER_IP this
          can be used to expose all defined ports.

          This should only be used if a name is not defined
          for the port and there is a single port defined for the service.
        type: boolean
      vip:
        description: 'Set the VIP definition directly (e.g. "/myvip:1234").'
        type: string
  Protocol:
    type: string
    enum:
      - HTTP
      - HTTPS
      - TCP
      - TLS
  ServerType:
    description: >-
      AUTO_IP detects between AGENT_IP and CONTAINER_IP and uses the
      appropriate value.

      AGENT_IP is for HOST and BRIDGE networking. VIP for l4lb service
      addresses. CONTAINER_IP is for virtual networks. This is not DNS.
    type: string
    enum:
      - AUTO_IP
      - AGENT_IP
      - CONTAINER_IP
      - VIP
  Error:
    type: object
    properties:
      code:
        type: integer
        format: int32
      message:
        type: string
  Match:
    type: string
    enum:
      - EXACT
      - REGEX
```

# Configuration format

Edge-LB accepts configuration in YAML or JSON, but YAML is preferred for readability.

A helpful graphical visualization tool for swagger can be found at [editor.swagger.io](http://editor.swagger.io)

# SSL/TLS certificates

See the [Examples](/1.10/networking/edge-lb/examples#sample-certificates).

# Configuration format FAQ

## How do I convert YAML to JSON?

`dcos edgelb config --to-json=/path/to/json`

## How do I convert JSON to YAML?

There currently isn't an automated way to do this, the suggested method is to
hand convert it, and then use the YAML to JSON conversion on your YAML and
then do a diff between your YAML and the JSON.

```
# First hand convert JSON to YAML

# Then compare to original json with the `diff` shell command.
# Here we "convert" even the JSON file to get consistently formatted JSON
diff <(dcos edgelb config --to-json=myconfig.yaml) <(dcos edgelb config --to-json=myconfig.json)
```

## How do I create an empty object in YAML?

The syntax is the same as in JSON. For example, basic use of `sticky`
involves setting it to the empty object.

YAML:
```
  sticky: {}
```

JSON:
```
{
  "sticky": {}
}
```

## Where does JSON expect commas?

Put them everywhere except after the last element in an object or array.

```
{
  "key1": "value1",
  "key2": "value2"
}
```

```
{
  "key": ["value1", "value2"]
}
```

