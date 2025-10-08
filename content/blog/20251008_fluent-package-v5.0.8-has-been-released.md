# fluent-package v5.0.8 has been released

Hi users!

We have released fluent-package [v5.0.8](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.8) on October 8, 2025.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.
Bundled Fluentd was updated to 1.16.10.


## Fluent Package v5.0.8

* Updated bundled Ruby to 3.2.9
* Updated bundled Fluentd to v1.16.10
  * [Fluentd v1.16.10 has been released](fluentd-v1.16.10-has-been-released)
* Fixed an issue where Fluentd’s temporary directory could be deleted by tmpfiles.d
* Updated bundled Nokogiri (Windows only) and rexml to address vulnerabilities

This article explains the changes in Fluent Package v5.0.8.

## Changes

### Updated bundled Ruby to 3.2.9

Ruby 3.2.9 includes multiple security and bug fixes.
For details, please see the [Ruby 3.2.9 release notes](https://github.com/ruby/ruby/releases/tag/v3_2_9).

### Updated bundled Fluentd from v1.16.9 to v1.16.10

Fluentd v1.16.10 includes the following fixes:

* Server plugin helper: Fixed an issue where connections might not be properly closed when Fluentd shuts down.
  * When [flush\_at\_shutdown](https://docs.fluentd.org/configuration/buffer-section#flushing-parameters) is enabled, Fluentd should flush all buffered data before stopping, unless output fails. However, buffer files sometimes remained after shutdown. The remaining buffer files are loaded on the next startup.

### Fixed an issue where Fluentd’s temporary directory could be deleted by tmpfiles.d

On some Linux distributions, tmpfiles.d is configured as follows, and files or directories in `/tmp` that remain unused for more than 10 days are deleted:

```
q /tmp 1777 root root 10d
```

When using the `out_file` or `out_secondary_file` plugins, Fluentd uses temporary directory like `/tmp/fluentd-lock-{...}/`, depending on the config.
If there is no output with `out_file` or `out_secondary_file` for an extended period, the temporary directory could be deleted by tmpfiles.d.

If the temporary directory is deleted while Fluentd is running, the following error occurs continuously in `out_file` and `out_secondary_file` output:

```
2025-09-11 14:33:29 +0900 [warn]: #2 failed to flush the buffer. retry_times=0 next_retry_time=2025-09-11 14:33:30 +0900 chunk="63e7fdca888e679a6fcdefb0c120bf58" error_class=Errno::ENOENT error="No such file or directory @ rb_sysopen - /tmp/fluentd-lock-20250911-1545462-74fvkh/fluentd-foo.lock"
```

Normally, some output is written periodically, so this issue is rare.
If it occurs, you can restore normal operation by restarting Fluentd before reaching the retry limit.

In this release, we added a rule to `/usr/lib/tmpfiles.d/fluentd.conf` to exclude `/tmp/fluentd-lock-{...}/` from automatic deletion.

### Updated bundled Nokogiri (Windows only) and rexml to address vulnerabilities
The bundled [Nokogiri](https://nokogiri.org/index.html) (for Windows only) has been updated from v1.16.8 to v1.18.10 to address the following vulnerabilities:

* [CVE-2025-24928](https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-vvfq-8hwr-qm4m)
* [CVE-2024-56171](https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-vvfq-8hwr-qm4m)
* [CVE-2025-24855](https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-mrxw-mxhj-p664)
* [CVE-2024-55549](https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-mrxw-mxhj-p664)
* [CVE-2025-32414](https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-5w6v-399v-w3cc)
* [CVE-2025-32415](https://github.com/sparklemotion/nokogiri/security/advisories/GHSA-5w6v-399v-w3cc)
* [CVE-2025-6021](https://access.redhat.com/security/cve/cve-2025-6021)
* [CVE-2025-6170](https://access.redhat.com/security/cve/cve-2025-6170)
* [CVE-2025-49794](https://access.redhat.com/security/cve/cve-2025-49794)
* [CVE-2025-49795](https://access.redhat.com/security/cve/cve-2025-49795)
* [CVE-2025-49796](https://access.redhat.com/security/cve/cve-2025-49796)

The bundled [rexml](https://github.com/ruby/rexml) has been updated from v3.3.9 to v3.4.4 to address the following vulnerabilities:

* [CVE-2025-58767](https://github.com/ruby/rexml/security/advisories/GHSA-c2f4-jgmc-q2r5)

## Download

Please see [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v5.0.9 by the end of 2025.
The content of updates are still TBD.

We strongly recommend upgrading to [fluent-package v6 LTS](https://www.fluentd.org/blog/fluent-package-v6.0.0-has-been-released).

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
