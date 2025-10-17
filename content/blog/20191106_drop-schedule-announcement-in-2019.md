# Drop schedule announcement in 2019

Hi users and developers!

We announce the drop schedule for Fluentd development.

## Fluentd

Fluentd now has v1 and v0.12 versions. v0.12 is old stable and v0.12 is now security maintenance mode.
To focus v1 development, we will stop all activities for v0.12 in the end of 2019.

- Stop to accept security fix patches
- Stop to update docker images
- Stop to handle v0.12 issues/questions

We recommend plugin developers to use v1 API for full v1 feature support :)

## Treasure Agent(td-agent)

td-agent 2.3 is no longer supported.
If you want to use td-agent for fluentd v0.12, use td-agent 2.5 instead.
td-agent 2.5 uses ruby 2.5, so td-agent 2.5 is more better than td-agent 2.3.

Of course, we recommend to use td-agent 3, fluentd v1 series, for new deployment :)

## Ruby

Fluentd now supports ruby 2.1 or later but it makes code harder to maintain.
For better development, we will drop ruby 2.1, 2.2 and 2.3 support in the end of 2019.
Supporting ruby 2.4 or later is reasonable because almost users now run fluentd on ruby 2.4 or later.

- td-agent 2.5 uses ruby 2.5
- td-agent 3 uses ruby 2.4
- td-agent 4 will use ruby 2.6
- Alpine docker images use ruby 2.5
- Debian docker images use ruby 2.6
- Latest OSes(CentOS 8, Ubuntu 18.04, Debian 10, etc) use ruby 2.4 or later

In addition, we can use rvm/rbenv to install any ruby version, so
we hope dropping ruby 2.3 or earlier doesn't have big impact for existing users.

If you have any question, post it to mailing list ;)


TAG: Fluentd td-agent Announcement
AUTHOR: masa
