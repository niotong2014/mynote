# QT的环境变量
**qt**和**eglfs**   **linuxfb** **directfb** **wayland**等的关系可以自行百度，这个链接我看可以https://www.jianshu.com/p/99e620c678dc ，根据之前A40I的经验，运行qt应用之前需要先配置qt的环境。一下为A40I的环境配置


```
export  QTDIR=/usr/local/Qt-5.9.0/                                                                                                                                                                             
export  QT_ROOT=$QTDIR
export  PATH=$QTDIR/bin:$PATH


export  LD_LIBRARY_PATH=$QTDIR/lib:/usr/lib/cedarx/:$LD_LIBRARY_PATH


export QT_QPA_PLATFORM_PLUGIN_PATH=$QT_ROOT/plugins
export QT_QPA_PLATFORM=linuxfb:tty=/dev/fb0
export QT_QPA_FONTDIR=$QT_ROOT/lib/fonts
#export LD_PRELOAD=/usr/lib/libts.so
#/usr/lib/preloadable_libiconv.so:
if [ -e "/dev/input/event4" ]; then
#       export QWS_MOUSE_PROTO="Tslib:/dev/input/event4"
#   export TSLIB_TSDEVICE=/dev/input/event4
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event4


fi
export QT_QPA_PLATFORM=eglfs
#export QT_QPA_GENERIC_PLUGINS=tslib
export QT_QPA_GENERIC_PLUGINS=evdevtouch
export QT_QPA_EGLFS_INTEGRATION=eglfs_mali
#export QT_QPA_FB_HIDECURSOR=1
#export QT_QPA_EGLFS_HIDECURSOR=1
#export QT_QPA_EGLFS_ROTATION=90


export QWS_MOUSE_PROTO=
export DBUS_SESSION_BUS_ADDRESS=`cat /tmp/dbusaddr`
```
其中的一些环境变量什么意思，可以自行百度。

下面是A133 TINA中的qt的环境配置


```
#!/bin/sh


export QT_QPA_PLATFORM=eglfs:size=1024x600
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt5/plugins
export QT_QPA_FONTDIR=/usr/share/fonts
export QT_QPA_GENERIC_PLUGINS=tslib                                                                                                                                                                            
export QT_QPA_GENERIC_PLUGINS=evdevmouse:/dev/input/event1
export QT_QPA_GENERIC_PLUGINS=evdevkeyboard:/dev/input/event2


export QT_QPA_EGLFS_INTEGRATION=none
export XDG_RUNTIME_DIR=/dev/shm
export QTWEBENGINE_DISABLE_SANDBOX=1
```
如果不配置export QT_QPA_PLATFORM=eglfs:size=1024x600的话，那么你运行qt应用时，需加-platform eglfs,比如./minimal -platform eglfs

如果不配置export QT_QPA_FONTDIR=/usr/share/fonts 可能会导致qt应用的字体无法显示，当然你配置的路径/usr/share/fonts下有对应的一些字体文件。

如果不配置export QT_QPA_EGLFS_INTEGRATION=none的话，运行qt应用会报“EGL library doesn't support Emulator extensions",该解决办法网上可以找到。

如果不配置exprot QTWEBENGINE_DISABLE_SANDBOX=1的话，运行qt应用时，需加上--no-sandbox,比如  ./minimal  --no-sandbox
总的来说碰到相关问题可以多网上查查资料。



在弄A133的TINA的QT过程中
1.我将A40I中的fonts（字体库）移植到A133中，从而解决字体显示的一些问题
2.将webgl用来测试oepngl的一些文件放进去了测试这个需要编译qt中的examples。cd /usr/share/qt5/examples/webenginewidgets/simplebrowser 然后./simplebrowser /webgl/examples/webgl_test.html，其实也可以不用simplebrowser也可以用minimal等。基本上只要运行成功那么说明webengine opengl这些都没有问题。