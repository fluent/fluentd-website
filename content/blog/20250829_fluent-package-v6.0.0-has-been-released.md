# fluent-package v6.0.0 has been released

Hi users!

We're excited to announce the release of fluent-package [v6.0.0](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.0) !

This is the first release of the v6 LTS series, and it will be supported until the end of 2027.

We strongly recommend upgrading to fluent-package v6 LTS!

## What is Fluent Package v6 LTS?
Fluent Package v6 LTS is a long-term support (LTS), stable package of Fluentd.

The conventional Fluentd project official package, td-agent, reached its end of support at the end of 2023. Fluent Package has been officially developed and distributed by the Fluentd project since the end of August 2023 as its successor package.

The current LTS version, Fluent Package v5 LTS, will reach end of support at the end of 2025.
As the next LTS version, Fluent Package v6 LTS will be supported until at least the end of 2027.

In LTS versions, we only perform bug fixes and security fixes over a pre-announced long-term period (minimum 2 years).
Therefore, there are two advantages for long-term stable operations:

* Continuous updates are easier
  * You can continuously incorporate the latest bug fixes and security fixes
* You can prepare systematically for the next major update
  * Since the support period is announced in advance, you know when the next major update will occur

For detailed support schedule information, please see [Scheduled support lifecycle announcement about Fluent Package v6](/blog/fluent-package-v6-scheduled-lifecycle).

## Major new features and improvements
This release includes many improvements for long-term stable operations.
The main improvements are as follows:

* Updated Fluentd to v1.19.0
  * Significantly improved fault tolerance and operability, including buffer evacuation.
* Zero-downtime update / restart
  * Configuration reloads and Fluentd restarts can now be performed with zero downtime.
* Refreshed platform support
  * Added support for modern platforms and discontinued support for older ones.
* OpenTelemetry support
  * Support for transferring OpenTelemetry data over HTTP/HTTPS.
* Easier updates
  * Auto-start settings and service startup command line arguments (Windows) are preserved.

### Updated Fluentd to v1.19.0
While Fluent Package v5 LTS bundled Fluentd v1.16, v6 LTS moves to Fluentd v1.19.
This makes the following new features available:

* Major new features and improvements in Fluentd v1.19.0
  * Improved fault tolerance and simplified recovery
    * [Buffer evacuation when retry limits are exceeded](https://docs.fluentd.org/buffer#handling-successive-failures)
      * Data that exceeded retry limits is automatically evacuated, making it easy to resend later.
    * Enhanced buffer corruption detection
      * If buffer files are corrupted due to forced shutdown, they are automatically evacuated, improving safe restarts.
    * Expanded metrics
      * Added several new metrics (e.g., number of tracked files in in_tail) to aid monitoring.
  * Performance improvements
    * Support for Zstandard (zstd) compression
        * Compared to gzip, this can reduce disk usage and improve transfer speed.
    * Other optimizations
        * Multiple performance improvements for faster processing and reduced memory usage.

For more detailed changes since v1.16, see:

* [Fluentd v1.19.0](https://www.fluentd.org/blog/fluentd-v1.19.0-has-been-released)
* [Fluentd v1.18.0](https://www.fluentd.org/blog/fluentd-v1.18.0-has-been-released)
* [Fluentd v1.17.0](https://www.fluentd.org/blog/fluentd-v1.17.0-has-been-released)

### Zero-downtime update / restart
Starting from v6 LTS, zero-downtime updates are available.
This feature allows you to safely execute configuration file reloading and Fluentd restarts with zero downtime (Windows not supported).

For more details, see the following article and try out this feature:

* [fluent-package v5.2.0 has been released](https://www.fluentd.org/blog/fluent-package-v5.2.0-has-been-released)

### Refreshed platform support
Fluent Package v6 supports the following platforms:

* Debian-based
  * Debian 12 (bookworm)
  * Debian 13 (trixie)
  * Ubuntu 22.04 (Jammy Jellyfish)
  * Ubuntu 24.04 (Noble Numbat)
* RHEL-based
  * RHEL 8 compatible
  * RHEL 9 compatible
  * RHEL 10 compatible
  * AmazonLinux 2023
* Windows

<div markdown="span" class="alert alert-danger" role="alert">
  <b>Important:</b> This release drops support for the following platforms:

  <ul>
    <li>Debian 11 (bullseye)</li>
    <li>Ubuntu 20.04 (Focal Fossa)</li>
  </ul>
</div>

### OpenTelemetry Support
This release supports transferring OpenTelemetry data over HTTP/HTTPS.
For configuration methods and other details, please see the plugin [README](https://github.com/fluent-plugins-nursery/fluent-plugin-opentelemetry/blob/main/README.md).

We also provide a [sample](https://github.com/fluent-plugins-nursery/fluent-plugin-opentelemetry/tree/main/example) for quick testing.

### Easier updates
We've improved the system to preserve auto-start configuration and Windows service (`fluentdwinsvc`) command line options during updates.
This eliminates the need for reconfiguration that was previously required during updates.

In addition, manually installed plugins still need to be reinstalled when updating an LTS version.
Starting from this release, when updating further in the future, plugins will be automatically reinstalled during updates (Windows not supported).
This will make future updates easier.

## Other Improvements and Fixes
* Updated from Ruby 3.2 to Ruby 3.4
* Migrated distribution CDN to fluentd.cdn.cncf.io
* Included necessary gems for [Linux Capability](https://docs.fluentd.org/deployment/linux-capability) functionality
* Disabled unnecessary linker flags (package-note-file) in RPM builds
* Added `fluent-plugin-fluent-package-update-notifier` plugin
  * Outputs Fluent Package version update notifications to logs (Linux environments only).
* Added `fluent-plugin-obsolete-plugins` plugin
  * Detects obsolete plugins at Fluentd startup and outputs to logs (Linux environments only).
* Updated `fluent-plugin-systemd` plugin
  * Fixed `SIGABORT` error.


## Download

Please see [the download page](/download/fluent_package).

## Announcement

### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol), td-agent v4 reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was an exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](upgrade-td-agent-v4-to-v5)

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed our X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode

