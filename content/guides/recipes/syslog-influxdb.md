# Aggregate and Analyze Syslog with InfluxDB

This article shows how to collect syslog data into [InfluxDB](http://github.com/influxdb/influxdb)
using Fluentd.

<img src="/images/recipes/syslog-fluentd-influxdb.png" style="display:block"/>

## Prerequisites

- A basic understanding of Fluentd
- A running instance of rsyslogd

**In this guide, we assume we are running [td-agent (Fluentd package for Linux and OSX)](/download) on Ubuntu Precise.**

## Step 1: Install InfluxDB

InfluxDB supports Ubuntu, RedHat and OSX (via brew). See [here](http://influxdb.com/download/) for the details.

Since we are assumed to be on Ubuntu, the following two lines install InfluxDB:

```
$ wget http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb
$ sudo dpkg -i influxdb_latest_amd64.deb
```

Once it is installed, you can run it with

```
$ /etc/init.d/influxdb start
```

Then, go to localhost:8083 (or wherever you are hosting InfluxDB) to access InfluxDB's web console.


The default user/password are both "root". Once you log in, create a database called "test". This is
where we will be storing syslog data.

<img src="/images/recipes/influxdb-create-db.png" style="display:block"/>

If you prefer command line or cannot access port 8083 from your local machine,
running the following command creates a database called "test".

```
$ curl -X POST 'http://localhost:8086/db?u=root&p=root' -d '{"name": "test"}'
```

We are done for now.

## Step 2: Install Fluentd and the InfluxDB plugin

On your aggregator server, set up Fluentd. [See here](/download) for the details.

```
$ curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-precise.sh | sh 
```

Next, the InfluxDB output plugin needs to be installed. Run

```
/usr/sbin/td-agent-gem install fluent-plugin-influxdb
```

If you are using vanilla Fluentd, run

```
fluent-gem install fluent-plugin-influxdb
```

You might need to `sudo` to install the plugin.

Finally, configure `/etc/td-agent/td-agent.conf` as follows.

```
<source>
  type syslog
  port 42185
  tag  system
</source>

<match system.*.*>
  type influxdb
  dbname test
  flush_interval 10s # for testing.
  host YOUR_INFLUXDB_HOST (localhost by default)
  port YOUR_INFLUXDB_PORT (8086 by default)
</match>
```

Restart td-agent with `sudo service td-agent restart`.

## Step 3: Configure rsyslogd

If remote rsyslogd instances are already collecting data into the aggregator rsyslogd,
the settings for rsyslog should remain unchanged. However, if this is a brandnew setup,
start forward syslog output by adding the following line to `/etc/rsyslogd.conf`

```
*.* @182.39.20.2:42185
```

You should replace "182.39.20.2" with the IP address of your aggregator server. Also,
there is nothing special about port 42185 (do make sure this port is open though).

Now, restart rsyslogd.

```
$ sudo service rsyslog restart
```

## Step 4: Confirm Data Flow

Your syslog data should be flowing into InfluxDB every 10 seconds (this is configured by `flush_interval`).

Clicking on "Explore Data" brings up the query interface that *lets you write SQL queries against your log data.*

<img src="/images/recipes/influxdb-explore-data.png" style="display:block"/>

Here, I am counting the number of lines of syslog messages per facility/priority:

```
SELECT COUNT(ident) FROM /^system\./ GROUP BY time(1s)
```

Click on "Execute Query" and you get a graph like this.

<img src="/images/recipes/influxdb-query.png" style="display:block"/>

Here is another screenshot just for the `system.daemon.info` series.

<img src="/images/recipes/influxdb-query-2.png" style="display:block"/>
