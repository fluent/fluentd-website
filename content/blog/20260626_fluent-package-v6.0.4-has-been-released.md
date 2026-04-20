# fluent-package v6.0.4 has been released

Hi users!

We have released fluent-package [v6.0.4](https://github.com/fluent/fluent-package-builder/releases/tag/v6.0.4) on 2026-06-26.
Fluent Package is a stable distribution package of Fluentd. (successor of td-agent)

This is a maintenance release of v6.0.x LTS series.

<div markdown="span" class="alert alert-danger" role="alert">
This release fixes some vulnerabilities which were resolved in Fluentd v1.19.3.
As fluentd will be deployed to internal/trusted networks usually, so they will not affect you,
but we recommend to upgrade to v6.0.4.
</div>

## Fluent Package v6.0.4

Fluent Package v6.0.4 includes the following improvements:

* Updated bundled Fluentd to v1.19.3 which fixes some vulnerabilities.

This article explains the changes in Fluent Package v6.0.4.

## Changes

### Updated bundled Fluentd to v1.19.3 which fixes some vulnerabilities.

In this release, some critical vulnerabilities were fixed.

* [Remote Code Execution (RCE) via Arbitrary File Write in `${tag}` Placeholder](https://github.com/fluent/fluentd/security/advisories/GHSA-44hj-4m45-frj3)
  * CVE-2026-44024
  * CVSS v3 score: 9.8/10 (Critical)
  * Workarounds: Restrict network access, run as non-root user, use `shared_key` for authentication, filter incoming untrusted tags.
* [Exposure of Sensitive Information via Monitor Agent API](https://github.com/fluent/fluentd/security/advisories/GHSA-pr7j-96cj-549h)
  * CVE-2026-44025
  * CVSS v3 score: 7.5/10 (High)
  * Workarounds: Restrict network access for `in_monitor_agent`, allow connection from only localhost.
* [Denial of Service (DoS) via Gzip Decompression Bomb in `in_http` and `in_forward`](https://github.com/fluent/fluentd/security/advisories/GHSA-j9cw-hwqf-85w7)
  * CVE-2026-44160
  * CVSS v3 score: 7.5/10 (High)
  * Workarounds: Restrict network access for `in_forward` or `in_http`, use `shared_key` for authentication which allow trusted incoming source.
* [Server-Side Request Forgery (SSRF) via out_http Placeholder Expansion](https://github.com/fluent/fluentd/security/advisories/GHSA-72f5-rr8c-r6gr)
  * CVE-2026-44161
  * CVSS v3 score: 7.2/10 (High)
  * Workarounds: Avoid usage of dynamic hostname in placeholder, restrict network access from untrusted network, use only allowed hosts.
* [Denial of Service (DoS) via Large Payloads and Decompression Bombs in `in_opentelemetry`](https://github.com/fluent-plugins-nursery/fluent-plugin-opentelemetry/security/advisories/GHSA-2jc5-xhx8-qj6h)
  * CVE-2026-44162
  * CVSS v3 score: 5.3/10 (Moderate)
  * Workarounds: Restrict network access for `in_opentelemetry`, use a robust reverse proxy in front of Fluentd to mitigate GZIP decompression bomb.
* [Denial of Service (DoS) via Decompression Bomb in `in_s3`](https://github.com/fluent/fluent-plugin-s3/security/advisories/GHSA-xv9w-7v6q-hpjh)
  * CVE-2026-44163
  * CVSS v3 score: 2.7/10 (Low)
  * Workarounds: Ensure that write (PUT) access to the S3 bucket monitored by `in_s3` is strictly limited to trusted services and administrators.

The above vulnerabilities affects to older than v1.19.3, thus the following packages also will be affected.

* fluent-package LTS v6.0.3 or earlier
* fluent-package Standard edition v6.0.0 (NOTE: no patched version planned yet, please consider to use LTS)
* fluent-package LTS v5.0.9 or earlier (NOTE: v5.0.x already reached EOL, no patched updates anymore)
* fluent-package Standard edition v5.2.0 or earlier (NOTE: v5.x already reached EOL, no patched updates anymore)
* All of td-agent (NOTE: td-agent already reached EOL, no patched updates anymore)

We recommend upgrading fluent-package to v6.0.4.

If you can't upgrade it immediately, there is a case that mitigation method is explained in above advisory.
Please check each advisory and take care of it.

## Download

Please visit [the download page](/download/fluent_package).

## Announcement

### About next LTS schedule

We plan to release the next LTS version of fluent-package v6.0.5 at Sep 2026.
The content of updates are still TBD.

### Follow us on X

We have been posting information about Fluentd in Japanese on [@fluentd_jp](https://x.com/fluentd_jp).
We would appreciate it if you followed the X account.

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
