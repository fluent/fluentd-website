# Upgrade to fluent-package v5

`fluent-package` "v5" is available since August 2023.
`fluent-package` is the successor of `td-agent` "v4".

In this post, we will share the steps we've tested and hopefully this will help your experience from v4 to v5.

## Why package was renamed?

`fluent-package` was formerly known as `td-agent`.
In the past, [Treasure Data, Inc](http://www.treasuredata.com/) took the initiative to provide the package, but now the Fluentd community does it. This is why the package name was changed.

To represent "All in one package of Fluentd which contains Fluentd and related gem packages", the package name was changed to `fluent-package`.

Even though package name was changed, Treasure Data, Inc still sponsor the package delivery resources.

## Which channel should I use?

There are two channels for `fluent-package`.

* Normal release version
* Long Term Support version

One is normal release version which will be updated regularly - rapid release development style (`td-agent v4` was released like this in almost every quarter).
In this version, fluentd will be eventually updated to newer minor version (e.g. 1.17.x and so on)

The other is a more conservative maintenance version (Long Term Support) which will not introduce a new feature. It only applies teeny update such as
security or bug fix only. LTS for v5 will be supported until March, 2025.

More details about difference between normal release version and LTS version will be explained in [Scheduled support lifecycle announcement about Fluent Package](fluent-package-scheduled-lifecycle).

## Differences between td-agent v4 and fluent-package v5

In the `fluent-package` v5, core components like ruby (2.7.8 -> 3.2.2) and OpenSSL (1.1.1 -> 3.1.0 for Windows, 3.0.8 for macOS) were updated.

The major changes are as follows.

* `td-agent` command is renamed to `fluentd`.
  * `$ td-agent --version` -> `$ fluentd --version`
* `td-agent-gem` command is renamed to `fluent-gem`.
  * `$ td-agent-gem list` -> `$ fluent-gem list`
* The service name for non-Windows `td-agent` is renamed to `fluentd`. 
  * `$ systemctl status td-agent` -> `$ systemctl status fluentd`

With the change of package name, install path, service name (e.g. /opt/fluent, fluentd.service) and so on were also changed.
Basically, for `td-agent` v4 users, it aims to keep compatibility as far as possible by executing the migration process with copying old files or providing
symbolic links for it.

If you want to know the details of upgraded components, see [CHANGELOG.md](https://github.com/fluent/fluent-package-builder/blob/master/CHANGELOG.md#release-v500---20230729).

NOTE: We explain for platform specific issue as "Additional hints for v4 users" section below.

## Upgrade steps

During the upgrade process, plugins bundled in `td-agent` are automatically upgraded. With that being said, other plugins added on your own are not included. You should review if you need to upgrade plugins since some directory structures from v4 and v5 are changed.

In this post, I will show steps with plugins added on my own, **"fluent-plugin-concat"** for instance. Here is sample configuration file I used through steps.

```
<filter docker.log>
  @type concat
  key message
  multiline_start_regexp /^Start/
</filter>
```

### 1. Review what plugins are installed together with td-agent v4.

```
$ td-agent-gem list | grep fluent-plugin*
fluent-plugin-calyptia-monitoring (0.1.3)
fluent-plugin-concat (2.5.0)
fluent-plugin-elasticsearch (5.3.0)
fluent-plugin-flowcounter-simple (0.1.0)
fluent-plugin-kafka (0.19.0)
fluent-plugin-metrics-cmetrics (0.1.2)
fluent-plugin-opensearch (1.1.0)
fluent-plugin-prometheus (2.0.3)
fluent-plugin-prometheus_pushgateway (0.1.0)
fluent-plugin-record-modifier (2.1.1)
fluent-plugin-rewrite-tag-filter (2.4.0)
fluent-plugin-s3 (1.7.2)
fluent-plugin-sd-dns (0.1.0)
fluent-plugin-systemd (1.0.5)
fluent-plugin-td (1.2.0)
fluent-plugin-utmpx (0.5.0)
fluent-plugin-webhdfs (1.5.0)
```

You can also find installed plugins under `/opt/td-agent/lib/ruby/gems/2.7.0/gems/` directories.

```
$ ls -l /opt/td-agent/lib/ruby/gems/2.7.0/gems |grep fluent-plugin*
drwxr-xr-x. 5 root root  175  7月 14 03:01 fluent-plugin-calyptia-monitoring-0.1.3
drwxr-xr-x. 4 root root  206  7月 14 03:03 fluent-plugin-concat-2.5.0
drwxr-xr-x. 5 root root 4096  7月 14 03:01 fluent-plugin-elasticsearch-5.3.0
drwxr-xr-x. 4 root root  205  7月 14 03:01 fluent-plugin-flowcounter-simple-0.1.0
drwxr-xr-x. 6 root root  191  7月 14 03:01 fluent-plugin-kafka-0.19.0
drwxr-xr-x. 5 root root  190  7月 14 03:01 fluent-plugin-metrics-cmetrics-0.1.2
drwxr-xr-x. 5 root root 4096  7月 14 03:01 fluent-plugin-opensearch-1.1.0
drwxr-xr-x. 5 root root  215  7月 14 03:01 fluent-plugin-prometheus-2.0.3
drwxr-xr-x. 6 root root  238  7月 14 03:01 fluent-plugin-prometheus_pushgateway-0.1.0
drwxr-xr-x. 4 root root  176  7月 14 03:01 fluent-plugin-record-modifier-2.1.1
drwxr-xr-x. 3 root root  210  7月 14 03:01 fluent-plugin-rewrite-tag-filter-2.4.0
drwxr-xr-x. 5 root root  230  7月 14 03:01 fluent-plugin-s3-1.7.2
drwxr-xr-x. 3 root root  170  7月 14 03:01 fluent-plugin-sd-dns-0.1.0
drwxr-xr-x. 3 root root   49  7月 14 03:01 fluent-plugin-systemd-1.0.5
drwxr-xr-x. 5 root root  221  7月 14 03:01 fluent-plugin-td-1.2.0
drwxr-xr-x. 5 root root  166  7月 14 03:01 fluent-plugin-utmpx-0.5.0
drwxr-xr-x. 4 root root  191  7月 14 03:01 fluent-plugin-webhdfs-1.5.0
```

### 2. Stop td-agent v4 daemon.

```
$ sudo systemctl stop td-agent
```

Even though `fluent-package` supports upgrade without stopping service, but recommend to stop explicitly.

### 3. Run installation script of fluent-package v5.

When you use RedHat or derivative distributions, you can run following script if you want to install normal release version of `fluent-package`.

```
# curl -L https://toolbelt.treasuredata.com/sh/install-redhat-fluent-package5.sh | sh
```

When you use RedHat or derivative distributions, you can run following script if you want to install LTS (Long term support) version of `fluent-package`.

```
# curl -L https://toolbelt.treasuredata.com/sh/install-redhat-fluent-package5-lts.sh | sh
```

You can find more information about the installation script in [Fluentd Doc - Installation](https://docs.fluentd.org/installation).

### 4. Confirm if fluent-package v5 is properly installed.

```
$ LANG=C yum info fluent-package
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
Installed Packages
Name        : fluent-package
Arch        : x86_64
Version     : 5.0.0
Release     : 1.el7
Size        : 64 M
Repo        : installed
From repo   : /fluent-package-5.0.0-1.el7.x86_64
Summary     : The stable distribution of Fluentd
URL         : https://www.treasuredata.com/
License     : ASL 2.0
Description : The stable distribution of Fluentd, called td-agent.
```

### 5. Reload fluent-package daemon.

```
$ sudo systemctl daemon-reload
$ sudo systemctl enable --now fluentd
```

### 6. Check installed plugins. 

```
$ fluent-gem list |grep fluent-plugin*
fluent-plugin-calyptia-monitoring (0.1.3)
fluent-plugin-elasticsearch (5.3.0)
fluent-plugin-flowcounter-simple (0.1.0)
fluent-plugin-kafka (0.19.0)
fluent-plugin-metrics-cmetrics (0.1.2)
fluent-plugin-opensearch (1.1.0)
fluent-plugin-prometheus (2.0.3)
fluent-plugin-prometheus_pushgateway (0.1.0)
fluent-plugin-record-modifier (2.1.1)
fluent-plugin-rewrite-tag-filter (2.4.0)
fluent-plugin-s3 (1.7.2)
fluent-plugin-sd-dns (0.1.0)
fluent-plugin-systemd (1.0.5)
fluent-plugin-td (1.2.0)
fluent-plugin-utmpx (0.5.0)
fluent-plugin-webhdfs (1.5.0)
```

You can see bundled plugins are upgraded as well but can not find plugins added on your own. In this post, added plugin was "fluent-plugin-concat" and it is not shown in installed list.

### 7. Install plugins added on my own.

```
$ sudo fluent-gem install fluent-plugin-concat
```

```
$ fluent-gem list | grep fluent-plugin*
fluent-plugin-calyptia-monitoring (0.1.3)
fluent-plugin-concat (2.5.0)
fluent-plugin-elasticsearch (5.3.0)
fluent-plugin-flowcounter-simple (0.1.0)
fluent-plugin-kafka (0.19.0)
fluent-plugin-metrics-cmetrics (0.1.2)
fluent-plugin-opensearch (1.1.0)
fluent-plugin-prometheus (2.0.3)
fluent-plugin-prometheus_pushgateway (0.1.0)
fluent-plugin-record-modifier (2.1.1)
fluent-plugin-rewrite-tag-filter (2.4.0)
fluent-plugin-s3 (1.7.2)
fluent-plugin-sd-dns (0.1.0)
fluent-plugin-systemd (1.0.5)
fluent-plugin-td (1.2.0)
fluent-plugin-utmpx (0.5.0)
fluent-plugin-webhdfs (1.5.0)
```
 
As for fluent-package v5, "fluent-plugin-concat" was installed under "/opt/fluent/lib/ruby/gems/3.2.0/gems/" directories.
 
```
$ ls -l /opt/fluent/lib/ruby/gems/3.2.0/gems/ |grep fluent-plugin*
drwxr-xr-x.  5 root root  175  7月 14 03:14 fluent-plugin-calyptia-monitoring-0.1.3
drwxr-xr-x.  4 root root  206  7月 14 03:16 fluent-plugin-concat-2.5.0
drwxr-xr-x.  5 root root 4096  7月 14 03:14 fluent-plugin-elasticsearch-5.3.0
drwxr-xr-x.  4 root root  205  7月 14 03:14 fluent-plugin-flowcounter-simple-0.1.0
drwxr-xr-x.  6 root root  191  7月 14 03:14 fluent-plugin-kafka-0.19.0
drwxr-xr-x.  5 root root  190  7月 14 03:14 fluent-plugin-metrics-cmetrics-0.1.2
drwxr-xr-x.  5 root root 4096  7月 14 03:14 fluent-plugin-opensearch-1.1.0
drwxr-xr-x.  5 root root  215  7月 14 03:14 fluent-plugin-prometheus-2.0.3
drwxr-xr-x.  6 root root  238  7月 14 03:14 fluent-plugin-prometheus_pushgateway-0.1.0
drwxr-xr-x.  4 root root  176  7月 14 03:14 fluent-plugin-record-modifier-2.1.1
drwxr-xr-x.  3 root root  210  7月 14 03:14 fluent-plugin-rewrite-tag-filter-2.4.0
drwxr-xr-x.  5 root root  230  7月 14 03:14 fluent-plugin-s3-1.7.2
drwxr-xr-x.  3 root root  170  7月 14 03:14 fluent-plugin-sd-dns-0.1.0
drwxr-xr-x.  3 root root   49  7月 14 03:14 fluent-plugin-systemd-1.0.5
drwxr-xr-x.  5 root root  221  7月 14 03:14 fluent-plugin-td-1.2.0
drwxr-xr-x.  5 root root  166  7月 14 03:14 fluent-plugin-utmpx-0.5.0
drwxr-xr-x.  4 root root  191  7月 14 03:14 fluent-plugin-webhdfs-1.5.0
```

### 8. Start fluent-package v5 daemon.

```
$ sudo systemctl start fluentd
```

### 9. Check if there are no error messages in fluentd logs.

```
$ tail -100f /var/log/fluent/fluentd.log
```

Now, upgrading steps are completed. Happy Logging!

## Additional hints for v4 users

### For Debian/Ubuntu

* `fluentd-apt-source` package will be marked as a transitional package.
  you can remove it safely with `sudo apt purge fluentd-apt-source`.
* If you want to enable `td-agent.service`, you must explicitly execute the following commands:

  ```
  $ sudo systemctl unmask td-agent
  $ sudo systemctl enable fluentd
  ```

### For RHEL

* If you want to enable `td-agent.service`, you must explicitly execute the following command:

  ```
  $ sudo systemctl enable fluentd
  ```

### For Windows

* `fluent-package` installer was changed not to start service by default.
  If you want to start `fluentd` as a service, execute the following command with administrator privileges.

  ```
  c:\opt\fluent> net start fluentdwinsvc
  ```

### For macOS

WARNING: Currently we have no plan to officially support dmg version of `fluent-package` yet.
It is just modified to be a minimally buildable state, it is for testing purpose only.

TAG: Fluentd td-agent fluent-package Announcement reminder
AUTHOR: clearcode
