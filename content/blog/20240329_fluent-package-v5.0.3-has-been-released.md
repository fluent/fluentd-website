# fluent-package v5.0.3 has been released

Hi users!

We have released fluent-package [v5.0.3](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.3).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.
As significant slow starting service and crash issues during startup on Windows were fixed, we recommend upgrading to fluent-package v5.0.3!

### Changes from fluent-package v5.0.2

* Update fluentd to [1.16.5](https://github.com/fluent/fluentd/releases/tag/v1.16.5).
  See the following blog articles about details.
  * [Fluentd v1.16.4 has been released](fluentd-v1.16.4-have-been-released)
  * [Fluentd v1.16.5 has been released](fluentd-v1.16.5-have-been-released)
* Update bundled plugins
  * e.g. fluent-diagtool v1.0.5. It supports to collect list of plugins on Windows.
* msi: fixed wrong environment path for Fluent Package Prompt ([#606](https://github.com/fluent/fluent-package-builder/pull/606))
  * It breaks fluent-diagtool behavior to launch fluent-gem correctly.
* msi: removed unnecessary path delimiter ([#607](https://github.com/fluent/fluent-package-builder/pull/607))
  * It doesn't cause any problem yet, but it should treat `%~dp0` correctly.
* rpm: fixed to take over enabled state of systemd service from td-agent v4 ([#613](https://github.com/fluent/fluent-package-builder/pull/613))
* deb rpm: fixed to quote target files correctly not to cause migration failures ([#615](https://github.com/fluent/fluent-package-builder/pull/615))
* msi: added a patch for RubyInstaller to avoid crash on start up ([#620](https://github.com/fluent/fluent-package-builder/pull/620))
* msi: fixed slow start issue on Windows ([#631](https://github.com/fluent/fluent-package-builder/pull/631))

<div markdown="span" class="alert alert-info" role="alert">
<i class="fa fa-info-circle"></i>
<b>Note:</b> v5.0.3 for Windows msi will be shipped later.
</div>

### Download

Please see [the download page](/download/fluent_package).

### Announcement

#### About next LTS schedule

We plan to ship next LTS version of fluent-package v5.0.4 on June, 2024.
The content of updates are still in T.B.D.

#### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol), td-agent v4 was reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](upgrade-td-agent-v4-to-v5)

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
