## LINE Case Study: From Batch to Stream Log Processing with Fluentd

## The Goal: Aggregating and Processing Log Data In-steam in Near Real-Time

LINE Corporation, known for its eponymous messenger app and various services on its platform, faces the challenge of collecting, storing and analyzing massive log data everyday. When Satoshi Tagomori, a member of their data engineering team, joined the company four years ago, they have a classic Hadoop setup: They used the Scribe log collector to collect everything into Hadoop and run batch jobs on Hadoop to process the logs. This setup was working perfectly fine, but Mr. Tagomori thought there were a few areas for improvment.

1. **Hadoop is designed to run batch jobs scalably but less suitable for real-time, in-stream processing**: Mr. Tagomori had the idea of baking some of the log processing (especially the ones against fixed time windows) into data collectors so that logs are analyzed as they came in. This system would make statistics around log data available to internal stakeholders in near real-time, allowing the entire company to make decisions more quickly. 
2. **By offloading log processing to data collectors, Hadoop clusters' resources could be better utilized**: By transforming some of the batch processing of log data on Hadoop to in-stream processing within data collectors, they would be able to free up Hadoop's resources and use it for other batch jobs.

Mr. Tagomori explored various options, including building a prototype himself. Eventually, he found Fluentd and started engaging with the community.

## Evolving With the Community

When Fluentd first came out in October 2011, it already had many of the key benefits it has today: pluggable architecture to make it easy to customize and extend its behavior, small memory footprint, reliable buffering and load balancing mechanism. One thing it did not have, however, was performance.

"Fluentd was...not very fast," recalled Mr. Tagomori, who now is a core maintainer of Fluentd. "But since it is an open source project, I began to work with the core developers and helped them benchmark Fluentd's performance. Over the next year or so, Fluentd's performance improved by 10x-15x."

Today, Fluentd is plenty fast for LINE: they use Fluentd to process 1.5TB (5.6 billion records) of log data everyday with more than 120,000 records per seconds of data at peak times. Also, as an active user of Fluentd, Mr. Tagomori has contributed 34 plugins ranging from HDFS output plugin to various filter plugins, which are now used at many other organizations.

"Community is one of my favorite things about Fluentd," said Mr. Tagomori. "I did consider alternative open source data collectors, but Fluentd has a vibrant community that's open to discussions with a strong commitment to keep Fluentd simple, powerful and fast. Plus, its plugin system is architected to make contributions super easy."

## Now: Schemaless Stream Processing in SQL atop Fluentd

Having developed dozens of plugins, Mr. Tagomori began to think that he could evolve Fluentd to be much more than a lightweight data stream processor. In May 2014, he launched Norikra, a schemaless stream processing engine that allows the user to write SQL queries against data streams.

"Norikra can sample, filter, aggregate and join data streams on Fluentd. Its query language is SQL, so there is no special DSL to learn, and you can add and remove SQL queries anytime. Norikra is already solving some data-related challenges at LINE by allowing us to query data streams directly."

## Profile

- Company: [LINE Corporation](http://line.me/en-US/)
- Location: Tokyo, Japan
- Use Case Summary:
    * Terabyte Scale: Fluentd used as the primary data stream processor against terabytes of data everyday.
    * Flexible Data Processing: Many custom plugins developed. Fluentd's vibrant and open community has been key to its success at LINE.
    * Taking Fluentd's Extensibility To a New Level: One of their engineers built a schemaless SQL stream processing engine on top of Fluentd.
