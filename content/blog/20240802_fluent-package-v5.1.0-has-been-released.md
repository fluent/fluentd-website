# fluent-package v5.1.0 has been released

Hi users!

We have released fluent-package [v5.1.0](https://github.com/fluent/fluent-package-builder/releases/tag/v5.1.0).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.x series.
Bundled ruby version was upgraded to 3.2.5 and fluentd v1.17.0 was shipped!

### Changes from fluent-package v5.0.4

In this release, focused on updating bundled ones.

* Update fluentd to 1.17.0
* Update ruby to 3.2.5
* Update bundled gems overall

### Update bundled components overall

In LTS version, conservative updating policy is enabled, so updating gem is very limited to bug fix or security fix.
In contrast to LTS version, v5.1.0 bundles more recent components because of standard version.

As we already announced in [Scheduled support lifecycle announcement about Fluent Package](/blog/fluent-package-scheduled-lifecycle)
blog article, in normal release channel, we will ship the latest version (v1.17.0) of Fluentd.

So if you want to try using latest version of Fluentd, v5.1.0 is one for you.
If you use fluent-package in enterprise services, keep using fluent-package 5.0.x (LTS).

<div markdown="span" class="alert alert-info" role="alert">
<i class="fa fa-info-circle"></i>
<b>Note:</b>In the previous versions, there is no different in normal release channel and LTS release channel. But 
from this release, v5.1.x will be shipped in normal release channel. v5.0.x will be shipped in LTS channel.
</div>

### Download

Please see [the download page](/download/fluent_package).

#### About next LTS schedule

We plan to ship the next LTS version of fluent-package v5.0.5 on Oct, 2024.
The content of updates are still in T.B.D.

#### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](schedule-for-td-agent-4-eol), td-agent v4 was reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](upgrade-td-agent-v4-to-v5)

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
