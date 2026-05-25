lina是大启动器，d是一个文件夹代表发行版操作模块，后面的每一个都是独立的cli工具。

[完成] lina d repo 管理发行版源。
  操作:
    add <URL>     添加一个源到配置文件
    editor        使用编辑器打开配置文件

[完成] lina d update 获取发行版数据（更新远程源索引）。
  读取所有已配置的源 URL，逐个获取 INDEX 文件，
  解析后将发行版条目写入本地缓存。每次执行会清空旧缓存，完全重建。
  目前还会对 INDEX 匹配 "# LINA_DISTRO_INDEX v1"

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
  INDEX             # 机器可读的发行版目录
  <arch>/
    <name>.sh       # 发行版定义文件（bash 5.3+，被 source 使用）
    ...
```

### INDEX 格式

首行必须是格式标识符 `# LINA_DISTRO_INDEX v1`。

数据行格式: `<name> <arch> <version...>  # <description>`

- NAME、ARCH 为单 token（无内部空格）
- 可列出一个或多个 VERSION
- `#` 后为描述文本，可选

### 发行版定义文件契约

每个 `<arch>/<name>.sh` 文件被 `d pull` source。source 时不得有副作用。

**必须设置的变量**:

- `DISTRO_NAME` — 发行版名称，须与文件名 stem 一致
- `DISTRO_ARCH` — 目标架构，须与父目录名一致
- `DISTRO_DESC` — 单行描述

**必须定义的函数 `distro_init()`**:

- 输入: `$1` = 版本号字符串
- 必须设置: `TAR_FILE` `SUM_FILE` `TAR_URL` `SUM_URL` `SUM_CMD`
- 可选设置: `TAR_STRIP`（tar --strip-components，默认 0）
- `SUM_URL` 三种模式: 完整 URL / `SKIP`（跳过校验）/ 纯十六进制字符串

**可选定义的函数 `distro_sum()`**:

- 输入: `$1` = tarball 路径, `$2` = 校验和文件路径
- 返回 0 成功，非 0 失败
- 未定义时默认行为: `$SUM_CMD -c "$SUM_FILE"`

### 新增发行版

1. 创建 `<arch>/<name>.sh`，按上述契约实现
2. 在 INDEX 中添加一行: `<name> <arch> <versions...>  # <description>`
3. 运行 `./validate` 验证格式
4. 推送仓库后，用户执行 `lina d update` 即可发现新发行版
