lina是大启动器，d是一个文件夹代表发行版操作模块，后面的每一个都是独立的cli工具。

[完成] lina d repo 管理发行版源。
  操作:
    add <URL>     添加一个源到配置文件
    editor        使用编辑器打开配置文件

[完成] lina d update 获取发行版数据（更新远程源索引）。
  读取所有已配置的源 URL，逐个获取并验证 INDEX 文件（CSV 格式），
  按架构展开条目后写入本地缓存。每次执行清空旧缓存，完全重建，
  跨源自动去重。

lina d search 在所有远程源中搜索发行版
lina d pull <distro:version>                    拉取发行版 rootfs 镜像，以及元数据，到d模块的images文件夹中。
lina d images                                   列出 images 文件夹下保存的 rootfs 镜像，并列出版本、源等信息。
lina d create --name <环境名称> <distro:version>不存在镜像则拉取并安装（自动执行各种钩子）。
lina d mount <环境名称>                         执行lina包装的mount底层命令，进行挂载。
lina d stop <环境名称>                          优雅终止一个容器（杀死所有那个容器的进程。
                                                执行lina包装的mount底层命令，进行卸载）
lina d kill <环境名称>                          暴力终止一个容器（杀死所有那个容器的进程。
                                                执行lina包装的mount底层命令，进行卸载）
lina d ps                                       发行版中的进程正在运行，并且已经挂载文件系统，则视为容器运行。列出
lina d ps -a                                    相较于lina d ps，列出了所有容器
lina d rm <环境名称>                            删除一个容器，若运行，则报错退出
lina d rmi <镜像名称>                           删除一个镜像，无关容器是否运行或存在
lina d enter <环境名称> - [USER=root]           进入那个容器，前提是已经挂载了。
    还可以精细控制selinux权能、Android cgroups/oom破解

lina d run <环境名称> - [USER=root]         对于已有的容器，自动处理挂载和进入

---

## 发行版源仓库格式规范

发行版源仓库是一个 git 仓库，`d update` 获取其 INDEX，`d pull` 使用其中的发行版定义文件下载 rootfs。

### 仓库结构

```
lina-distros/
  INDEX             # 机器可读的发行版目录（由 build_INDEX.sh 生成）
  distros/
    <name>.sh       # 发行版定义文件（bash 5.3+，被 source 使用）
    ...
```

### INDEX 格式

首行: 格式标识符 `# LINA_DISTRO_INDEX v1`
第二行: 字段说明注释 `# <path> <arch...> <version...>  # <description>`

数据行格式: `<path>,<archs>,<versions>  # <description>`

- 逗号分隔三个字段：定义文件路径、架构列表、版本列表
- `<path>` — 发行版定义文件在仓库内的相对路径（如 `distros/alpine.sh`）
- `<archs>` — 空格分隔的 CPU 架构列表（如 `aarch64 x86_64`）
- `<versions>` — 空格分隔的版本列表
- `#` 后为描述文本，可选

### 发行版定义文件契约

每个 `distros/<name>.sh` 文件被 `d pull` source。source 时不得有副作用。

**必须设置的变量**:

- `DESC` — 单行描述
- `OPTION_ARCH` — bash 数组，支持的架构列表
- `OPTION_VERSIONS` — bash 数组，可用的版本列表

**必须定义的函数 `distro_init()`**:

- 输入: `$1` = 架构, `$2` = 版本
- 必须设置: `SRC`（rootfs 下载地址）、`HASH_VAL`（校验值/URL/SKIP）、`HASH_CMD`（校验命令）
- 可选设置: `TAR_STRIP`（tar --strip-components，默认 0）

### 新增发行版

1. 创建 `distros/<name>.sh`，按上述契约实现
2. 运行 `build_INDEX.sh > INDEX` 重新生成索引
3. 运行 `validate.py` 验证下载链接可用性
4. 推送仓库后，用户执行 `lina d update` 即可发现新发行版
