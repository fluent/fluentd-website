# fluent-package v5.0.7 has been released

Hi users!

We have released fluent-package [v5.0.7](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.7).
fluent-package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.
Bundled Fluentd was updated to 1.16.9.

We recommend upgrading to fluent-package v5.0.7!

## Changes from fluent-package v5.0.6

* Update bundled ruby to 3.2.8
* Update bundled Fluentd to v1.16.9
  * [Fluentd v1.16.8 has been released](/blog/fluentd-v1.16.8-has-been-released)
  * [Fluentd v1.16.9 has been released](/blog/fluentd-v1.16.9-has-been-released)
* Update bundled gems overall
* Update bundled openssl gem to 3.3.0 due to support FIPS
* Fix memory leaks when exception was raised frequently with fluent-plugin-elasticsearch

## Update bundled openssl gem to 3.3.0 due to support FIPS

With an old gem, it caused an exception after FIPS enabled in OpenSSL.
We have updated the bundled openssl gem to 3.3.0 to solve the issue.

## Fix memory leaks when exception was raised frequently with fluent-plugin-elasticsearch

There were memory leaks under conditions where exceptions frequently occurred during communication between Elasticsearch and fluent-plugin-elasticsearch.
The issue was fixed in fluent-plugin-elasticsearch v5.4.4 and bundled into fluent-package v5.0.7.

## Download

Please see [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to ship the next LTS version of fluent-package v5.0.8 on September, 2025.
The content of updates are still in T.B.D.

### End of support for td-agent v4, let's migrate to fluent-package

As it was already announced [Drop schedule announcement about EOL of Treasure Agent (td-agent) 4](/blog/schedule-for-td-agent-4-eol), td-agent v4 reached EOL in Dec, 2023.

After reached EOL, td-agent v4.5.3 on Windows was released because there was a crash bug during startup on Windows. It was backported fix from fluent-package v5 as
it is critical in some case. Even though this was a exceptional maintenance release, but there is no change to the fact that we already stopped maintaining td-agent v4.

We strongly recommend migrating from td-agent v4 to fluent-package v5 (LTS).
See [Upgrade to fluent-package v5](/blog/upgrade-td-agent-v4-to-v5)

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
