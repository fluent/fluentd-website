# fluent-package v5.2.0 has been released

Hi users!

We have released fluent-package [v5.2.0](https://github.com/fluent/fluent-package-builder/releases/tag/v5.2.0).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This release is a new release of v5.2 series.

## Changes from fluent-package v5.1.0
* Support upgrade fluentd service with zero-downtime
* Update ruby to 3.2.6
* Update bundled Fluentd to v1.18.0
* Update bundled gems overall
* Solved possibility of DoS through "NoMemoryError"
* msi: set `GEM_HOME`/`GEM_PATH` in fluentd.bat
* deb: suppress service restart by needrestart
* Fixed SIGABORT error with fluent-plugin-systemd

## Support upgrade fluentd service with zero-downtime
Previously, when upgrading the fluent-package, you had to stop the fluentd service,
install the new version of the fluent-package, then install any necessary plugins,
and finally restart the fluentd service.

Starting from fluent-package v5.2.0,
we have introduced the zero-downtime restart feature that automatically installs the required plugins during the upgrade process
and allows you to upgrade Fluentd without interrupting the logging service.

Please refer to "Advisory for upgrading with zero-downtime".

## Solved possibility of DoS through "NoMemoryError"
In the previous versions of msgpack gem, there was a possibility that cause DoS (Denial Of Service)
when crafted message was sent to Fluentd.

When that message was sent, it might cause "NoMemoryError" on Fluentd because there is a case that msgpack
try to pre-allocate huge amount of memories.

Above behavior was fixed not to pre-allocate over 32k entries (limit pre-allocated amount of memories) in msgpack 1.7.3 and bundled.

## msi: set `GEM_HOME`/`GEM_PATH` in fluentd.bat
In the previous versions, fluentd.bat doesn't set GEM_HOME/GEM_PATH explicitly.

If users set custom `GEM_HOME` / `GEM_PATH` environment variables, the
batch file will not work as expected. Therefore, this patch will set
the appropriate values in the batch file.

## deb: suppress service restart by needrestart
We have changed so that Fluentd does not restart when the needrestart package is installed.
fluent-package v5.2.0 places `/etc/needrestart/conf.d/50-fluent-package.conf`.

## Fixed SIGABORT error with fluent-plugin-systemd
In this release, the bundled fluent-plugin-systemd was updated to 1.1.0.
That release fixed SIGABORT error with inconsistency of memory allocator handling.

## Advisory for upgrading with zero-downtime
The zero-downtime restart feature can be configured by `FLUENT_PACKAGE_SERVICE_RESTART` environment variable.
Please refer to following section for more details.

* Add `FLUENT_PACKAGE_SERVICE_RESTART` environmental variable
  * This section explains `FLUENT_PACKAGE_SERVICE_RESTART` environment variable.
* Automate Plugin Install for Update on Demand
  * This section explains the mechanism that installs the plugins automatically during the upgrade process.

### Add `FLUENT_PACKAGE_SERVICE_RESTART` environmental variable
We have introduced `FLUENT_PACKAGE_SERVICE_RESTART` environment variable to configure the zero-downtime restart feature.
The variable exists in the following file:

* RPM: `/etc/sysconfig/fluentd`
* DEB: `/etc/default/fluentd`

Example:

```
FLUENT_PACKAGE_OPTIONS=""
# Control method to upgrade service (auto/manual) restart
FLUENT_PACKAGE_SERVICE_RESTART=auto
```

#### **auto (default)**
The service automatically restarts with zero-downtime restart feature when all of the following conditions are met:

1. The service was active before updating.
2. The installed and upgrading versions are required 5.2.0 or higher (both sides must support this feature).

The plugins will be automatically reinstalled if needed if your environment has an active online connection.
For more details, please refer to "Automate Plugin Install for Update on Demand".

#### **manual**
You can use this approach if you prefer to manage plugins manually or if your environment does not have online connection.
If the service was active before the update, it will not restart automatically with this configuration.
You need to restart the service manually.

* The zero-downtime restart:
  * Send a `SIGUSR2` signal to the supervisor process, such as with `kill -USR2 <PID>`
* Normal restart:
  * Restart the service normally, such as with `systemctl restart fluentd`.

### Automate Plugin Install for Update on Demand
#### Automate Plugin Management
If you prefer to manage plugins automatically, please set `FLUENT_PACKAGE_SERVICE_RESTART` to `auto` (default).

When the service restarts automatically using the zero-downtime restart feature, any missing plugins are automatically detected and reinstalled before the restart.

Previously, automatic restarts after updates were not recommended due to potential issues.
If you manually install plugins, you need to reinstall them before restarting when the embedded Ruby version is updated.

To address this, this feature enables automatic plugin installation during the restart process. The steps are as follows:

1. Collect the current list of plugins before the update.
   - Recognize gems as plugins that has `fluent-plugin-` prefix.
2. After installing the updated package, detect missing plugins.
   - Compare the collected plugin list with the default plugins to identify any missing ones.
3. Install the missing plugins.

#### Manual Plugin Management
If you prefer to manage plugins manually, please set `FLUENT_PACKAGE_SERVICE_RESTART` to `manual`.
This is useful in cases such as:

- Pinning specific plugin versions
- Operating in an offline environment

In this mode, automatic plugin installation and restarts are disabled.
You can manually install plugins and send a `SIGUSR2` signal to trigger the zero-downtime restart feature after the update.

### Caution: if you use a custom unit file, need to migrate it to use this feature safely
If you use a custom unit file, such as `/etc/systemd/system/fluentd.service`, please remove these 2 lines.

```
Environment=GEM_HOME=/opt/fluentd/lib/ruby/gems/...
Environment=GEM_PATH=/opt/fluentd/lib/ruby/gems/...
```

We don't need `GEM_HOME` and `GEM_PATH`.
They will be removed after v5.2.0, but if you use a custom unit file, you need to remove them manually.
If these variables are set, the zero-downtime restart feature may not work correctly.
It is because the new process inherits the original environment variables if using this feature.

Please refer to [#713](https://github.com/fluent/fluent-package-builder/pull/713) for more details.


## Download
Please see [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule
We plan to ship the next LTS version of fluent-package v5.0.6 on March, 2025.
The content of updates are still in T.B.D.

### End of support for td-agent v4, let's migrate to fluent-package
As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol), td-agent v4 was reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](upgrade-td-agent-v4-to-v5)

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
