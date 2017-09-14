---
post_title: Edge-LB Architecture
menu_order: 8
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

Edge-LB has a 3-part architecture (API Server, Pool, and Load Balancer) that
is run entirely on top of DC/OS.

# Glossary

## <a name="edge-lb"></a>Edge-LB

The entire component (API Server, Pool, and Load Balancer).

## <a name="edge-lb-api-server"></a>Edge-LB API Server

The service that responds to CLI commands and manages Pools.

## <a name="edge-lb-pool"></a>Edge-LB Pool

The unit of Load Balancer configuration within Edge-LB. The Load Balancers within the same Pool are identical.

The Pool is concerned with properties such as the number of instances of the Load Balancers and their placement.

The number of instances of Load Balancers *cannot be scaled down* (This is
a limitation that we plan to address).

## <a name="edge-lb-load-balancer"></a>Edge-LB Load Balancer

The individual instances of the load balancer software (e.g. HAProxy). These accept traffic and route it to the appropriate services within the DC/OS cluster.

# <a name="edge-lb-reload-behavior"></a>Edge-LB Load Balancer Reload Behavior

## Normal Reload Scenario

A change to an service (such as scaling up or down) that is load balanced
by a Pool will trigger a reload of its Load Balancers. This reload has
the following properies:

* No traffic is dropped (unless the service instance that was serving the
  request was killed).
* The Load Balancer will wait until existing connections terminate, so a long
  running connection will prevent the reload from completing.
* A reload will occur at most once every 10 seconds.

The properties of this reload enable strategies such as
[Blue/Green Deployment](/1.10/networking/edge-lb/strategies#blue-green-deployment).

## Load Balancer Relaunch Scenario

A change to the Load Balancer (such as adding a Secret) will trigger a
relaunch of all such Load Balancers within the same Pool. This relaunch has
the following properies:

* Traffic is dropped
    * To minimize the impact, we suggest running more than one Load
      Balancer within the Pool.
* The Load Balancer will be relaunched on the same node (unless the node itself
  has failed).
