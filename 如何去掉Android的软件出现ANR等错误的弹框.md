# 如何去掉Android的软件出现ANR等错误的弹框
有些客户使用android系统但是他们不想让客户看到原生的android系统，所以他们要求我们去掉软件出现错误时出现的弹出框。
之前我是如何跟踪解决 这个问题，我也不知道怎么弄的。
解决办法如下，修改`framework/base/services/core/java/com/android/server/am/AppErrors.java`下
```
在handleShowAppErrorUi(Message msg)函数中
//proc.crashDialog = new AppErrorDialog(mContext, mService, data);
res.set(AppErrorDialog.RESTART);    //change by regan
```