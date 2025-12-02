# 如何区分android系统是多少位
最近客户咨询我全志的A133的sdk的系统是多少位的，所以我特意去查了下相关知识。
1.首先，查看内核配置看**CONFIG_64BIT=y**或者**CONFIG_ARM64=y**如果有这两个基本上可以确定内核是64的位反正为32位。
2.根据之前的经验我知道全志的sdk有时候内核是32bit但是系统却是64bit，所以如何确定系统层是64bit的呢？
   请参考以下网址资料https://blog.csdn.net/weixin_41508948/article/details/85258993
    一个简单的方法验证`adb shell ps | grep zygote`如果出现zygote64那么说明系统是64bit的，如果没有就是32位系统。
![adb shell ps | grep zygote结果](images/%E5%A6%82%E4%BD%95%E5%8C%BA%E5%88%86android%E7%B3%BB%E7%BB%9F%E6%98%AF%E5%A4%9A%E5%B0%91%E4%BD%8D/BA27411B-69BC-444C-91B6-71B15E25E556.png)

3.按照我个人的理解，android 64bit的系统上可以运行32bit的库，机制是系统加载so库的时候能找到64bit的库就加载64bit的库，找不到就加载32bit的库。