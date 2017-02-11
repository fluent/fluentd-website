# Debian based fluentd docker image has been released

Hi users!

We officially provide Alpine Linux based Fluentd docker image.
Alpine Linux is light weight and this is good for Fluentd use cases.
But some plugins, e.g. `fluent-plugin-systemd`, don't work on Alpine Linux, so
we received the request "Could you provide other OS based image for xxx."

To resolve this problem, [@tyranron](https://github.com/tyranron) works on improving Docker image management.
Easy to add other OS, more automated release and tagging, build testing and more.
Thanks to @tyranron for your hard work :)

In this result, we start to provide Debian based docker image together.

[Debian images by tyranron · Pull Request #71 · fluent/fluentd-docker-image](https://github.com/fluent/fluentd-docker-image/pull/71)

The default is still Alpine Linux but you can choose Debian version for your requirement.
See [Supported tags](https://github.com/fluent/fluentd-docker-image#supported-tags-and-respective-dockerfile-links) section in README for all available images.

If you have any problem, please let me know.

<br />
Happy logging!


TAG: Fluentd Docker Announcement
AUTHOR: masa
