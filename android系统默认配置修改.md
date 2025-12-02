# android系统默认配置修改
最近弄个一个客户的A133的板子，由于客户需求所以修改了些默认的系统配置，其中包括以前的一些总结，其实这些网上一查一打把，而且可以跟代码。
## 修改frameworks/base/core/res/res/values/config.xml
### 隐藏底部的虚拟导航按键
`<bool name="config_showNavigationBar">false</bool> `

-------

## 修改frameworks/base/packages/SettingsProvider/res/values/defaults.xml
### 打开自动旋转，这样gsensor就能使能了。
`<bool name="def_accelerometer_rotation">true</bool>` 
### 系统可以安装非应用市场的apk，这样adb install就可以用了
`<bool name="def_install_non_market_apps">true</bool> `
### 关闭应用的验证，这样安装应用就不用点击确定了
`<bool name="def_package_verifier_enable">false</bool>`
### 默认锁屏，这样开机之后进入系统就不是锁屏界面了
`<bool name="def_lockscreen_disabled">true</bool>`
### 锁屏时间，这个值几乎即使永不锁屏
`<integer name="def_screen_off_timeout">2147483647</integer> `
### 这个表示系统睡眠时间，网上自己查，结合代码看看
`<integer name="def_sleep_timeout">2147483647</integer>`


-------
## 修改frameworks/base/packages/SystemUI/res/values/config.xml
### 关闭锁屏服务
`<bool name="config_enableKeyguardService">false</bool>`