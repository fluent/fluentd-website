# fluent-package v5.0.4 has been released

Hi users!

We have released fluent-package [v5.0.4](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.4).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.
As bundled Ruby was updated to 3.2.4 and a foolproof mechanism was implemented to prevent launching duplicated Fluentd instances, we recommend upgrading to fluent-package v5.0.4!

### Changes from fluent-package v5.0.3

* Update ruby to 3.2.4 ([#645](https://github.com/fluent/fluent-package-builder/pull/645))
* Fixed to prevent launching Fluentd wrongly if the service is already running ([#648](https://github.com/fluent/fluent-package-builder/pull/648),[#649](https://github.com/fluent/fluent-package-builder/pull/649))
* Added support for Ubuntu 24.04 (Noble Numbat)

<div markdown="span" class="alert alert-info" role="alert">
<i class="fa fa-info-circle"></i>
<b>Note:</b> In this release, dropped CentOS 7 package because of EOL.
</div>

### Fixed to prevent launching Fluentd wrongly if the service is already running

In this release, a foolproof mechanism was implemented to prevent launching Fluentd wrongly if the service is already running.

As you know, you can check the version of Fluentd with `fluentd --version`, but there is a case that `fluentd -v` is executed wrongly to 
do it.

When already running Fluentd as a service, `fluentd -v` launches a duplicated Fluentd instance with the same fluentd configuration.
If you launch duplicated Fluentd instances, it causes the corruption of processing Fluentd buffer.
To prevent such a situation, a foolproof was implemented now.

For example, if Fluentd is running as a service, launching Fluentd causes an error to block it.

Here is the example on Windows:

```
> fluentd
Error: Can't start duplicate Fluentd instance with the default config.

To start Fluentd, please do one of the following:
  (Caution: Please be careful not to start multiple instances with the same config.)
  - Stop the Fluentd Windows service 'fluentdwinsvc'.
  - Specify the config path explicitly by '-c' ('--config').
```

Even though if you wrongly launch Fluentd to check version with `-v` (It should be `--version` to show version), then it causes the following error.

```
> fluentd -v
Error: Can't start duplicate Fluentd instance with the default config.

To take the version, please use '--version', not '-v' ('--verbose').

To start Fluentd, please do one of the following:
  (Caution: Please be careful not to start multiple instances with the same config.)
  - Stop the Fluentd Windows service 'fluentdwinsvc'.
  - Specify the config path explicitly by '-c' ('--config')
```

Note that this foolproof feature is intended to block launching duplicated Fluentd instance, you can explicitly launch Fluentd by specifying a specific option to pass it
even though already Fluentd is running as a service.

On Windows:

* `-c` (`--config`)
* `--dry-run`
* `--reg-winsvc`
* `--reg-winsvc-fluentdopt`
* `--show-plugin-config`

On Linux:

* `-c` (`--config`)
* `--dry-run`
* `--show-plugin-config`

### Download

Please see [the download page](/download/fluent_package).

### Announcement

#### About next LTS schedule

We plan to ship the next LTS version of fluent-package v5.0.5 on Oct, 2024.
The content of updates are still in T.B.D.

#### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](/blog/schedule-for-td-agent-4-eol), td-agent v4 was reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](/blog/upgrade-td-agent-v4-to-v5)

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
