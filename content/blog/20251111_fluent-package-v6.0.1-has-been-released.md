# fluent-package v6.0.1 has been released

Hi users!

We have released fluent-package [v6.0.1](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.1) on 2025-11-11.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v6.0.x LTS series.

## Fluent Package v6.0.1

Fluent Package v6.0.1 includes the following improvements:

* Updated bundled Ruby to 3.4.7
* Updated bundled Fluentd from v1.19.0 to v1.19.1
  * [Fluentd v1.19.1 has been released](fluentd-v1.19.1-has-been-released)
* Fixed an issue where Fluentd’s temporary directory could be deleted by tmpfiles.d
* Fixed Windows installer error for custom install path containing spaces

This article explains the changes in Fluent Package v6.0.1.

## Changes

### Updated bundled Ruby to 3.4.7

Ruby 3.4.7 includes multiple bug and security fixes.
For details, please see the [Ruby 3.4.7 release notes](https://github.com/ruby/ruby/releases/tag/v3_4_7).

### Updated bundled Fluentd from v1.19.0 to v1.19.1

Fluentd v1.19.1 includes the following fixes:

* YAML configuration: Added Support for Array Notation

Previously, when specifying multiple values, you had to use a comma-separated list such as: `retryable_response_codes: 503, 504`.

With this update, you can now use more YAML-style array notations:

```yml
retryable_response_codes: [503, 504]
```

or

```yml
retryable_response_codes:
  - 503
  - 504
```

Note: The special element [$arg](https://docs.fluentd.org/configuration/config-file-yaml#special-yaml-elements) has supported array notation from earlier versions.

Note: There is still a known YAML syntax issue where specifying a single int value for an Array option causes a config error. For details, please refer to [#5149](https://github.com/fluent/fluentd/issues/5149).

### Fixed an issue where Fluentd’s temporary directory could be deleted by tmpfiles.d

This issue, which was previously fixed in [Fluent Package v5.0.8](fluent-package-v5.0.8-has-been-released), has now been included in Fluent Package v6.0.1.

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

### Fixed Windows installer error for custom install path containing spaces
This fixes an issue in the Windows installer of Fluent Package v6.0.0.

When installing Fluent Package to a path containing spaces (e.g., `C:\Program Files\fluentd`), an error could occur during installation.
This issue has been fixed in v6.0.1.


## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v6.0.2 at February 2026.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
