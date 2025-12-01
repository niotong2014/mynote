	前言：前一段时间在公司分析一个由于突然关掉路由器，导致设备wifi崩溃的问题。通过一段时间的摸索和学习，了解到wifi状态机的工作原理。
	所谓状态机我的理解是，表示一个物体它现在所处的状态，以及所处状态对于不同指令的处理。以下是我本人所持有的开发板所带的android5.0的wifi状态机的所有状态

![这里写图片描述](https://img-blog.csdn.net/20170407232914181?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbmlvdG9uZzIwMTQ=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
	从图片中的代码可以看出这差不多是个树形结构（由于图片上传大小的限制，我自己画图没办法上传）。先是添加这个状态，然后进入InitialState这个初始状态，InitialState的代码如下
```
    class InitialState extends State {
        @Override
        public void enter() {
            mWifiNative.unloadDriver();

            if (mWifiP2pChannel == null) {
                mWifiP2pChannel = new AsyncChannel();
                mWifiP2pChannel.connect(mContext, getHandler(),
                    mWifiP2pServiceImpl.getP2pStateMachineMessenger());
            }

            if (mWifiApConfigChannel == null) {
                mWifiApConfigChannel = new AsyncChannel();
                WifiApConfigStore wifiApConfigStore = WifiApConfigStore.makeWifiApConfigStore(
                        mContext, getHandler());
                wifiApConfigStore.loadApConfiguration();
                mWifiApConfigChannel.connectSync(mContext, getHandler(),
                        wifiApConfigStore.getMessenger());
            }
        }
        @Override
        public boolean processMessage(Message message) {
            logStateAndMessage(message, getClass().getSimpleName());
            switch (message.what) {
                case CMD_START_SUPPLICANT:
                    if (mWifiNative.loadDriver()) {
                        try {
                            mNwService.wifiFirmwareReload(mInterfaceName, "STA");
                        } catch (Exception e) {
                            loge("Failed to reload STA firmware " + e);
                            // Continue
                        }

                        try {
                            // A runtime crash can leave the interface up and
                            // IP addresses configured, and this affects
                            // connectivity when supplicant starts up.
                            // Ensure interface is down and we have no IP
                            // addresses before a supplicant start.
                            mNwService.setInterfaceDown(mInterfaceName);
                            mNwService.clearInterfaceAddresses(mInterfaceName);

                            // Set privacy extensions
                            mNwService.setInterfaceIpv6PrivacyExtensions(mInterfaceName, true);

                           // IPv6 is enabled only as long as access point is connected since:
                           // - IPv6 addresses and routes stick around after disconnection
                           // - kernel is unaware when connected and fails to start IPv6 negotiation
                           // - kernel can start autoconfiguration when 802.1x is not complete
                            mNwService.disableIpv6(mInterfaceName);
                        } catch (RemoteException re) {
                            loge("Unable to change interface settings: " + re);
                        } catch (IllegalStateException ie) {
                            loge("Unable to change interface settings: " + ie);
                        }

                       /* Stop a running supplicant after a runtime restart
                        * Avoids issues with drivers that do not handle interface down
                        * on a running supplicant properly.
                        */
                        mWifiMonitor.killSupplicant(mP2pSupported);
                        if(mWifiNative.startSupplicant(mP2pSupported)) {
                            setWifiState(WIFI_STATE_ENABLING);
                            if (DBG) log("Supplicant start successful");
                            mWifiMonitor.startMonitoring();
                            transitionTo(mSupplicantStartingState);
                        } else {
                            loge("Failed to start supplicant!");
                        }
                    } else {
                        loge("Failed to load driver");
                    }
                    break;
                case CMD_START_AP:
                    if (mWifiNative.loadDriver()) {
                        setWifiApState(WIFI_AP_STATE_ENABLING);
                        transitionTo(mSoftApStartingState);
                    } else {
                        loge("Failed to load driver for softap");
                    }
                default:
                    return NOT_HANDLED;
            }
            return HANDLED;
        }
    }
```

进入状态机会先执行enter(),然后ProcessMessage处理对应的CMD，transitionTo（XXXXXXState）用来切换状态机所处的状态。当一个CMD所在状态处理不了，那么会将该状态交由父状态来处理（父状态处理不了，就给爷状态来处理，依此类推）。当然，发送CMD的可以是WifiStateMachine,也可以是WifiMonitor等。状态机是个逻辑分层很清晰，好好看代码就好。
