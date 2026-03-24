# fluent-package v6.0.3 has been released

Hi users!

We have released fluent-package [v6.0.3](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.3) on 2026-03-27.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of v6.0.x LTS series.

## Fluent Package v6.0.3

Fluent Package v6.0.3 includes the following improvements:

* Fixed a severe memory leak issue in the bundled `cool.io` v1.9.3 under specific conditions
* Updated bundled Ruby to 3.4.9
* Updated bundled Nokogiri to v1.19.2 (Windows only) for vulnerability fix

This article explains the changes in Fluent Package v6.0.3.

## Changes

### Fixed a severe memory leak issue in the bundled cool.io v1.9.3

In fluent-package v6.0.2, a critical issue was discovered where memory usage continuously increases over time.
This release completely resolves this problem.

* Affected Environments
  * This issue occurs in environments where TCP connections are frequently connected and disconnected.
  * It is easily reproducible when using the `out_forward` plugin with the `keepalive false` setting (which is the default value).
* Root cause
  * The asynchronous I/O library `cool.io` (v1.9.2 and v1.9.3) bundled in fluent-package v6.0.2 had a bug in its detachment process.
  * When a TCP connection was detached, the internal watcher objects were not properly garbage collected, leaving "garbage" data accumulated in the memory.
* Resolution
  * We have released `cool.io` v1.9.4 which fixes this bug, and it is now bundled by default in fluent-package v6.0.3. 

If operated for a long period, this memory leak will exhaust system memory resources, eventually causing the Fluentd process to be terminated unexpectedly by the OOM (Out of Memory) Killer. We strongly recommend users who are using `out_forward` on v6.0.2 to update to this version immediately.

**Note:** Users on fluent-package v6.0.1 or earlier are not affected by this specific issue.

### Updated bundled Ruby to 3.4.9

Ruby 3.4.9 includes multiple bug and security fixes. Specifically, it addresses the following vulnerability:

* [CVE-2026-27820](https://www.ruby-lang.org/en/news/2026/03/05/buffer-overflow-zlib-cve-2026-27820/)

For details, please see the [Ruby 3.4.9 release notes](https://github.com/ruby/ruby/releases/tag/v3_4_9).

### Updated bundled Nokogiri (Windows only) for vulnerability fix

We have updated the bundled [Nokogiri](https://nokogiri.org/index.html) from v1.18.10 to v1.19.2 for the Windows version to address the following vulnerability:

* [Nokogiri does not check the return value from xmlC14NExecute](https://github.com/advisories/GHSA-wx95-c6cv-8532)

## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v6.0.4 at June 2026.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
