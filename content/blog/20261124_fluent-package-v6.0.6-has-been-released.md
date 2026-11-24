# fluent-package v6.0.6 has been released

Hi users!

We have released fluent-package [v6.0.6](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.6) on 2026-11-24.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of v6.0.x LTS series.

<div markdown="span" class="alert alert-danger" role="alert">
This release updates the bundled Ruby to 3.4.13, which fixes seven vulnerabilities in the regular expression engine and in the case conversion of strings.
The Ruby project reports that some of them can be used to trigger remote code execution.
We released v6.0.6 ahead of the original schedule for this reason, and we strongly recommend upgrading to v6.0.6.
</div>

## Fluent Package v6.0.6

Fluent Package v6.0.6 includes the following improvements:

* Updated bundled Ruby to 3.4.13 which fixes multiple vulnerabilities
* Updated bundled gems
* deb rpm: Fixed logrotate failure when `fluentd.log` does not exist yet ([#1143](https://github.com/fluent/fluent-package-builder/pull/1143))
* deb rpm: Stopped leaving `/specs.4.8.gz` behind when installing missing plugins ([#1149](https://github.com/fluent/fluent-package-builder/pull/1149))
* linux: Accepted allowed options given with an attached value such as `--config=PATH` ([#1153](https://github.com/fluent/fluent-package-builder/pull/1153))
* rpm: Skipped auto restart when systemd is not running ([#1158](https://github.com/fluent/fluent-package-builder/pull/1158))
* deb: Fixed `prerm` failure when `/etc/default/fluentd` has been removed ([#1159](https://github.com/fluent/fluent-package-builder/pull/1159))

This article explains the changes in Fluent Package v6.0.6.

## Changes

### Updated bundled Ruby to 3.4.13 which fixes multiple vulnerabilities

The bundled Ruby has been updated from 3.4.11 to 3.4.13.
Ruby 3.4.13 fixes seven vulnerabilities in the regular expression engine and in the case conversion of strings.
The Ruby project is aware of PoCs which prove that some of them can be used to trigger remote code execution.

* [Heap buffer overflow in case conversion of strings](https://github.com/ruby/ruby/security/advisories/GHSA-34m4-m9fh-gqp5)
* [Double free in regular expression compilation](https://github.com/ruby/ruby/security/advisories/GHSA-7x2q-68qv-6p8x)
* [Integer overflow in case conversion of strings](https://github.com/ruby/ruby/security/advisories/GHSA-87fm-7w84-j2px)
* [Out-of-bounds read in case-insensitive regular expression matching](https://github.com/ruby/ruby/security/advisories/GHSA-wpqw-5qxg-m68r)
* [Heap buffer overflow in regular expression compilation](https://github.com/ruby/ruby/security/advisories/GHSA-3p8q-wmhx-vm2w)
* [Heap buffer overflow in `Regexp#to_s`](https://github.com/ruby/ruby/security/advisories/GHSA-7whj-cfh7-xgm4)
* [Out-of-bounds read in case-insensitive backreference matching](https://github.com/ruby/ruby/security/advisories/GHSA-pvgc-g7gj-pv6h)

CVE IDs are still pending for all of them, so the Ruby advisory refers to them by their GitHub Security Advisory (GHSA) identifiers.
See [the advisory of the Ruby project](https://www.ruby-lang.org/en/news/2026/11/18/multiple-vulnerabilities-in-regexp-and-string/) for details.

These flaws are triggered by compiling a crafted regular expression pattern, or by matching or changing the case of a crafted string.
Fluentd and its plugins use regular expressions and case conversion in many places, for example in parser plugins and in `fluent-plugin-rewrite-tag-filter`.
The patterns usually come from your configuration, but the strings they are applied to come from the log data which fluentd collects.
So even a fluentd which runs in an internal network may handle untrusted data, and we strongly recommend upgrading to v6.0.6.

The affected Ruby versions are 3.3.13 and earlier, 3.4.0 through 3.4.12, and 4.0.0 through 4.0.9.
Thus the following packages also will be affected.

* fluent-package LTS v6.0.5 or earlier
* fluent-package Standard edition v6.1.0 or earlier
* fluent-package LTS v5.0.9 or earlier (NOTE: v5.0.x already reached EOL, no patched updates anymore)
* fluent-package Standard edition v5.2.0 or earlier (NOTE: v5.x already reached EOL, no patched updates anymore)
* All of td-agent (NOTE: td-agent already reached EOL, no patched updates anymore)

For details of the Ruby release, please see the [Ruby 3.4.13](https://www.ruby-lang.org/en/news/2026/11/18/ruby-3-4-13-released/) release notes.

On Windows, the bundled OpenSSL has also been updated from 3.6.3 to 4.1.0, because the package uses RubyInstaller 3.4.13-1 which bundles it.

### Updated bundled gems

The updated gems include the following:

* `msgpack` v1.8.7
* `fluent-plugin-kafka` v0.19.9
* `fluent-plugin-opensearch` v1.1.8
* `fluent-plugin-fluent-package-update-notifier` v0.2.4
* `nokogiri` v1.19.7 (Windows)

The bundled Fluentd is still v1.19.4, the same version as v6.0.5.

### deb rpm: fixed logrotate failure when fluentd.log does not exist yet

`/etc/logrotate.d/fluentd` rotates `/var/log/fluent/fluentd.log`, but fluentd creates that file only when it runs.
If the package had been installed and fluentd had never been started, logrotate failed with `error: stat of /var/log/fluent/fluentd.log failed`.

The `missingok` directive has been added, so logrotate skips the missing file instead of failing.
Nothing changes when the log file exists. ([#1143](https://github.com/fluent/fluent-package-builder/pull/1143))

### deb rpm: no longer leave /specs.4.8.gz behind

When fluent-package was upgraded with `FLUENT_PACKAGE_SERVICE_RESTART=auto` and some plugins were missing, the maintainer scripts checked that rubygems.org is reachable before reinstalling them.
The check downloaded the whole RubyGems specs index with `curl -O`, and maintainer scripts run with `/` as the working directory, so such an upgrade left a file of about 6 MB at `/specs.4.8.gz`.
No package owned it, and nothing removed it.

The check now sends a HEAD request and discards the output, so nothing is written to disk.
The check also uses `--connect-timeout` and `--max-time`, so it no longer hangs for minutes when outbound packets are silently dropped. ([#1149](https://github.com/fluent/fluent-package-builder/pull/1149))

### linux: accept allowed options given with an attached value

On Linux, `/usr/sbin/fluentd` refuses to start while the `fluentd` service is active, unless one of `-c`, `--config`, `--dry-run`, `-h`, `--help` or `--show-plugin-config` is given.
The check compared each whole argument with these option names, so the forms which carry an attached value were rejected with "Can't start duplicate Fluentd instance with the default config.", even though fluentd itself accepts them.

* `--config=/path/to/fluentd.conf`
* `-c/path/to/fluentd.conf`
* `--show-plugin-config=input:dummy`

These forms are now accepted. The list of allowed options does not change. ([#1153](https://github.com/fluent/fluent-package-builder/pull/1153))

### rpm: skip auto restart when systemd is not running

When fluent-package was upgraded or reinstalled on an RPM based system where systemd is not running, such as in a container, the scriptlet of the old package could not read the MainPID.
It then failed with `integer expression expected`, left an empty PID behind, and the new package ran `kill -USR2` with no PID.

The scriptlets now return early when systemd is not running, as the deb package already did, and they check that the PID is not empty before sending `USR2`.
Nothing changes when systemd is running. ([#1158](https://github.com/fluent/fluent-package-builder/pull/1158))

### deb: do not fail prerm when /etc/default/fluentd has been removed

`prerm` of the old package reads the restart mode from `/etc/default/fluentd`.
That file is optional for the service, and dpkg does not restore a removed conffile on upgrade.
So if it had been removed while the `fluentd` service was running, `prerm` exited before it recorded the plugin list and the MainPID, and every later upgrade went on without auto restart.

The file is now read only when it exists. ([#1159](https://github.com/fluent/fluent-package-builder/pull/1159))

Note that this fix takes effect from the next upgrade, because the first upgrade to v6.0.6 still runs `prerm` of the installed version.

## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v6.0.7 at the end of Dec 2026.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
