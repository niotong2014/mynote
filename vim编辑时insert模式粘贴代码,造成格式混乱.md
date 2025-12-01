今天遇到用vim编辑代码的时候,在insert模式下,粘贴代码时,比如我想复制如下代码

```
//add by niotong
if(a>1){
return 0;
}
```
结果造成了复制成了

```
//add by niotong
//if(a>1){
//return 0;
//}
```
这是因为vim设置了自动缩进造成的问题,所以如果你需要在insert模式下粘贴代码的话,那么先执行

```
set paste
```

这样就不会引起上述问题.
自己敲代码的时候

```
set nopaste
```

这样代码又可以自动缩进了.
当然你可以在~/.vimrc中设置

```
set pastetoggle=<F11>
```

这样可以通过F11来切换模式了

[摘自](http://blog.csdn.net/tao_627/article/details/18764539)
