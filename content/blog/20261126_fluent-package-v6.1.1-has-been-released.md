# fluent-package v6.1.1 has been released

Hi users!

We have released fluent-package [v6.1.1](https://github.com/fluent/fluent-package-builder/releases/tag/v6.1.1) on 2026-11-26.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of the v6.1 series. Note that this is NOT an LTS version.
If you prefer stability, please use the LTS version (v6.0.x) instead.

<div markdown="span" class="alert alert-danger" role="alert">
Ruby 3.4.13 fixed seven vulnerabilities in the regular expression engine and in the case conversion of strings.
Some of them have public PoCs that prove remote code execution is possible.
fluent-package v6.1.0 bundles the affected Ruby 3.4.12, so we recommend upgrading to v6.1.1.
</div>

## Fluent Package v6.1.1

Fluent Package v6.1.1 includes the following improvements:

* Updated bundled Ruby to 3.4.13 which fixes seven vulnerabilities in Regexp and String case conversion
* Updated bundled gems (`msgpack`, `oj`, `aws-sdk-*`, `fluent-plugin-kafka` and so on)
* Updated `httpclient` and `td-client` for eMudhra CA distrust ([#1146](https://github.com/fluent/fluent-package-builder/pull/1146))
* deb rpm: Fixed logrotate failure when `fluentd.log` does not exist yet ([#1140](https://github.com/fluent/fluent-package-builder/pull/1140))
* deb rpm: Stopped leaving `/specs.4.8.gz` behind when installing missing plugins ([#1148](https://github.com/fluent/fluent-package-builder/pull/1148))
* linux: Do not guard allowed options given with an attached value ([#1152](https://github.com/fluent/fluent-package-builder/pull/1152))
* rpm: Skipped auto restart when systemd is not running ([#1155](https://github.com/fluent/fluent-package-builder/pull/1155))
* deb: Do not fail prerm when `/etc/default/fluentd` is removed ([#1157](https://github.com/fluent/fluent-package-builder/pull/1157))

This article explains the changes in Fluent Package v6.1.1.

## Changes

### Updated bundled Ruby to 3.4.13

On 2026-11-18, Ruby published [seven security advisories for vulnerabilities in the regular expression engine and in the case conversion of strings](https://www.ruby-lang.org/en/news/2026/11/18/multiple-vulnerabilities-in-regexp-and-string/).
Ruby 3.4.13 fixes all of them.

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

The LTS version v6.0.6, which was released on 2026-11-24, also bundles Ruby 3.4.13.
See [fluent-package v6.0.6 has been released](/blog/fluent-package-v6.0.6-has-been-released) for details.

For details, please see the [Ruby 3.4.13 release notes](https://github.com/ruby/ruby/releases/tag/v3_4_13).

### Updated bundled gems

The following bundled gems were updated.

* msgpack 1.8.7
* oj 3.17.8
* aws-partitions v1.1311.0
* aws-sdk-core v3.272.0
* aws-sdk-kms v1.145.0
* aws-sdk-s3 v1.245.2
* aws-sdk-sqs v1.131.0
* fluent-plugin-kafka v0.19.9
* httpclient v2.10.0
* td-client v3.1.0

Note that the bundled Fluentd is still v1.20.1.

### Updated httpclient and td-client for eMudhra CA distrust

`httpclient` 2.9.0 and earlier used its own bundled CA file (`cacert.pem`) by default, not the CA store of the OS.
That old bundle still trusted a root CA which cross-signs the compromised eMudhra intermediate CAs,
and updating the CA store of the OS had no effect on it.

`httpclient` 2.10.0 rejects the public keys of the compromised eMudhra intermediate CAs and ships an updated CA bundle.
`td-client` 3.1.0 requires `httpclient` 2.10.0 or later, and it no longer bundles its own CA certificates.
Instead, it uses the default CA selection of `httpclient`. ([#1146](https://github.com/fluent/fluent-package-builder/pull/1146))

Because of this change, the default set of trusted CAs may be different from the previous version.
If you use a custom endpoint or a TLS inspection proxy with `td-client` (e.g. via `fluent-plugin-td`), please check your CA configuration.

### deb rpm: do not fail logrotate when fluentd.log does not exist yet

`/etc/logrotate.d/fluentd` rotates `/var/log/fluent/fluentd.log`, but fluentd creates that file only when it runs.
If the package was installed and fluentd has never been started, logrotate failed with
`error: stat of /var/log/fluent/fluentd.log failed: No such file or directory`.
The configuration now includes `missingok`, so logrotate skips the missing file instead of failing.
Nothing changes when the log file exists. ([#1140](https://github.com/fluent/fluent-package-builder/pull/1140))

### deb rpm: do not leave /specs.4.8.gz behind when installing missing plugins

When fluent-package was upgraded with `FLUENT_PACKAGE_SERVICE_RESTART=auto`, the package scripts checked
that rubygems.org is reachable by downloading `https://rubygems.org/specs.4.8.gz` with `curl -O`.
Because dpkg and rpm run maintainer scripts with `/` as the working directory, every such upgrade
left an unowned ~6 MB `/specs.4.8.gz` file on the root filesystem.
The check now sends a HEAD request with the output discarded, so nothing is written to disk.
It also uses `--connect-timeout 10 --max-time 30` so that an upgrade does not hang when outbound packets are silently dropped.
Note that files left behind by earlier upgrades are not removed automatically. ([#1148](https://github.com/fluent/fluent-package-builder/pull/1148))

### linux: do not guard allowed options given with an attached value

On Linux, `/usr/sbin/fluentd` refuses to start while the `fluentd` service is active, unless one of
`-c`, `--config`, `--dry-run`, `-h`, `--help` or `--show-plugin-config` is given.
The guard compared each whole argument with these option names, so valid forms that OptionParser also accepts,
such as `--config=/path/to/fluentd.conf`, `-c/path/to/fluentd.conf` and `--show-plugin-config=input:dummy`,
were rejected with "Can't start duplicate Fluentd instance with the default config." even though fluentd itself accepts them.
The attached forms of the options that take a value are now accepted by the guard as well. ([#1152](https://github.com/fluent/fluent-package-builder/pull/1152))

### rpm: skip auto restart when systemd is not running

When fluent-package was upgraded or reinstalled on an RPM-based system where systemd is not running,
such as in a Docker container, `%preun` of the old package read an empty MainPID, treated it as an active service
and left an empty PID file behind. Then `%posttrans` of the new package ran `kill -USR2` with no PID and printed errors like
`integer expression expected` and `kill: usage`.
The auto restart markers are now skipped when systemd is not running, matching the deb package behavior,
and `kill -USR2` is guarded against an empty PID. Nothing changes when systemd is running. ([#1155](https://github.com/fluent/fluent-package-builder/pull/1155))

### deb: do not fail prerm when /etc/default/fluentd is removed

When the `fluentd` service was running, `prerm` of the old package read the restart mode with
`. "/etc/default/fluentd"`. Since `prerm` runs with `/bin/sh` (dash), sourcing a missing file is a fatal error.
So if `/etc/default/fluentd` had been removed, `prerm` failed before it recorded the plugin list and the MainPID,
and dpkg skipped the auto restart on every later upgrade because it does not restore a removed conffile.
The file is now sourced only when it exists, which is treated as `auto` as before. ([#1157](https://github.com/fluent/fluent-package-builder/pull/1157))

## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
