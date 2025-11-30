# Git 命令参考手册

## 1. repo 批处理

### 1.1 打标签
```bash
.repo/repo/repo forall -c "pwd;git tag Android_4.4.4_r2_APK_ES_017cd"
```

### 1.2 上传标签
```bash
.repo/repo/repo forall -c "pwd;git push --tag"
```

## 2. 重置代码
```bash
git reset --hard HEAD
```
执行此命令代码将会还原到HEAD对应的代码

## 3. 更新代码
```bash
git pull
```

## 4. 查看差异
```bash
git status
```
查询当前项目中的文件和本地仓库中的文件差异

## 5. 查看改动
```bash
git diff
```
查询当前仓库中的文件的改动

## 6. 添加到暂存区
```bash
git add XXXXX
```
将改动或者需要提交的代码加到本地仓库中

## 7. 提交代码
```bash
git commit -m "xxxxxx"
```
提交代码，并添加描述信息

## 8. 推送到远程
```bash
git push
```
将本地代码提交到服务器

## 9. 查看分支
```bash
git branch -a
```
查看当前项目中所有的分支

```bash
git branch -vv
```
将所有本地分支列出来并且包含更多的信息，如每个分支正在跟踪哪一个远程分支与本地分支是否领先，是否落后等

## 10. 切换分支
```bash
git checkout XXXXXX
```
切换到分支

```bash
git checkout -b XXXXX
```
新建XXXXX分支并切换过去

```bash
git checkout -b serverfix origin/serverfix
```
新建serverfix分支并切换过去并使其跟踪远程分支origin/serverfix

```bash
git checkout -- XXXXXX
```
丢弃工作区某个文件的修改

## 11. 新建分支
```bash
git branch -b XXXXXX
```
新建分支

## 12. 清理未跟踪文件
```bash
git clean -nxfd
git clean -nf
git clean -nfd
```
删除未跟踪的文件
- `-n` 之后表示演习一下告诉你要删掉什么
- `-f` 表示强制删除或确认删除
- `-x` 表示删除未跟踪

## 13. 分支的创建与提交

### 配置示例
```bash
regan@THTFIT-Compiler:~/a83t/android/frameworks/base$ git config -l
user.email=regan@thtfit.com
user.name=regan
color.ui=auto
core.repositoryformatversion=0
core.filemode=true
remote.lichee.url=git:projects/workdir/allwinner/A83T/android/platform/frameworks/base.git
remote.lichee.projectname=platform/frameworks/base
remote.lichee.fetch=+refs/heads/*:refs/remotes/lichee/*
branch.a83-v1.3-thtfit.remote=lichee
branch.a83-v1.3-thtfit.merge=a83-v1.3-thtfit
branch.a83-v1.3-thtfit_KDB_hide_NavigationBar.remote=lichee
branch.a83-v1.3-thtfit_KDB_hide_NavigationBar.merge=refs/heads/a83-v1.3-thtfit_KDB_hide_NavigationBar
```

### 提交分支到远程
```bash
git push lichee a83-v1.3-thtfit_KDB_hide_NavigationBar
```
提交本地分支a83-v1.3-thtfit_KDB_hide_NavigationBar到远程仓库lichee的a83-v1.3-thtfit_KDB_hide_NavigationBar分支上（没有该分支则新建）

```bash
git push lichee a83-v1.3-thtfit_KDB_hide_NavigationBar0:a83-v1.3-thtfit_KDB_hide_NavigationBar1
```
提交本地分支a83-v1.3-thtfit_KDB_hide_NavigationBar0到远程仓库lichee的a83-v1.3-thtfit_KDB_hide_NavigationBar1分支上（没有该分支则新建）

### 关联本地分支与远程分支
```bash
git branch --set-upstream a83-v1.3-thtfit_KDB_hide_NavigationBar lichee/a83-v1.3-thtfit_KDB_hide_NavigationBar
```

## 14. 克隆仓库
```bash
git clone XXXXX
```

## 15. 查看Git配置
```bash
git config -l
```
查看git的相关配置

## 16. 合并分支
```bash
git merge XXXXX
```
将XXXX的分支合并到当前分区

## 17. 临时保存工作
```bash
git stash
```
在某个分支上的修改进行到一半并且你还不能提交当前的代码，这时你可以执行git stash将工作的内容存起来

**恢复stash：**
- `git stash list` - 查看之前的保存
- `git stash apply` - 恢复stash内容，但不删除
- `git stash drop` - 删除stash内容
- `git stash pop` - 恢复并删除stash内容
- `git stash apply stash@{0}` - 恢复指定的stash（当有多次stash时）

## 18. 图形化查看提交信息
```bash
git log --graph
```
以图形的形式查看提交信息

**优化git log命令：**
```bash
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

**设置别名：**
```bash
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```
然后执行`git lg`就等同于上面的命令了

## 19. 打补丁
```bash
patch -p0 < XXXXX.patch
```

## 20. 修改提交
```bash
git commit --amend
```
此命令用于当你commit之后发现有些文件没有添加，可以`git add ****`，然后之后执行该命令。

## 21. 撤销添加
```bash
git reset HEAD <file>
```
此命令用于当你`git add ****`，然后发现某个文件你不想git add，可以用该命令撤销将该文件add到暂存区

## 22. 生成补丁
```bash
git format-pathch -1 节点A
```
会生成1个补丁包，打完补丁包后会成为节点A的代码

**补丁应用建议：**
- 推荐使用：`git apply ***.patch` 或者 `git am ****.patch`
- 不推荐使用：`patch -p1 < ****.patch`