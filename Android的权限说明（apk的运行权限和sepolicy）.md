[参考链接地址](http://www.360doc.com/content/11/1227/05/3700464_175237322.shtml)

[Android sepolicy知识链接](https://blog.csdn.net/u010781856/article/details/47664757)

**APK如何获取System权限**
[Android 7.0 SEAndroid app权限配置](https://blog.csdn.net/u010164190/article/details/70170695)
1.首先了解一个基础知识ps -Z 和ls -Z,这两个命令分别查看进程和文件的sepolicy属性
下面是apk拥有system权限
```
u:r:system_app:s0              system    30098 1653  1468104 62536 SyS_epoll_ 7ca8e30424 S com.niotong.tester
```
下面是apk拥有platform权限

```
u:r:platform_app:s0:c512,c768  u0_a62    21726 1653  1252992 37356 SyS_epoll_ 7ca8e30424 S com.niotong.tester
```
比如有时候我们想使用android.os.SystemProperties这个系统隐藏类，但是发现我们讲自己的代码放到apk中编译会提示找不到这个类就是这类型的原因造成的。
总结一下两种方法生成具有system权限的apk：
	1.源码中编译，在AndroidManifest.xml中添加android:sharedUserId="android.uid.system"，然后在Android.mk中修改LOCAL_CERTIFICATE := platform，然后mm -B编译出来的apk就具有system权限，如果只有LOCAL_CERTIFICATE := platform没有android:sharedUserId="android.uid.system"，那么编译出来的apk运行权限是platform权限了。
	
2.外部编译，比如用eclipse编译一个没有签名的apk，然后使用系统中的签名工具签名，这样生成的apk也会有platform权限。如果想要有system权限，那么得在AndroidManifest.xml中添加android:sharedUserId="android.uid.system"，然后生成未签名的apk，然后使用源码中的签名工具签名，这样签完名后的apk会有system权限。
