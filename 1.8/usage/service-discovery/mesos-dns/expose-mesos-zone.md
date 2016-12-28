---
post_title: Exposing Mesos Zones Outside
menu_order: 300
---

There are cases where you may want to have services outside of DC/OS that use DNS records inside of the DC/OS cluster.  However, the `.mesos` domain name that DC/OS uses to expose records does not support this. To enable this capability, you can put a BIND server in front of your cluster. 

Each DC/OS cluster has a unique cryptographic identifier. The zbase32 encoded version of the identifier can be found under system. 

In the example, the cryptographic cluster ID `yor6tqhiag39y6cjkdd4w9uzo45qhku6ra8hl7hpr6d9ukjaz3jo` is used.


1.  Install a BIND server in front of your cluster.

1.  Create a forwarding entry for your DC/OS master that resembles this.

    ```
    zone "yor6tqhiag39y6cjkdd4w9uzo45qhku6ra8hl7hpr6d9ukjaz3jo.dcos.directory" {
            type forward;
            forward only;
            forwarders { 10.0.4.173; };  // <Master-IP-1;Master-IP-2;Master-IP-3>
    };
    ```

    1.  Replace the master IP (`<Master-IP>`) with a semicolon separated list of your own master IPs. 
    
    1.  Replace the example cryptographic cluster ID with your own.



## Making a zone
Now, you can create the zone that you'd like to alias to this. You can also skip this step and [use an existing zone](#existing).

1.  Create a zone entry in the `named.conf` file. For this example, `contoso.com` is used:

    ```
    zone "contoso.com" {
            type master;
            file "/etc/bind/db.contoso.com";
    };
    ```

1.  Populate the zone file:

    ```
    $TTL    604800
    @       IN      SOA     localhost. root.localhost. (
                                  1         ; Serial
                                  1         ; Refresh
                                  1         ; Retry
                                  1         ; Expire
                                  1 )       ; Negative Cache TTL
    ;
    @       IN      NS      localhost.
    @       IN      DNAME   mesos.yor6tqhiag39y6cjkdd4w9uzo45qhku6ra8hl7hpr6d9ukjaz3jo.dcos.directory.
    ```

## <a name="existing"></a>Using an existing zone

-   To use an existing zone, add a DNAME record:

    ```
    @       IN      DNAME   mesos.yor6tqhiag39y6cjkdd4w9uzo45qhku6ra8hl7hpr6d9ukjaz3jo.dcos.directory.
    ```
    
    The `@` aliases the top level of the zone, for example `contoso.com`. 

-   To alias a high level domain, specify that value in the DNAME record. In this example, `foo` aliases `foo.contoso.com`:

    ```
    foo       IN      DNAME   mesos.yor6tqhiag39y6cjkdd4w9uzo45qhku6ra8hl7hpr6d9ukjaz3jo.dcos.directory.
    ```
