#Collecting and Analyzing dstat data

##Scenario

[dstat](https://github.com/dagwieers/dstat) is a versatile resource statistics tool that replaces vmstat, iostat, mpstat, netstat and ifstat.

By collecting dstat output into Fluentd and storing them in various backend systems, one can create a resource monitoring system very easily. For example,

1. Sending dstat data into MongoDB for analysis
2. Sending dstat data into Elasticsearch for analysis 

##Setup

1. Install the [dstat plugin](https://github.com/shun0102/fluent-plugin-dstat) by running the following command

    ```
    $ fluent-gem install fluent-plugin-dstat
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      type dstat
      tag input.dstat
      option -c
      delay 3
     </source>    
     ```
    
    With the above set up, Fluentd runs dstat periodically (roughly every 10 seconds) to gather resource data and tag it with "input.dstat".
    