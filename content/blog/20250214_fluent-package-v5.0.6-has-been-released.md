# fluent-package v5.0.6 has been released

Hi users!

We have released fluent-package [v5.0.6](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.6).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.
Bundled Fluentd was updated to 1.16.7.

We recommend upgrading to fluent-package v5.0.6!

## Changes from fluent-package v5.0.5

In this release, known Windows issues were fixed.

* Update bundled Fluentd to v1.16.7
* Update bundled gems overall
* msi: Fixed to keep some registry values with update

## msi: Fixed to keep some registry values with update

In the previous versions, there had been a known issue that fluent-package 
could not keep some registry values when upgrading.

Thus, if you modify Fluentd service (`fluentdwinsvc`) related registry,
you need to restore your configuration after upgrading.

Since v5.0.6, fluent-package was fixed to keep some registry values during upgrading package.

Here is the target registry which will be kept during upgrading fluent-package:

* `Start`
* `DelayedAutostart`
* `fluentdopt` (logging path might be modified by users)

In most cases, fluent-package user might want to keep `fluentdopt` because
it stores additional command line option parameters.

In this release, bundled Fluentd v1.16.7 also contains the fixes for Windows.

* Windows: Fix `NoMethodError` of --daemon option
* Windows: Fixed the issues which are related to start/stop Fluentd service

See [Fluentd v1.16.7 has been released](fluentd-v1.16.7-has-been-released) blog article in details.

## Download

Please see [the download page](/download/fluent_package).

### About next LTS schedule

We plan to ship the next LTS version of fluent-package v5.0.7 on June, 2025.
The content of updates are still in T.B.D.

### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol), td-agent v4 reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](upgrade-td-agent-v4-to-v5)

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
