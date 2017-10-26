---
post_title: Updating Marathon Services Inline
nav_title: Inline Update
menu_order: 2
---

The [DC/OS CLI][1] Marathon sub-command allows you to easily view and update the configuration of existing applications.

## Update an Environment Variable

The [Marathon `env` variable][2] can be updated by specifying a JSON string in a command argument.

Specify this CLI command with the JSON string included:

```bash
dcos marathon app update test-app env='{"APISERVER_PORT":"25502"}'
```

Now run the command below to see the result of your update:

```bash
dcos marathon app show test-app | jq '.env'
```

## Update all Environment Variables

The [Marathon `env` variable][1] can also be updated by specifying a JSON file in a command argument.

First, save the existing environment variables to a file:

```bash
dcos marathon app show test-app | jq .env >env_vars.json
```

The file will look like this:

```json
{ "SCHEDULER_DRIVER_PORT": "25501", }
```

Now edit the `env_vars.json` file. Make the JSON a valid object by enclosing the file contents with `{ "env" :}` and add your update:

```json
{ "env" : { "APISERVER_PORT" : "25502", "SCHEDULER_DRIVER_PORT" : "25501" } }
```

Specify this CLI command with the JSON file specified:

```bash
dcos marathon app update test-app < env_vars.json
```

View the results of your update:

```bash
dcos marathon app show test-app | jq '.env'
```

 [1]: /docs/1.7/usage/cli/
 [2]: https://mesosphere.github.io/marathon/docs/task-environment-vars.html
