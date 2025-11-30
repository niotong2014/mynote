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

## 构建和开发命令

### 可用脚本命令
- `bash createlnfile.sh` - 为 Android 交叉编译工具链创建符号链接
- `bash shell_sed.sh` - 路径检测工具（包含注释掉的 Git 状态操作）

### 实际的"构建"命令
由于这是一个个人技术笔记仓库，没有传统的构建系统。实际的开发命令主要是：

**Android 开发相关：**
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

**代码编译（通过 Vim 配置）：**
```bash
# 在 Vim 中使用 F5 键编译运行（根据 vimrc 配置）
:call CompileRunGcc()  # C/C++ 编译运行
```

## 开发环境

此仓库设计用于支持在 Android、Linux/Ubuntu 和 macOS 等多个平台上的开发。配置文件针对跨平台开发工作进行了优化，特别是 Android 系统开发和嵌入式编程。

## 项目架构

**知识库架构模式：**
- **分层文档结构**：原始命令参考 → 格式化 Markdown 手册 → Vim 配置
- **技术栈覆盖**：Git 版本控制 → Android 调试 → 系统管理 → 编辑器配置
- **开发工作流**：Android 系统开发 → 跨平台工具配置 → 命令自动化

**核心知识领域：**
1. **Android 开发**：ADB 操作、Launcher 开发、系统调试
2. **版本控制**：Git 高级操作、分支管理、补丁处理
3. **系统管理**：Ubuntu 配置、网络挂载、环境设置
4. **开发工具**： Vim 插件生态、Shell 脚本自动化

## 常用使用模式

使用此仓库时：
1. 查阅 `git_command.md` 进行版本控制操作（推荐）
2. 使用 `adb_command.md` 进行 Android 开发任务（推荐）
3. 应用 Vim 配置以增强编辑功能
4. 根据需要遵循 `ubuntu_command.md` 系统管理指南（推荐）
5. 使用 `bash scriptname.sh` 运行 shell 脚本
6. 参考 `acquisitionaboutlauncher` 进行 Android Launcher 开发

## 笔记内容

该仓库作为活跃的知识库，包含定期更新的开发笔记、命令参考和系统配置，用于支持专业的软件开发工作流程。
