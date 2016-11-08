#!/bin/bash
niotong_shell_path=$(cd "$(dirname "$0")";pwd)
niotong_local_path=$(pwd)
echo niotong_shell_path "$niotong_shell_path"
echo niotong_local_path $niotong_local_path
#匹配 修改: 然后替换 修改: 为 （空格） 并且将结果传递给 git checkout 下面命令同理
#git status | grep '修改:' | sed 's/修改:*//' | xargs git checkout
#git status | grep '删除:' | sed 's/删除://' | xargs git checkout
#git status | grep '\b\n' | xargs rm -rf
