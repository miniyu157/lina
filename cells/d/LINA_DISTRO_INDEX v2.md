## 发行版源仓库格式规范

### 仓库结构

```plaintext
lina-distros/
  INDEX             # 机器可读的发行版目录（由 build_INDEX.sh 生成）
  distros/
    <name>.sh       # 发行版定义文件（bash 5.3+，被 source 使用）
    ...
```

### INDEX 格式

首行: 格式标识符 `# LINA_DISTRO_INDEX v2`

第二行: 字段说明注释 `# <hash> <path> <name> <archs> <versions> <desc>`

数据行格式: 标准 TSV（Tab-separated values），每行 6 列，无行内注释。

| 列 | 字段 | 说明 |
|----|------|------|
| 1 | `<hash>` | md5 校验值，由 `{name}\t{archs}\t{versions}\t{desc}` 计算得出 |
| 2 | `<path>` | 发行版定义文件在仓库内的相对路径（如 `distros/alpine.sh`） |
| 3 | `<name>` | 发行版名称，由 path 的 basename 去除 .sh 后缀得出（如 `alpine`） |
| 4 | `<archs>` | 空格分隔的 CPU 架构列表（如 `aarch64 x86_64`） |
| 5 | `<versions>` | 空格分隔的版本列表 |
| 6 | `<desc>` | 发行版描述文本 |

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
