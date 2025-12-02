# 如何让android的MTP默认是连接的
之前在A64和A63上，有两个客户让我修改过这个功能，原生系统mtp需要进入系统之后确认才能mtp连接上，后面经过我分析代码修改`frameworks/base/services/usb/java/com/android/server/usb/UsbDeviceManager.java`中函数updateUsbStateBroadcastIfNeeded()可以实现客户需求
```
//intent.putExtra(UsbManager.USB_DATA_UNLOCKED, isUsbTransferAllowed() && mUsbDataUnlocked);
intent.putExtra(UsbManager.USB_DATA_UNLOCKED, isUsbTransferAllowed() && true);     //change by regan
```
之前解决这个问题我忘了怎么解决了，自己跟代码。