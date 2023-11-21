# fluent-package v5.0.2 has been released

Hi users!

We have released fluent-package [v5.0.2](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.2).
fluent-package is a stable distribution package of Fluentd.

This is a maintenance release of v5.0.x LTS series.
As significant `in_tail` bugs (wrongly stopping tailing logs) were fixed in latest release, we recommend upgrading to fluent-package v5.0.2!

### Changes from fluent-package v5.0.1

* Update fluentd to [1.16.3](https://github.com/fluent/fluentd/releases/tag/v1.16.3)
  which contains significant bug fixes about `in_tail`.
  See [Fluentd v1.16.3 and v1.16.2 have been released](/blog/fluentd-v1.16.2-v1.16.3-have-been-released) blog article about details.
* Update plugins
  * fluent-diagtool v1.0.3. It supports fluent-package and can collect information about locally installed gems. It may help to migrate from td-agent v4 a bit.
    See [Upgrade to fluent-package v5](/blog/upgrade-td-agent-v4-to-v5) for migration.
* msi: support path which contains space or parenthesis ([#589](https://github.com/fluent/fluent-package-builder/pull/589))
* deb: fixed system user/group name in logrotate config ([#592](https://github.com/fluent/fluent-package-builder/pull/592),[#594](https://github.com/fluent/fluent-package-builder/pull/594))
  * It fixes a bug that unknown user error was reported during log rotation.
* rpm: fixed to create fluentd user as system account ([#596](https://github.com/fluent/fluent-package-builder/pull/596))
  * It fixes a bug that /var/lib/fluent directory was created unexpectedly. It doesn't affect the fluentd service behavior, but it is desirable one.
* rpm: changed to keep system account after removing fluent-package. ([#598](https://github.com/fluent/fluent-package-builder/pull/598))
  * In the previous versions, there was a bug that group was not cleanly removed
    when the package was upgraded from td-agent v4.
    This change makes reinstall/downgrade friendly.

### About next LTS schedule

We plan to ship next LTS version of fluent-package v5.0.3 on Feb, 2024.
The content of updates are still in T.B.D.

### Download

Please see [the download page](/download/fluent_package).

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
