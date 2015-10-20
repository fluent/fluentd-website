# Monitoring HAProxy Real-time with Elasticsearch and Fluentd

HAProxy is a popular reverse proxy server. This short guide shows you how to use it store its logs into Elasticsearch to monitor its performance.

## Prerequisites

- A basic understanding of Fluentd
- HAProxy logs written to files via syslog-ng/rsyslogd
- A running Elasticsearch instance

In this guide, we assume we are running [td-agent](/download) on Ubuntu Precise.

## Tailing the HAProxy logs

The first step is to set up [the tail input](http://docs.fluentd.org/articles/in_tail) to tail the HAProxy log.

The TCP HAProxy logs look something like this:

```
haproxy[27508]: info 127.0.0.1:45111 [12/Jul/2012:15:19:03.258] wss-relay wss-relay/local02_9876 0/0/50015 1277 cD 1/0/0/0/0 0/0
```

Which can be parsed with the following regular expression:

```
/^(?<ps>\w+)\[(?<pid>\d+)\]: (?<pri>\w+) (?<c_ip>[\w\.]+):(?<c_port>\d+) \[(?<time>.+)\] (?<f_end>[\w-]+) (?<b_end>[\w-]+)\/(?<b_server>[\w-]+) (?<tw>\d+)\/(?<tc>\d+)\/(?<tt>\d+) (?<bytes>\d+) (?<t_state>[\w-]+) (?<actconn>\d+)\/(?<feconn>\d+)\/(?<beconn>\d+)\/(?<srv_conn>\d+)\/(?<retries>\d+) (?<srv_queue>\d+)\/(?<backend_queue>\d+)$/
```

The HTTP HAProxy logs look something like this:


Which can be parsed with the following regular expression:

```
 /^(?<ps>\w+)\[(?<pid>\d+)\]: (?<c_ip>[\w\.]+):(?<c_port>\d+) \[(?<time>.+)\] (?<f_end>[\w-]+) (?<b_end>[\w-]+)\/(?<b_server>[\w-]+) (?<tq>\d+)\/(?<tw>\d+)\/(?<tc>\d+)\/(?<tr>\d+)\/(?<tt>\d+) (?<status_code>\d+) (?<bytes>\d+) (?<req_cookie>\S+) (?<res_cookie>\S+) (?<t_state>[\w-]+) (?<actconn>\d+)\/(?<feconn>\d+)\/(?<beconn>\d+)\/(?<srv_conn>\d+)\/(?<retries>\d+) (?<srv_queue>\d+)\/(?<backend_queue>\d+) \{(?<req_headers>[^}]*)\} \{(?<res_headers>[^}]*)\} "(?<request>[^"]*)"/
```

In the rest of the article, we assume the format is TCP. Hence, assuming the HAProxy log is located at `/var/log/haproxy/haproxy.log`, add the following to the configuration file (which, for `td-agent` is at `/etc/td-agent/td-agent.conf`.)

```
<source>
  type tail
  path /var/log/haproxy/haproxy.log
  pos  /path/to/file_position_file
  format /^(?<ps>\w+)\[(?<pid>\d+)\]: (?<pri>\w+) (?<c_ip>[\w\.]+):(?<c_port>\d+) \[(?<time>.+)\] (?<f_end>[\w-]+) (?<b_end>[\w-]+)\/(?<b_server>[\w-]+) (?<tw>\d+)\/(?<tc>\d+)\/(?<tt>\d+) (?<bytes>\d+) (?<t_state>[\w-]+) (?<actconn>\d+)\/(?<feconn>\d+)\/(?<beconn>\d+)\/(?<srv_conn>\d+)\/(?<retries>\d+) (?<srv_queue>\d+)\/(?<backend_queue>\d+)$/
  tag haproxy.tcp
  time_format %d/%B/%Y:%H:%M:%S
</source>
```

## Outputting Data into Elasticsearch

Fluentd support Elasticsearch as an output.  For td-agent, run

```
/usr/sbin/td-agent-gem install fluent-plugin-elasticsearch
```

If you are using vanilla Fluentd, run

```
fluent-gem install fluent-plugin-elasticsearch
```

(You might need to sodo). Now, configure Elasticsearch as an output.

```
<match haproxy.*>
  type copy
  <store>
    # for debug (see /var/log/td-agent.log)
    type stdout
  </store>
  <store>
    type elasticsearch
    logstash_format true
    flush_interval 10s # for testing.
    host YOUR_ES_HOST
    port YOUR_ES_PORT
  </store>
</match>
```

## Restart and Confirm That Data Flow into Elasticsearch

Restart td-agent with `sudo service td-agent restart`. Then, run `tail` against /var/log/td-agent.log. You should see the following lines:

```
2012-07-12 15:19:03 +0000 haproxy.tcp: {"ps":"haproxy","pid":"27508","pri":"info","c_ip":"127.0.0.1","c_port":"45111","f_end":"wss-relay","b_end":"wss-relay","b_server":"local02_9876","tw":"0","tc":"0","tt":"50015","bytes":"1277","t_state":"cD","actconn":"1","feconn":"0","beconn":"0","srv_conn":"0","retries":"0","srv_queue":"0","backend_queue":"0"}
```

Then, query Elasticsearch to make sure the data is in there.

## What's Next?

In production, you might want to remove writing output into stdout. So, use the following output configuration:

```
<match haproxy.*>
  type elasticsearch
  logstash_format true
  host YOUR_ES_HOST
  port YOUR_ES_PORT
</match>
```

Do you wish to store HAProxy logs into other systems? Check out other [data outputs!](/dataoutputs).
