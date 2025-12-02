# 如何调整CPU的工作模式
cpu的工作模式有ondemand  userspace powersave interactive performance这几种。
* **ondemand**  按需调节cpu频率,不操作手机的时候控制在最低频率,滑屏或进入应用后会迅速提升至最高频率,当空闲时迅速降低频率,性能较稳定,但因频率变化幅度过大,省电方面只有一般的水平。是一种在电池和性能之间趋向平衡的默认模式,但是对于智能手机来说,ondemand在性能表现方面略有欠缺。
* **userspace**  最早的cpufreq 子系统通过userspace governor为用户提供了这种灵活性。系统将变频策略的决策权交给了用户态应用程序，并提供了相应的接口供用户态应用程序调节CPU 运行频率使用。也就是长期以来都在用的那个模式。可以通过手动编辑配置文件进行配置。
* **powersave**  将CPU频率设置为最低的所谓“省电”模式，CPU会固定工作在其支持的最低运行频率上，而不动态调节。
* **interactive**  和ondemand相似,规则是“快升慢降”,注重响应速度、性能,当有高需求时迅速跳到高频率,当低需求时逐渐降低频率,相比ondemand费电。
* **performance**  只注重效率，将CPU频率固定工作在其支持的最高运行频率上，而不动态调节。

输入如下命令调整cpu工作模式
```
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```