 - **开发环境**
 cpu:ARM芯片
 系统：使用buildroot（版本为2016.11）编译出的linux系统（无界面）
 BT模块：AP6212(该芯片有bt+wifi功能)
 
 - **测试步骤**
	1.加载bcmdhd驱动
	2.rfkill来控制bt的供电
	3.执行brcm_patchram_plus程序控制ap6212的工作方式以及固件下载
	以上三个命令我写入了脚本openbt.sh
	

```
#!/bin/sh

insmod /system/vendor/modules/bcmdhd.ko
echo "0" >/sys/class/rfkill/rfkill0/state
slepp 5
echo "1" >/sys/class/rfkill/rfkill0/state
brcm_patchram_plus -d --enable_hci --no2bytes --tosleep 200000 --use_baudrate_for_download --baudrate 1500000 --bd_addr "11:22:33:44:55:66" --patchram /lib/firmware/ap6212/bcm43438a1.hcd /dev/ttyS3 &
sleep 10
kill -9 `ps -elf | grep brcm | grep -v grep | awk '{print $1}'`
brcm_patchram_plus -d --enable_hci --no2bytes --tosleep 200000 --use_baudrate_for_download --baudrate 1500000 --bd_addr "11:22:33:44:55:66" --patchram /lib/firmware/ap6212/bcm43438a1.hcd /dev/ttyS3 &
```
可以看出脚本当中执行了两次brcm_patchram_plus，这是因为只有执行第二次该程序的时候，才会出现对应的蓝牙设备节点，不然的话会有问题。（具体什么原因供应商那边也没有给出原因）。

４．使用buildroot编译出的相关工具进行蓝牙查找设备，绑定设备，发送文件，接受文件操作，命令操作如下

```
#hciconfig hci0 up
#hciconfig hci0 piscan
#/usr/libexec/bluetooth/bluetoothd -C & (如果不加-C的话,运行之后无法出现/var/run/sdp)
#/usr/libexec/bluetooth/obexd -r $HOME -a -d -n & (obexd是OBEX的服务进程 -d表示打开DEBUG，需要设置dbus的环境变量，不然执行失败)
#bt-adapter -d  (搜索蓝牙设备，出现你手机的蓝牙设备之后可以CTRL+C退出）
#bt-devices -c xx:xx:xx:xx:xx:xx(连接手机的蓝牙）
#bt-obex -p xx:xx:xx:xx:xx:xx /xxxxx/xxxx/xxxx  (给手机发送文件，文件的格式有特定性，我测试的是jpg的图片文件）
#bt-obex -s /xxx/xxx/ (接收文件，最后一个参数为接收到文件的保存目录，因为obexd中设置了-r所以可以直接使用bt-obex -s)
```
测试蓝牙的时候，其实遇到很多坑，各种工具都有测试过，最终上面的这些工具经过我的验证可以测试bluetooth的功能，工具的具体使用方法请自行百度，且以上工具均是buildroot编译出来的。
