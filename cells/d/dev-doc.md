lina是大启动器，d是一个文件夹代表发行版操作模块，后面的每一个都是独立的cli工具。

lina d repo 显示当前远程源
            add <url> 添加一个远程源，元数据带有名称，重复名称则报错
            del <name> 删除一个远程源
            list 列出已经安装的远程源
lina d update 获取发行版数据（更新远程源索引）
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