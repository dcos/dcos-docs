---
post_title: Quick Start
menu_order: 0
post_excerpt: ""
feature_maturity: experimental
enterprise: 'no'
---


Use this guide to get started with DC/OS logging. 

# Deploy a sample app
Deploy a sample Marathon app for use in this quick start guide.

1.  Create the following Marathon app definition and save as `test-log.json`.
    
    ```json
    {
      "id": "/test-log",
      "cmd": "while true;do echo stdout;echo stderr >&2;sleep 1;done",
      "cpus": 0.001,
      "instances": 1,
      "mem": 128
    }
    ```

1.  Deploy the app with this CLI command:
    
    ```bash
    $ dcos marathon app add test-log.json
    ```

1.  Verify that the app has been successfully deployed and note task ID:

    ```bash
    $ dcos task test-log
    ```
    
    The output should resemble:
    
    ```bash
    NAME      HOST        USER  STATE  ID 
    test-log  10.0.1.105  root    R    test-log.e69c4b2f-c255-11e6-a451-aa711cbcaa78
    ```

# View the Mesos and DC/OS logs

You can access the Mesos stderr and stdout logs natively through the DC/OS CLI `dcos task log` command. In this example, a task is launched and the stderr and stdout logs from Mesos are accessed. 
  
1.  Run this command to view the stdout logs, where `<task_id>` is the task ID:

    ```bash
    $ dcos task log <task_id>
    ```
    
    The output should resemble:
    
    ```bash
    Thu Dec 15 00:49:10 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    Thu Dec 15 00:49:11 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    ```
1.  Run this command to follow the logs, where `<task_id>` is the task ID:

    ```bash
    $ dcos task log --follow <task_id>
    ```
    
    This will create a running stream of logs similar to this:
    
    ```bash
    Wed Dec 14 16:50:12 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131]: stdout
    Wed Dec 14 16:50:13 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131]: stdout
    ```

1.  Run this command to get last 5 log entries:
 
    ```bash
    $ dcos task log <task_id> --lines=5
    ```
    
    The output should resemble:
    
    ```bash
    Thu Dec 15 00:51:27 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    Thu Dec 15 00:51:28 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    Thu Dec 15 00:51:29 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    Thu Dec 15 00:51:30 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    Thu Dec 15 00:51:31 2016 ip-10-0-1-177.us-west-2.compute.internal Command Executor (Task: test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd) (Command: sh -c 'while true;d...') [7131] stdout
    ```

# View the Mesos task and system logs 

You can view logs from tasks or the host subsystem with the `dcos node log` command. 
    
1.  Run this command to view the leading Mesos master logs:

    ```bash
    $ dcos node log --leader --lines 3 
    ```
    
    The output should resemble:
    
    ```bash
    Thu Dec 15 00:29:28 2016 ip-10-0-6-165.us-west-2.compute.internal [10530] ip-10-0-6-165.us-west-2.compute.internal nginx: 10.0.6.72 - - [15/Dec/2016:00:29:28 +0000] "GET /service/marathon/v2/groups?_timestamp=1481761768409&embed=group.groups&embed=group.apps&embed=group.pods&embed=group.apps.deployments&embed=group.apps.counts&embed=group.apps.tasks&embed=group.apps.taskStats&embed=group.apps.lastTaskFailure HTTP/1.1" 200 1941 "http://joel-logg-elasticl-m6yuis5u674t-297942863.us-west-2.elb.amazonaws.com/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36"
    Thu Dec 15 00:29:29 2016 ip-10-0-6-165.us-west-2.compute.internal nginx [2929] 2016/12/15 00:29:29 [notice] 10530#0: *1136 [lua] auth.lua:131: validate_jwt_or_exit(): UID from valid JWT: `email@email.io`, client: 10.0.6.72, server: dcos.*, request: "GET /system/v1/logs/v1/range/?skip_prev=3 HTTP/1.1", host: "joel-logg-elasticl-m6yuis5u674t-297942863.us-west-2.elb.amazonaws.com"
    Thu Dec 15 00:29:29 2016 ip-10-0-6-165.us-west-2.compute.internal dcos-oauth [1505] time="2016-12-15T00:29:29Z" level=info msg="HTTP request received" method=GET uri="/acs/api/v1/users/youremail@email.io"
    ```

1.  Run this command to view the Mesos agent logs, where node ID (`<node_id>`) is specified:

    ```bash
    $ dcos node log --mesos-id=<node_id> --lines 3
    ```
    
    **Tip:** Run `dcos task` to identify which node is running your app, followed by `dcos node` to get the node ID.
    
    The output should resemble:
    
    ```bash
    Thu Dec 15 00:46:18 2016 ip-10-0-1-175.us-west-2.compute.internal mesos-agent [3284] I1215 00:46:18.794333  3315 http.cpp:288] HTTP GET for /slave(1)/state from 10.0.1.175:44661 with User-Agent='Mesos-State / Host: ip-10-0-1-175, Pid: 3023'
    Thu Dec 15 00:46:20 2016 ip-10-0-1-175.us-west-2.compute.internal mesos-agent [3284] I1215 00:46:20.800422  3319 http.cpp:288] HTTP GET for /slave(1)/state from 10.0.1.175:44661 with User-Agent='Mesos-State / Host: ip-10-0-1-175, Pid: 3023'
    Thu Dec 15 00:46:22 2016 ip-10-0-1-175.us-west-2.compute.internal spartan-env [2621] 00:46:22.575 [error] Lager event handler error_logger_lager_h exited with reason {'EXIT',{{badmatch,[<0.27147.0>,{info,{tcp_closed,#Port<0.9301>}},{wait_for_query,{state,#Port<0.9301>,{spartan_tcp_listener,{198,51,100,3}},ranch_tcp,<0.27148.0>}},exit,tcp_closed,state_functions,[{gen_statem,loop_event_result,9,[{file,"gen_statem.erl"},{line,978}]},{proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,247}]}]]},[{error_logger_lager_h,log_event,2,[{file,"/pkg/src/spartan/_build/default/lib/lager/src/error_logger_lager_h.erl"},{line,155}]},{gen_event,server_update,4,[{file,...},...]},...]}}
    ```

1.  Run these commands to view a list of components running on the leader or agent node:

    -   Leader node:
    
        ```bash
        $ dcos node list-components --leader
        ```
 
        The output should resemble:
        
        ```bash
        dcos-3dt.service
        dcos-adminrouter-reload.service
        dcos-adminrouter-reload.timer
        dcos-adminrouter.service
        dcos-cosmos.service
        dcos-epmd.service
        dcos-exhibitor.service
        dcos-gen-resolvconf.service
        dcos-gen-resolvconf.timer
        dcos-history.service
        ...
        ```
    
    -  Agent node, where your node ID (`<mesos-id>`) is specified:
    
       ```bash
       $ dcos node list-components --mesos-id=<mesos-id>
       ```
       
       The output should resemble:
       
       ```bash
       dcos-3dt.service
       dcos-3dt.socket
       dcos-adminrouter-agent-reload.service
       dcos-adminrouter-agent-reload.timer
       dcos-adminrouter-agent.service
       dcos-docker-gc.service
       dcos-docker-gc.timer
       dcos-epmd.service
       dcos-gen-resolvconf.service
       ...
       ```
    
1.  Run this command to view the leading master component log for DC/OS components. In this example, the Marathon component logs are queried:

    ```bash
    $ dcos node log --leader --component dcos-marathon.service
    ```
    
    The output should resemble:
    
    ```bash
    Thu Dec 15 00:34:08 2016 ip-10-0-6-165.us-west-2.compute.internal java [2541] [2016-12-15 00:34:08,121] INFO  Received status update for task test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd: TASK_RUNNING (Reconciliation: Latest task state) (mesosphere.marathon.MarathonScheduler$$EnhancerByGuice$$28056dde:Thread-296)
    Thu Dec 15 00:34:08 2016 ip-10-0-6-165.us-west-2.compute.internal java [2541] [2016-12-15 00:34:08,121] INFO  Received status update for task test-log.2fc56009-c25d-11e6-81b2-9a5d88789ccd: TASK_RUNNING (Reconciliation: Latest task state) (mesosphere.marathon.MarathonScheduler$$EnhancerByGuice$$28056dde:Thread-297)
    ...
    ```
    
