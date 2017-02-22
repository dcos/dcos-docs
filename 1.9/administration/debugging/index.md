---
post_title: Debugging
feature_maturity: experimental
menu_order: 3.3
---

The `dcos task exec` DC/OS CLI command allows you to execute commands inside of a task's container. You just need to supply the ID of the task and be logged into the DC/OS CLI via `dcos auth login`. The container must be running. It offers an experience very similar to [`docker exec`](https://docs.docker.com/engine/reference/commandline/exec/), without any need for SSH keys. The connection occurs over an HTTP stream and does not use SSH at all.

You can run the command in any of the following modes.

- `dcos task exec <task-id> <command>` (no flags): stream STDOUT and STDERR from the remote terminal to your local terminal as raw bytes. Note that the use of raw bytes prevents you from launching programs like `vim` as these programs require control characters.

- `dcos task exec --tty <task-id> <command>` OR `dcos task exec -t <task-id> <command>`: streams STDOUT and STDERR from the remote terminal to your local terminal, but not as raw bytes. Instead, this option puts your local terminal into raw mode, allocates a remote pseudo terminal (PYT), and streams the STDOUT and STDERR through the remote PTY. This affords you the experience of interacting directly with the remote PTY and allows you to launch programs like `vim`.

- `dcos task exec --interactive <task-id> <command>` OR `dcos task exec -i <task-id> <command>`: streams STDOUT and STDERR from the remote terminal to your local terminal and streams STDIN from your local terminal to the remote command. Note that both streams will be raw bytes preventing you from launching programs like `vim` as these programs rely on control characters.

- `dcos task exec --interactive --tty <task-id> <command>` OR `dcos task exec -it <task-id> <command>`: streams STDOUT and STDERR from the remote terminal to your local terminal and streams STDIN from your local terminal to the remote terminal. Also puts your local terminal into raw mode; allocates a remote pseudo terminal (PYT); and streams STDOUT, STDERR, and STDIN through the remote PTY so that they are not raw bytes.  This option offers the maximum functionality.

**Requirement:** To use the debugging feature, the service or job must be launched using either the Mesos container runtime or the Universal container runtime. Debugging cannot be used on containers launched with the Docker runtime. See [Using Mesos Containerizers](/1.9/usage/containerizers/) for more information.

<!-- Fork a Process Inside a Mesos Container, stream its output (OSS) -->
<!-- Support Optional Stream of STDIN to Forked Process (OSS) -->
<!-- Support Optional Pseudo-Teletype for Forked Process (OSS) -->
<!-- Secure the the Debugging API with Fine Grained Auth (Enterprise) -->

For more information, see the [Quick Start](/docs/1.9/administration/debugging/quickstart/).