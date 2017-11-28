#!/bin/bash
#将当前目录下的arm-linux-androideabi-*的文件生成软链接文件名改为arm-linux-eabi-*
FILES=`ls arm-linux-androideabi-*`;
for FILE in $FILES;
do 
echo $FILE | sed 's/arm-linux-androideabi-/arm-linux-eabi-/' |xargs ln -s $FILE 
done
