 - 官方下载压缩包，解压，放置到一个固定目录比如/usr/local/java,然后整个java的路径就是/usr/local/java/jdk1.7.0_55.
 - 编译/etc/profile
 

> sudo vim /etc/profile

```
export JAVA_HOME=/usr/local/java/jdk1.7.0_55
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
```

 - 使环境变量生效

 

> source /etc/profile
> cd /usr/bin 
> ln -s -f  /usr/local/java/jdk1.7.0_55/bin/java 
> ln -s -f /usr/local/java/jdk1.7.0_55/bin/javac 
> ln -s -f /usr/local/java/jdk1.7.0_55/bin/javaws 

 - 查看是否安装成功
 

> java -version

 - 如果有自己安装的对应版本信息，那么 jdk安装应该没有问题了，如果出现运行eclipse出现找不到jre等错误信息，那么可以这样解决
 - 首先查看java使用的版本
 

> sudo update-alternatives --display java

 - 如果有问题的话可以先删除不对的版本，然后再装对的版本
 

> sudo update-alternatives --remove-all java
> sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.7.0_55/bin/java" 1

 - 同理将javac和javaws修改，那么基本关于jdk环境的问题基本都可以会解决
