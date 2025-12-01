**1.前言**
首次刷机之后，第一次启动系统会运行一个开机向导，该向导会设置系统语言  ，wifi,日期和时间等，由于现在需要去掉该向导，所得找到是那个apk干的这件事。
**2.搜索apk**
[请先阅读此文章](http://blog.csdn.net/u011974987/article/details/50502769)
我发现Provision.apk并没有编译，所以从启动向导来分析，该apk应该是在priv-app中，所以我从priv-app中找，在该文件夹中找到SetupWizard.apk，从apk的名字大概猜测其是启动向导apk，所以找到控制编译该apk的Android.mk，如下

```
include $(CLEAR_VARS)
LOCAL_MODULE := SetupWizard
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := Provision
LOCAL_SRC_FILES := $(LOCAL_MODULE)_tablet_dark.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRIVILEGED_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)
```
将其注释掉，然后编译生成固件包，发现成功去掉开机向导。
另外听我同事讲ro.setupwizard.mode这个系统属性也可能控制向导的启动，但是具体控制不控制，得看情况而定。另外从Provision.apk的AndroidManfest.xml可以来参考如何写启动apk
