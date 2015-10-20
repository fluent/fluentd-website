#Collecting and Analyzing Ruby Application Logs

##Scenario

You have an application written in Ruby/Rails and want to collect data into MongoDB, HDFS, Elasticsearch, et. al. for analytics/search.

Logging directly into MongoDB/HDFS/Elasticsearch is not highly recommended since synchronous logging is slow/potentially hazardous for the backend. You can build asynchronous logging into your application, but Fluentd can sit between your application and backend systems to achieve reliable, asynchronous logging.

<table>
    <tr>
        <td>
            <img width="400px" src="/assets/img/datasources/synchronous_logging.png"/>
        </td>
        <td width="50px"></td>
        <td>
            <img width="400px" src="/assets/img/datasources/asynchronous_logging.png"/>
        </td>
    </tr>
</table>

The basic idea is to run Fluentd to accept TCP requests and use Fluentd's Ruby logger to send data to Fluentd from Ruby applications. You do not have to worry about performance issues since all the logging is done asynchronously.

##Setup

1. Set up Fluentd with in_forward. By default, Fluentd has this enabled. It is the following section in the configuration file:

    ```
    <source>
      type forward
      port 24224
    </source>
    ```

    The above configuration makes Fluentd listen to TCP requests on port 24224.

2. Add fluent-logger to your Gemfile like this:

    ```
    gem 'fluent-logger'
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    require 'fluent-logger'

    # This assumes that Fluentd is running on the same machine as the app on Port 24224
    Fluent::Logger::FluentLogger.open(nil, :host=>'localhost', :port=>24224)

    # The first argument is the tag, the second argument is the event.
    Fluent::Logger.post("fluentd.test.follow", {"from"=>"userA", "to"=>"userB"})    
     ```
    
    That's it. Now, you can configure Fluentd's outputs to send events to various backend systems. Also, [see the docs](http://docs.fluentd.org/articles/ruby) for detailed information