# fluent-package v5.0.5 has been released

Hi users!

We have released fluent-package [v5.0.5](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.5).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.
As bundled Ruby was updated to 3.2.6 and Fluentd was updated to 1.16.6.
We recommend upgrading to fluent-package v5.0.5!

### Changes from fluent-package v5.0.4

In this release, focused on updating bundled ones.

* Update ruby to 3.2.6
* Update fluentd to 1.16.6
* Update bundled gems overall
* Solved possibility of DoS through "NoMemoryError"
* msi: set `GEM_HOME`/`GEM_PATH` in fluentd.bat
* Fixed SIGABORT error with fluent-plugin-systemd

### Solved possibility of DoS through "NoMemoryError"

In the previous versions of msgpack gem, there was a possibility that cause DoS (Denial Of Service)
when crafted message was sent to Fluentd.

When that message was sent, it might cause "NoMemoryError" on Fluentd because there is a case that msgpack
try to pre-allocate huge amount of memories.

Above behavior was fixed not to pre-allocate over 32k entries (limit pre-allocated amount of memories) in msgpack 1.7.3 and bundled into fluent-package v5.0.5.

### msi: set `GEM_HOME`/`GEM_PATH` in fluentd.bat

In the previous versions, fluentd.bat doesn't set GEM_HOME/GEM_PATH explicitly.

If users set custom `GEM_HOME` / `GEM_PATH` environment variables, the
batch file will not work as expected. Therefore, this patch will set
the appropriate values in the batch file.

Above bug was also fixed in fluent-package v5.0.5.

### Fixed SIGABORT error with fluent-plugin-systemd

In this release, the bundled fluent-plugin-systemd was updated to 1.1.0.
That release fixed SIGABORT error with inconsistency of memory allocator handling.

### Download

Please see [the download page](/download/fluent_package).

#### About next LTS schedule

We plan to ship the next LTS version of fluent-package v5.0.6 on March, 2025.
The content of updates are still in T.B.D.

#### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol), td-agent v4 was reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](upgrade-td-agent-v4-to-v5)

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
