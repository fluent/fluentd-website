# Upgrade Guide for fluent-package v6

On August 29, 2025, we released `fluent-package` v6 as a new series of stable packages.

## What is Fluent Package v6 LTS?
Fluent Package v6 LTS is a long-term support (LTS), stable package of Fluentd.

Fluent Package v5 LTS will reach end of support at the end of 2025.
As its successor, Fluent Package v6 LTS will be supported until at least the end of 2027.

For more details, see the following article:

* [fluent-package v6.0.0 has been released](https://www.fluentd.org/blog/fluent-package-v6.0.0-has-been-released)

## Upgrade procedure to Fluent Package v6 LTS
As an example, you can upgrade with the following steps:

1. Check manually installed plugins
2. Stop the Fluentd service
3. Back up registry settings (Windows only)
4. Install Fluent Package v6 LTS
5. Reinstall plugins
6. Restart the Fluentd service

Below are details for each step.

### 1. Check manually installed plugins
If your current version (before upgrade) is Fluent Package v5.0.2 or later (v5.0.3 for Windows),
you can use the bundled [fluent-diagtool](https://github.com/fluent/diagtool) to list manually installed plugins.

Run the following command:

```sh
$ /opt/fluent/bin/fluent-diagtool -t fluentd -o /tmp
```

* `-t fluentd`: required
* `-o /tmp`: specifies the output directory for results (you can choose any directory)

The tool outputs various information to standard output.
The following section shows the list of manually installed plugins:

```
(...)
2025-07-17 08:13:31 +0000: [Diagtool] [INFO] [Collect] fluent-package manually installed gem information is stored in /tmp/20250717081331/output/gem_local_list.output
2025-07-17 08:13:31 +0000: [Diagtool] [INFO] [Collect] fluent-package manually installed gems:
2025-07-17 08:13:31 +0000: [Diagtool] [INFO] [Collect]   * fluent-plugin-remote_syslog
(...)
```

In this example, the only manually installed plugins are `fluent-plugin-remote_syslog`.
The list is also saved to a file:


* `/{output_directory}/{execution_timestamp}/output/gem_local_list.output`

For the above case, the list was saved to `/tmp/20250717081331/output/gem_local_list.output`.

If you are using a version earlier than v5.0.2, the bundled `fluent-diagtool` is outdated.
Please update it in advance:

```sh
$ sudo fluent-gem install fluent-diagtool
```

If you cannot update `fluent-diagtool`, obtain the list of plugins with:

```sh
$ fluent-gem list fluent-plugin
```

**Note:**
On `fluent-package` v5.0.2 for Windows or earlier, `fluent-diagtool` is not available due to a known issue.
Use `fluent-gem list fluent-plugin` instead.

### 2. Stop the Fluentd service
Stop any running Fluentd service(s).
If multiple Fluentd services are running, stop them in the order: forwarders first, then aggregators.

### 3. Back up registry settings (Windows only)
On Windows, back up registry settings needed for rollback.
Run the following command in PowerShell or Command Prompt as an administrator:

```console
> reg export HKLM\System\CurrentControlSet\Services\fluentdwinsvc C:\fluent-package-5_fluentdwinsvc.reg
```

### 4. Install Fluent Package v6 LTS

Install Fluent Package v6 LTS.

Example for RPM Package (Red Hat Linux):

```sh
$ curl -fsSL https://fluentd.cdn.cncf.io/sh/install-redhat-fluent-package6-lts.sh | sh
```

Please refer to the official documentation for each environment:

* [RPM Package (Red Hat Linux)](https://docs.fluentd.org/installation/install-fluent-package/install-by-rpm-fluent-package)
* [DEB Package (Debian/Ubuntu)](https://docs.fluentd.org/installation/install-fluent-package/install-by-deb-fluent-package)
* [.msi Installer (Windows)](https://docs.fluentd.org/installation/install-fluent-package/install-by-msi-fluent-package)

### 5. Reinstall plugins
The manually installed plugins need to be reinstalled.
Reinstall the plugins identified in step 1.

Example:

```sh
$ sudo fluent-gem install fluent-plugin-remote_syslog
```

### 6. Restart the Fluentd service
Restart the Fluentd service(s) you stopped in step 2.
If multiple services exist, start them in the order from aggregators to forwarders.

**Note:**
Zero-Downtime Update Settings (non-Windows)

From the next update onward, you can perform upgrades without stopping the service using the zero-downtime update feature (not supported on Windows).

You can configure how Fluentd restarts after an update:

* auto (default): automatically performs zero-downtime restart after update
* manual: requires manual zero-downtime restart, disabling automatic plugin reinstallation and restart

This setting can be changed anytime and does not require restarting Fluentd itself.

For details, see:

* [fluent-package v5.2.0 has been released](https://www.fluentd.org/blog/fluent-package-v5.2.0-has-been-released)


## Rollback from Fluent Package v6 LTS to v5
### 1. Stop the Fluentd service
Stop running Fluentd services, in the order from forwarders to aggregators.

### 2. Install Fluent Package v5 LTS
On Linux, simply reinstall Fluent Package v5 LTS on top of v6. No need to uninstall v6 beforehand.
On Windows, uninstall Fluent Package v6 LTS first, then install v5 LTS.

Manually installed plugins remain on the system, so after rollback they are still available.
No reinstallation is required.

### 3. Restore the registry (Windows only)
On Windows, restore the registry with the following command (admin PowerShell or Command Prompt):

```console
> reg import C:\fluent-package-5_fluentdwinsvc.reg
```

This restores Windows service auto-start settings and startup command-line arguments.

### 4. Restart the Fluentd service
Restart the stopped Fluentd services in opposite order: aggregators first, then forwarders.


## Download

Please see [the download page](/download/fluent_package).

## Announcement

### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol),
td-agent v4 reached EOL in Dec, 2023.

And fluent-package v5 will reach EOL in end of 2025.

We strongly recommend upgrading to fluent-package v6 LTS.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed our X account.

TAG: Fluentd fluent-package Announcement reminder
AUTHOR: clearcode
