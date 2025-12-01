cat /proc/bus/input/devices 
确定键盘是通过DEV下哪个inputevent和调用的哪个KL
I: Bus=0000 Vendor=0000 Product=0000 Version=0000
      N: Name="ft5x06_ts"
      P: Phys=
      S: Sysfs=/devices/virtual/input/input0
      U: Uniq=
      H: Handlers=kbd event0 cpufreq 
      B: PROP=0
      B: EV=b
      B: KEY=400 0 0 0 0 0 40000800 40 0 0 0
      B: ABS=6650000 0
红色Name就是对应的KL文件名，如果你的系统内没有设置KL，系统会自动找Generic。最好设置自己对应的KL文件映射表。而红色S代表是的键盘会成驱动input0内上报键值。接下来就要添加新的按键。底层上报的是Scancode会通过你的KL文件转换成Android上层使用的虚拟KEYCODE。主要是现在KL文件内添加：

1）KL文件进行映射：
     key 150   MY_NEW_KEY

2)frameworks/base/native/include/android/keycodes.h(添加定义)
 AKEYCODE_MY_NEW_KEY 223

3)如果想让此按键为系统按键
frameworks/base/libs/ui/Input.cpp
KeyEvent::isSystemKey（）function 添加

4）frameworks/base/core/java/android/view/KeyEvent.java（添加new keycode）
5)  frameworks/base/include/ui/KeycodeLabels.h添加new keycode）
6)  frameworks/base/core/res/res/values/attrs.xml
7)  external/webkit/Source/WebKit/android/plugins/ANPKeyCodes.h(如果然BROWSE能收到就在这里也定义)

这样修改后已OK，就make update-api 可以测试了。当然numeric+function一些按键要根据自己的功能来修改。要支持输入法，输入法也得修改。
