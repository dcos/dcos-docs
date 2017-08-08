---
post_title: Connecting to Multiple Clusters
nav_title: Multiple Clusters  
menu_order: 3.1
---

You can connect the CLI to multiple DC/OS clusters at the same time by using the `dcos cluster` command. 

To connect to a cluster, run this command with your cluster name (`<name>`) specified: 

```bash
dcos cluster attach <name>
```

**Tips:** 

-  You can view all configured clusters with the `dcos cluster list` command. The attached cluster will have an asterisk (`*`) by its cluster ID. To view only the attached cluster run the `dcos cluster list --attached` command. In this example, the cluster ID `cf96739f-f800-42ea-95d7-d60acc689194` is connected:

   ```bash
        NAME                   CLUSTER ID               VERSION                                       URL                                        
    dcosprod     5f7fb957-6daf-446e-8689-0b5b476b2d39     N/A    https://dcosclust-elasticl-eosy64z9zduk-926805990.us-west-2.elb.amazonaws.com   
   dcosdev*      cf96739f-f800-42ea-95d7-d60acc689194     N/A    https://dcosclust-elasticl-5m650j1mo8cc-1644521530.us-west-2.elb.amazonaws.com 
    dcostest     d112e8cd-9918-4660-a3f8-95953723de09     N/A    https://dcosclust-elasticl-1kjl0p9j0rc0p-374529426.us-west-2.elb.amazonaws.com 
   ```

-  You can rename your cluster with this `dcos cluster rename <old-name> <new-name>` command. For example, to rename your cluster from `dcosdev` to `dcoslive`:

   ```bash
   dcos cluster rename dcosdev dcoslive
   ```
    
   