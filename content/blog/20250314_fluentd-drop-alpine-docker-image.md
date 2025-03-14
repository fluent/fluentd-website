# Drop alpine and switch default to debian for Fluentd docker image

Hi users!

We have planned to change what docker image provides.

Currently, we ships Fluentd docker image for alpine and debian (armhf, arm64, amd64).
But, alpine image in Fluentd was already marked as deprecated, so we will make things forward.

In near future, we will drop alpine image.
This decision affects existing alpine image users.

## Notice about existing alpine image users

* `fluent/fluentd:edge` will be changed from alpine to debian image
  * This is notable incompatible change!
* v1.19 (not released yet)
  * No more release for alpine images
  * Then short tag also changed to debian images (e.g. v1.19.0-1.0, v1.19-1 should be debian instead of alpine)
* v1.18 alpine image will not be supported when v1.19 was released (T.B.D.), so recommend to migrate it!
* v1.16 alpine image will be supported until Dec 2025, so there is a room to migrate gradually.

If you still want to use alpine, keep v1.16 series or v1.18 series. (not recommended though)

## Why not provide alpine anymore?

It was well known that alpine has possibility of incompatibility and performance issues in contrast to debian images.
It was a historical reason to provide alpine images - "In the previous versions, we provided them",
so there is no positive reason to continue it.

## What will be changed existing Debian image users?

Not only just dropping alpine image, we will improve tagging rules:

* Add version specific tag which will not be affected by internal version bump

In the previous versions, no version specific tag which will follow it without being affected internal version bump.
For example, if you want to stick to Fluentd v1.18.0, you can select v1.18.0-1.0, but if internal version was bumped to v1.18.0-1.1 or something, need to update it.
There is `edge-debian` tag, but it is valid until next major/minor version was released.

For such a purpose, shorter v1.19 or v1.19.x tag will be available in the future release.

Happy logging!

TAG: Fluentd fluent-package Announcement
AUTHOR: clearcode
