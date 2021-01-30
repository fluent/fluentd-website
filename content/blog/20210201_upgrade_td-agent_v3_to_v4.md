# Upgrade td-agent from v3 to v4

td-agent “v4” is available since August 2020. You' might’ve been wondering what the upgrade process is. 
You are in a right place, In this post, we will share the steps we’ve tested and hopefully this will help your experience from v3 to v4.

## Differences between td-agent v3 and v4

In the td-agent v4, core components like ruby(2.4 -> 2.7) and jemalloc(4.5.0 -> 5.2.1) were updated as well as removing libraries for 3rd party gems like postgreSQL  to improve the maintainability of packages. 

## Upgrade steps

During the upgrade process, plugins bundled in td-agent are automatically upgraded. With that being said, other plugins added on your own are not included. You should review if you need to upgrade plugins since some directory structures from v3 and v4 are changed.
In this post, I will show steps with plugins added on my own, **“fluent-plugin-mongo“** for instance. Here is sample configuration file I used through steps.

```
[root@fluent02 ~]# cat /etc/td-agent/td-agent.conf
<source>
        @type syslog
        port 5140
        bind 0.0.0.0
        tag system
</source>

<match system.**>
        @type copy
        <store>
                @type stdout
        </store>
        <store>
                @type mongo
                database rsyslog
                collection system
                host 127.0.0.1
                port 27017
        </store>
</match>
```

### 1. Review what plugins are installed together with td-agent v3.  
```
[root@fluent02 ~]# td-agent-gem list | grep fluent-plugin*
    fluent-plugin-elasticsearch (4.0.9)
    fluent-plugin-kafka (0.13.0)
    fluent-plugin-mongo (1.5.0)
    fluent-plugin-prometheus (1.8.0)
    fluent-plugin-prometheus_pushgateway (0.0.2)
    fluent-plugin-record-modifier (2.1.0)
    fluent-plugin-rewrite-tag-filter (2.3.0)
    fluent-plugin-s3 (1.3.2)
    fluent-plugin-systemd (1.0.2)
    fluent-plugin-td (1.1.0)
    fluent-plugin-td-monitoring (0.2.4)
    fluent-plugin-webhdfs (1.2.5)
```

You can also find installed plugins under “/opt/td-agent/embedded/lib/ruby/gems/2.4.0/gems/“ directories.
```
[root@fluent02 ~]# ll /opt/td-agent/embedded/lib/ruby/gems/2.4.0/gems/ | grep fluent-plugin*
drwxrwxr-x. 5 root root 4096 Dec 2 06:17 fluent-plugin-elasticsearch-4.0.9
drwxrwxr-x. 3 root root 169 Dec 2 06:17 fluent-plugin-kafka-0.13.0
drwxr-xr-x. 5 root root 209 Dec 2 06:54 fluent-plugin-mongo-1.5.0
drwxrwxr-x. 5 root root 195 Dec 2 06:17 fluent-plugin-prometheus-1.8.0
drwxrwxr-x. 6 root root 206 Dec 2 06:17 fluent-plugin-prometheus_pushgateway-0.0.2
drwxrwxr-x. 3 root root 161 Dec 2 06:17 fluent-plugin-record-modifier-2.1.0
drwxrwxr-x. 3 root root 210 Dec 2 06:17 fluent-plugin-rewrite-tag-filter-2.3.0
drwxrwxr-x. 3 root root 222 Dec 2 06:17 fluent-plugin-s3-1.3.2
drwxrwxr-x. 3 root root 49 Dec 2 06:17 fluent-plugin-systemd-1.0.2
drwxrwxr-x. 3 root root 236 Dec 2 06:17 fluent-plugin-td-1.1.0
drwxrwxr-x. 4 root root 152 Dec 2 06:17 fluent-plugin-td-monitoring-0.2.4
drwxrwxr-x. 3 root root 176 Dec 2 06:17 fluent-plugin-webhdfs-1.2.5
```

### 2. Stop td-agent v3 daemon.
```
[root@fluent02 ~]# systemctl stop td-agent
```
### 3. Run installation script of td-agent v4.

When RedHat, you can run following script.
```
[root@fluent02 ~]# curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent4.sh | sh
```

You can find more information about the installation script in [Fluend Doc - Installation](https://docs.fluentd.org/installation).

### 4. Confirm if td-agent v4 is properly installed.
```
[root@fluent02 ~]# yum info td-agent
Installed Packages
Name : td-agent
Version : 4.0.1
Release : 1.el8
Architecture : x86_64
Size : 59 M
Source : td-agent-4.0.1-1.el8.src.rpm
Repository : @System
From repo : treasuredata
Summary : The stable distribution of Fluentd
URL : https://www.treasuredata.com/
License : ASL 2.0
Description : The stable distribution of Fluentd, called td-agent.
```

### 5. Reload td-agent daemon.
```
[root@fluent02 ~]# systemctl daemon-reload
```

### 6. Check installed plugins. 
```
[root@fluent02 ~]# td-agent-gem list | grep fluent-plugin*
    fluent-plugin-elasticsearch (4.1.1)
    fluent-plugin-kafka (0.14.1)
    fluent-plugin-prometheus (1.8.2)
    fluent-plugin-prometheus_pushgateway (0.0.2)
    fluent-plugin-record-modifier (2.1.0)
    fluent-plugin-rewrite-tag-filter (2.3.0)
    fluent-plugin-s3 (1.4.0)
    fluent-plugin-systemd (1.0.2)
    fluent-plugin-td (1.1.0)
    fluent-plugin-webhdfs (1.2.5)
 ```

You can see bundled plugins are upgraded as well but can not find plugins added on my own. In this post, added plugin was “fluent-plugin-mongo“ and it is not shown in installed list.

### 7. Install plugins added on my own.
```
[root@fluent02 ~]# td-agent-gem install fluent-plugin-mongo

[root@fluent02 ~]# td-agent-gem list | grep fluent-plugin*
    fluent-plugin-elasticsearch (4.1.1)
    fluent-plugin-kafka (0.14.1)
    fluent-plugin-mongo (1.5.0)
    fluent-plugin-prometheus (1.8.2)
    fluent-plugin-prometheus_pushgateway (0.0.2)
    fluent-plugin-record-modifier (2.1.0)
    fluent-plugin-rewrite-tag-filter (2.3.0)
    fluent-plugin-s3 (1.4.0)
    fluent-plugin-systemd (1.0.2)
    fluent-plugin-td (1.1.0)
    fluent-plugin-webhdfs (1.2.5)
 ```
 
 As for td-agent v4, “fluent-plugin-mongo“ was installed under “/opt/td-agent/lib/ruby/gems/2.7.0/gems/” directories.
 
 ```
[root@fluent02 ~]# ll /opt/td-agent/lib/ruby/gems/2.7.0/gems/ | grep fluent-plugin*
drwxr-xr-x. 5 root root 4096 Dec 2 08:26 fluent-plugin-elasticsearch-4.1.1
drwxr-xr-x. 3 root root 169 Dec 2 08:26 fluent-plugin-kafka-0.14.1
drwxr-xr-x. 5 root root 209 Dec 2 08:36 fluent-plugin-mongo-1.5.0
drwxr-xr-x. 4 root root 200 Dec 2 08:26 fluent-plugin-prometheus-1.8.2
drwxr-xr-x. 6 root root 206 Dec 2 08:26 fluent-plugin-prometheus_pushgateway-0.0.2
drwxr-xr-x. 3 root root 161 Dec 2 08:26 fluent-plugin-record-modifier-2.1.0
drwxr-xr-x. 3 root root 210 Dec 2 08:26 fluent-plugin-rewrite-tag-filter-2.3.0
drwxr-xr-x. 3 root root 222 Dec 2 08:26 fluent-plugin-s3-1.4.0
drwxr-xr-x. 3 root root 49 Dec 2 08:26 fluent-plugin-systemd-1.0.2
drwxr-xr-x. 3 root root 236 Dec 2 08:26 fluent-plugin-td-1.1.0
drwxr-xr-x. 3 root root 176 Dec 2 08:26 fluent-plugin-webhdfs-1.2.5
```

### 8. Start td-agent v4 daemon.
```
[root@fluent02 ~]# systemctl start td-agent
```

### 9. Check if there are no error messages in tg-agent logs.
```
[root@fluent02 ~]# tail -100f /var/log/td-agent/td-agent.log
```
### 
10. As for my sample configuration, I restart “sshd“ service for instance and see messages are stored in MongoDB as expected. 

i) Restart “sshd“ daemon.
```
[root@fluent02 mongo]# systemctl restart sshd
```
ii) Confirm messages in “stdout“ output.
```
[root@fluent02 ~]# tail -100f /var/log/td-agent/td-agent.log

---------- Sample message ----------
2020-12-02 08:50:29.000000000 +0000 system.authpriv.info: {"host":"fluent02","ident":"sshd","pid":"2960","message":"Server listening on :: port 22."}
```

iii) Create sample script to read data from MongoDB.
```
[root@fluent02 mongo]# vim mongo_test.py
from pymongo import MongoClient
from bson.json_util import loads, dumps
import json

client = MongoClient('localhost', 27017)
db = client.rsyslog
collection = db.system
f = collection.find()
json_str = dumps(f)
print(json_str)
```
iv) Run sample script and confirm if same messages with “stdout“ are available.
```
[root@fluent02 mongo]# python3 mongo_test.py | jq

---------- Sample message ----------
    {
        "_id": {
            "$oid": "5fc7559b0bf9f80b84137e1f"
        },
            "host": "fluent02",
            "ident": "sshd",
            "pid": "2960",
            "message": "Server listening on :: port 22.",
            "time": {
                "$date": 1606899029000
            }
        }
    }
```

Now, upgrading steps are completed. Happy Logging!

*This blog was originall written by [kubotat](https://github.com/kubotat) in the [Fluentd Subscription Network](https://fluentd.ctc-america.com/blog/how-to-upgrade-td-agent).*

TAG: Fluentd td-agent
AUTHOR: hisa-tanaka
