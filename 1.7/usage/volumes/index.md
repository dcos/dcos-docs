---
post_title: Local and External Volumes 
nav_title: Local and External Volumes 
menu_order: 4.5 
---

You can create stateful applications using either local or external volumes.

# [Local Volumes][1]
Use local volumes when speed is crucial for your app, or when you have a performance-sensitive app that needs exclusive access to a disk.


# [External Volumes][2]

Use external volumes when fault-tolerance is crucial for your app. If a host fails, the native Marathon instance reschedules your app on another host, along with its associated data, without user intervention. External volumes also typically offer a larger amount of storage.

[1]: /docs/1.7/usage/volumes/local-volumes/ 
[2]: /docs/1.7/usage/volumes/external-volumes/ 
