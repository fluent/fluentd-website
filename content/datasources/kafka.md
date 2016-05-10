# Collecting Data from Kafka

## Scenario

[Kafka](http://kafka.apache.org) is a highly distributed messaging system.

You run Kafka as a messaging system and now want to send the messages into various other systems.

Fluentd can setup to collect messages from Kafka. Applications include:

1. Sending Kafka messages into HDFS for analysis
2. Sending Kafka messages into Elasticsearch for analysis

## Setup

1. Download the latest [kafka-fluentd-consumer jar](https://github.com/treasure-data/kafka-fluentd-consumer/releases).

2. Set kafka-fluentd-consumer settings correctly. (See [fluentd-consumer.properties](https://github.com/treasure-data/kafka-fluentd-consumer/blob/master/config/fluentd-consumer.properties) for example.)

3. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      type exec
      command java -Dlog4j.configuration=file:///path/to/log4j.properties -jar /path/to/kafka-fluentd-consumer-LATEST_VERSION-all.jar /path/to/config/fluentd-consumer.properties
      tag dummy
      format json
    </source>
    ```

   With the above setup, Fluentd consumes Kafka messages which are specified topics in `fluentd-consumer.properties` via `in_exec` plugin.
