#Collecting Data from Scribe

##Scenario

You already have an exiting installation of Scribe but want to collect data into multiple backend systems (by leveraging Fluentd's wide-ranging output plugins).

The benefit of this approach is:

1. No need to gut out the existing Scribe instances.
2. Take advantage of Fluentd's rich set of output plugins. For example, sending data to both HDFS and Amazon S3.

##Setup

1. Install the [Scribe input plugin](https://github.com/fluent/fluent-plugin-scribe) by running the following command

    ```
    $ fluent-gem install fluent-plugin-scribe
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      @type scribe
      port 1463
      bind 0.0.0.0
      msg_format json
    </source> 
    ```
    In the above example, we assume `bind` is localhost and `port` is 1463. See [the docs](https://docs.fluentd.org/articles/in_scribe) for the full list of parameters.
