# 代码如何去掉SystemUI的状态栏（StatusBar）和导航栏（NavigationBar）
1.修改`framework/base/core/res/res/values/dimens.xml`
```
<dimen name="status_bar_height">0dp</dimen>
```
将高度改为0dp自然就看不到了

2.修改`framework/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/PanelView.java`
```
onTouchEvent(MotionEvent event)中第一行加
mTouchDisabled = true; //add by regan
```
这样可以直接跳过状态栏下拉的的操作。

3.修改`framework/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/PhoneStatusBar.java`
    
```
在start()函数中注释掉
//addNavigationBar();   //mask by regan

```
这样可以不用加在导航栏界面

```
在makeStatusBarView()函数末尾return之前加入
mStatusBarView.setVisibility(View.GONE);        //add by regan
```
这样可以让状态栏界面不显示