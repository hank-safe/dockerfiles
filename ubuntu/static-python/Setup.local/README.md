# Modules/Setup.local 说明

## 这个文件是什么

CPython 构建系统通过一组 `Setup` 文件告诉 `make`，哪些标准库扩展模块需要编译、用什么源文件、链接哪些库。

| 文件 | 作用 | 维护者 |
|---|---|---|
| `Modules/Setup` | 历史遗留主清单（3.11 起几乎为空） | CPython 官方 |
| `Modules/Setup.stdlib` | **3.12 起**由 `configure` 根据系统自动生成 | configure 脚本 |
| `Modules/Setup.bootstrap` | 启动解释器必需的最小模块集 | CPython 官方 |
| `Modules/Setup.local` | **留给用户覆盖/追加的口子**（默认不存在） | 用户自己 |

构建时这几个文件由 `Modules/makesetup` 脚本合并生成 Makefile 规则，**后出现的条目覆盖前面同名模块**。

### 文件语法

```make
*static*          # 之后列出的模块全部静态链入 python 可执行文件
*shared*          # 之后列出的模块编译为 .so（动态加载）
*disabled*        # 之后列出的模块禁用，不编译

# 格式： <模块名> <源文件...> <编译/链接参数...>
_ssl _ssl.c -lssl -lcrypto
```

---

## 各版本内容应如何确定

### 最简写法（推荐，适用于 3.12+）

只写一行，其余全交给 configure 自动处理：

```make
# -*- makefile -*-
*static*
```

configure 会根据系统已安装的 `-dev` 包自动检测可用模块，生成正确的 `Setup.stdlib`，所有 `_ssl / _hashlib / _ctypes / _bz2 / _lzma / zlib` 等都会被自动列入并静态化。

> **为什么 3.11 需要手写完整清单？**
> 3.11 及以前没有 `Setup.stdlib`，configure 不会自动生成模块清单，必须在 `Setup.local` 里手动列出所有需要的模块。

---

### 需要精确裁剪时：如何获取某版本的权威清单

1. 先不放 `Setup.local`，在对应版本源码目录里跑一次 configure：

   ```bash
   cd /src/Python-<version>
   ./configure --disable-shared --with-openssl=/usr
   cat Modules/Setup.stdlib
   ```

2. `Setup.stdlib` 的输出就是该平台下的"标准答案"，把所有 `*shared*` 段落中的模块移到 `*static*` 段下，即为可用的 `Setup.local`。

---

## 各版本主要差异

| 变更 | 影响版本 |
|---|---|
| `_sha256` + `_sha512` 合并为 `_sha2`（源文件 `sha2module.c`） | 3.12+ |
| `_md5/_sha1/_sha2/_sha3/_blake2` 改用 HACL* 实现，编译参数需加 `-I$(srcdir)/Modules/_hacl/include` 和多个 `_hacl/Hacl_Hash_*.c` | 3.13+ |
| 删除（PEP 594）：`audioop` `ossaudiodev` `spwd` `crypt` `nis` `aifc` `chunk` `imghdr` `mailcap` `nntplib` `pipes` `sndhdr` `sunau` `telnetlib` `uu` `xdrlib` | 3.13 |
| 删除：`asynchat` `asyncore` `smtpd` `lib2to3` | 3.14 |
| 新增：`_zstd`（需要 `libzstd-dev`）、`_remote_debugging` | 3.14 |

---

## 编译验证

构建完成后，在生成的 python 可执行文件里跑：

```bash
./python -c "import _ssl, _hashlib, _ctypes, _bz2, _lzma, zlib, ssl, hashlib, ctypes, sqlite3; print('ok')"
```

这几个模块是 `pip install` 的依赖，缺一个都会导致包安装失败。

构建报错排查：

| 报错类型 | 原因 |
|---|---|
| `No such file or directory: xxx.c` | `Setup.local` 里引用了该版本已删除的源文件 |
| `undefined reference to ...` | 缺少 `-lxxx` 链接参数，或缺少 HACL* 的 `.c` 文件 |
| `multiple definition of ...` | 同一模块同时被 `Setup.stdlib` 和 `Setup.local` 定义，删掉 `Setup.local` 里该行 |

---

## 目录结构

每个子文件对应一个 Python 版本，由 Dockerfile 的 `COPY Setup.local/${app_version}` 指令复制到源码目录：

```
Setup.local/
├── 3.11.6     # 手写完整模块清单（3.11 无 Setup.stdlib，必须手写）
├── 3.11.13    # 同上
├── 3.12.12    # 只需 *static* 一行
├── 3.13.9     # 只需 *static* 一行
└── 3.14.0     # 只需 *static* 一行
```
