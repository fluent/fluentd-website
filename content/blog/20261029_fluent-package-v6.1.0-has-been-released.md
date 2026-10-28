# fluent-package v6.1.0 has been released

Hi users!

We have released fluent-package [v6.1.0](https://github.com/fluent/fluent-package-builder/releases/tag/v6.1.0) on 2026-10-29.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a new release of the v6.1 series. Note that this is NOT an LTS version.
If you prefer stability, please use the LTS version (v6.0.x) instead.

## Fluent Package v6.1.0

Fluent Package v6.1.0 includes the following improvements:

* Updated bundled Fluentd to v1.20.1.
* Updated bundled Ruby to 3.4.12
* Updated most of bundled gems
* Changed to keep compatibility with older RHEL 9.x/10.x ([#1087](https://github.com/fluent/fluent-package-builder/pull/1087), [#1088](https://github.com/fluent/fluent-package-builder/pull/1088))
* msi: fix broken link to enterprise services ([#1078](https://github.com/fluent/fluent-package-builder/pull/1078))
* Drop LTO flags on RHEL 10.x and Ubuntu. Note that hardening flags are kept. ([#1101](https://github.com/fluent/fluent-package-builder/pull/1101))
* Added experimental support for Windows ARM64 ([#1132](https://github.com/fluent/fluent-package-builder/pull/1132))
* Stopped bundling `nokogiri` on Windows, including x86_64.

This article explains the changes in Fluent Package v6.1.0.

## Changes

### Updated bundled Fluentd to v1.20.1.

Unlike v1.19.x, which is bundled in the LTS version, Fluentd v1.20.1
includes not only many bug fixes but also includes new major features.

See the following [Fluentd v1.20.0 has been released](/blog/fluentd-v1.20.0-has-been-released.html) article in details.

If you want to use the latest features right away, we recommend this
version. If you prefer stability, please keep using the LTS version.

### Updated bundled Ruby to 3.4.12

Ruby 3.4.12 is a maintenance release. Compared to Ruby 3.4.5 which was bundled in the previous version (v6.0.0), it includes the following security fixes in bundled gems:

* `uri`: [CVE-2025-61594](https://www.ruby-lang.org/en/news/2025/10/07/uri-cve-2025-61594/) (fixed in Ruby 3.4.7)
* `rexml`: [CVE-2025-58767](https://www.ruby-lang.org/en/news/2025/09/18/dos-rexml-cve-2025-58767/) (fixed in Ruby 3.4.8)
* `zlib`: [CVE-2026-27820](https://www.ruby-lang.org/en/news/2026/03/05/buffer-overflow-zlib-cve-2026-27820/) (fixed in Ruby 3.4.9)
* `net-imap`: [CVE-2026-47240](https://github.com/advisories/GHSA-8p34-64r3-mwg8), [CVE-2026-47241](https://github.com/advisories/GHSA-c4fp-cxrr-mj66), [CVE-2026-47242](https://github.com/advisories/GHSA-46q3-7gv7-qmgg) (fixed in Ruby 3.4.10)
* `resolv`: [CVE-2026-80212 and CVE-2026-80213](https://www.ruby-lang.org/en/news/2026/08/27/multiple-vulnerabilities-in-resolv/) (fixed in Ruby 3.4.11)

For details, please see the [Ruby 3.4.7](https://www.ruby-lang.org/en/news/2025/10/07/ruby-3-4-7-released/), [Ruby 3.4.8](https://www.ruby-lang.org/en/news/2025/12/17/ruby-3-4-8-released/), [Ruby 3.4.9](https://www.ruby-lang.org/en/news/2026/03/11/ruby-3-4-9-released/), [Ruby 3.4.10](https://www.ruby-lang.org/en/news/2026/06/30/ruby-3-4-10-released/), [Ruby 3.4.11](https://www.ruby-lang.org/en/news/2026/09/23/ruby-3-4-11-released/) and [Ruby 3.4.12](https://www.ruby-lang.org/en/news/2026/10/23/ruby-3-4-12-released/) release notes.

### Added experimental support for Windows ARM64

We have started providing an experimental Windows ARM64 installer in preparation for the upcoming v7 release.

### Stopped bundling nokogiri on Windows

Windows packages no longer bundle `nokogiri`. This change also applies to x86_64 packages.

When `nokogiri` is not installed, the `winevt_xml` parser uses `REXML`, and `in_windows_eventlog2` performs less strict bookmark validation.

To retain the previous behavior or use `parser nokogiri`, install `nokogiri` with `fluent-gem install nokogiri`.

### msi: fixed a broken link to enterprise services on popup window

The link to the enterprise services page on the popup window of the Windows installer was broken.
It has been fixed in this release. ([#1079](https://github.com/fluent/fluent-package-builder/pull/1079))

### rpm: keep compatibility with older RHEL 9.x and 10.x

Recent build environments introduced dependencies on library symbols unavailable in older RHEL minor releases.

We now build the RHEL 9 and 10 packages using AlmaLinux 9.2 and 10.0 environments, respectively,
with key build dependencies pinned to preserve ABI compatibility. ([#1087](https://github.com/fluent/fluent-package-builder/pull/1087), [#1088](https://github.com/fluent/fluent-package-builder/pull/1088))

This issue was fixed and shipped as 6.0.4-2 on above platforms which had been implemented in advance, has now been officially released.

### rpm deb: disable LTO for RHEL 10 and Ubuntu

RPM 4.19 (AlmaLinux 10) and `dpkg-buildflags` on Ubuntu export LTO (Link Time Optimization) flags
(`-flto=auto -ffat-lto-objects`) into the build process. These flags leaked into jemalloc, Ruby and
native gem extensions, and made the build much slower. For example, the total build time on AlmaLinux 10
grew extraordinaly.

Since the bundled Ruby uses its own optimization settings, LTO gives no measurable benefit here.
So we removed the LTO flags and the annobin plugin from the build environment.
The hardening flags such as stack protection, control flow protection and `FORTIFY_SOURCE` are kept as before.

This change also means that native extensions which users build with `fluent-gem install` no longer
inherit the LTO overhead. ([#1102](https://github.com/fluent/fluent-package-builder/pull/1102))

## Download

Please visit [the download page](/download/fluent_package).

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
