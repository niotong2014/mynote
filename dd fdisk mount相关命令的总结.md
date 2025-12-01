**概论**
工作中经常会碰到dd fdisk mount这些命令，比如这段时间玩banana-pi,在生成镜像和制作启动卡，会经常用到dd fdisk mount这些命令。

**常用参数**
if=文件名：输入文件名，缺省为标准输入。即指定源文件。< if=input file > 
of=文件名：输出文件名，缺省为标准输出。即指定目的文件。< of=output file > 
ibs=bytes：一次读入bytes个字节，即指定一个块大小为bytes个字节。 
obs=bytes：一次输出bytes个字节，即指定一个块大小为bytes个字节。 
bs=bytes：同时设置读入/输出的块大小为bytes个字节。 
cbs=bytes：一次转换bytes个字节，即指定转换缓冲区大小。 
skip=blocks：从输入文件开头跳过blocks个块后再开始复制。 
seek=blocks：从输出文件开头跳过blocks个块后再开始复制。 
注意：通常只用当输出文件是磁盘或磁带时才有效，即备份到磁盘或磁带时才有效。 
count=blocks：仅拷贝blocks个块，块大小等于ibs指定的字节数。 

**制作镜像**

```
#!/bin/bash

#gunzip -c BPI_M3_1080P.img.gz | dd of=/dev/mmcblk0 conv=sync,noerror bs=1k

die() {
        echo "$*" >&2
        exit 1
}

[ -s "./env.sh" ] || die "please run ./configure first."
. ./env.sh
O=$1

if [ ! -z $O ] ; then
        BOARD=$O
fi

P=${TOPDIR}/output/$BOARD/pack
U=${TOPDIR}/output/100MB
#echo DOWNLOAD DIR=$P

mkdir -p $U
TMP_FILE=${U}/${BOARD}.tmp
IMG_FILE=${U}/${BOARD}.img
#先制作一个大小为100M的${TMP_FILE}的文件,然后将其和伪设备关联起来
(sudo dd if=/dev/zero of=${TMP_FILE} bs=1M count=100) >/dev/null 2>&1
LOOP_DEV=`sudo losetup -f --show ${TMP_FILE}`
#将boot0_sdcard.fex复制到${TMP_FILE}文件的8KB处
(sudo dd if=$P/boot0_sdcard.fex of=${LOOP_DEV} bs=1k seek=8) >/dev/null 2>&1
(sudo dd if=$P/u-boot.fex       of=${LOOP_DEV} bs=1k seek=19096) >/dev/null 2>&1
(sudo dd if=$P/sunxi_mbr.fex    of=${LOOP_DEV} bs=1k seek=20480) >/dev/null 2>&1
(sudo dd if=$P/boot-resource.fex of=${LOOP_DEV} bs=1k seek=36864) >/dev/null 2>&1
(sudo dd if=$P/env.fex          of=${LOOP_DEV} bs=1k seek=69632) >/dev/null 2>&1
#(sudo dd if=$P/boot.fex        of=${LOOP_DEV} bs=1k seek=86016) >/dev/null 2>&1

sudo sync

sudo losetup -d ${LOOP_DEV}
#从${TMP_FILE}8kb处复制总共复制102392kb，刚好会使${IMG_FILE}的大小为100M
(dd if=${TMP_FILE} of=${IMG_FILE} bs=1024 skip=8 count=102392 status=noxfer) >/dev/null 2>&1

rm -f ${IMG_FILE}.gz
echo "gzip ${IMG_FILE}"
gzip ${IMG_FILE}
rm -f ${TMP_FILE}

```
这个脚本是将boot0_sdcard.fex u-boot.fex sunxi_mbr.fex boot-resource.fex env.fex这几个文件制作成BPI_M3_1080P.img.gz(经过gzip压缩后的镜像文件)




**烧录镜像**
下面这个命令是基于上面命令生成的镜像文件烧录到SD卡
```
sudo gunzip -c BPI_M3_1080P.img.gz  | dd of=/dev/sdb bs=1024 seek=8
```


下面这些命令实质上是上面所有命令的一个本质上的解释。
```
#!/bin/sh
#从这里可以看出204800x512byte=100M该空间为启动程序用的空间
# make partition table by fdisk command
# reserve part for fex binaries download 0~204799
# partition1 /dev/sdc1 vfat 204800~327679
# partition2 /dev/sdc2 ext4 327680~end

die() {
        echo "$*" >&2
        exit 1
}

[ $# -eq 1 ] || die "Usage: $0 /dev/sdc"

[ -s "./env.sh" ] || die "please run ./configure first."

. ./env.sh

O=$1
P=../output/$BOARD/pack

sudo dd if=$P/boot0_sdcard.fex  of=$O bs=1k seek=8
sudo dd if=$P/u-boot.fex        of=$O bs=1k seek=19096
sudo dd if=$P/sunxi_mbr.fex     of=$O bs=1k seek=20480
sudo dd if=$P/boot-resource.fex of=$O bs=1k seek=36864
sudo dd if=$P/env.fex           of=$O bs=1k seek=69632
#sudo dd if=$P/boot.fex                 of=$O bs=1k seek=86016

```

**fdisk分区**
实际上基于上面烧录的操作之前，我们首先应该将	SD卡进行分区，每个磁盘分区的前512bytes为磁盘的分区信息。分区完成后，一般得mkfs.vfat mkfs.ext4等命令来格式对应的分区，比如上面情况为

```
mkfs.vfat /dev/sdb1
mkfs.ext4 /dev/sdb2
```


**mount命令**
mount命令，自行搜索
