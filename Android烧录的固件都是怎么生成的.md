根据我本人4412开发板烧录需要以下这些文件
Superboot4412.bin ramdisk-u.img system.img userdata.img zImage这些 镜像文件。以下是友善之臂提供的生成img的脚本gen-img.sh中的内容：

```
#!/bin/bash

OUTDIR=out/target/product/tiny4412
AHOSTBIN=out/host/linux-x86/bin

# install vendor files
if [ -d vendor/friendly-arm/tiny4412/rootdir/system/ ]; then
    cp -af vendor/friendly-arm/tiny4412/rootdir/system/* ${OUTDIR}/system/
fi
if [ -d vendor/friendly-arm/tiny4412/rootdir/data/ ]; then
    cp -af vendor/friendly-arm/tiny4412/rootdir/data/*   ${OUTDIR}/data/
fi

# make images
LOPTS="-T -1 -S ${OUTDIR}/root/file_contexts"
${AHOSTBIN}/make_ext4fs -s ${LOPTS} -l 629145600 -a system system.img ${OUTDIR}/system

# eMMC Size | UserData partition Size
#------------------------------------------------
#        4G |  2149580800  (2G)  2050*1024*1024
#        8G |  4299161600  (4G)
#       16G | 10747904000 (10G) 10250*1024*1024
#------------------------------------------------
${AHOSTBIN}/make_ext4fs -s ${LOPTS} -l  2149580800 -a data userdata-4g.img  ${OUTDIR}/data
${AHOSTBIN}/make_ext4fs -s ${LOPTS} -l  4299161600 -a data userdata-8g.img  ${OUTDIR}/data
${AHOSTBIN}/make_ext4fs -s ${LOPTS} -l 10485760000 -a data userdata-16g.img ${OUTDIR}/data
cp userdata-4g.img userdata.img

# ramdisk
${AHOSTBIN}/mkbootfs ${OUTDIR}/root | ${AHOSTBIN}/minigzip > ${OUTDIR}/ramdisk.img
mkimage -A arm -O linux -T ramdisk -C none -a 0x40800000 -n "ramdisk" \
        -d ${OUTDIR}/ramdisk.img ramdisk-u.img

# minitools support
MINITOOLS_PATH=/opt/MiniTools/tiny4412/images/Android5.0
if [ -d ${MINITOOLS_PATH} ]; then
    cp -f ramdisk-u.img ${MINITOOLS_PATH}/
    cp -f system.img ${MINITOOLS_PATH}/
    cp -f userdata*.img ${MINITOOLS_PATH}/
    ls -l ${MINITOOLS_PATH}/ramdisk-u.img
    ls -l ${MINITOOLS_PATH}/system.img
    ls -l ${MINITOOLS_PATH}/userdata*.img
fi
```
从这个脚本可以看出这个脚本将android-5.0.2/out/target/product/tiny4412下的文件夹system/和data/这两个目录分别生成system.img userdata.img.

zImage为编译内核生成的

Superboot4412.bin我认为是bootloader，这是友善之臂提供的

ramdisk-u.img则是android-5.0.2/out/target/product/tiny4412/ramdisk.img经过处理得到的。通过分析ramdisk.img是由android-5.0.2/out/target/product/tiny4412/root/这个目录生成的


烧录是将system.img ramdisk-u.img userdata.img zImage Superboot4412.bin分别烧录到对应分区，然后从nand启动，先启动bootloader,然后启动zImage(内核) ramdisk-u.img应该是挂载到根目录/下。内核启动完应该就是启动init（root/init）程序。system.img挂载到ramdisk-u.img(root/system/)
userdata.img挂载到ramdisk-u.img(root/data)
基本就这个流程。

不同的公司，因为平台不一样比如rockchip,allwinner等会有所不同，不过大概应该是这样的。
