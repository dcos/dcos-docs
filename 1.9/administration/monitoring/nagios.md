---
post_title: Monitoring DC/OS with Nagios
nav_title: Nagios
---

Nagios is a popular monitoring framework for distributed hosts. This guide explains how to monitor a DC/OS cluster with [Nagios Core 4x](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/monitoring-linux.html) using [NRPE](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/addons.html#nrpe).

## Installation
This guide assumes you've installed and configured Nagios for your cluster. Below are links to popular configuration management suites:

- Puppet Module: [thias/nagios](https://forge.puppet.com/thias/nagios)
- Chef Cookbook: [schubergphilis/nagios](https://github.com/schubergphilis/nagios)
- Manual Install: [nagios.org/documentation](https://www.nagios.org/documentation/)

### Recommendations

1. Use SSL

    The NRPE plugin for Nagios allows you to setup server-daemon interface with SSL. We recommend you do this for security.

2. Lightweight Checks

    The most common Nagios implementation error is building overly complicated scripts that do not pay attention to the resources the check requires. This could undermine your cluster performance. Ensure your checks are clean, require low resource overhead, and make full use of the process in which they're spawned (i.e., don't pipe `grep` to `awk`).

3. Nagios via DC/OS

    We ***do not*** recommend running Nagios via DC/OS. Running your monitoring platform on the cluster you are monitoring has intrinsic pitfalls: if your cluster goes down, your monitoring platform will also.

## What to Monitor

Once you have Nagios installed on your cluster and have the NRPE plugin configured, then you can construct scripts to monitor resource health for DC/OS.

### systemd units

DC/OS runs only on systemd. Tracking units with Nagios is easy. You can use one of the popular scripts for NRPE remote checks such as [jonschipp/nagios-plugins/check_service.sh](https://github.com/jonschipp/nagios-plugins/blob/master/check_service.sh) or roll your own.

Units differ between agents and masters, but you can easily determine which units to monitor without hard coding them (since they are prone to changing or being added to). Modify [jonschipp/nagios-plugins/check_service.sh](https://github.com/jonschipp/nagios-plugins/blob/master/check_service.sh) for monitoring only DC/OS units by adding a simple wrapper:

```bash
# cat dcos_unit_check.sh
#!/bin/bash
for unit in `ls /etc/systemd/system/dcos.target.wants`; do
  echo "Checking $unit"
  ./check_service.sh -s ${unit} > /dev/null 2>&1
  STATUS=$?
  if [ "${STATUS}" -ne 0 ]; then
    echo "Status for $unit is not 0, got $STATUS"
    exit $STATUS
  fi
done
```

If a service is not healthy, such as adminrouter, we will get a failure from this script:

```bash
ip-10-0-6-126 core # ./dcos_unit_check.sh
Checking dcos-adminrouter-reload.service
Status for dcos-adminrouter-reload.service is not 0, got 2
```

### Docker

Monitoring Docker via Nagios can be tricky, as there are many aspects you might want to watch. If your intent is to check if the service is available and running, (i.e., Docker service is running and enabled and healthy according to systemd) then we recommend a NRPE script that does just that.

If your intent is to monitor what is going on inside the container, we recommend you run a service such as [cAdvisor](https://github.com/google/cadvisor).


