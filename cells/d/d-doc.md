lina 是大启动器，模块文件夹是 cells，d(distro) 是一个文件夹代表具体的模块，cells/d 下的每一个文件都是独立的 CLI 工具。

# lina 项目 d 模块开发草稿

- [完成] repo: 管理发行版源。

    ```console
    add <URL>     添加一个源到repos文件
    editor        使用编辑器打开repos文件
    ```

- [完成] update: 获取发行版数据（更新远程源索引）。
  遵循 LINA_DISTRO_INDEX v2，编排为以下格式：
  <hash(INDEX远程)>	<sh_url(source+path)>	<name>	<archs>	<versions>	<desc>
  本地数据库为 INDEX 集合，按照 <hash> 自动去重。

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
