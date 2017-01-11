---
post_title: Opt-Out
menu_order: 4
---

## Authentication

You can opt-out of the provided authentication by disabling it for your cluster. To disable authentication, add this parameter to your [`config.yaml`][4] file during installation (note this requires using the [CLI][1] or [advanced][2] installers):

```yaml
oauth_enabled: 'false'
```

Note that if you’ve already installed your cluster and would like to disable this in-place, you can go through an upgrade with the same parameter set.

## Telemetry

You can opt-out of providing anonymous data by disabling telemetry for your cluster. To disable telemetry, you can either:

- Add this parameter to your [`config.yaml`][4] file during installation (note this requires using the [CLI][1] or [advanced][2] installers):

    ```yaml
    telemetry_enabled: 'false'
    ```
Or

- Add a flag to the custom installer, `dcos_generate_config.sh --cli-telemetry-disabled`, to disable the CLI basic telemetry. For more information, see the [documentation](/docs/1.8/administration/installing/custom/cli/).
    

Note that if you’ve already installed your cluster and would like to disable this in-place, you can go through an [upgrade][3] with the same parameter set.

[1]: /docs/1.8/administration/installing/custom/cli/
[2]: /docs/1.8/administration/installing/custom/advanced/
[3]: /docs/1.8/administration/installing/custom/configuration-parameters/
[4]: /docs/1.8/administration/installing/custom/configuration-parameters/

