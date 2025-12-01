 - 生成本地机器上生成公钥和私钥
 - 将公钥通过scp命令发送到远程服务器
```
scp .ssh/regan.pub regan@192.168.1.181:/home/regan/regan.pub
```
 - 将regan.pub添加到.ssh/authorized_keys文件里
 

```
cat regan.pub >> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
```

> ">>"这个运算符是将内容追加到文件中，如果文件存在不清空里面的内容，">"这个运算符会将文件中的内容清空然后追加。

这个就可以在本地机器中不用输入密码登录进远程服务器了。

但是还有点不方便的是，每次登录远程服务器你还得输入ssh regan@192.168.1.181.这个可以通过.ssh/config来进行配置

```
Host    别名

    HostName        主机名

    Port            端口

    User            用户名

    IdentityFile    密钥文件的路径
```
就当前这个例子config应该这样写(本地.ssh/config)

```
Host    regan

    HostName        192.168.1.181

    User            regan
```
													
