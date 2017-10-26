---
post_title: Mesos DNS API
post_excerpt: ""
menu_order: 201
---

You can use the Mesos DNS API to discover the IP addresses and ports of other applications.

# Routes

Access to the Mesos DNS API is proxied through the Admin Router on each node using the following route:

```bash
curl -H "Authorization: token=<auth-token>" http://<master-ip>/mesos_dns/v1/
```

Access to the Mesos DNS API of the agent nodes is also proxied through the master nodes:

```bash
curl -H "Authorization: token=<auth-token>" http://<public-master-ip>/system/v1/agent/{agent_id}/mesos_dns/v1/
```

# Format

The Metrics API request and response bodies are formatted in JSON.

Requests must include the accept header:

```
Accept: application/json
```

Responses will include the content type header:

```
Content-Type: application/json
```

# Resources
Mesos-DNS implements a simple REST API for service discovery over HTTP. These examples assume you have an [SSH connection to the node](/docs/1.8/administration/access-node/sshcluster/).

## <a name="get-version"></a>GET /v1/version

Lists in JSON format the Mesos-DNS version and source code URL.

```bash
curl -H "Authorization: token=<auth-token>" http://<master-ip>/mesos_dns/v1/version
```

The output should resemble:

```json
{
  "Service": "Mesos-DNS",
  "URL": "https://github.com/mesosphere/mesos-dns",
  "Version": "dev"
 }
```

## <a name="get-config"></a>GET /v1/config

Lists in JSON format the Mesos-DNS configuration parameters.

```bash
curl -H "Authorization: token=<auth-token>" http://<master-ip>/mesos_dns/v1/config
```

The output should resemble:

```json
{
  "RefreshSeconds": 30,
  "Port": 61053,
  "Timeout": 5,
  "StateTimeoutSeconds": 300,
  "ZkDetectionTimeout": 30,
  "HttpPort": 8123,
  "TTL": 60,
  "SOASerial": 1495828138,
  "SOARefresh": 60,
  "SOARetry": 600,
  "SOAExpire": 86400,
  "SOAMinttl": 60,
  "SOAMname": "ns1.mesos.",
  "SOARname": "root.ns1.mesos.",
  "Masters": null,
  "ZoneResolvers": {},
  "Resolvers": [
   "169.254.169.253"
  ],
  "IPSources": [
   "host",
   "netinfo"
  ],
  "Zk": "zk://zk-1.zk:2181,zk-2.zk:2181,zk-3.zk:2181,zk-4.zk:2181,zk-5.zk:2181/mesos",
  "Domain": "mesos",
  "File": "/opt/mesosphere/etc/mesos-dns-enterprise.json",
  "Listener": "0.0.0.0",
  "HTTPListener": "127.0.0.1",
  "RecurseOn": true,
  "DnsOn": true,
  "HttpOn": true,
  "ExternalOn": true,
  "EnforceRFC952": false,
  "SetTruncateBit": false,
  "EnumerationOn": true,
  "MesosHTTPSOn": true,
  "CACertFile": "/run/dcos/pki/CA/certs/ca.crt",
  "CertFile": "/run/dcos/pki/tls/certs/mesos-dns.crt",
  "KeyFile": "/run/dcos/pki/tls/private/mesos-dns.key",
  "MesosCredentials": {
   "Principal": "",
   "Secret": ""
  },
  "IAMConfigFile": "/run/dcos/etc/mesos-dns/iam.json",
  "MesosAuthentication": "iam"
 }
```


## <a name="get-hosts"></a>GET /v1/hosts/{host}

Lists in JSON format the IP addresses that correspond to a hostname. It is the equivalent of a DNS A record lookup.

**Note:** The HTTP interface only resolves hostnames in the Mesos domain.

```bash
curl -H "Authorization: token=<auth-token>" http://<master-ip>/mesos_dns/v1/hosts/nginx.marathon.mesos
```

The output should resemble:

```json
[
    {"host":"nginx.marathon.mesos.","ip":"10.249.219.155"},
    {"host":"nginx.marathon.mesos.","ip":"10.190.238.173"},
    {"host":"nginx.marathon.mesos.","ip":"10.156.230.230"}
]
```

## <a name="get-service"></a>GET /v1/services/{service}

Lists in JSON format the hostname, IP address, and ports that correspond to a hostname. It is the equivalent of a DNS SRV record lookup.

**Note:** The HTTP interface only resolves service names in the Mesos domain.

```bash
curl -H "Authorization: token=<auth-token>" http://<master-ip>/mesos_dns/v1/services/_nginx._tcp.marathon.mesos
```

The output should resemble:

```json
[
    {"host":"nginx-s2.marathon.mesos.","ip":"10.249.219.155","port":"31644","service":"_nginx._tcp.marathon.mesos."},
    {"host":"nginx-s1.marathon.mesos.","ip":"10.190.238.173","port":"31667","service":"_nginx._tcp.marathon.mesos."},
    {"host":"nginx-s0.marathon.mesos.","ip":"10.156.230.230","port":"31880","service":"_nginx._tcp.marathon.mesos."}
]
```
