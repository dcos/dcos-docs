---
post_title: CLI Command Reference
nav_title: Reference
menu_order: 5
---

# dcos

    Description:
        The Mesosphere Datacenter Operating System (DC/OS) spans all of the machines in
    your datacenter or cloud and treats them as a single, shared set of resources.
    
    Usage:
        dcos [options] [<command>] [<args>...]
    
    Options:
        --debug
            Enable debug mode.
        --help
            Print usage.
        --log-level=<log-level>
            Set the logging level. This setting does not affect the output sent to
            stdout. The severity levels are:
            * debug    Prints all messages.
            * info     Prints informational, warning, error, and critical messages.
            * warning  Prints warning, error, and critical messages.
            * error    Prints error and critical messages.
            * critical Prints only critical messages to stderr.
        --version
            Print version information.
    

# dcos auth

    Description:
        Authenticate to DC/OS cluster
    
    Usage:
        dcos auth --help
        dcos auth --info
        dcos auth list-providers [--json]
        dcos auth login
            [--provider=<provider_id>] [--username=<username>]
            [--password=<password> | --password-file=<password_file>
            | --password-env=<password_env> | --private-key=<key_path>]
        dcos auth logout
    
    Commands:
        list-providers
            List configured authentication providers for your DC/OS cluster.
        login
            Login to your DC/OS cluster.
        logout
            Logout of your DC/OS cluster.
    
    Options:
        -h, --help
            Print usage.
        --info
            Print a short description of this subcommand.
        --password=<password>
            Specify password on the command line (insecure).
        --password-env=<password_env>
            Specify environment variable name that contains the password.
        --password-file=<password_file>
            Specify path to a file that contains the password.
        --provider=<provider_id>
            Specify authentication provider to use for login.
        --private-key=<key_path>
            Specify path to file that contains the private key.
        --username=<username>
            Specify username for login.
        --version
            Print version information.

# dcos config

    Description:
        Manage the DC/OS configuration file.
    
    Usage:
        dcos config --info
        dcos config set <name> <value>
        dcos config show [<name>]
        dcos config unset <name>
        dcos config validate
    
    Commands:
        set
            Add or set a DC/OS configuration property.
        show
            Print the DC/OS configuration file contents.
        unset
            Remove a property from the configuration file.
        validate
            Validate changes to the configuration file.
    
    
    Options:
        -h, --help
            Print usage.
        --info
            Print a short description of this subcommand.
        --version
            Print version information.
    
    Positional Arguments:
        <name>
            The name of the property.
        <value>
            The value of the property.
    

# dcos help

    Description:
        Display help information about DC/OS.
    
    Usage:
        dcos help
        dcos --info
        dcos help <subcommand>
    
    Commands:
        help
            Print help information about a subcommand.
    
    Options:
        --help
            Print usage.
        --info
            Print a short description of this subcommand.
        --version
            Print version information.
    
    Positional Arguments:
        <subcommand>
            The subcommand name.
    
# dcos job

    Description:
        Deploy and manage jobs in DC/OS.

    Usage:
        dcos job [--help]
        dcos job [--version]
        dcos job [--config-schema]
        dcos job [--info]
        dcos job add <job-file>
        dcos job remove <job-id> [--stopCurrentJobRuns]
        dcos job show <job-id>
        dcos job update <job-file>
        dcos job kill <job-id> [run-id][--all]
        dcos job run <job-id>
        dcos job list [--json]
        dcos job schedule add <job-id> <schedule-file>
        dcos job schedule show <job-id> [--json]
        dcos job schedule remove <job-id> <schedule-id>
        dcos job schedule update <job-id> <schedule-file>
        dcos job show runs <job-id> [--run-id <run-id>][--json][--q]
        dcos job history <job-id> [--json][--show-failures]

        Commands:
            job add
                Add a job.
        job remove
            Remove a job.
        job show
            Show the job.
        job update
            Update the job.
        job kill
            Show the job.
        job run
            Run a job now.
        job list
            Show all job definitions.
        job schedule add
            Adds a schedule to a job.
        job schedule show
            Shows the schedules of a job.
        job schedule remove
            Removes a schedule from a job.
        job schedule update
            Updates a schedule on a job.
        job show runs
            Shows the successful and failure runs of a job.
        job history
            Provides a job run history.

    Options:
        -h, --help
            Print usage.
        --version
            Print version information.
        --config-schema
            Show the configuration schema for the Metronome subcommand.
        --info
            Print a short description of this subcommand.
        --stopCurrentJobRuns
            Indicates on a job removal that all current running jobs should be killed.
        --all
            Instead of specifying a run_id to kill, indicates all runs should be killed.
        --json
            Print JSON-formatted list instead of a table.
        --q
            Indicates a quiet mode which results in just an array of run ids.
        --show-failures
            Indicates to show the failure table and statistics for history.
    
    Positional Arguments:
        <job-id>
            The job ID.
        <job-file>
            A JSON formatted file of a job.
        <run-id>
            The run ID of a job run.
        <schedule-file>
            A JSON formatted file of a job schedule.
        <schedule-id>
            The schedule ID.

# dcos marathon

    Description:
        Deploy and manage applications to DC/OS.
    
    Usage:
        dcos marathon --config-schema
        dcos marathon --help
        dcos marathon --info
        dcos marathon about
        dcos marathon app add [<app-resource>]
        dcos marathon app list [--json]
        dcos marathon app remove [--force] <app-id>
        dcos marathon app restart [--force] <app-id>
        dcos marathon app show [--app-version=<app-version>] <app-id>
        dcos marathon app start [--force] <app-id> [<instances>]
        dcos marathon app stop [--force] <app-id>
        dcos marathon app kill [--scale] [--host=<host>] <app-id>
        dcos marathon app update [--force] <app-id> [<properties>...]
        dcos marathon app version list [--max-count=<max-count>] <app-id>
        dcos marathon deployment list [--json <app-id>]
        dcos marathon deployment rollback <deployment-id>
        dcos marathon deployment stop <deployment-id>
        dcos marathon deployment watch [--max-count=<max-count>]
                                       [--interval=<interval>] <deployment-id>
        dcos marathon group add [<group-resource>]
        dcos marathon group list [--json]
        dcos marathon group scale [--force] <group-id> <scale-factor>
        dcos marathon group show [--group-version=<group-version>] <group-id>
        dcos marathon group remove [--force] <group-id>
        dcos marathon group update [--force] <group-id> [<properties>...]
        dcos marathon pod add [<pod-resource>]
        dcos marathon pod kill <pod-id> [<instance-ids>...]
        dcos marathon pod list [--json]
        dcos marathon pod remove [--force] <pod-id>
        dcos marathon pod show <pod-id>
        dcos marathon pod update [--force] <pod-id>
        dcos marathon debug list [--json]
        dcos marathon debug summary <app-id> [--json]
        dcos marathon debug details <app-id> [--json]
        dcos marathon task list [--json <app-id>]
        dcos marathon task stop [--wipe] <task-id>
        dcos marathon task show <task-id>
    
    Commands:
        about
            Print info.json for DC/OS Marathon.
        app add
            Add an application.
        app list
            List the installed applications.
        app remove
            Remove an application.
        app restart
            Restart an application.
        app show
            Show the `marathon.json` for an  application.
        app start
            Start an application.
        app stop
            Stop an application.
        app kill
            Kill a running application instance.
        app update
            Update an application.
        app version list
            List the version history of an application.
        deployment list
            Print a list of currently deployed applications.
        deployment rollback
            Remove a deployed application.
        deployment stop
            Cancel the in-progress deployment of an application.
        deployment watch
            Monitor deployments.
        group add
            Create a new group.
        group list
            Print the list of groups.
        group scale
            Scale a group.
        group show
            Print a detailed list of groups.
        group remove
            Remove a group.
        group update
            Update a group.
        pod add
            Create a new pod.
        pod kill
            Kill one or more running pod instances.
        pod list
            List the deployed pods.
        pod remove
            Remove a pod.
        pod show
            Display detailed information for a specific pod.
        pod update
            Update a pod.
        debug list
            Print a list of currently queued instance launches for
            debugging purpose.
        debug summary
            Display summarized information for a queued instance launch
            for debugging purpose.
        debug details
            Display detailed information for a queued instance launch
            for debugging purpose.
        task list
            List all tasks.
        task stop
            Stop a task. Wipe persistent data if `--wipe` is set.
        task show
            List a specific task.
    
    Options:
        --app-version=<app-version>
            The version of the application to use. It can be specified as an
            absolute or relative value. Absolute values must be in ISO8601 date
            format. Relative values must be specified as a negative integer and they
            represent the version from the currently deployed application definition.
        --config-schema
            Show the configuration schema for the Marathon subcommand.
        --force
            Disable checks in Marathon during updates.
        --group-version=<group-version>
            The group version to use for the command. It can be specified as an
            absolute or relative value. Absolute values must be in ISO8601 date
            format. Relative values must be specified as a negative integer and they
            represent the version from the currently deployed group definition.
        -h, --help
            Print usage.
        --host=<host>
            The hostname that is running app.
        --info
            Print a short description of this subcommand.
        --interval=<interval>
            Number of seconds to wait between actions.
        --json
            Print JSON-formatted data.
        --max-count=<max-count>
            Maximum number of entries to fetch and return.
        --scale
            Scale the app down after performing the the operation.
        --version
            Print version information.
    
    Positional Arguments:
        <app-id>
            The application ID.
        <app-resource>
            Path to a file or HTTP(S) URL that contains the app's JSON definition.
            If omitted, the definition is read from stdin. For a detailed
            description see
            https://mesosphere.github.io/marathon/docs/rest-api.html#post-v2-apps.
        <deployment-id>
            The deployment ID.
        <group-id>
            The group ID.
        <group-resource>
            Path to a file or HTTP(S) URL that contains the group's JSON definition.
            If omitted, the definition is read from stdin. For a detailed
            description see
            https://mesosphere.github.io/marathon/docs/rest-api.html#post-v2-groups.
        <instance-ids>
            List of one or more space-separated pod instance IDs.
        <instances>
            The number of instances.
        <pod-id>
            The pod ID.
        <pod-resource>
            Path to a file or HTTP(S) URL that contains the pod's JSON definition.
            If omitted, the definition is read from stdin.
        <properties>
            List of space-separated JSON object properties to update.  The list
            must be formatted as <key>=<value>. For example, `cpus=2.0 mem=308`.
            If omitted, properties are read from a JSON object provided on stdin.
        <task-id>
            The task ID.
        <scale-factor>
            The factor to scale an application group by.
    

# dcos node

    Description:
        Administer and manage DC/OS cluster nodes.
    
    Usage:
        dcos node --help
        dcos node --info
        dcos node [--json]
        dcos node log [--follow --lines=N --leader --master --mesos-id=<mesos-id> --slave=<slave-id>]
                      [--component=<component-name> --filter=<filter>...]
        dcos node list-components [--leader --mesos-id=<mesos-id> --json]
        dcos node ssh [--option SSHOPT=VAL ...]
                      [--config-file=<path>]
                      [--user=<user>]
                      [--master-proxy]
                      (--leader | --master | --mesos-id=<mesos-id> | --slave=<slave-id>)
                      [<command>]
        dcos node diagnostics create (<nodes>)...
        dcos node diagnostics delete <bundle>
        dcos node diagnostics download <bundle> [--location=<location>]
        dcos node diagnostics (--list | --status | --cancel) [--json]
    
    Commands:
        log
            Prints the Mesos logs for the leading master node, agent nodes, or both.
        ssh
            Establish an SSH connection to the master or agent nodes of your DC/OS
            cluster.
        diagnostics create
            Create a diagnostics bundle. Nodes can be: ip address, hostname, mesos ID
            or keywords "all", "masters", "agents" (notice the quotes around the keywords).
        diagnostics download
            Download a diagnostics bundle.
        diagnostics delete
            Delete a diagnostics bundle.
    
    Options:
        --config-file=<path>
            Path to SSH configuration file.
        --follow
            Dynamically update the log.
        -h, --help
            Show this screen.
        --info
            Show a short description of this subcommand.
        --json
            Print JSON-formatted list of nodes.
        --leader
            The leading master.
        --lines=N
            Print the last N lines, where 10 is the default.
        --master
            Deprecated. Please use --leader.
        --master-proxy
            Proxy the SSH connection through a master node. This can be useful when
            accessing DC/OS from a separate network. For example, in the default AWS
            configuration, the private slaves are unreachable from the public
            internet. You can access them using this option, which will first hop
            from the publicly available master.
        --option SSHOPT=VAL
            The SSH options. For information, enter `man ssh_config` in your
            terminal.
        --slave=<agent-id>
            Agent node with the provided ID.
        --user=<user>
            The SSH user, where the default user [default: core].
        --list
            List available diagnostics bundles.
        --status
            Print diagnostics job status.
        --cancel
            Cancel a running diagnostics job.
        --location=<location>
            Download a diagnostics bundle to a particular location.
            If not set, default to present working directory.
        --version
            Print version information.
        --list-components
            Print a list of available DC/OS components on specified node.
        --component=<component-name>
            Show DC/OS component logs.
        --filter=<filter>
            Filter logs by field and value. Filter must be a string separated by colon.
            For example: --filter _PID:0 --filter _UID:1
    
    Positional Arguments:
        <command>
            Command to execute on the DCOS cluster node.

By default, `dcos node ssh` connects to the private IP of the node, which is only accessible from hosts within the same network, so you must use the `--master-proxy` option to access your cluster from an outside network. For example, in the default AWS configuration, the private agents are unreachable from the public internet, but you can SSH to them using this option, which will proxy the SSH connection through the publicly reachable master.

# <a name="cli-dcos-package"></a>dcos package

    Description:
        Install and manage software packages from the a DC/OS package repository.
    
    Usage:
        dcos package --config-schema
        dcos package --info
        dcos package describe [--app --cli --config]
                              [--render]
                              [--package-versions]
                              [--options=<file>]
                              [--package-version=<package-version>]
                              <package-name>
        dcos package install [--cli | [--app --app-id=<app-id>]]
                             [--package-version=<package-version>]
                             [--options=<file>]
                             [--yes]
                             <package-name>
        dcos package list [--json --app-id=<app-id> <package-name>]
        dcos package search [--json <query>]
        dcos package repo add [--index=<index>] <repo-name> <repo-url>
        dcos package repo remove <repo-name>
        dcos package repo list [--json]
        dcos package uninstall [--cli | [--app --app-id=<app-id> --all]]
                               <package-name>
    
    Commands:
        describe
            Get specific details for packages.
        install
            Install a package.
        list
            Print a list of the installed DC/OS packages.
        search
            Search the package repository.
        repo add
            Add a package repository to DC/OS.
        repo remove
            Remove a package repository from DC/OS.
        repo list
            Print the package repository sources. Possible sources include a local
            file, HTTPS, and Git.
        uninstall
            Uninstall a package.
        update
            This command has been deprecated. Repositories are dynamically updated
            as they are added by `dcos package repo add`.
    
    Options:
        --all
            All packages.
        --app
            Application only.
        --app-id=<app-id>
            The application ID.
        --cli
            Command line only.
        --config
            Print the the configurable properties for the `marathon.json` and
            `command.json` files.
        --index=<index>
            The numerical position in the package repository list. Package
            repositories are searched in descending order. By default the Universe
            repository first in the list.
        -h, --help
            Print usage.
        --info
            Print a short description of this subcommand.
        --options=<file>
            Path to a JSON file that contains customized package installation options.
        --package-version=<package-version>
            The package version to install.
        --package-versions
            Print all versions for this package.
        --render
            Collate the marathon.json or command.json package templates with the
            values from config.json and --options. If not provided, print the raw
            templates.
        --version
            Print version information.
        --yes
            Turn off interactive mode and assume "yes" is the answer to all prompts.
    
    Positional Arguments:
        <package-name>
            Name of the DC/OS package in the package repository.
        <query>
            Pattern to use for searching the package repository.  You can use
            complete or partial values.
        <repo-name>
            Name of the package repository. For example, `Universe`.
        <repo-url>
            URL of the package repository. For example,
            https://universe.mesosphere.com/rep
    

# dcos service

    Description:
        Manage DC/OS services.
    
    Usage:
        dcos service --info
        dcos service [--completed --inactive --json]
        dcos service log [--follow --lines=N --ssh-config-file=<path>]
                         <service> [<file>]
        dcos service shutdown <service-id>
    
    Commands:
        log
            Print the service logs.
    
        shutdown
            Shutdown a service.
    
    
    Options:
        --completed
            Show the completed and active services. Completed services have either
            been disconnected from master and reached their failover timeout, or
            have been explicitly shutdown via the /shutdown endpoint.
        -h, --help
            Print usage.
        --follow
            Print data as the log file grows.
        --inactive
            Show the inactive and active services. Inactive services have been
            disconnected from master, but haven't yet reached their failover timeout.
        --info
            Print a short description of this subcommand.
        --json
            Print JSON-formatted list of DC/OS services.
        --lines=N
            Print the last N lines, where 10 is the default.
        --ssh-config-file=<path>
            The path to the SSH config file. This is used to access the Marathon
            logs.
        --version
            Print version information.
    
    Positional Arguments:
        <file>
            The service log filename for the Mesos sandbox. The default is stdout.
        <service>
            The DC/OS Service name.
        <service-id>
            The DC/OS Service ID.
    

**Important:** To view the native DC/OS Marathon logs by using the `dcos service log marathon` command, you must be on the same network or connected by VPN to your cluster. For more information, see [Accessing native DC/OS Marathon logs][1].

# dcos task

```
Description:
    Manage DC/OS tasks.

Usage:
    dcos task --help
    dcos task --info
    dcos task exec [--interactive --tty] <task> <cmd> [<args>...]
    dcos task log [--completed --follow --lines=N] [<task>] [<file>]
    dcos task ls [--long --completed] [<task>] [<path>]
    dcos task [--completed --json <task>]

Command:
    exec
        Launch a process (<cmd>) inside of a container for a task (<task_id>).

    log
        Print the task log. By default, the 10 most recent task logs from stdout
        are printed.
    ls
        Print the list of files in the Mesos task sandbox.

Options:
    --completed
        Print completed and in-progress tasks.
    -h, --help
        Print usage.
    --info
        Print a short description of this subcommand.
    --interactive
        Attach a STDIN stream to the remote command for interactive session.
    --tty
        Attach a TTY to the remote stream.
    --follow
        Dynamically update the log.
    --json
        Print JSON-formatted list of tasks.
    --lines=N
        Print the last N lines. The default is 10 lines.
    --long
        Print full Mesos sandbox file attributes.
    --version
        Print version information.

Positional Arguments:
    <cmd>
        The command to execute inside of the remote container. For example: `/bin/bash`.
    <args>
        Additional arguments to pass to the command (`<cmd>`).
    <file>
        Specify the sandbox file to print. The default is stdout.
    <path>
        The Mesos sandbox directory path. The default is '.'.
    <task>
        A full task ID, a partial task ID, or a regular expression.
``` 

If you specify a partial task ID, logs for all task names that contain the partial task ID are displayed. For example, if you have tasks named `spark1`, `spark2`, and `spark3`, then the command `dcos task log spark` will display task logs for all three of these tasks; you do not need to use wildcards.

If you use a regular expression, you must enclose the task ID in double quotation marks and include an asterisk at the end of the task ID. For example, `dcos task log "spark[13]*"` will display information for tasks `spark1` and `spark3`, but not `spark2`.

For more information about the `dcos task exec` command, see the Debugging [documentation](/docs/1.9/administration/debugging/quickstart/).

 [1]: /docs/1.9/administration/logging/quickstart/
