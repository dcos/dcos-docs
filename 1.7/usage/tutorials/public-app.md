---
post_title: Deploying Public Services
nav_title: Public Services
---

The native Marathon instance is configured to receive offers from the public agent nodes (`--mesos_role="slave_public"`). Marathon apps are configured to use unreserved resources and launch on private agent nodes (`--default_accepted_resource_roles="*"`).

To run a Marathon app on public agent nodes, you must set the `acceptedResourceRoles` property to:

```json
"acceptedResourceRoles":["slave_public"]
```

To run a Marathon app on any agent node type, you must set the `acceptedResourceRoles` property to:

```json
"acceptedResourceRoles":["slave_public", "*"]
```
