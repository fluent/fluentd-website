# Update the GPG key for Treasure Agent

Hi folks,

This article is for Treasure Agent users.

We have updated Treasure Agent's GPG key for deb/rpm to drop deprecated SHA1 based signing.
It means you need to update imported old GPG key before td-agent update.

If new deployment or if you disable gpg check, no need update action.

Here is an update steps for deb and rpm.

## deb

### Remove old GPG key

```
% apt-key del A12E206F
```

### Import new GPG key

```
% curl -O https://packages.treasuredata.com/GPG-KEY-td-agent
% apt-key add GPG-KEY-td-agent
```

You can check imported is succeeded or not.

```
% apt-key list
```

### Error content

Here is error example with old GPG key

```txt
W: GPG error: http://packages.treasuredata.com/2/ubuntu/xenial xenial InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 901F9177AB97ACBE
```

## rpm

### Remove old GPG key

If you found this key in rpm, remove it by following command:

```
% rpm -e --allmatches "gpg-pubkey-a12e206f-*"
```

### Imoprt new GPG key

Import by `rpm import`

```
% rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent
```

You can check imported is succeeded or not.

```
% rpm -qi "gpg-pubkey-ab97acbe-*"
```

### Error content

Here is error example with old GPG key

```txt
The GPG keys listed for the "TreasureData" repository are already installed but they are not correct for this package.
Check that the correct key URLs are configured for this repository.


 Failing package is: td-agent-2.3.4-0.el7.x86_64
 GPG Keys are configured as: https://packages.treasuredata.com/GPG-KEY-td-agent
```


TAG: Fluentd td-agent Announcement
AUTHOR: masa
