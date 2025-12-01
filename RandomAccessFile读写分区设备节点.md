最近遇到一个apk读写分区的问题,代码如下

```
RandomAccessFile file = new RandomAccessFile("/dev/block/platform/by-name/logo", "rw");
```
这个方法会抛出FileNotFoundException这个异常.然后我就纳闷了首先想到的是AndroidManifest.xml的权限问题,但是尝试半天之后依旧是这个异常,通过adb shell查看文件的权限,我发现/dev/block/platform/by-name/logo是一个链接文件它的权限了777,链接的是/dev/block/mmcblk0p4(它的权限是600),然后我将它的权限改成777就不会抛出异常了.

在AndroidManifest.xml注意加上

```
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
<uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"></uses-permission>

```
