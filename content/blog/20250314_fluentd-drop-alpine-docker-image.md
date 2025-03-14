# Drop Alpine and switch default to Debian for Fluentd docker image

Hi users!

We have planned to change what docker image provides.

Currently, we ship Fluentd docker image for Alpine and Debian (armhf, arm64, amd64).
But, Alpine image in Fluentd was already marked as deprecated, so we will make things forward.

In the near future, we will drop Alpine image.
This decision affects existing Alpine image users.

## Notice about existing Alpine image users

* `fluent/fluentd:edge` will be changed from Alpine to Debian image
  * This is a notable incompatible change!
* v1.19 (not released yet)
  * No more releases for Alpine images
  * Then short tag also changed to Debian images (e.g. v1.19.0-1.0, v1.19-1 should be Debian instead of Alpine)
* v1.18 Alpine image will not be supported after v1.19 is released (T.B.D.), so recommend to migrate it!
* v1.16 Alpine image will be supported until Dec 2025, so there is room to migrate gradually.

If you still want to use Alpine, keep v1.16 series or v1.18 series. (not recommended though)

## Why not provide Alpine anymore?

It was well known that Alpine has possibility of incompatibility and performance issues in contrast to Debian images.
It was a historical reason to provide Alpine images - "In the previous versions, we provided them",
so there is no positive reason to continue it.

## Provide shorter tags to follow internal version bump

Not only just dropping Alpine image, we will improve tagging rules:

* Add version-specific tag which will not be affected by internal version bump

In previous versions, there was no version-specific tag which would follow internal version bump.
For example, if you want to stick to Fluentd v1.18.0, you can select v1.18.0-1.0, but if internal version was bumped to v1.18.0-1.1 or something, need to update it.
There is `edge-debian` tag, but it does not stick to a specific Fluentd version because it will automatically update when the next major/minor version is released.

For such a purpose, shorter v1.19 or v1.19.x tag will be available in the future release.

Happy logging!

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
