# Collectin Data from Flume-NG

## Scenario

You already have an exiting installation of Flume-NG but want to collect data into backend other than HDFS (for which Flume-NG is optimized).

The benefit of this approach is:

1. Take advantage of Fluentd's rich set of output plugins. For example, sending data to both HDFS and Amazon S3.

## Setup

1. Install the Latest [Flume-NG Fluentd Sink jar](https://github.com/cosmo0920/flume-ng-fluentd-sink/releases) into ${FLUME_HOME}/lib:

    ```
    FLUME_HOME $ tree -L 1 .
    .
    ├── CHANGELOG
    ├── DEVNOTES
    ├── LICENSE
    ├── NOTICE
    ├── README
    ├── RELEASE-NOTES
    ├── bin
    ├── conf
    ├── docs
    ├── lib # <- Put flume-ng-fluentd-sink-LATEST_VERSION-all.jar here.
    └── tools
    ```

2. Write Flume-NG configuration like this:

    ```
    a1.sinks = k1

    a1.sinks.k1.type = com.github.cosmo0920.fluentd.flume.plugins.FluentdSink
    al.sinks.k1.hostname = localhost
    a1.sinks.k1.port = 24224
    a1.sinks.k1.tag = flume.fluentd.sink
    a1.sinks.k1.format = text
    ```

3. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      type forward
      bind 0.0.0.0
      port 24224
    </source>
    ```

    That's it. Now, you can send Flume-NG events into Fluentd via `flume-ng-fluentd-sink`.
