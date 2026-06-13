这是一个 lina 客户端项目, 类似 docker 操作逻辑, 用于管理 rootfs 和挂载.

cells 文件夹为 模块目录(lina 启动器 MODS_DIR 变量),
其中, 第一级的可执行文件为直接调用执行，例如 `lina <cmd> [args...]`,
文件夹代表模块, 可以使用 `lina <cmd> <sub_cmd> [args...]` 执行.

> ./lina 启动器功能已实现

目前的上游发行版源的本地仓库在 [distros_spec](../lina-distros)
可以读取本地的仓库索引 INDEX 文件进行分析，或者查看最新版本的 SPEC.md 规范文档
