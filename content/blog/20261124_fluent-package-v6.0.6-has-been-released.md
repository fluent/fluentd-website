# fluent-package v6.0.6 has been released

Hi users!

We have released fluent-package [v6.0.6](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.6) on 2026-11-24.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of v6.0.x LTS series.

<div markdown="span" class="alert alert-danger" role="alert">
Ruby 3.4.13 fixed seven vulnerabilities in the regular expression engine and in the case conversion of strings.
Some of them have public PoCs that prove remote code execution is possible.
We originally planned to release v6.0.6 in Dec 2026, but we decided to ship this package ahead of the schedule
to deliver the fixed Ruby as soon as possible. We recommend upgrading to v6.0.6.
</div>

## Fluent Package v6.0.6

Fluent Package v6.0.6 includes the following improvements:

* Updated bundled Ruby to 3.4.13 which fixes seven vulnerabilities in Regexp and String case conversion (the main reason of this release)
* Updated bundled gems (`msgpack`, `fluent-plugin-kafka`, `fluent-plugin-opensearch` and so on)
* deb rpm: Fixed logrotate failure when `fluentd.log` does not exist yet
* deb rpm: Stopped leaving `/specs.4.8.gz` behind when installing missing plugins
* linux: Do not guard allowed options given with an attached value
* rpm: Skipped auto restart when systemd is not running
* deb: Do not fail prerm when `/etc/default/fluentd` is removed

This article explains the changes in Fluent Package v6.0.6.

## Changes

### Updated bundled Ruby to 3.4.13

On 2026-11-18, Ruby published [seven security advisories for vulnerabilities in the regular expression engine and in the case conversion of strings](https://www.ruby-lang.org/en/news/2026/11/18/multiple-vulnerabilities-in-regexp-and-string/).
Seven memory-safety vulnerabilities were discovered in Ruby's regular expression engine and in the case conversion of strings,
and Ruby 3.4.13 fixes all of them. Because public PoCs prove that some of them can be used to trigger remote code execution,
we decided to release fluent-package v6.0.6 immediately, ahead of the original Dec 2026 schedule, instead of waiting for the next regular maintenance release.

The fixed vulnerabilities are the following ones. (CVE identifiers had not been assigned yet at the time of the Ruby advisory, so they are referred to by their GHSA identifiers.)

* [GHSA-34m4-m9fh-gqp5](https://github.com/ruby/ruby/security/advisories/GHSA-34m4-m9fh-gqp5): Heap buffer overflow in case conversion of strings
  * A one-byte heap-based buffer overflow. Changing the case of a crafted string may allow remote code execution. PoCs exist.
* [GHSA-7x2q-68qv-6p8x](https://github.com/ruby/ruby/security/advisories/GHSA-7x2q-68qv-6p8x): Double free in regular expression compilation
  * Compiling a crafted regular expression pattern may allow remote code execution. PoCs exist.
* [GHSA-87fm-7w84-j2px](https://github.com/ruby/ruby/security/advisories/GHSA-87fm-7w84-j2px): Integer overflow in case conversion of strings
  * The integer overflow causes a heap-based buffer overflow. Changing the case of a crafted string may allow remote code execution. PoCs exist.
* [GHSA-wpqw-5qxg-m68r](https://github.com/ruby/ruby/security/advisories/GHSA-wpqw-5qxg-m68r): Out-of-bounds read in case-insensitive regular expression matching
  * Matching against a crafted pattern may allow remote code execution. PoCs prove attacker-controlled memory corruption.
* [GHSA-3p8q-wmhx-vm2w](https://github.com/ruby/ruby/security/advisories/GHSA-3p8q-wmhx-vm2w): Heap buffer overflow in regular expression compilation
  * An integer overflow causes a heap-based buffer overflow when compiling a crafted pattern. PoCs exist.
* [GHSA-7whj-cfh7-xgm4](https://github.com/ruby/ruby/security/advisories/GHSA-7whj-cfh7-xgm4): Heap buffer overflow in `Regexp#to_s`
  * Converting a crafted regular expression to a string may allow information disclosure or remote code execution. PoCs exist.
* [GHSA-pvgc-g7gj-pv6h](https://github.com/ruby/ruby/security/advisories/GHSA-pvgc-g7gj-pv6h): Out-of-bounds read in case-insensitive backreference matching
  * Matching a crafted string may disclose memory contents or crash the process.

We believe these vulnerabilities do not affect fluentd in normal usage.
Fluentd compiles regular expressions only from its configuration file, which is controlled by administrators,
so the flaws triggered by crafted patterns are unlikely to be exploited.
However, whether they can be triggered depends on your configuration and on the plugins you have added.
For example, the flaws in the case conversion of strings can be triggered by crafted strings themselves, which may originate from log data,
and additional plugins may compile patterns or convert the case of strings that are influenced by incoming records.
As fluentd is usually deployed in internal/trusted networks the risk is lower,
but considering that RCE PoCs are public, we recommend upgrading promptly.

These vulnerabilities affect Ruby 3.4.12 and earlier, thus the following packages are also affected.

* fluent-package LTS v6.0.5 or earlier
* fluent-package Standard edition v6.1.0 (NOTE: it bundles the affected Ruby 3.4.12. If you need the fix right away, consider using the LTS version v6.0.6)
* fluent-package v5.x and td-agent (NOTE: they already reached EOL, no patched updates anymore)

For details, please see the [Ruby 3.4.13 release notes](https://github.com/ruby/ruby/releases/tag/v3_4_13).

### Updated bundled gems

The following bundled components were updated in addition to Ruby.

* msgpack 1.8.7
* fluent-plugin-kafka v0.19.9
* fluent-plugin-opensearch v1.1.8
* fluent-plugin-fluent-package-update-notifier 0.2.4
* OpenSSL 4.1.0 (Windows)
* nokogiri v1.19.7 (Windows)

Note that the bundled Fluentd is still v1.19.4, which is the latest fixed version of the v1.19.x series.

### deb rpm: do not fail logrotate when fluentd.log does not exist yet

`/etc/logrotate.d/fluentd` rotates `/var/log/fluent/fluentd.log`, but fluentd creates that file only when it runs.
If the package was installed and fluentd has never been started, logrotate failed with
`error: stat of /var/log/fluent/fluentd.log failed: No such file or directory`.
The configuration now includes `missingok`, so logrotate skips the missing file instead of failing.
Nothing changes when the log file exists. ([#1143](https://github.com/fluent/fluent-package-builder/pull/1143))

### deb rpm: do not leave /specs.4.8.gz behind when installing missing plugins

When fluent-package was upgraded with `FLUENT_PACKAGE_SERVICE_RESTART=auto`, the package scripts checked
that rubygems.org is reachable by downloading `https://rubygems.org/specs.4.8.gz` with `curl -O`.
Because dpkg and rpm run maintainer scripts with `/` as the working directory, every such upgrade
left an unowned ~6 MB `/specs.4.8.gz` file on the root filesystem.
The check now sends a HEAD request with the output discarded, so nothing is written to disk.
It also uses `--connect-timeout 10 --max-time 30` so that an upgrade does not hang when outbound packets are silently dropped.
Note that files left behind by earlier upgrades are not removed automatically. ([#1149](https://github.com/fluent/fluent-package-builder/pull/1149))

### linux: do not guard allowed options given with an attached value

On Linux, `/usr/sbin/fluentd` refuses to start while the `fluentd` service is active, unless one of
`-c`, `--config`, `--dry-run`, `-h`, `--help` or `--show-plugin-config` is given.
The guard compared each whole argument with these option names, so valid forms that OptionParser also accepts,
such as `--config=/path/to/fluentd.conf`, `-c/path/to/fluentd.conf` and `--show-plugin-config=input:dummy`,
were rejected with "Can't start duplicate Fluentd instance with the default config." even though fluentd itself accepts them.
The attached forms of the options that take a value are now accepted by the guard as well. ([#1153](https://github.com/fluent/fluent-package-builder/pull/1153))

### rpm: skip auto restart when systemd is not running

When fluent-package was upgraded or reinstalled on an RPM-based system where systemd is not running,
such as in a Docker container, `%preun` of the old package read an empty MainPID, treated it as an active service
and left an empty PID file behind. Then `%posttrans` of the new package ran `kill -USR2` with no PID and printed errors like
`integer expression expected` and `kill: usage`.
The auto restart markers are now skipped when systemd is not running, matching the deb package behavior,
and `kill -USR2` is guarded against an empty PID. Nothing changes when systemd is running. ([#1158](https://github.com/fluent/fluent-package-builder/pull/1158))

### deb: do not fail prerm when /etc/default/fluentd is removed

When the `fluentd` service was running, `prerm` of the old package read the restart mode with
`. "/etc/default/fluentd"`. Since `prerm` runs with `/bin/sh` (dash), sourcing a missing file is a fatal error.
So if `/etc/default/fluentd` had been removed, `prerm` failed before it recorded the plugin list and the MainPID,
and dpkg skipped the auto restart on every later upgrade because it does not restore a removed conffile.
The file is now sourced only when it exists, which is treated as `auto` as before. ([#1159](https://github.com/fluent/fluent-package-builder/pull/1159))

## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next maintenance release of fluent-package v6.0.x in early 2027.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
