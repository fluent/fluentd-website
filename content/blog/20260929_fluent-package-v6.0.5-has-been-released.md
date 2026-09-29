# fluent-package v6.0.5 has been released

Hi users!

We have released fluent-package [v6.0.5](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.5) on 2026-09-29.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of v6.0.x LTS series.

<div markdown="span" class="alert alert-danger" role="alert">
This release fixes some vulnerabilities which were resolved in Fluentd v1.19.4, and also in the bundled oj and json gems.
As fluentd will be deployed to internal/trusted networks usually, so they will not affect you,
but we recommend to upgrade to v6.0.5.
</div>

## Fluent Package v6.0.5

Fluent Package v6.0.5 includes the following improvements:

* Updated bundled Fluentd to v1.19.4 which fixes some vulnerabilities
* Updated bundled Ruby to 3.4.11
* Updated bundled gems which fix vulnerabilities and crashes (`oj`, `json`)
* msi: Fixed a broken link to enterprise services on the popup window of the Windows installer
* rpm: Kept compatibility with older RHEL 9.x and 10.x
* deb rpm: Reduced build time by disabling LTO on RHEL 10 and Ubuntu

This article explains the changes in Fluent Package v6.0.5.

## Changes

### Updated bundled Fluentd to v1.19.4 which fixes some vulnerabilities

In this release, some critical vulnerabilities were fixed.

* [Incomplete Fix for CVE-2026-44024: Path Traversal Bypass via Bare `..` Tag in Output Plugins](https://github.com/fluent/fluentd/security/advisories/GHSA-5hq3-r276-rfr5)
  * CVE ID pending (this page will be updated once assigned)
  * CVSS v3 score: 7.5/10 (High)
  * Workarounds: Restrict network access, allow connection within a closed, trusted network. Run fluentd as non-root user. Do not use the `${tag}` placeholder in the path parameter of output plugins. Filter incoming untrusted tags.
* [Out-of-Memory DoS via Object Allocation Amplification in `in_http` ndjson parsing](https://github.com/fluent/fluentd/security/advisories/GHSA-g69w-f42r-xp35)
  * CVE ID pending (this page will be updated once assigned)
  * CVSS v3 score: 7.5/10 (High)
  * Workarounds: Restrict network access for `in_http`, allow connection within a closed, trusted network. Implement reverse proxy limits with forcing strict rate limiting and request size limits at the proxy layer to drop anomalous requests before they reach the Fluentd worker.
* [Out-of-Memory DoS via Unbounded TCP/TLS Connection Buffer in `in_syslog`](https://github.com/fluent/fluentd/security/advisories/GHSA-h3xv-5jpx-r4j2)
  * CVE ID pending (this page will be updated once assigned)
  * CVSS v3 score: 7.5/10 (High)
  * Workarounds: Restrict network access for `in_syslog`, allow connection within a closed, trusted network. Switch to UDP Transport for a while. Implement reverse proxy limits with strict client connection timeout and buffer size limits to terminate anomalous, non-delimited streams before they overwhelm Fluentd.
* [Incomplete Fix for CVE-2026-44160: DoS via Unbounded Decompression in Buffer Chunk Streaming](https://github.com/fluent/fluentd/security/advisories/GHSA-x455-r5cg-h9p9)
  * CVE ID pending (this page will be updated once assigned)
  * CVSS v3 score: 2.9/10 (Low)
  * Workarounds: Disable buffer compression. Disable automatic chunk backup with `disable_chunk_backup true`. Restrict incoming data only within a closed, trusted network.

The above vulnerabilities affects to older than v1.19.4, thus the following packages also will be affected.

* fluent-package LTS v6.0.4 or earlier
* fluent-package Standard edition v6.0.0 (NOTE: no patched version planned yet, please consider to use LTS)
* fluent-package LTS v5.0.9 or earlier (NOTE: v5.0.x already reached EOL, no patched updates anymore)
* fluent-package Standard edition v5.2.0 or earlier (NOTE: v5.x already reached EOL, no patched updates anymore)
* All of td-agent (NOTE: td-agent already reached EOL, no patched updates anymore)

We recommend upgrading fluent-package to v6.0.5.

If you can't upgrade it immediately, there is a case that mitigation method is explained in above advisory.
Please check each advisory and take care of it.

Fluentd v1.19.4 also contains many bug fixes. See [the release announcement of Fluentd v1.19.4](/blog/fluentd-v1.19.4-has-been-released) for details.

### Updated bundled Ruby to 3.4.11

Ruby 3.4.11 is a maintenance release. Compared to Ruby 3.4.9 which was bundled in the previous version, it includes the following security fixes in bundled gems:

* `net-imap`: [CVE-2026-47240](https://github.com/advisories/GHSA-8p34-64r3-mwg8), [CVE-2026-47241](https://github.com/advisories/GHSA-c4fp-cxrr-mj66), [CVE-2026-47242](https://github.com/advisories/GHSA-46q3-7gv7-qmgg) (fixed in Ruby 3.4.10)
* `resolv`: [CVE-2026-80212 and CVE-2026-80213](https://www.ruby-lang.org/en/news/2026/08/27/multiple-vulnerabilities-in-resolv/) (fixed in Ruby 3.4.11)

For details, please see the [Ruby 3.4.10](https://www.ruby-lang.org/en/news/2026/06/30/ruby-3-4-10-released/) and [Ruby 3.4.11](https://www.ruby-lang.org/en/news/2026/09/23/ruby-3-4-11-released/) release notes.

### msi: fixed a broken link to enterprise services on popup window

The link to the enterprise services page on the popup window of the Windows installer was broken.
It has been fixed in this release. ([#1079](https://github.com/fluent/fluent-package-builder/pull/1079))

### rpm: keep compatibility with older RHEL 9.x and 10.x

The packages for RHEL 9.x and 10.x were built on the latest minor version of each series.
As a result, the built binaries required newer symbols such as `GLIBC_2.35` or `OPENSSL_3.4.0`,
and they did not work on older minor versions like RHEL 9.6 or RHEL 10.1.

To keep the ABI compatible in the whole 9.x and 10.x series, the build environment is now pinned to
RHEL 9.2 and RHEL 10.0. ([#1089](https://github.com/fluent/fluent-package-builder/pull/1089), [#1090](https://github.com/fluent/fluent-package-builder/pull/1090))

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

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v6.0.6 at Dec 2026.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
