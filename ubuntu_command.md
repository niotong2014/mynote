# Ubuntu 系统管理命令参考手册

## 1. 安装终端右键菜单
```bash
sudo apt-get install nautilus-open-terminal
```
如果系统中没有"在终端中打开"，安装此程序，然后重新加载文件管理器：
```bash
nautilus -q
```

## 2. 修改Ubuntu启动器的启动顺序

### 方法一：修改GRUB配置
```bash
sudo vim /etc/default/grub
```
在打开的文本中修改`GRUB_DEFAULT=0`这一项。比如win7在启动项列表中为第5项，则将0改为4。

**其他GRUB配置选项：**
- `GRUB_TIMEOUT=所要等待的秒数` - 修改启动项列表等待的时间，-1表示不倒计时。

### 方法二：修改启动项优先级
```bash
sudo mv /etc/grub.d/30_os-prober /etc/grub.d/08_os-prober
```
该命令是将etc文件夹下的grub.d文件夹下的30_os-prober文件改名为08_os-prober。（08可以改为06~09都可以）。Ubuntu的启动项相关文件名为"10_...."这样就可以将win7的启动项放在Ubuntu前面，即启动项列表的第一个。由于引导程序默认启动第一个启动项，所以这样就可以先启动win7了。

**注意：**
无论哪种方法，修改之后必须执行：
```bash
sudo update-grub
```
修改才能生效。

## 3. 挂载服务器文件到本地
```bash
sudo mount -t cifs //192.168.10.230/regan/ /mnt/regan/ -o username=regan,password=XXXXXXX,dir_mode=0777,file_mode=0777
```

## 4. 启动Shadowsocks代理
```bash
sudo sslocal -c /home/thtfit/ss.conf
```
Shadowsocks的Linux启动配置

## 5. 配置Ubuntu的JDK和JRE位置
```bash
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.6.0_45/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.6.0_45/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.6.0_45/bin/javaws" 1
```

## 6. 通过SSH传输文件
```bash
scp -P 26169 jdk-8u45-linux-i586.gz root@104.224.169.145:./jdk-8u45-linux-i586.gz
```
从SSH服务器上下载或者上传文件，参数是将前面一个弄到后面一个。

## 7. 安装配置Shadowsocks科学上网

### 安装步骤：
1. 安装Python包管理器
```bash
sudo apt-get install python-pip
```

2. 安装Shadowsocks
```bash
sudo pip install shadowsocks
```

3. 启动Shadowsocks
```bash
sudo sslocal -c /home/niotong/mic64.conf & >> /dev/null
```
（此命令在脚本ss_start.sh中）

4. 设置开机启动
```bash
sudo vim /etc/rc.local
```
在`exit 0`之前添加：
```bash
sudo sh /home/niotong/ss_start.sh
```
这样就能够开机启动sslocal了。

### mic64.conf配置文件内容：
```json
{
    "server":"104.224.169.159",
    "server_port":28388,
    "local_port":8091,
    "password":"31415926sb",
    "timeout":60,
    "method":"aes-256-cfb"
}
```

**配置Firefox使用FoxyProxy代理**

## 8. 大文件分割与合并

### 分割大文件
有时候需要将大文件切分成多个小文件，可以使用`split`命令。该命令我只记录自己常用的方法，比如有个`android_orig.tgz`这个大文件，执行：
```bash
split -b 1024m android_orig.tgz android_part_
```
执行完命令之后会生成`android_part_aa`、`android_part_ab`、`android_part_ac`等若干个小文件。

### 合并文件
```bash
cat android_part_* > android_orig.tgz
```
这样就可以拼接完成。

## 9. Vim中替换命令
```bash
:%s/old/new/gc
```
表示整个文件中的"old"替换成"new"，其中的"c"表示经过确认才替换。