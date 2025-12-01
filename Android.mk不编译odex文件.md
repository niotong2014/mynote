	最近公司将android从4.4升级为6.0时，调试apk时，由于6.0编译的时候，有时候会生成odex文件，调试的时候odex不方便。所以网上找了下资料，只需在Android.mk中添加LOCAL_DEX_PREOPT := false就可以了，编译之后不生成odex，方便调试。
	同时还发现来一个十分蛋疼的问题，在4.4版本中使用LOCAL_JNI_SHARED_LIBRARIES := libJniTest就会将libJniTest.so这个库文件编译进apk中。但是在6.0中即使加来这句话，so动态库不会再编译进apk中，将apk解压压根就看不到libs这个目录。所以当你修改了so，你还需将so动态库push到开发板中。
