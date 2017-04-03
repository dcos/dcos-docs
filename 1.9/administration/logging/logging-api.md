---
post_title: Logging API
feature_maturity: preview
menu_order: 3
---

The Logging API exposes node, component, and container (task) logs.

The Logging API is backed by the [DC/OS Log component](/docs/1.9/overview/architecture/components/#dcos-log), which runs on all nodes in the cluster.

For more information about using the Logging API, see [Logging](/docs/1.9/administration/logging/).


## Routes

Access to the Logging API is proxied through the Admin Router on each node using the following route:

```
/system/v1/logs/v1/
```

Access to the Logging API of the agent nodes is also proxied through the master nodes:

```
/system/v1/agent/{agent_id}/logs/v1/
```

To determine the address of your cluster, see [Cluster Access](/docs/1.9/api/access/).


## Format

The API request header can be any the following:

- `text/plain`, `text/html`, `*/*` request logs in text format, ending with `\n`.
- `application/json` request logs in JSON format.
- `text/event-stream` request logs in Server-Sent-Events format.


## Resources

The following resources are available under both of the above routes:

<div class="swagger-section">
  <div id="message-bar" class="swagger-ui-wrap message-success" data-sw-translate=""></div>
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.9/api/logs.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>


## Examples

## GET parameters
- `/system/v1/logs/v1/stream/?skip_prev=10` get the last 10 entires from the journal and follow new events.
- `/system/v1/logs/v1/range/?skip_next=100&limit=10` skip 100 entries from the beggining of the journal and return 10 following entries.
- `/system/v1/logs/v1/stream/?cursor=s%3Dcea8150abb0543deaab113ed2f39b014%3Bi%3D1%3Bb%3D2c357020b6e54863a5ac9dee71d5872c%3Bm%3D33ae8a1%3Bt%3D53e52ec99a798%3Bx%3Db3fe26128f768a49` get all logs after the specific cursor and follow new events.
- `/system/v1/logs/v1/range/?cursor=s%3Dcea8150abb0543deaab113ed2f39b014%3Bi%3D1%3Bb%3D2c357020b6e54863a5ac9dee71d5872c%3Bm%3D33ae8a1%3Bt%3D53e52ec99a798%3Bx%3Db3fe26128f768a49&skip_prev=2&limit=2` get 2 entries. The first one is the one before the cursor position and the second one is the entry with given cursor position.

## Accept: text/plain

```
curl -H 'Accept: text/plain' '127.0.0.1:80/system/v1/logs/v1/range/?skip_prev=200&limit=1'
Wed Oct 12 06:28:20 2016 a60c1d059aea systemd [1] Starting Daily Cleanup of Temporary Directories.
```

## Accept: application/json

```
curl -H 'Accept: application/json' '127.0.0.1:80/system/v1/logs/v1/range/?skip_prev=200&limit=1' | jq '.'
{
  "fields": {
    "CODE_FILE": "../src/core/unit.c",
    "CODE_FUNCTION": "unit_status_log_starting_stopping_reloading",
    "CODE_LINE": "1272",
    "MESSAGE": "Starting Daily Cleanup of Temporary Directories.",
    "MESSAGE_ID": "7d4958e842da4a758f6c1cdc7b36dcc5",
    "PRIORITY": "6",
    "SYSLOG_FACILITY": "3",
    "SYSLOG_IDENTIFIER": "systemd",
    "UNIT": "systemd-tmpfiles-clean.timer",
    "_BOOT_ID": "637573ba91ae4008b58eaa9505a11f86",
    "_CAP_EFFECTIVE": "3fffffffff",
    "_CMDLINE": "/sbin/init",
    "_COMM": "systemd",
    "_EXE": "/lib/systemd/systemd",
    "_GID": "0",
    "_HOSTNAME": "a60c1d059aea",
    "_MACHINE_ID": "48230110dd084e91b7b6885728b98295",
    "_PID": "1",
    "_SOURCE_REALTIME_TIMESTAMP": "1476253700204523",
    "_SYSTEMD_CGROUP": "e",
    "_TRANSPORT": "journal",
    "_UID": "0"
  },
  "cursor": "s=f78aeb5184144e2a94963a42b0cac49e;i=262;b=637573ba91ae4008b58eaa9505a11f86;m=6fbb8f76b;t=53ea51966297e;x=69cba0539a7e4576",
  "monotonic_timestamp": 29993006955,
  "realtime_timestamp": 1476253700204926
}
```

## Accept: text/event-stream
```
curl -H 'Accept: text/event-stream' '127.0.0.1:80/system/v1/logs/v1/range/?skip_prev=200&limit=1'
id: s=f78aeb5184144e2a94963a42b0cac49e;i=262;b=637573ba91ae4008b58eaa9505a11f86;m=6fbb8f76b;t=53ea51966297e
data: {"fields":{"CODE_FILE":"../src/core/unit.c","CODE_FUNCTION":"unit_status_log_starting_stopping_reloading","CODE_LINE":"1272","MESSAGE":"Starting Daily Cleanup of Temporary Directories.","MESSAGE_ID":"7d4958e842da4a758f6c1cdc7b36dcc5","PRIORITY":"6","SYSLOG_FACILITY":"3","SYSLOG_IDENTIFIER":"systemd","UNIT":"systemd-tmpfiles-clean.timer","_BOOT_ID":"637573ba91ae4008b58eaa9505a11f86","_CAP_EFFECTIVE":"3fffffffff","_CMDLINE":"/sbin/init","_COMM":"systemd","_EXE":"/lib/systemd/systemd","_GID":"0","_HOSTNAME":"a60c1d059aea","_MACHINE_ID":"48230110dd084e91b7b6885728b98295","_PID":"1","_SOURCE_REALTIME_TIMESTAMP":"1476253700204523","_SYSTEMD_CGROUP":"e","_TRANSPORT":"journal","_UID":"0"},"cursor":"s=f78aeb5184144e2a94963a42b0cac49e;i=262;b=637573ba91ae4008b58eaa9505a11f86;m=6fbb8f76b;t=53ea51966297e;x=69cba0539a7e4576","monotonic_timestamp":29993006955,"realtime_timestamp":1476253700204926}
```
