
```
1、init.rc是一个可配置的初始化文件,通常定制厂商可以配置额外的初始化配置，init.%PRODUCT%.rc
2、init.rc是在$GINGERBREAD/system/core/init/init.c中读取的,它基于“行”，包含一些用空格隔开的关键字（它属于特殊字符）
3、如果关键字中有空格，处理方法类似于C语言，使用/表示转义，使用“”防止关键字被断开，另外注意/在末尾表示换行
4、#开头的表示注释
5、init.rc包含4种状态类别：Actions/Commands/Services/Options
6、当声明一个service或者action的时候，它将隐式声明一个section，它之后跟随的command或者option都将属于这个section
7、action和service不能重名，否则忽略为error
8、actions就是在某种条件下触发一系列的命令，通常有一个trigger，形式如：
on <trigger>
     <command>
     <command>
9、service结构如下：
service <name> <pathname> [ <argument> ]*
     <option>
     <option>
10、option是service的修饰词，主要包括：
   critical  
   表示如果服务在4分钟内存在多于4次，则系统重启到recovery mode
   disabled  
   表示服务不会自动启动，需要手动调用名字启动
   setEnv <name> <value>  
   设置启动环境变量
   socket <name> <type> <permission> [<user> [<group>]] 
   开启一个unix域的socket，名字为/dev/socket/<name> , <type>只能是dgram或者stream,<user>和<group>默认为0
   user <username> 
   表示将用户切换为<username>,用户名已经定义好了，只能是system/root
   group <groupname> 
   表示将组切换为<groupname>
   oneshot 
   表示这个service只启动一次
   class <name> 
   指定一个要启动的类，这个类中如果有多个service，将会被同时启动。默认的class将会是“default”
   onrestart 
   在重启时执行一条命令
11、trigger主要包括：
   boot 
   当/init.conf加载完毕时
   <name>=<value> 
   当<name>被设置为<value>时
   device-added-<path> 
   设备<path>被添加时
   device-removed-<path> 
   设备<path>被移除时
   service-exited-<name> 
   服务<name>退出时
12、命令主要包括：
   exec <path> [ <argument> ]*
   执行一个<path>指定的程序
   export <name> <value>
   设置一个全局变量
   ifup <interface>
   使网络接口<interface>连接
   import <filename>
   引入其他的配置文件
   hostname <name>
   设置主机名
   chdir <directory>
   切换工作目录
   chmod <octal-mode> <path>
   设置访问权限
   chown <owner> <group> <path>
   设置用户和组
 
   chroot <directory>
   设置根目录
   class_start <serviceclass>
   启动类中的service
   class_stop <serviceclass>
   停止类中的service
   domainname <name>
   设置域名
   insmod <path>
   安装模块
   mkdir <path> [mode] [owner] [group]
   创建一个目录，并可以指定权限，用户和组
   mount <type> <device> <dir> [ <mountoption> ]*
   加载指定设备到目录下
   <mountoption> 包括"ro", "rw", "remount", "noatime"
   setprop <name> <value>
   设置系统属性
   setrlimit <resource> <cur> <max>
   设置资源访问权限
   start <service>
   开启服务
   stop <service>
   停止服务
   symlink <target> <path>
   创建一个动态链接
   sysclktz <mins_west_of_gmt>
   设置系统时钟
   trigger <event>
   触发事件
   write <path> <string> [ <string> ]*
   向<path>路径的文件写入多个<string>
```

```
1# Copyright (C) 2012 The Android Open Source Project
2# Copyright (C) 
3# Copyright (C) 
4#
5# IMPORTANT: Do not create world writable files or directories.
6# This is a common source of Android security bugs.
7#
8
9import /init.${ro.hardware}.rc  //import <filename> : 包含其他的*.rc，类似include
10import /init.usb.rc
11import /init.trace.rc
12
13on early-init     //最先做 其中的action， 开始early-init 段
14    # Set init and its forked children's oom_adj.
15    write /proc/1/oom_adj -16  //直接写入procfs
16
17    start ueventd   //启动一个服务，注意ueventd 必须是一个service,在359行有定义
18
19# create mountpoints
20    mkdir /mnt 0775 root system //创建目录，具体用法与shell中的mkdir命令一样
21
22on init  //开始init段，其中的action在 early-init,property-init后执行
23
24sysclktz 0  //设置系统时钟，如果是0表示用GMT的时钟ticks
25
26loglevel 3  //log的输出级别［0，7］，控制的kernel的log输出
27
28# setup the global environment 
29    export PATH /sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin  //export,shell命令，设置全局环境变量
30    export LD_LIBRARY_PATH /vendor/lib:/system/lib
31    export ANDROID_BOOTLOGO 1
32    export ANDROID_ROOT /system
33    export ANDROID_ASSETS /system/app
34    export ANDROID_DATA /data
35    export ASEC_MOUNTPOINT /mnt/asec
36    export LOOP_MOUNTPOINT /mnt/obb
37    export BOOTCLASSPATH /system/framework/core.jar:/system/framework/core-junit.jar:/system/framework/bouncycastle.jar:/system/framework/ext.jar:/system/framework/framework.jar:/system/framework/framework_ext.jar:/system/framework/android.policy.jar:/system/framework/services.jar:/system/framework/apache-xml.jar
38
39# Backward compatibility
40    symlink /system/etc /etc  //创建一个指向/system/etc的软连接/etc, 也就是/etc目录实际上指向/system/etc
41    symlink /sys/kernel/debug /d
42
43# Right now vendor lives on the same filesystem as system,
44# but someday that may change.
45    symlink /system/vendor /vendor
46
47# Create cgroup mount point for cpu accounting
48    mkdir /acct
49    mount cgroup none /acct cpuacct //mount <type> <device> <dir> ［mountoption］ 把device(none)挂载到type为cgroup 的文件系统/acct下
                                      //其中<device>可以是以mtd@name形式指定的一个mtd块设备. mountoption可以是mode=0755,gid=1000
50    mkdir /acct/uid
51
52    mkdir /system
53    mkdir /data 0771 system system
54    mkdir /cache 0770 system cache
55    mkdir /config 0500 root root
56
57    # Directory for putting things only root should see.
58    mkdir /mnt/secure 0700 root root
59
60    # Directory for staging bindmounts
61    mkdir /mnt/secure/staging 0700 root root
62
63    # Directory-target for where the secure container
64    # imagefile directory will be bind-mounted
65    mkdir /mnt/secure/asec  0700 root root
66
67    # Secure container public mount points.
68    mkdir /mnt/asec  0700 root system
69    mount tmpfs tmpfs /mnt/asec mode=0755,gid=1000
70
71    # Filesystem image public mount points.
72    mkdir /mnt/obb 0700 root system
73    mount tmpfs tmpfs /mnt/obb mode=0755,gid=1000
74
75    write /proc/sys/kernel/panic_on_oops 1
76    write /proc/sys/kernel/hung_task_timeout_secs 0
77    write /proc/cpu/alignment 4
78    write /proc/sys/kernel/sched_latency_ns 10000000
79    write /proc/sys/kernel/sched_wakeup_granularity_ns 2000000
80    write /proc/sys/kernel/sched_compat_yield 1
81    write /proc/sys/kernel/sched_child_runs_first 0
82    write /proc/sys/kernel/randomize_va_space 2
83    write /proc/sys/kernel/kptr_restrict 2
84    write /proc/sys/kernel/dmesg_restrict 1
85    write /proc/sys/vm/mmap_min_addr 32768
86    write /proc/sys/kernel/sched_rt_runtime_us 950000
87    write /proc/sys/kernel/sched_rt_period_us 1000000
88
89# Create cgroup mount points for process groups
90    mkdir /dev/cpuctl
91    mount cgroup none /dev/cpuctl cpu
92    chown system system /dev/cpuctl   //改变目录（/dev/cpuctl）的使用群体为system
93    chown system system /dev/cpuctl/tasks
94    chmod 0660 /dev/cpuctl/tasks      //改变文件（/dev/cpuctl/tasks）的使用权限为0660
95    write /dev/cpuctl/cpu.shares 1024
96    write /dev/cpuctl/cpu.rt_runtime_us 950000
97    write /dev/cpuctl/cpu.rt_period_us 1000000
98
99    mkdir /dev/cpuctl/apps
100    chown system system /dev/cpuctl/apps/tasks
101    chmod 0666 /dev/cpuctl/apps/tasks
102    write /dev/cpuctl/apps/cpu.shares 1024
103    write /dev/cpuctl/apps/cpu.rt_runtime_us 800000
104    write /dev/cpuctl/apps/cpu.rt_period_us 1000000
105
106    mkdir /dev/cpuctl/apps/bg_non_interactive
107    chown system system /dev/cpuctl/apps/bg_non_interactive/tasks
108    chmod 0666 /dev/cpuctl/apps/bg_non_interactive/tasks
109    # 5.0 %
110    write /dev/cpuctl/apps/bg_non_interactive/cpu.shares 52
111    write /dev/cpuctl/apps/bg_non_interactive/cpu.rt_runtime_us 700000
112    write /dev/cpuctl/apps/bg_non_interactive/cpu.rt_period_us 1000000
113
114# Allow everybody to read the xt_qtaguid resource tracking misc dev.
115# This is needed by any process that uses socket tagging.
116    chmod 0644 /dev/xt_qtaguid
117
118on fs  //??????
119# mount mtd partitions
120    # Mount /system rw first to give the filesystem a chance to save a checkpoint
121    mount yaffs2 mtd@system /system
122    mount yaffs2 mtd@system /system ro remount
123    mount yaffs2 mtd@userdata /data nosuid nodev
124    mount yaffs2 mtd@cache /cache nosuid nodev
125
126on post-fs
127    # once everything is setup, no need to modify /
128    mount rootfs rootfs / ro remount
129
130    # We chown/chmod /cache again so because mount is run as root + defaults
131    chown system cache /cache
132    chmod 0770 /cache
133
134    # This may have been created by the recovery system with odd permissions
135    mkdir /cache/recovery
136    chown system cache /cache/recovery
137    chmod 0770 /cache/recovery
138
139    #change permissions on vmallocinfo so we can grab it from bugreports
140    chown root log /proc/vmallocinfo
141    chmod 0440 /proc/vmallocinfo
142
143    #change permissions on kmsg & sysrq-trigger so bugreports can grab kthread stacks
144    chown root system /proc/kmsg
145    chmod 0440 /proc/kmsg
146    chown root system /proc/sysrq-trigger
147    chmod 0220 /proc/sysrq-trigger
148
149    # create the lost+found directories, so as to enforce our permissions
150    # Moved to init.target.rc in the Sony product git
151    # mkdir /cache/lost+found 0770 root root
152
153on post-fs-data
154    # We chown/chmod /data again so because mount is run as root + defaults
155    chown system system /data
156    chmod 0771 /data
157
158    # Create dump dir and collect dumps.
159    # Do this before we mount cache so eventually we can use cache for
160    # storing dumps on platforms which do not have a dedicated dump partition.
161    mkdir /data/dontpanic 0750 root log
162
163    # Collect apanic data, free resources and re-arm trigger
164    copy /proc/apanic_console /data/dontpanic/apanic_console
165    chown root log /data/dontpanic/apanic_console
166    chmod 0640 /data/dontpanic/apanic_console
167
168    copy /proc/apanic_threads /data/dontpanic/apanic_threads
169    chown root log /data/dontpanic/apanic_threads
170    chmod 0640 /data/dontpanic/apanic_threads
171
172    write /proc/apanic_console 1
173
174    # create basic filesystem structure
175    mkdir /data/misc 01771 system misc
176    mkdir /data/misc/bluetoothd 0770 bluetooth bluetooth
177    mkdir /data/misc/bluetooth 0770 system system
178    mkdir /data/misc/keystore 0700 keystore keystore
179    mkdir /data/misc/keychain 0771 system system
180    mkdir /data/misc/vpn 0770 system vpn
181    mkdir /data/misc/systemkeys 0700 system system
182    # give system access to wpa_supplicant.conf for backup and restore
183    mkdir /data/misc/wifi 0770 wifi wifi
184    chmod 0660 /data/misc/wifi/wpa_supplicant.conf
185    mkdir /data/local 0751 root root
186    chmod 2770 /data/radio
187
188    # For security reasons, /data/local/tmp should always be empty.
189    # Do not place files or directories in /data/local/tmp
190    mkdir /data/local/tmp 0771 shell shell
191    mkdir /data/data 0771 system system
192    mkdir /data/app-private 0771 system system
193    mkdir /data/app-asec 0700 root root
194    mkdir /data/app 0771 system system
195    mkdir /data/property 0700 root root
196    mkdir /data/ssh 0750 root shell
197    mkdir /data/ssh/empty 0700 root root
198
199    # create dalvik-cache, so as to enforce our permissions
200    mkdir /data/dalvik-cache 0771 system system
201
202    # create resource-cache and double-check the perms
203    mkdir /data/resource-cache 0771 system system
204    chown system system /data/resource-cache
205    chmod 0771 /data/resource-cache
206
207    # create the lost+found directories, so as to enforce our permissions
208    # Moved to init.target.rc in the Sony product git
209    # mkdir /data/lost+found 0770 root root
210
211    # create directory for DRM plug-ins - give drm the read/write access to
212    # the following directory.
213    mkdir /data/drm 0770 drm drm
214
215    # If there is no fs-post-data action in the init.<device>.rc file, you
216    # must uncomment this line, otherwise encrypted filesystems
217    # won't work.
218    # Set indication (checked by vold) that we have finished this action
219    #setprop vold.post_fs_data_done 1
220
221on boot //开始boot段，其中的action在 early-init,property-init,init后执行
222# basic network init
223    ifup lo                 //启动网路接口 lo, 但lo是啥接口？
224    hostname localhost      //设置手机主机名为localhost
225    domainname localdomain  //设置域名localdomain
226
227# set RLIMIT_NICE to allow priorities from 19 to -20
228    setrlimit 13 40 40
229
230# Memory management.  Basic kernel parameters, and allow the high
231# level system server to be able to adjust the kernel OOM driver
232# parameters to match how it is managing things.
233    write /proc/sys/vm/overcommit_memory 1
234    write /proc/sys/vm/min_free_order_shift 4
235    chown root system /sys/module/lowmemorykiller/parameters/adj
236    chmod 0664 /sys/module/lowmemorykiller/parameters/adj
237    chown root system /sys/module/lowmemorykiller/parameters/minfree
238    chmod 0664 /sys/module/lowmemorykiller/parameters/minfree
239
240    # Tweak background writeout
241    write /proc/sys/vm/dirty_expire_centisecs 200
242    write /proc/sys/vm/dirty_background_ratio  5
243
244    # Permissions for System Server and daemons.
245    chown radio system /sys/android_power/state
246    chown radio system /sys/android_power/request_state
247    chown radio system /sys/android_power/acquire_full_wake_lock
248    chown radio system /sys/android_power/acquire_partial_wake_lock
249    chown radio system /sys/android_power/release_wake_lock
250    chown system system /sys/power/state
251    chown system system /sys/power/autosleep
252    chown system system /sys/power/wakeup_count
253    chown radio system /sys/power/wake_lock
254    chown radio system /sys/power/wake_unlock
255    chmod 0660 /sys/power/state
256    chmod 0660 /sys/power/wake_lock
257    chmod 0660 /sys/power/wake_unlock
258
259    chown system system /sys/devices/system/cpu/cpufreq/interactive/timer_rate
260    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/timer_rate
261    chown system system /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
262    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
263    chown system system /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
264    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
265    chown system system /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
266    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
267    chown system system /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
268    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
269    chown system system /sys/devices/system/cpu/cpufreq/interactive/boost
270    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/boost
271    chown system system /sys/devices/system/cpu/cpufreq/interactive/boostpulse
272    chown system system /sys/devices/system/cpu/cpufreq/interactive/input_boost
273    chmod 0660 /sys/devices/system/cpu/cpufreq/interactive/input_boost
274
275    # Assume SMP uses shared cpufreq policy for all CPUs
276    chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
277    chmod 0660 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
278
279    chown system system /sys/class/timed_output/vibrator/enable
280    chown system system /sys/class/leds/keyboard-backlight/brightness
281    chown system system /sys/class/leds/lcd-backlight/brightness
282    chown system system /sys/class/leds/button-backlight/brightness
283    chown system system /sys/class/leds/jogball-backlight/brightness
284    chown system system /sys/class/leds/red/brightness
285    chown system system /sys/class/leds/green/brightness
286    chown system system /sys/class/leds/blue/brightness
287    chown system system /sys/class/leds/red/device/grpfreq
288    chown system system /sys/class/leds/red/device/grppwm
289    chown system system /sys/class/leds/red/device/blink
290    chown system system /sys/class/leds/red/brightness
291    chown system system /sys/class/leds/green/brightness
292    chown system system /sys/class/leds/blue/brightness
293    chown system system /sys/class/leds/red/device/grpfreq
294    chown system system /sys/class/leds/red/device/grppwm
295    chown system system /sys/class/leds/red/device/blink
296    chown system system /sys/class/timed_output/vibrator/enable
297    chown system system /sys/module/sco/parameters/disable_esco
298    chown system system /sys/kernel/ipv4/tcp_wmem_min
299    chown system system /sys/kernel/ipv4/tcp_wmem_def
300    chown system system /sys/kernel/ipv4/tcp_wmem_max
301    chown system system /sys/kernel/ipv4/tcp_rmem_min
302    chown system system /sys/kernel/ipv4/tcp_rmem_def
303    chown system system /sys/kernel/ipv4/tcp_rmem_max
304    chown root radio /proc/cmdline
305
306# Define TCP buffer sizes for various networks
307#   ReadMin, ReadInitial, ReadMax, WriteMin, WriteInitial, WriteMax,
308    setprop net.tcp.buffersize.default 4096,87380,110208,4096,16384,110208
309    setprop net.tcp.buffersize.wifi    524288,1048576,2097152,262144,524288,1048576
310    setprop net.tcp.buffersize.lte     524288,1048576,2097152,262144,524288,1048576
311    setprop net.tcp.buffersize.umts    4094,87380,110208,4096,16384,110208
312    setprop net.tcp.buffersize.hspa    4094,87380,1220608,4096,16384,1220608
313    setprop net.tcp.buffersize.hsupa   4094,87380,1220608,4096,16384,1220608
314    setprop net.tcp.buffersize.hsdpa   4094,87380,1220608,4096,16384,110208
315    setprop net.tcp.buffersize.hspap   4094,87380,2097152,4096,16384,1220608
316    setprop net.tcp.buffersize.edge    4093,26280,35040,4096,16384,35040
317    setprop net.tcp.buffersize.gprs    4092,8760,11680,4096,8760,11680
318    setprop net.tcp.buffersize.evdo_b  4094,87380,262144,4096,16384,262144
319
320# Assign TCP buffer thresholds to be ceiling value of technology maximums
321# Increased technology maximums should be reflected here.
322    write /proc/sys/net/core/rmem_max  2097152
323    write /proc/sys/net/core/wmem_max  1220608
324
325# Set this property so surfaceflinger is not started by system_init
326    setprop system_init.startsurfaceflinger 0
327
328    class_start core  //如果所有的class类别为core 的服务没有运行，则马上启动它们
329    class_start main
330
331on nonencrypted
332    class_start late_start
333
334on charger
335    class_start charger
336
337on property:vold.decrypt=trigger_reset_main
338    class_reset main
339
340on property:vold.decrypt=trigger_load_persist_props
341    load_persist_props
342
343on property:vold.decrypt=trigger_post_fs_data
344    trigger post-fs-data   //触发一个事件post-fs-data， 该事件是用on post-fs-data定义的，位于后面
345
346on property:vold.decrypt=trigger_restart_min_framework
347    class_start main
348
349on property:vold.decrypt=trigger_restart_framework
350    class_start main
351    class_start late_start
352
353on property:vold.decrypt=trigger_shutdown_framework
354    class_reset late_start
355    class_reset main
356
357## Daemon processes to be run by init.
358##
359service ueventd /sbin/ueventd  //表示service段，语法: service <服务名字> <服务对应的执行文件>; 声明服务名字为ueventd的服务，其具体执行路径
                                  //为/sbin/ueventd
360    class core                 //表示属于class 类别为core 的服务,如果没有设置，则表示该服务的默认类别为default
361    critical                   //
362
363service console /system/bin/sh
364    class core
365    console
366    disabled
367    user shell
368    group log
369
370on property:ro.debuggable=1    //如果用setprop命令设置属性 ro.debuggable变成1,则触发下面的start console
371    start console
372
373# adbd is controlled via property triggers in init.<platform>.usb.rc
374service adbd /sbin/adbd
375    class core
376    disabled      //该服务不能通过启动一类服务来启动，比如 class_start core来启动，只能以单独的名字来启动 start adbd.
377
378# adbd on at boot in emulator
379on property:ro.kernel.qemu=1
380    start adbd
381
382service servicemanager /system/bin/servicemanager
383    class core
384    user system        //在该服务启动前，把用户名切换到 system,默认是root
385    group system       //在该服务启动前，把组名切换到 system.
386    critical           //说明该服务是个对于设备很关键的服务，如果4分钟内退出大于4次，则系统将重启并进入recovery恢复模式
387    onrestart exec /system/bin/sync  //当该服务重启时，执行后面的命令 exec
                                     //exec创建和执行一个程序（/system/bin/sync），在程序完全执行完之前，init会被阻塞。所以极有可能引起init卡死
388    onrestart write /proc/sysrq-trigger c
389
390service vold /system/bin/vold
391    class core
392    socket vold stream 0660 root mount //语法：socket <name> <type> <perm> <user> <group>, 创建一个名字为vold<name>,类别为stream<type>
                                          //访问权限为0660<perm> 用户为root,用户组为mount
393    ioprio be 2
394
395service netd /system/bin/netd
396    class main
397    socket netd stream 0660 root system
398    socket dnsproxyd stream 0660 root inet
399    socket mdns stream 0660 root system
400
401service debuggerd /system/bin/debuggerd
402    class main
403
404service ril-daemon /system/bin/rild
405    class main
406    socket rild stream 660 root radio
407    socket rild-debug stream 660 radio system
408    user root
409    group radio cache inet misc audio sdcard_r sdcard_rw qcom_oncrpc diag qcom_diag log
410
411service surfaceflinger /system/bin/surfaceflinger
412    class main
413    user system
414    group graphics
415    onrestart exec /system/bin/sync
416    onrestart write /proc/sysrq-trigger c
417
418service zygote /system/bin/app_process -Xzygote /system/bin --zygote --start-system-server
419    class main
420    socket zygote stream 660 root system
421    onrestart exec /system/bin/sync
422    onrestart write /proc/sysrq-trigger c
423
424service drm /system/bin/drmserver
425    class main
426    user drm
427    group drm system inet drmrpc sdcard_r
428
429service media /system/bin/mediaserver
430    class main
431    user media
432    group system audio camera inet net_bt net_bt_admin net_bw_acct drmrpc input qcom_diag
433    ioprio rt 4
434
435service bootanim /system/bin/bootanimation
436    class main
437    user graphics
438    group graphics
439    disabled
440    oneshot    //该服务只启动一次，退出后不再运行
441
442service dbus /system/bin/dbus-daemon --system --nofork
443    class main
444    socket dbus stream 660 bluetooth bluetooth
445    user bluetooth
446    group bluetooth net_bt_admin
447
448service bluetoothd /system/bin/logwrapper /system/bin/bluetoothd -n
449    class main
450    socket bluetooth stream 660 bluetooth bluetooth
451    socket dbus_bluetooth stream 660 bluetooth bluetooth
452    # init.rc does not yet support applying capabilities, so run as root and
453    # let bluetoothd drop uid to bluetooth with the right linux capabilities
454    group bluetooth net_bt_admin misc
455    disabled
456
457service installd /system/bin/installd
458    class main
459    socket installd stream 600 system system
460
461service flash_recovery /system/etc/install-recovery.sh
462    class main
463    oneshot
464
465service racoon /system/bin/racoon
466    class main
467    socket racoon stream 600 system system
468    # IKE uses UDP port 500. Racoon will setuid to vpn after binding the port.
469    group vpn net_admin inet
470    disabled
471    oneshot
472
473service mtpd /system/bin/mtpd
474    class main
475    socket mtpd stream 600 system system
476    user vpn
477    group vpn net_admin inet net_raw
478    disabled
479    oneshot
480
481service keystore /system/bin/keystore /data/misc/keystore
482    class main
483    user keystore
484    group keystore drmrpc
485    socket keystore stream 666
486
487service dumpstate /system/bin/dumpstate -s
488    class main
489    socket dumpstate stream 0660 shell log
490    disabled
491    oneshot
492
493service sshd /system/bin/start-ssh
494    class main
495    disabled
496
497service mdnsd /system/bin/mdnsd
498    class main
499    user mdnsr
500    group inet net_raw
501    socket mdnsd stream 0660 mdnsr inet
502    disabled
503    oneshot
504

```

[init.rc语法介绍](http://blog.csdn.net/champgauss/article/details/8373172)
[实例分析init.rc的语法](http://blog.csdn.net/pillarbuaa/article/details/9023603)
