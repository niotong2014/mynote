1.原理
	启动ubuntu后,你发现的启动画面是由/boot/grub/grub.cfg这个文件决定的,你能从这个文件中找到启动画面的一些启动项.而/boot/grub/grub.cfg这个文件本质上是由update-grub这个命令然后结合/etc/grub.d/这个文件夹下的00_header  05_debian_theme  10_linux  20_linux_xen  20_memtest86+  30_os-prober  30_uefi-firmware  40_custom  41_custom 等等这些文件生成的,执行update-grub这个命令之后,系统会解析/etc/default/grub这个文件中的一些配置,然后依次解析00_header 05_debian_theme等(从开头数字从小到大的顺序)然后生成/boot/grub/grub.cfg这个文件(最终决定你的启动项)

2.修改
	一半情况下默认启动第一个启动项.也就是set default="0".所以你可以修改/etc/default/grub这里面的配置来选择你的启动项.当然也可以直接修改/etc/grub.d/文件下的文件的文件名来控制启动项的顺序.
	比如一般双系统(windows+ubuntu)的电脑.windows的启动项在ubuntu后面,你可以将windows的那个生成启动项的文件名(数字_windows,文件名不一定是这样的)将这个数字修改.这样就可以调整启动项顺序了.

	有的人直接修改/boot/grub/grub.cfg最后发现可能临时成功地修改了启动配置,但是不是永久性的,因为你没有改到本质上去.
