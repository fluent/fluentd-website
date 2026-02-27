# fluent-package v6.0.2 has been released

Hi users!

We have released fluent-package [v6.0.2](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.2) on 2026-02-27.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of v6.0.x LTS series.

## Fluent Package v6.0.2

Fluent Package v6.0.2 includes the following improvements:

* Updated bundled Ruby to 3.4.8
* Updated bundled Fluentd from v1.19.1 to v1.19.2
  * [Fluentd v1.19.2 has been released](/blog/fluentd-v1.19.2-has-been-released)
* rpm: fixed update error if working directory was removed
* Fixed CVEs about bundled gems: [CVE-2025-14762](https://github.com/advisories/GHSA-2xgq-q749-89fq), [CVE-2026-25765](https://github.com/lostisland/faraday/security/advisories/GHSA-33mh-2634-fwr2)
  * When using with fluentd, usually it will not be affected by these vulnerability, but
    bundled fixed versions with keeping compatibility.
* msi: fixed installation rollback issue when executing maintenance script

This article explains the changes in Fluent Package v6.0.2.

## Changes

### Updated bundled Ruby to 3.4.8

Ruby 3.4.8 includes multiple bug and security fixes.
For details, please see the [Ruby 3.4.8 release notes](https://github.com/ruby/ruby/releases/tag/v3_4_8).

### Updated bundled Fluentd from v1.19.1 to v1.19.2

Fluentd v1.19.2 includes the following fixes:

* Fixed duplicate configuration file loading in `config_include_dir`
* in_tail: fixed error when files without read permission are included in glob patterns
* out_forward: added timeout to prevent infinite loop under unstable network connection
* gem: use latest net-http to solve IPv6 addr error
* warn when backed-up conf file will be included

For details, please see the [Fluentd v1.19.2 has been released](/blog/fluentd-v1.19.2-has-been-released).

### rpm: fixed update error if working directory was removed

In this release, it was fixed update error if temporary working directory was removed.

In the previous versions, if temporary working directory was removed by tmpfiles.d, 
there was a case that updating to v6 (up to v6.0.1) causes fatal error while rpm processes
transaction.

Now, with changing temporary working directory handling, it was fixed in v6.0.2.

### msi: fixed installation rollback issue when executing maintenance script

Since v6.0.0, installation maintenance script (powershell) was partially introduced for Windows.
But in some environments, there is a case that the execution of powershell was prohibited in your policy.
In such a case, installation process will be failed unexpectedly.

In this release, added fallback not to terminate installation process accidentally.

## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v6.0.3 at June 2026.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
