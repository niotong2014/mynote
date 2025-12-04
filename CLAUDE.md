# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库概述

这是 niotong 的个人笔记仓库，包含各种开发工具和系统的开发笔记、配置和命令参考。它作为技术知识库和参考指南使用。

## 项目结构

仓库包含以下内容：

- **Markdown 格式的命令参考**：`git_command.md`、`adb_command.md`、`ubuntu_command.md` 格式化的命令手册
- **开发笔记**：原始格式的命令参考文件
- **配置文件**：常规版和 Mac 版本的 Vim 配置
- **Shell 脚本**：用于开发任务的实用工具脚本
- **二进制文件**：Synergy 可执行文件和其他工具
- **PDF 文档**：技术文档文件

## 核心组件

### Git 命令 (`git_command.md`)
全面的 Git 参考手册，包括：
- Markdown 格式的结构化手册（`git_command.md`）
- 仓库批量操作（标签推送、拉取）
- 分支管理和操作
- 配置和提交工作流
- 补丁管理和暂存
- 使用自定义格式的优化日志查看

### ADB 命令 (`adb_command.md`)
Android Debug Bridge 命令，包括：
- Markdown 格式的结构化手册（`adb_command.md`）
- 设备连接和 shell 访问
- 文件传输操作（推送/拉取）
- 应用程序管理（安装/卸载）
- 系统操作和挂载
- 服务和活动管理

### Ubuntu 命令 (`ubuntu_command.md`)
Ubuntu 系统管理命令，包括：
- Markdown 格式的结构化手册（`ubuntu_command.md`）
- 软件安装和系统配置
- 网络挂载和 SSH 操作
- Shadowsocks 代理设置
- Java 环境配置
- 文件系统操作

### Shell 脚本
- `createlnfile.sh`：为 Android 交叉编译工具链文件创建符号链接
- `shell_sed.sh`：具有路径检测和 Git 状态操作的 Shell 工具（已注释）

### Vim 配置
- `vimrcniotong`：包含插件的全面 Vim 配置
- `macvimrcniotong`：具有插件管理的 Mac 特定 Vim 配置
- 包含 NERDTree、YouCompleteMe、Vundle 和开发特定映射

### Android Launcher 开发笔记 (`acquisitionaboutlauncher`)
Android Launcher 开发相关技术说明，包括：
- 屏幕分辨率适配策略（sw720dp 等规格选择）
- Workspace 和 Hotseat 布局架构
- CellLayout 配置和屏幕管理
- 文件夹（folders）和小部件（widget）设置
- 应用程序自定义（appscustomize）配置
- 启动提示（cling）和布局文件（land/port）配置

## 开发命令和工具

### Shell 脚本命令
- `bash createlnfile.sh` - 为 Android 交叉编译工具链文件创建符号链接（将 arm-linux-androideabi-* 链接为 arm-linux-eabi-*）
- `bash shell_sed.sh` - 路径检测工具（显示当前脚本路径和工作路径，包含注释掉的 Git 状态操作）

### Vim 快捷操作
根据 vimrc 配置，支持以下编译运行快捷键：
- `<F5>` - 编译运行：C/C++/Java/Shell/Python 代码的编译执行
- `<F8>` - 调试模式：C/C++ 代码的 GDB 调试
- `<F7>` - 打开 NERDTree 文件浏览器
- `<F2>` - 删除空行
- `<F12>` - 代码格式化

### Android 开发命令
```bash
# 应用开发
adb install [-r] app.apk           # 安装应用
adb uninstall [-k] com.example.app # 卸载应用
adb logcat                       # 查看日志
adb shell am start -n com.example/.MainActivity  # 启动应用

# 系统调试
adb remount                       # 获取 root 权限
adb push local.file /system/path  # 推送文件到系统
adb pull /system/path local.file  # 从系统拉取文件
```

## 开发环境

此仓库设计用于支持在 Android、Linux/Ubuntu 和 macOS 等多个平台上的开发。配置文件针对跨平台开发工作进行了优化，特别是 Android 系统开发和嵌入式编程。

## 项目架构

**知识库架构模式：**
- **分层文档结构**：原始技术文档 → 格式化 Markdown 手册 → 配置文件 → 开发脚本
- **技术栈覆盖**：Android 系统开发 → Linux 内核驱动 → Git 版本控制 → 跨平台工具配置
- **开发工作流**：Android 系统移植 → 驱动开发 → 系统调试 → 文档记录

**核心知识领域：**
1. **Android 系统开发**：固件生成、系统移植、Launcher 开发、ADB 调试
2. **Linux 内核驱动**：字符设备驱动、触摸屏驱动、LCD 驱动、音频编解码器
3. **嵌入式系统**：全志 Allwinner、晨讯 A33、晶晨 A133 平台开发
4. **系统级调试**：功耗管理、WiFi/蓝牙调试、充电控制、硬件适配

## 常用使用模式

使用此仓库时：
1. **Android 系统开发**：参考 `adb_command.md`、`Android编译错误.md`、`A523 Android13 camera测试总结.md` 等文档
2. **驱动开发**：查阅 `虚拟字符设备驱动的编写.md`、`touchpanel驱动.md`、`LCD驱动分析.md`、`codec音频编解码器驱动分析.md`
3. **硬件平台适配**：参考全志 `A523`、晨讯 `A33`、晶晨 `A133` 等平台特定文档
4. **系统调试**：使用 `kernel编译时出现的error.md`、`init.rc语法解析.md`、`WifiStateMachine分析.md` 等调试指南
5. **开发工具**：应用 Vim 配置，使用 `createlnfile.sh` 脚本，参考 `git_command.md` 进行版本控制
6. **系统配置**：使用 `ubuntu_command.md` 进行系统管理，参考 `mac环境配置.md` 进行 macOS 配置

## 文档分类索引

**Android 系统开发**：
- 固件生成与烧录：`Android烧录的固件都是怎么生成的.md`
- 系统编译：`Android.mk编译控制.md`、`Android.mk不编译odex文件.md`
- 权限管理：`Android的权限说明（apk的运行权限和sepolicy）.md`

**硬件驱动开发**：
- 触摸屏：`touchpanel驱动.md`
- 显示系统：`LCD驱动分析.md`、`MIPI DSI的配置.md`
- 音频系统：`codec音频编解码器驱动分析.md`、`I2S协议.md`
- 电源管理：`AXP707充电相关的理解.md`、`如何调整CPU的工作模式.md`

**系统调试与优化**：
- 开机优化：`A33 Android6.0开机时间优化记录.md`
- 功耗管理：`如何让系统不进去深度休眠.md`
- 网络调试：`Linux如何验证AP6212(AP6236)的bluetooth功能.md`
- WiFi 调试：`分析WifiStateMachine如何启动wifi驱动.md`

**跨平台开发**：
- JNI 开发：`jni基本编程.md`
- Java 开发：`java的命名规则.md`、`jdk环境配置.md`
- AIDL：`AIDL示例编程.md`
- C++：`代理模式和回调.md`、`排序算法.md`
