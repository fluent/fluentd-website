#Collecting and Analyzing GlusterFS logs

##Scenario

[GlusterFS](http://gluster.org) is an open source, distributed file system commercially supported by Red Hat, Inc. Each node in GlusterFS generates its own logs, and it's sometimes convenient to have these logs collected in a central location for analysis (e.g., When one GlusterFS node went down, what was happening on other nodes?).

By collecting dstat output into Fluentd and storing them in various backend systems, one can create a resource monitoring system very easily. For example,

1. Sending GlusterFS logs into HDFS for analysis
2. Sending GlusterFS logs into Elasticsearch for real-time root cause analysis 

##Setup

1. Install the GlusterFS input plugin by running the following command

    ```
    $ fluent-gem install fluent-plugin-glusterfs
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      @type glusterfs_log
      path /var/log/glusterfs/etc-glusterfs-glusterd.vol.log
      tag glusterfs_log.glusterd
      format /^(?<message>.*)$/
    </source>
     ```
    