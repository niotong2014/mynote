# A33 Android6.0开机时间优化记录

当前调试的是无pmu的a33开发板，目前使用秒表测试到的开机时间（非首次启动，从插电到看到launcher桌面）为28S。adb shell 然后执行ps看到信息如下：

```
USER      PID   PPID  VSIZE  RSS   WCHAN            PC  NAME
root      1     0     22964  560   sys_epoll_ 00071698 S /init
root      2     0     0      0       kthreadd 00000000 S kthreadd
root      3     2     0      0     run_ksofti 00000000 S ksoftirqd/0
root      6     2     0      0     cpu_stoppe 00000000 S migration/0
root      7     2     0      0     cpu_stoppe 00000000 S migration/1
root      9     2     0      0     run_ksofti 00000000 S ksoftirqd/1
root      10    2     0      0     cpu_stoppe 00000000 S migration/2
root      11    2     0      0     worker_thr 00000000 S kworker/2:0
root      12    2     0      0     run_ksofti 00000000 S ksoftirqd/2
root      13    2     0      0     cpu_stoppe 00000000 S migration/3
root      14    2     0      0     worker_thr 00000000 S kworker/3:0
root      15    2     0      0     run_ksofti 00000000 S ksoftirqd/3
root      16    2     0      0     rescuer_th 00000000 S cpuset
root      17    2     0      0     rescuer_th 00000000 S khelper
root      18    2     0      0      devtmpfsd 00000000 S kdevtmpfs
root      19    2     0      0     rescuer_th 00000000 S netns
root      20    2     0      0     rescuer_th 00000000 S suspend
root      21    2     0      0     rescuer_th 00000000 S sync_system_wor
root      23    2     0      0     worker_thr 00000000 S kworker/2:1
root      24    2     0      0     worker_thr 00000000 S kworker/3:1
root      25    2     0      0     worker_thr 00000000 S kworker/1:1
root      26    2     0      0     bdi_sync_s 00000000 S sync_supers
root      27    2     0      0     bdi_forker 00000000 S bdi-default
root      28    2     0      0     rescuer_th 00000000 S kblockd
root      29    2     0      0     ion_heap_d 00000000 S sytem
root      30    2     0      0     hub_thread 00000000 S khubd
root      31    2     0      0     rescuer_th 00000000 S cfg80211
root      34    2     0      0     rescuer_th 00000000 S rpciod
root      42    2     0      0         kswapd 00000000 S kswapd0
root      43    2     0      0     fsnotify_m 00000000 S fsnotify_mark
root      44    2     0      0     rescuer_th 00000000 S nfsiod
root      45    2     0      0     rescuer_th 00000000 S cifsiod
root      46    2     0      0     rescuer_th 00000000 S crypto
root      62    2     0      0          kapmd 00000000 S kapmd
root      70    2     0      0     rescuer_th 00000000 S f_mtp
root      71    2     0      0     sleep_thre 00000000 S file-storage
root      72    2     0      0     cpufreq_in 00000000 S cfinteractive
root      73    2     0      0     mmc_queue_ 00000000 S mmcqd/0
root      74    2     0      0     mmc_queue_ 00000000 S mmcqd/0boot0
root      75    2     0      0     mmc_queue_ 00000000 S mmcqd/0boot1
root      76    2     0      0     rescuer_th 00000000 S binder
root      78    2     0      0     rescuer_th 00000000 S switch_resume
root      79    2     0      0     rescuer_th 00000000 S codec_init
root      80    2     0      0     rfcomm_run 00000000 S krfcommd
root      81    2     0      0     rescuer_th 00000000 S deferwq
root      82    2     0      0     rescuer_th 00000000 S devfreq_wq
root      87    1     1708   256   poll_sched 000685e4 S /sbin/ueventd
root      91    2     0      0     kjournald2 00000000 S jbd2/mmcblk0p7-
root      92    2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      99    2     0      0     kjournald2 00000000 S jbd2/mmcblk0p10
root      100   2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      106   2     0      0     kjournald2 00000000 S jbd2/mmcblk0p15
root      107   2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      113   2     0      0     kjournald2 00000000 S jbd2/mmcblk0p1-
root      114   2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      119   2     0      0     down_inter 00000000 S xradio_etf
logd      120   1     10680  1660  sys_rt_sig b6e2fec4 S /system/bin/logd
root      127   2     0      0     kauditd_th 00000000 S kauditd
root      128   1     9400   1908  hrtimer_na b6c24a98 S /system/bin/vold
root      142   1     2460   332   sys_epoll_ 00037f38 S /sbin/healthd
root      145   1     3068   1084  sys_epoll_ b6f14c10 S /system/bin/lmkd
system    148   1     2692   980   binder_thr b6e6fd3c S /system/bin/servicemanager
system    151   1     59060  4508  sys_epoll_ b6d95c10 S /system/bin/surfaceflinger
system    152   1     4768   1364  hrtimer_na b6d74a98 S /system/bin/sayeye
root      161   1     1227484 51840 poll_sched b6c9edd8 S zygote
shell     164   1     3032   1100  n_tty_read b6e58bec S /system/bin/sh
root      165   1     14404  1792  hrtimer_na b6d0ba98 S /system/bin/netd
root      168   1     3096   1056  __skb_recv b6e3db74 S /system/bin/debuggerd
root      170   1     8160   1512  hrtimer_na b6dbda98 S /system/bin/rild
drm       174   1     15792  5524  binder_thr b6cf0d3c S /system/bin/drmserver
media     179   1     98320  16764 binder_thr b6a8ed3c S /system/bin/mediaserver
root      181   1     2744   1032  unix_strea b6e30bec S /system/bin/installd
keystore  185   1     6216   2216  binder_thr b6d46d3c S /system/bin/keystore
system    189   1     5272   1688  binder_thr b6d20d3c S /system/bin/gatekeeperd
root      195   1     2764   1060  hrtimer_na b6e04a98 S /system/xbin/perfprofd
root      201   1     5788   420   poll_sched 0002b314 S /sbin/adbd
root      235   2     0      0     worker_thr 00000000 S kworker/1:2
root      279   2     0      0     worker_thr 00000000 S kworker/0:2
system    557   161   1188768 70412 sys_epoll_ b6c9ec10 S system_server
media_rw  1096  128   6508   1772  inotify_re b6e89bec S /system/bin/sdcard
u0_a14    1104  161   693076 78800 sys_epoll_ b6c9ec10 S com.android.systemui
u0_a2     1503  161   625444 35192 sys_epoll_ b6c9ec10 S android.process.acore
u0_a36    1544  161   632296 38092 sys_epoll_ b6c9ec10 S com.android.inputmethod.latin
u0_a6     1553  161   667844 52100 sys_epoll_ b6c9ec10 S com.android.launcher3
u0_a46    1569  161   619900 27804 sys_epoll_ b6c9ec10 S com.android.printspooler
u0_a31    1622  161   627860 29268 sys_epoll_ b6c9ec10 S com.android.exchange
u0_a29    1638  161   639204 36036 sys_epoll_ b6c9ec10 S com.android.email
u0_a4     1675  161   625088 35380 sys_epoll_ b6c9ec10 S android.process.media
u0_a5     1680  161   617372 27016 sys_epoll_ b6c9ec10 S com.android.externalstorage
system    1723  161   624552 37088 sys_epoll_ b6c9ec10 S com.abupdate.fota_demo_iot
u0_a39    1740  161   619336 29684 sys_epoll_ b6c9ec10 S com.android.music
u0_a48    1763  161   619348 27764 sys_epoll_ b6c9ec10 S com.android.quicksearchbox
u0_a24    1798  161   622496 28516 sys_epoll_ b6c9ec10 S com.android.deskclock
system    1814  161   618480 26704 sys_epoll_ b6c9ec10 S com.android.keychain
radio     1821  161   641228 40608 sys_epoll_ b6c9ec10 S com.android.phone
u0_a50    1854  161   617116 26040 sys_epoll_ b6c9ec10 S com.android.smspush
system    1903  161   641212 28632 sys_epoll_ b6c9ec10 S com.android.settings
u0_a8     1919  161   617476 26540 sys_epoll_ b6c9ec10 S com.android.musicfx
root      1947  2     0      0     worker_thr 00000000 S kworker/0:0
root      1948  2     0      0     worker_thr 00000000 S kworker/u:1
root      1949  2     0      0     bdi_writeb 00000000 S flush-179:0
root      1950  2     0      0     worker_thr 00000000 S kworker/u:0
root      1953  2     0      0     worker_thr 00000000 S kworker/0:1
root      1954  2     0      0     worker_thr 00000000 S kworker/u:2
root      1965  201   3032   1096  sys_rt_sig b6e9fec4 S /system/bin/sh
root      1975  1965  2712   1008           0 b6e4dbec R ps
```

然后adb remount 然后adb shell 进系统先删软件

```
cd /system/app/
rm Galaxy4/ Gallery2/ PrintSpooler/   Email/  Exchange2/  DeskClock/ DragonAging/  DragonFire/ DragonPhone/ Music/  QuickSearchBox/  LatinIME/  -rf
cd /system/priv-app/
rm MusicFX/  OneTimeInitializer/  WallpaperCropper/ Contacts/  -rf
sync
```

优化完之后26S的启动时间，查看ps信息如下

```
USER      PID   PPID  VSIZE  RSS   WCHAN            PC  NAME
root      1     0     22964  728   sys_epoll_ 00071698 S /init
root      2     0     0      0       kthreadd 00000000 S kthreadd
root      3     2     0      0     run_ksofti 00000000 S ksoftirqd/0
root      4     2     0      0     worker_thr 00000000 S kworker/0:0
root      5     2     0      0     worker_thr 00000000 S kworker/u:0
root      6     2     0      0     cpu_stoppe 00000000 S migration/0
root      7     2     0      0     cpu_stoppe 00000000 S migration/1
root      8     2     0      0     worker_thr 00000000 S kworker/1:0
root      9     2     0      0     run_ksofti 00000000 S ksoftirqd/1
root      10    2     0      0     cpu_stoppe 00000000 S migration/2
root      11    2     0      0     worker_thr 00000000 S kworker/2:0
root      12    2     0      0     run_ksofti 00000000 S ksoftirqd/2
root      13    2     0      0     cpu_stoppe 00000000 S migration/3
root      14    2     0      0     worker_thr 00000000 S kworker/3:0
root      15    2     0      0     run_ksofti 00000000 S ksoftirqd/3
root      16    2     0      0     rescuer_th 00000000 S cpuset
root      17    2     0      0     rescuer_th 00000000 S khelper
root      18    2     0      0      devtmpfsd 00000000 S kdevtmpfs
root      19    2     0      0     rescuer_th 00000000 S netns
root      20    2     0      0     rescuer_th 00000000 S suspend
root      21    2     0      0     rescuer_th 00000000 S sync_system_wor
root      22    2     0      0     worker_thr 00000000 S kworker/0:1
root      23    2     0      0     worker_thr 00000000 S kworker/2:1
root      24    2     0      0     worker_thr 00000000 S kworker/3:1
root      25    2     0      0     worker_thr 00000000 S kworker/1:1
root      26    2     0      0     bdi_sync_s 00000000 S sync_supers
root      27    2     0      0     bdi_forker 00000000 S bdi-default
root      28    2     0      0     rescuer_th 00000000 S kblockd
root      29    2     0      0     ion_heap_d 00000000 S sytem
root      30    2     0      0     hub_thread 00000000 S khubd
root      31    2     0      0     rescuer_th 00000000 S cfg80211
root      34    2     0      0     rescuer_th 00000000 S rpciod
root      42    2     0      0         kswapd 00000000 S kswapd0
root      43    2     0      0     fsnotify_m 00000000 S fsnotify_mark
root      44    2     0      0     rescuer_th 00000000 S nfsiod
root      45    2     0      0     rescuer_th 00000000 S cifsiod
root      46    2     0      0     rescuer_th 00000000 S crypto
root      62    2     0      0          kapmd 00000000 S kapmd
root      63    2     0      0     worker_thr 00000000 S kworker/u:1
root      70    2     0      0     rescuer_th 00000000 S f_mtp
root      71    2     0      0     sleep_thre 00000000 S file-storage
root      72    2     0      0     cpufreq_in 00000000 S cfinteractive
root      73    2     0      0     mmc_queue_ 00000000 S mmcqd/0
root      74    2     0      0     mmc_queue_ 00000000 S mmcqd/0boot0
root      75    2     0      0     mmc_queue_ 00000000 S mmcqd/0boot1
root      76    2     0      0     rescuer_th 00000000 S binder
root      77    2     0      0     worker_thr 00000000 S kworker/u:2
root      78    2     0      0     rescuer_th 00000000 S switch_resume
root      79    2     0      0     rescuer_th 00000000 S codec_init
root      80    2     0      0     rfcomm_run 00000000 S krfcommd
root      81    2     0      0     rescuer_th 00000000 S deferwq
root      82    2     0      0     rescuer_th 00000000 S devfreq_wq
root      87    1     1708   408   poll_sched 000685e4 S /sbin/ueventd
root      91    2     0      0     kjournald2 00000000 S jbd2/mmcblk0p7-
root      92    2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      95    2     0      0     bdi_writeb 00000000 S flush-179:0
root      99    2     0      0     kjournald2 00000000 S jbd2/mmcblk0p10
root      100   2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      106   2     0      0     kjournald2 00000000 S jbd2/mmcblk0p15
root      107   2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      113   2     0      0     kjournald2 00000000 S jbd2/mmcblk0p1-
root      114   2     0      0     rescuer_th 00000000 S ext4-dio-unwrit
root      119   2     0      0     down_inter 00000000 S xradio_etf
logd      120   1     10424  1824  sys_rt_sig b6dfcec4 S /system/bin/logd
root      127   2     0      0     kauditd_th 00000000 S kauditd
root      128   1     9400   2212  hrtimer_na b6cdaa98 S /system/bin/vold
root      143   1     2460   332   sys_epoll_ 00037f38 S /sbin/healthd
root      146   1     3068   1080  sys_epoll_ b6eb9c10 S /system/bin/lmkd
system    149   1     2692   976   binder_thr b6e18d3c S /system/bin/servicemanager
system    154   1     60092  4624  sys_epoll_ b6df0c10 S /system/bin/surfaceflinger
system    155   1     4768   1304  hrtimer_na b6e30a98 S /system/bin/sayeye
root      161   1     1227484 51604 poll_sched b6cbcdd8 S zygote
shell     164   1     3032   1096  n_tty_read b6e87bec S /system/bin/sh
root      167   1     14148  1840  hrtimer_na b6ccfa98 S /system/bin/netd
root      168   1     3096   1052  __skb_recv b6e8db74 S /system/bin/debuggerd
root      173   1     8160   1444  hrtimer_na b6e22a98 S /system/bin/rild
drm       175   1     15792  5480  binder_thr b6d32d3c S /system/bin/drmserver
media     178   1     97808  16620 binder_thr b6a65d3c S /system/bin/mediaserver
root      180   1     2744   1028  unix_strea b6e1dbec S /system/bin/installd
keystore  186   1     6216   2036  binder_thr b6cf6d3c S /system/bin/keystore
system    192   1     5272   1692  binder_thr b6d9bd3c S /system/bin/gatekeeperd
root      193   1     2764   1060  hrtimer_na b6e60a98 S /system/xbin/perfprofd
root      198   2     0      0     worker_thr 00000000 S kworker/1:2
root      199   1     5532   248   poll_sched 0002b314 S /sbin/adbd
root      326   2     0      0     worker_thr 00000000 S kworker/0:2
root      390   2     0      0     bdi_writeb 00000000 S flush-253:0
system    556   161   1183168 67360 sys_epoll_ b6cbcc10 S system_server
media_rw  1095  128   6508   1744  inotify_re b6df8bec S /system/bin/sdcard
u0_a14    1106  161   692820 78612 sys_epoll_ b6cbcc10 S com.android.systemui
u0_a2     1497  161   624404 34588 sys_epoll_ b6cbcc10 S android.process.acore
u0_a6     1551  161   657796 46640 sys_epoll_ b6cbcc10 S com.android.launcher3
u0_a4     1596  161   624832 35380 sys_epoll_ b6cbcc10 S android.process.media
u0_a5     1601  161   617116 27100 sys_epoll_ b6cbcc10 S com.android.externalstorage
system    1639  161   618480 26688 sys_epoll_ b6cbcc10 S com.android.keychain
radio     1647  161   641228 40620 sys_epoll_ b6cbcc10 S com.android.phone
u0_a50    1680  161   617116 26036 sys_epoll_ b6cbcc10 S com.android.smspush
system    1708  161   641212 28740 sys_epoll_ b6cbcc10 S com.android.settings
root      1736  199   3032   1096  sys_rt_sig b6e5dec4 S /system/bin/sh
root      1746  1736  2712   1008           0 b6e9fbec R ps
```

然后删除PicoTts   BasicDreams  SoundRecorder  Calendar  Update/ webview  HTMLViewer  DownloadProviderUi  OpenWnn  PacProcessor
TeleService Telecom  TelephonyProvider CalendarProvider ContactsProvider  MmsService  DownloadProvider   VpnDialogs
删掉上面这些之后启动时间25.72S

