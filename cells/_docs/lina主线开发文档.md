lina 是大启动器，模块文件夹是 cells，d(distro) 是一个文件夹代表具体的模块，cells/d 下的每一个文件都是独立的 CLI 工具。

# lina 项目 d 模块开发草稿

- [完成] repo: 管理发行版源。

    ```console
    add <URL>     添加一个源到repos文件
    editor        使用编辑器打开repos文件
    ```

- [完成] update: 获取发行版数据（更新远程源索引）。
  遵循 LINA_DISTRO_INDEX v2，编排为以下格式：
  <hash(INDEX远程)> <sh_url(source+path)> <name> <archs> <versions> <desc>
  本地数据库为 INDEX 集合，位于 local_index.tsv，按照 <hash> 自动去重。

- [完成] search: 在本地发行版数据库中搜索。
  支持大小写不敏感子串匹配，多个关键字为 AND 关系。

- pull: 拉取镜像到本地，应该存储在 LINA_WORKER_DIR/images
  lina d pull <distro>:<version> [-a/arch arch]
  版本标签是必须的，如果未指定，则报错到>&2、列出可选版本，退出。
  --arch 若未提供，则根据 uname -m 自动确定。无论是手动指定还是自动指定，若不匹配，则报错到>&2、列出可选架构，退出。
  下载的镜像需要存储在 LINA_WORKER_DIR/images/blob/<hash(镜像ID)>.<ext>。
  维护一个 index.json，存储镜像元数据。

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

上游数据仓库不仅配备了 JSON 索引生成器，还配备了validate.py，能检查各个数据正确，还能检查 HTTP 请求和 sum 格式等。
lina 客户端可以添加多个上游数据仓库，仓库源还可以设置为任意 file:// ftp:// 等协议。

## 客户端 CLI 设计

目前处于 bash 原型机阶段，未来使用 go/rust 重构。
发行版小程序接口及仓库索引规范，可以参考本地仓库 ../lina-distros/SPEC.md 文件。

*lina repo:*
可以新增发行版源，editor 直接打开编辑器，一行一个 URL。
存储到本地 repos 文件（例如 ~/.config/lina/repos），为一行一个 URL 的简洁格式。

*lina update:*
遍历 repos 文件，从每个有效的仓库拉取仓库索引文件，聚合到本地数据库（例如 ~/.config/lina/local_index.json）。
会根据仓库索引的 entries[].applet.hash 去重，原地将 entries[].applet.file 由相对路径结合仓库 URL 拼凑为绝对路径。
丢弃顶层 version 和 entries 包装，条目直接构成顶层 JSON 数组。

*lina search:*
根据关键字搜索，支持多关键字做 AND 操作。

*lina pull:*
拉取发行版镜像到本地。
用法: <distro>[:version] [--arch <ARCH>] [--mirror <URL>]
参数处理: 需要拿到 DISTRO、VERSION、ARCH、MIRROR
  distro 必选，得到 DISTRO；
    使用 DISTRO 在本地数据库中匹配 [].name 或者 [].applet.hash 是否存在，
    若不存在，则报错退出，提示用户可以使用 lina search 列出或在所有发行版中搜索。
    边界情况:
      若本地数据库中存在多个相同 [].name 的条目，
      需要弹出 fzf 菜单以供选择（列出 [].name、[].applet.hash、[].applet.file 等辨识数据），
      若为非终端环境，则以非零状态码报错退出，然后列出冲突的条目和辨识数据。
  :version 和 --mirror 可选
    若显式指定，需要验证 [].options 中对应的数组中是否存在，若不存在，则报错退出并列出可选项。
    未显式指定时，若为非终端环境，则自动选择 [].options.versions[0] 和 [].options.mirrors[0] 得到 VERSION 和 MIRROR，
      若为终端环境，则为缺失的参数分别弹出 fzf 菜单，列出 [].options 中对应的数组以供选择（提供一个 auto 项目），表示自动选择数组第一项。
  --arch 可选，若未提供，则自动运行 uname -m 获取架构，得到 ARCH，
    无论是手动还是自动选择，都需要验证 [].options.archs[] 中是否存在对应 ARCH，若不存在，则报错退出并列出可选项。
操作:

                  
              拉取:
                  下载发行版（`entries[].exec.file`）的小程序后，需要传入位置参数以获取发行版文件直链。
                  发行版小程序用法: "get <version> <arch> [mirror]"
                  传入根据上述参数处理得到的 version、arch、mirror，
                  等待标准输出，需要处理超时。
                  输出结果的 JSON 形如：
                  ```
                  {
                    "src": "https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso/latest/archlinux-bootstrap-2026.06.01-x86_64.tar.zst",
                    "hash_val": "sha256:e68ba918c9f7deede8eccd2cd8ce259df104d84b0791cff3a2bc7579ced34849"
                  }
                  ```
                  其中 hash_val 的值为 "算法:文件hash" 或者 "SKIP"。

                  下载 src 到 images 文件夹的 mktemp文件夹，下载完成后，根据 hash_val 校验文件完整性。
                  成功后，存储到 images/blob/算法_文件hash（不带后缀），若 hash_val 为 SKIP，则自动获取 sha256 进行存储。

                  下载完成后，在 images 文件夹下操作索引，为下载的发行版文件存储元数据
                  包括
                  
                  
              选项:
                distro    发行版名称
                          在本地数据库中，需要查找 name 字段，可能包含多个 name 字段，
                  其中 hash 字段一定是不同的（也就是 sh_url 不同，hash 在上游根据 .sh 的 sha256 得到）。
                :version 可选，未提供则使用 versions 数组的第一个元素。
                --arch 可选，未提供则使用 uname -m 获取。
              mirror 的处理:
                mirror 在上游 .sh 中，info 命令可以获取 mirrors 数组，get 命令可以传入 mirror，
                如果不传入，则使用内部硬编码的 mirror。
                mirrors 数组被编排进了 INDEX 文件中，即本地数据库中存在 mirrors 数组。
              行为:
                执行 pull 时，检查 distro 和 version，
                若 distro 在本地数据库中不明确，则弹出 fzf 菜单，列出所有相同 name 字段的发行版，包含 sh_url 和 hash，要求用户选择。
                弹出一个 fzf 菜单，列出 mirrors，和一个 auto，要求用户选择，
                  其中 auto 代表不传入 mirror，使用上游推荐的 mirror。
                对 .sh 执行 get 命令，传入所有得到的参数，根据 .sh 的输出：src 和 hash_val。
                内容寻址。
                  在 LINA_IMAGES_DIR 中使用 mktemp，得到临时文件名，
                  将 src 以这个临时路径保存到 LINA_IMAGES_DIR 中。
                  hash_val 根据 v3.1 标准，为 "算法:hex字符串" 格式。
                  若 hash_val 为 SKIP，下载 src 后获取 sha256。
                  将那个这个临时压缩包重命名为 "算法_hex字符串"。
                每拉取一个镜像需要生成本地镜像索引。

d/images：列出本地镜像
d/create --name <NAME> <distro:version>：解压rootfs镜像到工作目录，不存在则自动拉取。
d/mount，底层命令，挂载vfs和一些必要的宿主文件，如果内核强大，则自动做隔离。若挂载，则视为容器运行。
d/stop d/kill，取消那个rootfs根目录的所有挂载、隔离和进程
d/ps -a，列出已经挂载或者有进程的容器，直接遍历/proc或者查询挂载点
d/proc，查询容器进程列表，直接遍历/proc
d/rm d/rmi，删除容器，删除镜像
d/enter <NAME> - [USER=root]，底层命令，进入一个容器
d/run <NAME> - [USER=root]，进入一个容器，如果没有挂载文件系统，则自动挂载

以下是项目的定位和介绍：

lina就像个门槛极低的跨平台wsl一样。
lina项目是基于原生chroot的linux发行版管理器，类docker逻辑。最低要求：能执行chroot mount等系统调用。
也就是任何获取root的安卓手机和linux pc都能跑。跨平台，还对Android进行大量优化，例如checkmount的怪异行为，oom破解，奇怪的cgrouov1/v2混合破解。
计划添加自动探测内核开关支持，以控制是否开启高级功能。也就是如果有折腾大神把Android编译了各个隔离功能。那么lina就可以像docker一样创造一个完全隔离的环境。
目前的类docker的发行版管理仅仅是一个d模块，打算添加一个新的模块，例如x11套接字自动共享，systemd伪装等等独特功能

详尽剖析
