# lina

在你的 Android 设备上通过 Chroot 运行 Linux 发行版。

简单、快速、优雅。

### 🛠️ 环境准备

为了避免 Android Toybox 工具的兼容性问题, lina 强依赖 Termux 的二进制文件

如果你还没有安装 Termux, 可以前往 [termux/termux-app](https://github.com/termux/termux-app/releases) 下载, 推荐下载 `Pre-release` 版本

> 使用你的 root 管理器, 如 Magisk, Apatch 等授权 termux, lina 会将 linux rootfs 安装到 `/data/local/chroot/`

使用以下命令更新软件包和下载必要的依赖

```bash
pkg update && pkg upgrade -y
```

```bash
pkg install -y git curl pv
```

> pv 是可选的, 如果没有安装 pv, `lina backup` 和 `lina restore` 命令就不会显示进度条

> 默认的字体和配色不好看吗? 安装 [Termux:Styling](https://github.com/termux/termux-styling/releases) 换一个心仪的字体和配色吧。或者直接编辑或者替换 `/data/data/com.termux/files/home/.termux/font.ttf` 和 `/data/data/com.termux/files/home/.termux/colors.properties`

### 🚀 安装

```bash
git clone https://github.com/miniyu157/lina.git ~/.local/bin/lina-bin
```

```bash
ln -s ~/.local/bin/lina-bin/lina ~/.local/bin/lina
```

> [!NOTE]
> 确保 `~/.local/bin` 位于 PATH 环境变量中

*Enjoy it!*

### 🐧 Linux 发行版

使用以下命令查看支持的发行版列表

```bash
lina install -l
```

发行版数据存放在 `core/distros/` 文件夹中, 想要添加发行版, 直接在那里创建一个 `<distros>.sh` 即可

> [!NOTE]
> 需要根据文档实现对应的方法, 位置在 [modules/core/distros/_README.txt](./modules/core/distros/_README.txt)

> 当然, lina 也会提交更多发行版的数据

### 🤝 贡献

我没有足够多的 Android 设备进行测试, lina 在不同的 Android 设备上表现也可能不同, 可能会发生难以预测的兼容性问题

所以:

**欢迎提交 Pull requests !**

> [!NOTE]
> 你可以直接运行 ./mock 来模拟 Android 的环境以调试, 前提是安装了 mksh 和 proot。
> lina 会尝试自动更新, 如果想要禁用更新, 新建一个空文件在 `./.lina-dev`, 这样就可以随意在本地修改代码了!

### ⚖️ 许可证

本项目采用 **GNU General Public License v3.0 (GPLv3)** 进行授权。
详见 [LICENSE](LICENSE) 文件。

Copyright (C) 2025 Yumeka <miniyu157@163.com>

### 🙏 致谢

* **User Interface Logic:**
    项目中的终端交互逻辑 (`lib/message.sh`) 衍生自 **Arch Linux Pacman** 项目。
  * Copyright (c) 2006-2024 Pacman Development Team
  * Copyright (c) 2002-2006 Judd Vine

