# ADB (Android Debug Bridge) 命令参考手册

## 1. 获取Root权限
```bash
adb remount
```
获取adb的root权限，比如想进入/system/app中删除软件，登录之前先执行此命令，才有权限删除软件。

## 2. 进入ADB终端
```bash
adb shell
```

## 3. 网络连接ADB
```bash
adb connect 192.168.70.89:9351
```
通过网络连接adb，之后可以执行`adb shell`进入终端。

## 4. 查看Log信息
```bash
adb logcat
```
查看adb的log信息。

## 5. 从设备拉取文件
```bash
adb pull XXXXX XXXXX
```
前面为android设备中的文件的路径名，后面为文件存放位置。

## 6. 向设备推送文件
```bash
adb push XXXXX XXXXX
```
前面为本地文件的路径名，后面为android设备的存放位置。

## 7. 查看连接设备
```bash
adb devices
```

## 8. 启动Activity
```bash
adb shell am start -n {包(package)名}/{包名}.{activity}
```

## 9. 启动服务
```bash
adb shell am startservice -n {包(package)名}/{包名}.{service}
```

## 10. 发送广播
```bash
adb shell am broadcast -a com.android.test --es test_string "this is test string" --ei test_int 100 --ez test_boolean true
```
发送广播，分别携带string、int、boolean型的参数。

## 11. 停止应用程序
```bash
adb shell am force-stop {包名}
```
关掉应用程序。

## 12. 安装APK应用
```bash
adb install [-l] [-r] [-s] ****.apk
```
安装apk程序，参数说明：
- `-l` - 锁定该程序
- `-r` - 重新安装程序，保存数据（常用）
- `-s` - 安装在SD卡内，而不是设备内部存储
- `-d` - 允许降级覆盖安装
- `-t` - 允许安装测试包

## 13. 卸载应用程序
```bash
adb uninstall [-k] <package>
```
卸载程序，`-k`表示保留安装包的数据和缓存目录。

## 14. 系统分区挂载操作

进入设备终端：
```bash
adb shell
```

### 挂载private分区
```bash
mount -o rw -t vfat /dev/block/by-name/private /mnt/private
```
将private分区挂载到/mnt/private目录下。

### 重新挂载分区
```bash
mount -o remount,rw /dev/block/by-name/private /mnt/private
```
将private分区重新以rw的权限挂载。