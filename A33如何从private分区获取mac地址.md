# A33如何从private分区获取mac地址
下面以A33来示例
1.全志分区会有一个private分区，大小为16M，在系统启动之后执行rc文件中得一些服务时，如下
```
service  ococcisetmac  /system/bin/busybox  sh  /system/bin/setmac.sh                                                                                                                                          
  class main
  user root
  group root
  oneshot
```
当启动ococcisetmac服务时，脚本setmac.sh就执行，该脚本内容如下


```
#!/system/bin/busybox sh


BUSYBOX="/system/bin/busybox"
                                                                                                                                                                                                               
echo "mount -o remount,rw /"
mount -o remount,rw /
echo "mkdir /private"
mkdir /private
echo "mount -t vfat /dev/block/by-name/private /private"
mount -t vfat /dev/block/by-name/private /private


/system/bin/setmacaddr /data/wifimac.txt
##/system/bin/setbtmacaddr /data/misc/bluedroid/bdaddr
setprop ro.macaddress "`cat /private/ULI/factory/mac.txt`"


umount /private
rmdir /private


mount -o remount,ro /
sync
sync


exit 0
```
它会挂载private分区，然后从该分区中读取mac.txt中的值，然后将该值赋值给系统属性ro.macaddress，
然后后续怎么处理就随意了。



这里拓展一下，有些需要系统启动完成之后再执行的脚本可以这样写
```
on property:sys.boot_completed=1
    start ococcidata

service  ococcidata  /system/bin/busybox  sh  /system/bin/ococcidata.sh
  class main
  user root
  group root
  disabled
  oneshot
```
如上ococcidata服务中有个disabled，所以该服务不会自行执行，oneshot表示服务执行一次，当系统启动完成之后，系统属性property:property:sys.boot_completed会从0变成1，这样就可以触发ococcidata的执行了。