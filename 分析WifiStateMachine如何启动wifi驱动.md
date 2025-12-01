WifiStateMachine中通过mWifiNative.loadDriver()来加载驱动，loadDriver对应jni的一个native方法，grep搜索下结果如下

> ./opt/net/wifi/service/jni/com_android_server_wifi_WifiNative.cpp:1062:    { "loadDriver", "()Z",  (void *)android_net_wifi_loadDriver }

 ![grep结果](images/分析WifiStateMachine如何启动wifi驱动/1764576793406.png)

然后所有wifi_load_driver在hardware/libhardware_legacy/wifi/wifi.c中搜索到

![代码](images/分析WifiStateMachine如何启动wifi驱动/1764576874609.png)
从代码可以看出通过查看系统属性可以知道wifi现在所处的状态。
本质上wifi_load_driver是hal中的方法，而com_android_server_wifi_WifiNative.cpp能直接使用中间的细节没有去深究。

