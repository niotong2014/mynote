系统修改屏幕亮度只用修改SetttingProvider中的Settings.System.SCREEN_BRIGHTNESS这个值就可以了，那么系统在这个背后都做了些什么呢？

通过搜索Settings.System.SCREEN_BRIGHTNESS这个关键字，可以在PowerManagerService.java这个文件中找到，分析代码，截取片段如下

```
//这个是SettingProvider的监听器
mSettingsObserver = new SettingsObserver(mHandler);

//注册监听
resolver.registerContentObserver(Settings.System.getUriFor(
                    Settings.System.SCREEN_BRIGHTNESS),
                    false, mSettingsObserver, UserHandle.USER_ALL);

//监听器的定义，继承ContentObserver
    private final class SettingsObserver extends ContentObserver {
        public SettingsObserver(Handler handler) {
            super(handler);
        }

   @Override
   public void onChange(boolean selfChange, Uri uri) {
            synchronized (mLock) {
                handleSettingsChangedLocked();
            }
        }
    }
    //handleSettingsChangedLocked()的定义
    private void handleSettingsChangedLocked() {
        updateSettingsLocked();
        updatePowerStateLocked();
    }

//在updateSettingsLocked()中有如下那么一段代码
private void updateSettingsLocked() {
...
        final int oldScreenBrightnessSetting = mScreenBrightnessSetting;
        mScreenBrightnessSetting = Settings.System.getIntForUser(resolver,
                Settings.System.SCREEN_BRIGHTNESS, mScreenBrightnessSettingDefault,
                UserHandle.USER_CURRENT);
        if (oldScreenBrightnessSetting != mScreenBrightnessSetting) {
            mTemporaryScreenBrightnessSettingOverride = -1;
...
mDirty |= DIRTY_SETTINGS;//这个很重要，相当于标志位
        }


//updatePowerStateLocked()中是真正的更新PowerState的状态的代码

    /**
     * Updates the global power state based on dirty bits recorded in mDirty.
     *
     * This is the main function that performs power state transitions.
     * We centralize them here so that we can recompute the power state completely
     * each time something important changes, and ensure that we do it the same
     * way each time.  The point is to gather all of the transition logic here.
     */
    private void updatePowerStateLocked() {
        if (!mSystemReady || mDirty == 0) {
            return;
        }
        if (!Thread.holdsLock(mLock)) {
            Slog.wtf(TAG, "Power manager lock was not held when calling updatePowerStateLocked");
        }

        Trace.traceBegin(Trace.TRACE_TAG_POWER, "updatePowerState");
        try {
            // Phase 0: Basic state updates.
            updateIsPoweredLocked(mDirty);
            updateStayOnLocked(mDirty);

            // Phase 1: Update wakefulness.
            // Loop because the wake lock and user activity computations are influenced
            // by changes in wakefulness.
            final long now = SystemClock.uptimeMillis();
            int dirtyPhase2 = 0;
            for (;;) {
                int dirtyPhase1 = mDirty;
                dirtyPhase2 |= dirtyPhase1;
                mDirty = 0;

                updateWakeLockSummaryLocked(dirtyPhase1);
                updateUserActivitySummaryLocked(now, dirtyPhase1);
                if (!updateWakefulnessLocked(dirtyPhase1)) {
                    break;
                }
            }
//updateDisplayPowerStateLocked（）才是真正修改亮度的代码
            // Phase 2: Update display power state.
            boolean displayBecameReady = updateDisplayPowerStateLocked(dirtyPhase2);

            // Phase 3: Update dream state (depends on display ready signal).
            updateDreamLocked(dirtyPhase2, displayBecameReady);

            // Phase 4: Send notifications, if needed.
            if (mDisplayReady) {
                finishInteractiveStateChangeLocked();
            }

            // Phase 5: Update suspend blocker.
            // Because we might release the last suspend blocker here, we need to make sure
            // we finished everything else first!
            updateSuspendBlockerLocked();
        } finally {
            Trace.traceEnd(Trace.TRACE_TAG_POWER);
        }
    }

}
```
		准确来讲，亮度调节到updateDisplayPowerStateLocked（）后续还有很多的细节没有去分析，在之前公司RK提供的代码可以看出亮度的调节是通过HAL来控制的，但是从我自己手中的开发板提供的代码，亮度调节的代码貌似在电池管理那一块，具体情况具体分析吧，本来想着看通过分析这个来了解framework如何使用HAL。
