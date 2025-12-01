用时钟源来产生时钟！
在STM32中，有五个时钟源，为HSI、HSE、LSI、LSE、PLL。
①、HSI是高速内部时钟，RC振荡器，频率为8MHz。
②、HSE是高速外部时钟，可接石英/陶瓷谐振器，或者接
外部时钟源，频率范围为4MHz~16MHz。
③、LSI是低速内部时钟，RC振荡器，频率为40kHz。
④、LSE是低速外部时钟，接频率为32.768kHz的石英晶体。
⑤、PLL为锁相环倍频输出，其时钟输入源可选择为HSI/2、
HSE或者HSE/2。倍频可选择为2~16倍，但是其输出频率最
大不得超过72MHz。
其中40kHz的LSI(低速内部时钟)供独立看门狗IWDG使用，另外它还可以被选择为实时时钟RTC的时钟源。另外，实时时钟RTC的时钟源还可以选 择LSE(低速外部时钟)，或者是HSE(高速外部时钟)的128分频。RTC的时钟源通过RTCSEL[1:0]来选择。
STM32中有一个全速功能的USB模块，其串行接口引擎需要一个频率为48MHz的时钟源。该时钟源只能从PLL输出端获取，可以选择为1.5分频或者 1分频，也就是，当需要使用USB模块时，PLL必须使能，并且时钟频率配置为48MHz或72MHz。(armjishu.com)
另外，STM32还可以选择一个时钟信号输出到MCO脚(PA8)上，可以选择为PLL输出的2分频、HSI、HSE、或者系统时钟。
系统时钟SYSCLK最大频率为72MHz，它是供STM32中绝大部分部件工作的时钟源。系统时钟可由PLL、HSI或者HSE提供输出，并且它通过AHB分频器分频后送给各模块使用，AHB分频器可选择1、2、4、8、16、64、128、256、512分频。其中AHB分频器输出的时钟送给5大模块使用：①、送给AHB总线、内核、内存和DMA使用的HCLK时钟。
②、分频后送给STM32芯片的系统定时器时钟（Systick=Sysclk/8=9Mhz）
③、直接送给Cortex的自由运行时钟(free running clock)FCLK。【ARMJISHU注：FCLK 为处理器的自由振荡的处理器时钟，用来采样中断和为调试模块计时。在处理器休眠时，通过FCLK 保证可以采样到中断和跟踪休眠事件。 Cortex-M3内核的“自由运行时钟(free running clock)”FCLK。“自由”表现在它不来自系统时钟HCLK，因此在系统时钟停止时FCLK 也继续运行。FCLK和HCLK 互相同步。FCLK 是一个自由振荡的HCLK。FCLK 和HCLK 应该互相平衡，保证进入Cortex-M3 时的延迟相同。】④、送给APB1分频器。APB1分频器可选择1、2、4、8、16分频，其输出一路供APB1外设使用(PCLK1，最大频率36MHz)，另一路送给定时器(Timer)2、3、4倍频器使用。该倍频器可选择1或者2倍频，时钟输出供定时器2、3、4使用。
⑤、送给APB2分频器。APB2分频器可选择1、2、4、8、16分频， 其输出一路供APB2外设使用(PCLK2，最大频率72MHz)，另一路送给定时器(Timer)1倍频器使用。该倍频器可选择1或者2倍频，时钟输出 供定时器1使用。另外，APB2分频器还有一路输出供ADC分频器使用，分频后送给ADC模块使用。ADC分频器可选择为2、4、6、8分频。
以上提到3种时钟Fclk、Hclk和Pclk，简单解释如下：Fclk为供给CPU内核的时钟信号，我们所说的cpu主频为XXXXMHz，就是指的这个时钟信号，相应的，1/Fclk即为cpu时钟周期；Hclk为优秀的高性能总线（AHB bus peripherals）供给时钟信号（AHB为advanced high-performance bus）；HCLK ：AHB总线时钟，由系统时钟SYSCLK 分频得到，一般不分频，等于系统时钟，HCLK是高速外设时钟，是给外部设备的，比如内存，flash。Pclk为优秀的高性能外设总线（APB bus peripherals）供给时钟信号（其中APB为advanced peripherals bus）。
在以上的时钟输出中，有很多是带使能控制的，例如AHB总线时钟、内核时钟、各种APB1外设、APB2外设等等。当需要使用某模块时，记得一定要先使能对应的时钟。
需要注意的是定时器的倍频器，当APB的分频为1时，它的倍频值为1，否则它的倍频值就为2。
连接在APB1(低速外设)上的设备有：电源接口、备份接口、CAN、USB、I2C1、I2C2、UART2、UART3、SPI2、窗口看门狗、Timer2、Timer3、Timer4。
注意：USB模块虽然需要一个单独的48MHz时钟信号，但它应该不是供USB模块工作的时钟，而只是提供给串行接口引擎(SIE)使用的时钟。USB模块工作的时钟应该是由APB1提供的。
连接在APB2(高速外设)上的设备有：UART1、SPI1、Timer1、
ADC1、ADC2、所有普通IO口(PA~PE)、第二功能IO口。
[caption id="attachment_2541" align="alignnone" width="516" caption="STM32的HCLK与FCLK关系图"]STM32时钟分配及其解释-STM32cubeMX时钟设置[/caption]
下图是STM32用户手册中的时钟系统结构图（位于《STM32F103CDE_DS_CH_V5.pdf》的第14页，或者《STM32F10XXX参考手册_CN.pdf》的第47页），通过该图可以从
[caption id="attachment_2542" align="alignnone" width="847" caption="STM32的时钟系统结构图"]STM32时钟分配及其解释-STM32cubeMX时钟设置
总体上掌握STM32的时钟系统。
