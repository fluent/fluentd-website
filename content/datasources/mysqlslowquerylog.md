#Collecting and Analyzing Slow Query Logs for MySQL

##Scenario

Slow queries can degrade the overall performance of a MySQL cluster, so they need to be monitored closely and addressed promptly.

Fluentd can be set up to parse and collect data from MySQL's slow query logs. Applications include:

1. Sending email alerts if the query time exceeds a particular threshold.
2. Generate real-time statistics on slow queries by using Elasticsearch as the search backend.

##Setup

1. Install the [MySQL slow query plugin](https://github.com/yuku-t/fluent-plugin-mysqlslowquery) by running the following command

    ```
    $ fluent-gem install fluent-plugin-mysqlslowquery
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      type mysql_slow_query
      path /path/to/mysqld-slow.log
      tag mysqld.slow_query
    </source>
    ```
    
    For example, in most cases, the slow query log is located at `/var/log/mysql/slow.log`, so the above config would be

    ```
    <source>
        type mysql_slow_query
        path /var/log/mysql/slow.log
        tag mysqld.slow_query
    </source>
    ```

    If you are not sure where you slow query logs are, ask the DBA or [look into my.cnf](http://dev.mysql.com/doc/refman/5.6/en/slow-query-log.html)