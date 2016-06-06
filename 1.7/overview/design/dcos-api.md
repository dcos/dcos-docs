---
post_title: DC/OS API Design
nav_title: API
menu_order: 2
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->
DC/OS consists of a number of components that each serve a specialized function.
The Unified DC/OS API brings all of their APIs together under one umbrella. It’s the “POSIX” of DC/OS.

Status: draft


## Proposed Endpoints

* Process - ps
   * Create
   * Status
   * Completed/Current
   * Kill
   * Executors?
   * Debugging - gdb
* Networking
   * Ingress - view, create, update, delete backends (aka endpoint publishing)
   * VIPs (aka endpoint routing within the cluster)
   * Isolation groups
   * Control visibility (internal, external, admin)
   * Arbitrary isolation
   * IPAM
* Security
   * Secrets management
* Storage
   * CRUD - external volumes
   * CRUD - disk reservations and local volumes
   * Mounting distributed filesystems (Mount table)
   * Installing Storage Drivers
      * RexRay
      * Flocker
      * AWS EBS
      * Azure Cloud Storage
      * GCP Persistent Disk
* Metrics        
* Data Store - internal database
* Service - a la systemd, process management
   * View, install, update, uninstall
   * Control visibility (internal, external, admin)
   * Lifecycle
   * Upgrades/Deployments
* Package - apt-get, yum, docker registry
   * CRUD - packages
   * view package repo
   * view running packages (Blurs into DCOS Service?)
   * add repo
* Log - journald
   * System components
   * Custom executor logs
   * Task logs
* Environment
* System
   * Time (Globally consistent)
   * Health
   * Config Information
   * Build Information
   * Flags
   * Performance
      * Mesos queue depths
      * Request/Response times
   * Support - gather system data
   * Node
      * Masters
      * Agents
         * Attributes
         * Roles
         * Reservations
         * Resources
      * Fault Domains
      * Maintenance
      * Regions? (for latency guarantees)
   * Resources
      * Quota
      * Roles
      * Reservations
      * Offers
   * Upgrade
   * Backup
* Infrastructure - cloud/on-prem specifics like external IPs
* SDK
   * Express fault tolerance or latency constraints


## User Experience Requirements

* Works with existing unix tooling and language client libraries
* Provides the ability to explore the API
* All APIs allow introspection and enumeration based on the current state.
   * What you can see is based entirely off your user context
* All APIs are consistent for:
   * Documentation
   * Responses
   * Error Handling
* There is a single root endpoint that the API is based off, users do not need to connect to different hosts to use the API.
* The API is available in the user context in the cluster.
   * You can only see the endpoints that are available for your current logged in permissions.
* The SDK is integrated into the DCOS API
   * There will be endpoints in the API that are RPC calls for the SDK
* Match the terminology in existing and popular APIs as much as possible
* The process API should start a one-off and have no (or as little as possible) definition.
* The process should be able to be attached to a lifecycle manager
   * Marathon
   * Chronos
   * Kafka Scheduler


## Protocol

* Make a request, asynchronously query the status of a request
* Endpoints return the current state and send diffs as changes occur
* We want extensibility when returning status/conditions for each request
* JSON + YAML
* Streaming is a fundamental part of the API
* HTTP 1.1 (pending discovery on 2.0 http clients)
* Write everything in your envelope
* Put the following in the URL:
   * Version
   * Kind
