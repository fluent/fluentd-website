# Collecting Data from Kafka

## Scenario

[Kafka](http://kafka.apache.org) is a highly distributed messaging system.

You run Kafka as a messaging system and now want to send the messages into various other systems.

Fluentd can setup to collect messages from Kafka. Applications include:

1. Sending Kafka messages into HDFS for analysis
2. Sending Kafka messages into Elasticsearch for analysis

You can two choices for this purpose whether using `in_kafka` or using `kafka-fluentd-consumer`.

## Setup: fluent-plugin-kafka

1. Install the [Kafka input plugin](https://github.com/htgc/fluent-plugin-kafka) by running the following command:

    ```
    $ fluent-gem install fluent-plugin-kafka
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      @type  kafka
      host   <broker host>
      port   <broker port: default=9092>
      topics <listening topics(separate with comma',')>
      format <input text type (text|json|ltsv|msgpack)>
      message_key <key (Optional, for text format only, default is message)>
    </source>
    ```

    With the above setup, Fluentd consumes Kafka messages via `in_kafka` plugin.

## Setup: kafka-fluentd-consumer

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

### Note

For simplification, you can use `in_kafka` plugin to retrive kafka messages.
If you assume highly kafka traffic in production, we recommend to use `kafka-fluentd-consumer` instead of `in_kafka`. Because `in_kafka` has been reported high CPU usage when 1000req/sec environment. In more detail, please refer to [the issue](https://github.com/htgc/fluent-plugin-kafka/issues/16).
