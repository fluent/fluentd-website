# fluent-package v5.0.9 has been released

Hi users!

We have released fluent-package [v5.0.9](https://github.com/fluent/fluent-package-builder/releases/tag/v5.0.9) on December 19, 2025.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent v4)

This is a maintenance release of v5.0.x LTS series.

<div markdown="span" class="alert alert-danger" role="alert">
<b>End of Life:</b>
<p>
Fluent Package v5 LTS series is scheduled to be supported until the end of 2025.
This release (v5.0.9) is planned to be the final version of the v5 LTS series.
</p>

<p>
Please refer to <a href="https://www.fluentd.org/blog/fluent-package-v6-scheduled-lifecycle">Scheduled support lifecycle announcement about Fluent Package v6</a>.
</p>
</div>

## Fluent Package v5.0.9

* Updated bundled Fluentd to v1.16.11
  * [Fluentd v1.16.11 has been released](/blog/fluentd-v1.16.11-has-been-released)

This article explains the changes in Fluent Package v5.0.9.

## Changes

### Updated bundled Fluentd from v1.16.10 to v1.16.11

Fluentd v1.16.11 includes the following fixes:

* out_forward: fix issue where could cause output to stop when using `<security>` and TLS setting together under unstable network environments
  * In an unstable network environment, if communication is lost during the forward plugin's connection process after TLS is established, the out_forward connection process could fall into an infinite loop, causing log output to stop.
  * We applied the existing [hard_timeout](https://docs.fluentd.org/output/forward#hard_timeout) parameter setting to this connection process to enable interruption and recovery via timeout.

## Download

Please see [the download page](/download/fluent_package).

## Announcement

### The final release of v5 LTS series

This release (v5.0.9) is planned to be the final version of the v5 LTS series.
We strongly recommend upgrading to [Fluent Package v6 LTS](/blog/fluent-package-v6.0.0-has-been-released) series for next long term support.

Please refer to [Scheduled support lifecycle announcement about Fluent Package v6](/blog/fluent-package-v6-scheduled-lifecycle).

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
