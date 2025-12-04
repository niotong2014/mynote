# 全志pwm的调试知识

最近调试全志B810芯片，发现s\_pwm0无法正常使用，因为s_pwm0是呗eink的驱动去使用的，软件上我又不太可能去弄个程序去调试它，所以使用全志提供的调试节点来调试。

```
#cd /dev/class/pwm
#ls
pwmchip0  pwmchip16
#cd pwmchip0
#echo 0 > export    //然后就可以看到生成了一个pwm0的目录，如果echo其他值就代表打开其他的pwm通道
#cd  pwm0
#echo 1000000000 > period           //频率，单位为ns，我理解的就是1S切分成X份
#echo 500000000 > duty_cycle          //代表正空比
#echo normal  > polarity           //极性
#echo 1 > enable        //使能  执行这个命令之后就能从 pwm口测量到波形了
```

pwmchip0 控制了16个通道  pwmchip16控制两个2通道

