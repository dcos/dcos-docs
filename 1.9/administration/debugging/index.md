---
post_title: Debugging
feature_maturity: experimental
menu_order: 3.3
---

The `dcos task exec` command allows you to execute an arbitrary command inside of a task's container and stream its output back to your local terminal. It offers an experience very similar to [`docker exec`](https://docs.docker.com/engine/reference/commandline/exec/), without any need for SSH keys. 

You can execute this command in any of the following four modes.

- `dcos task exec <task-id> <command>` (no flags): streams STDOUT and STDERR from the remote terminal to your local terminal as raw bytes. 

- `dcos task exec --tty <task-id> <command>`: streams STDOUT and STDERR from the remote terminal to your local terminal, but not as raw bytes. Instead, this option puts your local terminal into raw mode, allocates a remote pseudo terminal (PYT), and streams the STDOUT and STDERR through the remote PTY. 

- `dcos task exec --interactive <task-id> <command>` streams STDOUT and STDERR from the remote terminal to your local terminal and streams STDIN from your local terminal to the remote command. 

- `dcos task exec --interactive --tty <task-id> <command>`: streams STDOUT and STDERR from the remote terminal to your local terminal and streams STDIN from your local terminal to the remote terminal. Also puts your local terminal into raw mode; allocates a remote pseudo terminal (PYT); and streams STDOUT, STDERR, and STDIN through the remote PTY. This mode offers the maximum functionality.

**Note:** If your mode streams raw bytes, you won't be able to launch programs like `vim`, because these programs require the use of control characters.

**Tip:** We have included the text of the full flags above for readability, but each one can be shortened. Instead of typing `--interactive`, you can just type `-i`. Likewise, instead of typing `--tty`, you can just type `-t`.

**Requirement:** To use the debugging feature, the service or job must be launched using either the Mesos container runtime or the Universal container runtime. Debugging cannot be used on containers launched with the Docker runtime. See [Using Mesos Containerizers](https://dcos.io/docs/1.9/usage/containerizers/) for more information.

<!-- Fork a Process Inside a Mesos Container, stream its output (OSS) -->
<!-- Support Optional Stream of STDIN to Forked Process (OSS) -->
<!-- Support Optional Pseudo-Teletype for Forked Process (OSS) -->
<!-- Secure the the Debugging API with Fine Grained Auth (Enterprise) -->

For more information, see:

- [Command reference](/docs/1.9/usage/cli/command-reference/)
- [Quick Start](/docs/1.9/administration/debugging/quickstart/).