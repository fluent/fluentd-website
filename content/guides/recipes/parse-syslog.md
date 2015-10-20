# Parse Syslog Messages Robustly

Syslog is a popular protocol that virtually runs on every server. It is used to collect all kinds of logs.

The problem with syslog is that services have a wide range of log format, and no single parser can parse all syslog messages effectively.

In this tutorial, we will show how to use Fluentd to filter and parse different syslog messages robustly.

## Prerequisites

- A basic understanding of Fluentd
- A running instance of rsyslogd

In this guide, we assume we are running [td-agent](/download) on Ubuntu Precise.

## Setting up rsyslogd

Go to /etc/rsyslogd.conf and add the following line:

```
*.* @127.0.0.1:42185
```

This line tells rsyslogd to forward local system logs to port 42185 to which Fluentd will listen.

## Setting up Fluentd

In this section, we will evolve our Fluentd configuration step-by-step.

### Step 1: Listening to syslog messages

First, let's configure to listen to syslog messages.

Edit `/etc/td-agent/td-agent.conf` to look like this:

```
<source>
  type syslog
  port 42185
  tag system
</source>

<match system.**>
  type stdout
</match>
```

This is the most basic setup: it listens to all syslog messages and logs them to stdout.

Now, let's restart td-agent:

```
$ sudo service td-agent restart
```

Let's confirm data is coming in. Here is what my log looks like:

```
$ sudo tail /var/log/td-agent/td-agent.log
```

(One can always "force" a syslog event with the `logger` command like `logger -t foo.bar "hello world"`)

```
2014-06-01 19:41:28 +0000 system.kern.info: {"host":"precise64","ident":"kernel","message":"[49851.032200] docker0: port 2(veth6091) entering disabled state"}
2014-06-01 19:41:29 +0000 system.daemon.info: {"host":"precise64","ident":"ntpd","pid":"3289","message":"Deleting interface #11 veth6091, fe80::540b:1aff:fe1f:810c#123, interface stats: received=0, sent=0, dropped=0, active_time=4 secs"}
2014-06-01 19:41:29 +0000 system.daemon.info: {"host":"precise64","ident":"ntpd","pid":"3289","message":"peers refreshed"}
2014-06-01 19:41:44 +0000 system.authpriv.notice: {"host":"precise64","ident":"sudo","message":"vagrant : TTY=pts/3 ; PWD=/home/vagrant ; USER=root ; COMMAND=/usr/bin/vim /var/log/td-agent/td-agent.log"}
```

### Step 2: Parsing the details of `sudo` calls.

Now, let's look at a `sudo` message like this one.

>2014-06-01 19:41:44 +0000 system.authpriv.notice: {"host":"precise64",<span style="color:red">"ident":"sudo"</span>,"message":"vagrant : TTY=pts/3 ; PWD=/home/vagrant ; USER=root ; COMMAND=/usr/bin/vim /var/log/td-agent/td-agent.log"}

For security, it is worth knowing which user performed which action as a sudo-er. In order to do so, we need to parse the message field.

In other words, we need to parse sudo syslog messages _differently from other messages_.

To do this, we will use the [rewrite tag filter output plugin](https://github.com/fluent/fluent-plugin-rewrite-tag-filter). This plugin examines an event's record fields, match them against regexps and routes them. In the following example, Fluentd filters out all events except for "sudo" events. Sudo events are assigned the new tag "sudo".

The rewrite tag filter output plugin ships with td-agent. If you are using vanilla Fluentd, run `gem install fluent-plugin-rewrite-tag-filter`.

```
<source>
  type syslog
  port 42185
  tag system
</source>

<match system.**>
  type rewrite_tag_filter
  rewriterule1 ident ^sudo$  sudo # sudo events
  rewriterule2 .*                   clear # everyone else
</match>

<match clear>
  type null
</match>
```

The last "clear" match block is to filter out all non-sudo events. Think of it as Fluentd's `/dev/null`.

We still need to match sudo events. More specifically, let's just match lines that look like this:

>2014-06-01 19:41:44 +0000 system.authpriv.notice: {"host":"precise64","ident":"sudo",<span style="color:green">"message":"vagrant : TTY=pts/3 ; PWD=/home/vagrant ; USER=root ; COMMAND=/usr/bin/vim /var/log/td-agent/td-agent.log"</span>}

For this, we use the rewrite tag filter plugin again and use another plugin called [fluent-plugin-parser](https://github.com/tagomoris/fluent-plugin-parser). fluent-plugin-parser lets Fluentd re-parse a particular field with arbitrary regular expressions.

To install fluent-plugin-parser, run

```
$ sudo /usr/sbin/td-agent-gem install fluent-plugin-parser
Fetching: fluent-plugin-parser-0.3.4.gem (100%)
Successfully installed fluent-plugin-parser-0.3.4
1 gem installed
```

Now, here is the final configuration:

```
<source>
  type syslog
  port 42185
  tag system
</source>

<match system.**>
  type rewrite_tag_filter
  rewriterule1 ident ^sudo$  sudo  # sudo events
  rewriterule2 ident .*      clear # everyone else
</match>

# This one matches for the exact sudo syslog messages that we want to parse
# and re-tags it with "sudo_parse_it"
<match sudo>
  type rewrite_tag_filter
  rewriterule1 message PWD=[^ ]+ ; USER=[^ ]+ ; COMMAND=.*$ sudo_parse_it
  rewriterule2 message .* clear
</match>

# This one parses the message field and emits it with the sudoer, pwd and 
# command. Then, it emits the parsed event with the tag "sudo_parsed"
<match sudo_parse_it>
  type parser
  key_name message # this is the field to be parsed
  format /PWD=(?<pwd>[^ ]+) ; USER=(?<sudoer>[^ ]+) ; COMMAND=(?<command>.*)$/
  tag sudo_parsed
</match>

# Finally, emitting the data to stdout to confirm the behavior!
<match sudo_parsed>
    type stdout
</match>

<match clear>
  type null
</match>
```


Restart td-agent

```
$ sudo service td-agent restart
```

And run some sudo command. Since I have Docker running as root, let me peek into `/var/lib/docker`.

```
~$ sudo ls -alh /var/lib/docker
total 76K
drwx------  10 root root 4.0K Jun  1 19:41 .
drwxr-xr-x  41 root root 4.0K May 30 23:02 ..
drwxr-xr-x   2 root root 4.0K Apr 17 06:06 apparmor
drwxr-xr-x   5 root root 4.0K Apr 15 19:59 aufs
drwx------   4 root root 4.0K Jun  1 19:41 containers
drwx------   3 root root 4.0K Apr 15 19:59 execdriver
drwx------  64 root root  12K Jun  1 01:20 graph
drwx------   2 root root 4.0K May 31 05:55 init
-rw-r--r--   1 root root 7.0K Jun  1 19:41 linkgraph.db
-rw-------   1 root root 1.4K Jun  1 01:20 repositories-aufs
drwx------   2 root root 4.0K May 30 23:22 vfs
drwx------ 147 root root  20K May 30 22:37 volumes
```

Now, let's check to make sure my furtive sudo attempt was logged:

```
$ sudo tail /var/log/td-agent/td-agent.log
2014-06-01 23:26:50 +0000 [info]: adding match pattern="system.**" type="rewrite_tag_filter"
2014-06-01 23:26:50 +0000 [info]: adding rewrite_tag_filter rule: rewriterule1 ["ident", /^sudo$/, "", "sudo"]
2014-06-01 23:26:50 +0000 [info]: adding rewrite_tag_filter rule: rewriterule2 ["ident", /.*/, "", "clear"]
2014-06-01 23:26:50 +0000 [info]: adding match pattern="sudo" type="rewrite_tag_filter"
2014-06-01 23:26:50 +0000 [info]: adding rewrite_tag_filter rule: rewriterule1 ["message", /PWD=[^ ]+ ; USER=[^ ]+ ; COMMAND=.*$/, "", "sudo_parse_it"]
2014-06-01 23:26:50 +0000 [info]: adding rewrite_tag_filter rule: rewriterule2 ["message", /.*/, "", "clear"]
2014-06-01 23:26:50 +0000 [info]: adding match pattern="sudo_parse_it" type="parser"
2014-06-01 23:26:50 +0000 [info]: adding match pattern="sudo_parsed" type="stdout"
2014-06-01 23:26:50 +0000 [info]: adding match pattern="clear" type="null"
2014-06-01 23:27:14 +0000 sudo_parsed: {"pwd":"/home/vagrant","sudoer":"root","command":"/bin/ls -alh /var/lib/docker"}
```

There it is, as you can see in the last line!

## Conclusion

Fluentd makes it easy to ingest syslog events. You can immediately send the data to output systems like MongoDB and Elasticsearch, but also you can do filtering and further parsing _inside Fluentd_ before passing the processed data onto output destinations.