---
post_title: Quick Start
feature_maturity: experimental
menu_order: 3.3
---

Use this guide to get started with the `dcos task exec` debugging command.

**Prerequisite:**

- A container launched by using the [DC/OS Universal container runtime](/docs/1.9/usage/containerizers/).

# Pipe output from a command running inside a container 

You can run commands inside a container by using the `dcos task exec` command. In this example, a long running Marathon app is launched and then the `dcos task exec` command is used to get the hostname of the node running the app. 

1.  Create a Marathon app definition and name it `my-app.json` with the following contents:

    ```bash
    {
       "id": "/my-app",
       "cmd": "sleep 100000000",
       "cpus": 1,
       "instances": 1
     }
    ``` 
    
1.  Deploy the service on DC/OS:

    ```bash
    $ dcos marathon app add my-app.json
    ```

1.  Get the task ID of the job with this CLI command:

    ```bash
    $ dcos task
    ```
    
    The output should look similar to this: 
    
    ```bash
    NAME        HOST        USER  STATE  ID                                               
    my-app      10.0.1.106  root    R    <task_id>
    ```

1.  Run this command to show the hostname of the container running your app, where `<task-ID>` is your task ID.

    ```bash
    $ dcos task exec <task_id> hostname
    ```
    
    The output should look similar to this:
    
    ```bash
    ip-10-0-1-105.us-west-2.compute.internal
    ```

For more information about the `dcos task exec` command, see the CLI command [reference](/docs/1.9/usage/cli/command-reference/).

# Run an interactive command inside a task's container
You can run interactive commands on machines in your cluster by using the `dcos task exec` command. In this example, the `dcos task exec` command is used to copy a simple script from your local machine to the task container on the node. The script is then administered locally by using the `dcos task exec` command.

1.  Create a Marathon app definition and name it `my-interactive-app.json` with the following contents:

    ```bash
    {
       "id": "/my-interactive-app",
       "cmd": "sleep 100000000",
       "cpus": 1,
       "instances": 1
    }
    ```

1.  Deploy the app on DC/OS:

    ```bash
    $ dcos marathon app add my-interactive-app.json
    ```

1.  Get the task ID of the app with this CLI command:

    ```bash
    $ dcos task
    ```
    
    The output should look similar to this: 
    
    ```bash
    NAME                HOST        USER  STATE  ID                                               
    my-interactive-app  10.0.1.106  root    R    <task_id>
    ```

1.  Write a script called `hello-world.sh` with the following contents:

    ```bash
    echo "Hello World"
    ```
    
1.  Upload the script to your task container:

    ```bash
    $ cat hello-world.sh | dcos task exec -i <task_id> bash -c "cat > hello-world.sh"
    ```
    
1.  Give the file executable permissions:

    ```bash
    $ dcos task exec <task_id> chmod a+x hello-world.sh
    ```
1. Run the script inside of the container:

    ```bash
    $ dcos task exec <task_id> ./hello-world.sh
    ```

    The output should look similar to this:
    
    ```bash
    Hello World
    ```

# Launch a long running interactive Bash session

In this example, a long running [job](/docs/1.9/usage/jobs/) is launched by using the `dcos job run` command, and the `dcos task exec` command is used to launch an interactive Bash shell inside the container of that job.

1.  Deploy and run a job with the DC/OS CLI:

    1.  Create the following job definition and save as `my-job.json`. This specifies a sleep job that runs for `10000000` seconds.
    
        ```bash
        {
          "id": "my-job",
          "labels": {},
          "run": {
            "artifacts": [],
            "cmd": "sleep 100000000",
            "cpus": 0.01,
            "disk": 0,
            "env": {},
            "maxLaunchDelay": 3600,
            "mem": 32,
            "placement": {
              "constraints": []
            },
            "restart": {
              "policy": "NEVER"
            },
            "volumes": []
          }
        }
        ```
    
    1.  Deploy the job with this CLI command:
    
        ```bash
        $ dcos job add my-job.json
        ```
        
    1.  Verify that the job has been successfully deployed:
    
        ```bash
        $ dcos job list
        ```
        
        The output should resemble:
        
        ```bash
        ID      DESCRIPTION  STATUS       LAST SUCCESFUL RUN        
        my-job               Unscheduled         None
        ```

    1.  Run the job:
    
        ```bash
        $ dcos job run my-job
        ```

1.  Get the task ID of the job with this CLI command:

    ```bash
    $ dcos task
    ```
    
    The output should look similar to this: 
    
    ```bash
    NAME                          HOST       USER  STATE  ID                                                                       
    20161209183121nz2F5.my-job    10.0.2.53  root    R    <task_id>
    ```

1.  Launch a process inside of the container with the task ID (`<task_id>`) specified and attach a TTY to it. This will launch an interactive Bash session.

    ```bash
    $ dcos task exec --interactive --tty <task_id> bash
    ```
    
    You should now be inside the container running an interactive Bash session.
    
    ```bash
    root@ip-10-0-2-53 / #
    ```
    
1.  Run a command from the interactive Bash session. For example, the `ls` command:

    ```bash
    root@ip-10-0-1-104 / # ls
    bin   dev  home  lib64	     media  opt   root	sbin  sys  usr
    boot  etc  lib	 lost+found  mnt    proc  run	srv   tmp  var
    ```
    
 **Tip:** You can use shorthand abbreviations `-i` for `--interactive` or `-t` for `--tty`. Also, only the beginning unique characters of the `<task_id>` are required. For example, if your task ID is `exec-test_20161214195` and there are no other task IDs that begin with the letter `e`, this is valid command syntax: `dcos task exec -i -t e bash`. For more information, see the CLI command [reference](/docs/1.9/usage/cli/command-reference/).


