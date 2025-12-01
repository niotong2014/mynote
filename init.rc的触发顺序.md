很久之前一直差不多搞清楚来触发顺序，不过后来又忘了。先来看下我自己开发板的init.rc的内容吧

```
# Copyright (C) 2012 The Android Open Source Project
#
# IMPORTANT: Do not create world writable files or directories.
# This is a common source of Android security bugs.
#

import /init.environ.rc
import /init.usb.rc
import /init.${ro.hardware}.rc
import /init.${ro.zygote}.rc
import /init.trace.rc

on early-init

on init

on property:sys.boot_from_charger_mode=1
    class_stop charger
    trigger late-init

on late-init
    trigger early-fs
    trigger fs
    trigger post-fs
    trigger post-fs-data
    trigger load_all_props_action
    trigger firmware_mounts_complete
    trigger early-boot
    trigger boot


on post-fs

on post-fs-data


on boot

on property:vold.decrypt=trigger_post_fs_data
    trigger post-fs-data


```
大部分内容被我精简了。可以肯定的先触发early-init  依次 init  然后由于sys.boot_from_charger_mode属性值被改变，就被会触发，然后late-init  在late-init中依次触发early-fs   fs   post-fs post-fs-data  load_all_props_action(猜测应该是读取prop.build这些文件将所以系统属性加载) firmware_mounts_complete（这个不太清楚） early-boot boot  。所以boot应该是最后被触发的。所以如果你干什么可以根据触发顺序来搞。比如如果你开机后执行一个脚本可以这样在init.rc中添加

```
service service_demo /system/bin/demo.sh
    disabled
    oneshot
```
然后 在某个地方添加start service_demo,因为没有添加 class main（core）等所以默认class default.因为添加了disabled所以必须通过start service_demo来触发。
