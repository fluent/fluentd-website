## SlideShare Presents Unified Data Front With Fluentd

Founded in October 2006 with the goal of facilitating knowledge-sharing online, SlideShare has grown into the world’s largest community for sharing presentations and other content. In Q4 2013, SlideShare averaged 60 million unique visitors per month and 215 million page views as users viewed presentations, infographics, documents, videos and PDFs.

<img width="600px" style="display:block" src="http://engineering.slideshare.net/wp-content/uploads/2014/04/skynet-archi.jpg"/>

## The Goal: Deeper and Quicker Insights that Transform Usage Patterns and System Health

Rapid growth is a dream come true for many companies, but it also introduces new challenges. For SlideShare, it meant ensuring that their service stays engaging and available by closely monitoring their application and service infrastructure in a scalable (read: automated) manner.

## The Challenge: Find a Solution to Help Collect and Structure Logs for Near Real-Time Analysis and Share to Multiple Systems

SlideShare began by looking at open source log collectors. They wanted something that is lightweight, fast, and written in Ruby: Since Slideshare uses Ruby throughout its stack, they wanted the data collector to be written in Ruby to minimize technical friction. Being open source is also important because they wanted to make sure they can tweak the software to match their needs.

## The Solution: Use Fluentd to Build an Intelligent Message Bus Among Subsystems

SlideShare ended up choosing Fluentd because it satisfied the aforementioned requirements. Furthermore, Fluentd’s plugin ecosystem gave them the confidence that they could extend Fluentd to evolve with Slideshare’s architecture.
“Fluentd is good at stream processing and is easy to integrate with whatever backend system of your choice,” said Casey Brown, Engineering Manager.

Using Fluentd as the key component, SlideShare implemented a new monitoring system called Skynet. Skynet collects both application logs and system metrics and pass them onto Fluentd to collect and aggregate reliably into MongoDB, which in turn powers their internal dashboard.

In the past two years, SlideShare’s use of Fluentd expanded. For example, Fluentd powers the infrastructure for email analytics. Fluentd is used to collect statistics on email opens, reads, links clicked among others for the millions of emails that they send out every week.

## Profile

- Company: [Slideshare](http://www.slideshare.com)
- Location: San Francisco, CA and New Delhi, India
- Use Case Summary:
    * Fluentd deployed on hundreds of servers to collect both application and system metrics.
    * Several custom plugins to send data to AMQP, HDFS, MongoDB, Ganglia among others.
    * Taking full advantage of Fluentd’s extensible architecture.
    * [Here is Slideshare's own write-up on its data architecture](http://engineering.slideshare.net/2014/04/skynet-project-monitor-scale-and-auto-heal-a-system-in-the-cloud/)