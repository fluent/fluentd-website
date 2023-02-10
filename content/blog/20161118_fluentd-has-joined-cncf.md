# Fluentd joins the Cloud Native Computing Foundation

[Fluentd](http://www.fluentd.org) is giving a big step forward in terms of adoption. It was not a surprise that it was early adopted by several companies and from a _cloud_ perspective, it become the default standard to solve Logging in containerized environments. We were able to see how [Docker](http://docker.com) users relies on Fluentd to scale logging while in the orchestration area, users from [Kubernetes](http://kubernetes.io/) started their own integrations too, nowadays Kubernetes uses Fluentd to ship logs to [Elasticsearch](https://www.elastic.co/products/elasticsearch) and [Google Cloud Platform](https://cloud.google.com/logging/docs/agent/). Fluentd is having an organic grow.

From a project perspective, _adoption_ is the key to succeed. But to accomplish this adoption a project needs to be a good citizen with other components, a good integration is always desired. Fluentd adoption is merely thanks to the flexibility to adapt and integrate with other platforms, and of course solving a real-worl problem which is logging.

As you might noticed, in the last two years Fluentd team was very active sharing logging knowledge in several conference around the world, I'd say our biggest participation have been in LinuxCon Asia, Europe and NorthAmerica (in all it versions!). This kind of interaction was really positive to understand how the project could evolve even more. At the beginning of 2016, we were thinking about what would be the next natural step for Fluentd and we saw some lights when Linux Foundation announced the new [Cloud Native Computing Foundation (aka CNCF)](http://cncf.io).

Since CNCF is a nonprofit organization committed to advancing the development of cloud native technology, it sound a really good fit for Fluentd, at that moment Google already donated Kubernetes to CNCF. One of the biggest benefits of CNCF compared to other _foundations_ are:

- Flexibility: development and roadmap continue being handled by the project. CNCF do not want to control that, so we can move forward very quickly.
- Ecosystem: formally Fluentd can be part of a cloud native stack. Work together with Kubernetes team (and others) in a better way.
- Investment: CNCF donates resources for documentation and give access to the [CNCF Cluster (1k servers)](https://www.cncf.io/cluster).
- Awareness: Fluentd becomes recognized as the default Logging Cloud Native technology.

After a long process of review and technical discussions, the [CNCF Technical Oversight Committee](https://www.cncf.io/about/technical-oversight-committee) voted for Fluentd ending in positive result, Fluentd joins the CNCF and this was announced in the Opening Keynote session at [CloudNativeCon](http://events.linuxfoundation.org/events/cloudnativecon) (jump to minute 24:40):

<iframe width="560" height="315" src="https://www.youtube.com/embed/3rGJ0bt0UhE" frameborder="0" allowfullscreen></iframe>

### Fluentd at CNCF

Note that Fluentd is a whole ecosystem, if you look around inside our [Github Organization](http://github.com/fluent/fluentd), you will see around 35 repositories including Fluentd service, plugins, languages SDKs and complement project such as [Fluent Bit](http://fluentbit.io). All of them are part of CNCF now!.

In name of [Treasure Data](http://www.treasuredata.com), I want thanks to every developer of Fluentd, plugins and SDKs who were very supportive on this transition for the project. Our code and community is part of something bigger now :) .

### What's Next ?

Fluentd team continue working hard to make it even better, there is a long roadmap for v0.14 and looking forward for a v1.0 on Q1 of 2017. We want everybody continue be involved on this, this is a really exciting time in the _Cloud Native Era_ and Fluentd Community is having a key role on it.

TAG: Fluentd News CNCF
AUTHOR: eduardo
