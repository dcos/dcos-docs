---
post_title: What is DC/OS?
menu_order: 1
---

DC/OS is a distributed operating system based on the Apache Mesos distributed systems kernel. It enables the management of multiple machines as if they were a single computer. It automates resource management, schedules process placement, facilitates inter-process communication, and simplifies the installation and management of distributed services. Its included web interface and available command-line interface (CLI) facilitate remote management and monitoring of the cluster and its services.

When you’re operating a datacenter, there are a set of common operations that you do because you have to, not because you want to. In a single computer environment, your operating system automatically takes care of these things. When was the last time you had to manually tell your laptop which processor core to run your application on? For those of you who responded with anything other than “never”, there are some amazing computers at the Computer History Museum that you might want to check out.

On your laptop, the job of scheduling an application to a specific core is handled by the kernel. Abstracting this process out, the kernel manages all of the resources on your computer, including memory, disk, inputs and outputs, etc. There’s no reason why a kernel must operate only on a single computer. Programs to manage resources across multiple computers can solve the same problem. In fact, this is what a container orchestrator does. It can act like a kernel for the combined resources of an entire datacenter instead of the resources of just a single computer.

At this point, the act of running an application on some resources is automated away. Unfortunately, that’s only one small piece of the puzzle. Our modern operating systems contain a plethora of software that is used to solve many other common computing problems and allows us to focus on doing actual work, rather than managing our computers. DC/OS includes these solutions to these common problems out of the box, whereas before you had to research solutions yourself and integrate them by hand into the computers in your datacenter. 


## Common management interfaces - GUI and CLI

When is the last time you used a computer that didn’t have a GUI and a CLI? We don’t write programs on punch cards any longer. There’s no reason we should be interacting with low level APIs, even RESTful ones, unless we’re doing something advanced.

At some point, it becomes impossible to interact with every computer in the datacenter as an individual. For sheer sanity, you must layer an abstraction over the top and view the datacenter as a whole. You need a single place to see what’s running and where it is running. You can easily monitor and debug problems, reducing downtime. There’s no reason to SSH into hundreds of hosts just to find the logs for a specific application.

The CLI is just as important as a GUI, and sometimes not given the credit it is due. Regular tasks can skip the GUI entirely or even be integrated into your normal environment such as VI or Emacs. For special cases, the CLI ends up being an excellent tool to script and automate those things that you just don’t want to worry about.


## Service discovery

It is rare to write a service that stands alone and doesn’t need to contact any other services. With three tier applications, you need to figure out how to configure the middle tier to contact the backend database. On a single host, this can be done via ports. All you have to do is specify a port, assume the IP address is localhost and you’re ready to go. Unfortunately, once you move to multiple hosts there are some problems that can occur:

- What is the host IP the container is running on?
- How do I configure my clients to connect to the correct host IP?
- How do I dynamically update my clients to connect to a new host IP once the container has been rescheduled?
- How do I manage two applications that want to bind to a popular port like 8080?

DNS is the beginning of a solution. It was originally built to take care of service discovery at the scale of the internet after all. Unfortunately, it doesn’t work well in a world of dynamically changing IPs because of caching issues and can’t generally address ports.

You can provide a virtual IP and port for clients to communicate with your containers. This architecture works on-prem and in every cloud, and brings building applications back to the world of a single computer. Legacy and modern applications rely on this simple solution to go about their business without any code changes.


## Package management

Applications tend to be composed of more than a single process that has no configuration. Microservices can be made up of hundreds of processes all with their own configurations. Taking something like this and deploying it across a datacenter is a time consuming, delicate process. It is easy to misunderstand the implications of a specific configuration setting in your environment or just be unable to get the application running.

One way to make sense of all this complexity is to create a package of the common applications you would like to take advantage of in your datacenter. There is a multitude of options such as databases and message queues that you build on top of. By bundling the processes and configuration into a single package, you can get started fast and be sure you’re following best practices.
