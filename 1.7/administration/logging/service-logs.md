---
post_title: Service and Task Logging
menu_order: 0
---

As soon as you move from one machine to many, accessing and aggregating logs becomes difficult. Once you hit a certain scale, keeping these logs and making them available to others can add massive overhead to your cluster. After watching how users interact with their logs, we’ve scoped the problem to two primary use cases. This allows you to pick the solution with the lowest overhead that solves your specific problem.

# Debugging

When things go wrong, you need to see the logs to understand how to fix it. DC/OS services and tasks write `stdout` and `stderr` files in their sandboxes by default. Traditionally, log aggregation has been the solution here. Write the logs locally and then ship all that data elsewhere for someone to actually access. Moving data around is expensive, especially when it ends up being written multiple times.

For most debugging tasks, log aggregation ends up being a particularly heavy solution for a simple task. All you want is to see the logs, where they come from doesn’t actually matter. By scoping the debugging task down to this level, we’ve been able to provide a couple simple solutions that work for most use cases.

DC/OS knows where every task has run in your cluster. It is also able to stream every file your application outputs. By combining these two features, you’re able to use the CLI or GUI to access historical and current logs such as stdout/stderr from your local machine.

Let’s say that you’ve got a service misbehaving. For some reason, it is continually crashing and you need to figure out why. You don’t need to SSH to a specific machine to find the logs and start to understand this problem. Instead, you can use the CLI or GUI to immediately get access to the files that your service is creating.

## CLI

If you’ve created a service named `service` in Marathon and would like to see stdout for every instance of that in real time, you can run the following:

```
dcos task log --follow service
```

For more advanced usage, you can check out the CLI documentation:

- [DC/OS CLI Usage][1]

## GUI

For those who are more comfortable with the GUI, we have a solution as well! By going to `Services -> Marathon -> service` in the DC/OS UI, you’ll be able to download all the files your service has produced as well as watch stdout/stderr via. the `Log Viewer`.

Check out some of the DC/OS UI documentation for more details:

- [DC/OS UI](/docs/1.7/usage/webinterface/)

# Compliance

Unfortunately, streaming logs from machines in your cluster isn’t always viable. Sometimes, you need the logs stored somewhere else as a history of what’s happened. This is where log aggregation really is required. Check out how to get it setup with some of the most common solutions:

- [ELK][2]
- [Splunk][3]

[1]: /docs/1.7/usage/cli/
[2]: ../elk/
[3]: ../splunk/
