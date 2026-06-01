#!/usr/bin/env bash
# =============================================================================
# Relocatable Python @@APP_VERSION@@ self-extracting installer
# (Miniconda 风格：自解压 + 前缀重写)
#
# 用法：
#   bash python-@@APP_VERSION@@-installer.sh -p /opt/mypython [-b] [-f]
#       -p PREFIX   安装目录（必填）
#       -b          batch 模式，不交互
#       -f          目标目录已存在时强制覆盖
# =============================================================================
set -euo pipefail

APP_VERSION="@@APP_VERSION@@"
PLACEHOLDER_PREFIX="@@PLACEHOLDER_PREFIX@@"
PLACEHOLDER_LEN=${#PLACEHOLDER_PREFIX}

PREFIX=""
BATCH=0
FORCE=0

usage() {
    sed -n '2,12p' "$0"
    exit 1
}

while getopts "p:bfh" opt; do
    case "$opt" in
        p) PREFIX="$OPTARG" ;;
        b) BATCH=1 ;;
        f) FORCE=1 ;;
        h|*) usage ;;
    esac
done

[[ -z "$PREFIX" ]] && { echo "ERROR: -p PREFIX is required"; usage; }

# 绝对路径
case "$PREFIX" in
    /*) ;;
    *)  PREFIX="$(pwd)/$PREFIX" ;;
esac

# 长度校验：用户路径必须 <= 占位前缀长度
if [[ ${#PREFIX} -gt $PLACEHOLDER_LEN ]]; then
    echo "ERROR: install prefix too long (${#PREFIX} > ${PLACEHOLDER_LEN})"
    exit 1
fi

if [[ -e "$PREFIX" ]]; then
    if [[ $FORCE -eq 1 ]]; then
        rm -rf "$PREFIX"
    else
        echo "ERROR: $PREFIX already exists. Use -f to overwrite."
        exit 1
    fi
fi

if [[ $BATCH -eq 0 ]]; then
    echo "Installing relocatable Python ${APP_VERSION} to: $PREFIX"
    read -r -p "Proceed? [y/N] " ans
    [[ "${ans,,}" == "y" ]] || { echo "Aborted."; exit 1; }
fi

# -----------------------------------------------------------------------------
# 1. 找到 payload 起始位置（通过 gzip 魔数 1f 8b 定位）
#    Shell 头部是纯 ASCII 文本，不含 \x1f\x8b，所以首次出现即为 payload 起始位置
#    无需构建时嵌入任何偏移，适用于所有 Linux 环境
# -----------------------------------------------------------------------------
PAYLOAD_OFFSET=$(grep -boa -m 1 $'\x1f\x8b' "$0" 2>/dev/null | cut -d: -f1)
[[ -n "$PAYLOAD_OFFSET" ]] || { echo "ERROR: cannot locate gzip payload in $0"; exit 1; }

mkdir -p "$PREFIX"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "[1/3] Extracting payload ..."
tail -c +$((PAYLOAD_OFFSET + 1)) "$0" | tar -xzf - -C "$TMPDIR"

# payload 解出来是 $TMPDIR/payload/...
mv "$TMPDIR"/payload/* "$PREFIX"/
# 文件清单（构建时 manifest 也被打进 payload 的 /tmp/* 子路径）
TEXT_LST="$TMPDIR/tmp/text-files.lst"
BIN_LST="$TMPDIR/tmp/bin-files.lst"

# -----------------------------------------------------------------------------
# 2. 文本文件：直接 sed 替换占位前缀
# -----------------------------------------------------------------------------
echo "[2/3] Rewriting prefix in text files ..."
ESC_OLD=$(printf '%s\n' "$PLACEHOLDER_PREFIX" | sed -e 's/[\/&]/\\&/g')
ESC_NEW=$(printf '%s\n' "$PREFIX"             | sed -e 's/[\/&]/\\&/g')

if [[ -f "$TEXT_LST" ]]; then
    while IFS= read -r rel; do
        f="$PREFIX/${rel#./}"
        [[ -f "$f" ]] || continue
        # 只处理文本文件
        if grep -Iq . "$f" 2>/dev/null; then
            sed -i "s/${ESC_OLD}/${ESC_NEW}/g" "$f" || true
        fi
    done < "$TEXT_LST"
fi

# -----------------------------------------------------------------------------
# 3. 二进制文件：等长 + NUL 填充 替换（路径短时右侧补 \0）
#    bash 命令替换会吞掉 \0，所以 NUL 填充必须在 perl 里直接构造
# -----------------------------------------------------------------------------
echo "[3/3] Rewriting prefix in binary files ..."

if command -v perl >/dev/null 2>&1; then
    if [[ -f "$BIN_LST" ]]; then
        while IFS= read -r rel; do
            f="$PREFIX/${rel#./}"
            [[ -f "$f" ]] || continue
            PLACEHOLDER_PREFIX="$PLACEHOLDER_PREFIX" \
            NEW_PREFIX="$PREFIX" \
            PLACEHOLDER_LEN="$PLACEHOLDER_LEN" \
            perl -0777 -pi -e '
                my $old = $ENV{PLACEHOLDER_PREFIX};
                my $new = $ENV{NEW_PREFIX};
                my $pad = $ENV{PLACEHOLDER_LEN} - length($new);
                my $rep = $new . ("\0" x $pad);
                s/\Q$old\E/$rep/g;
            ' "$f" || true
        done < "$BIN_LST"
    fi
else
    echo "ERROR: perl not found, binary prefix rewrite cannot proceed"
    exit 1
fi

# 清理 manifest 残留
rm -rf "$PREFIX/tmp" 2>/dev/null || true

# 创建一个方便的 activate 脚本
cat > "$PREFIX/bin/activate-env.sh" <<EOF
# source me
export PATH="$PREFIX/bin:\$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:\${LD_LIBRARY_PATH:-}"
EOF

cat <<EOF

================================================================================
 Installation complete.

 Python:     $PREFIX/bin/python3
 Activate:   source $PREFIX/bin/activate-env.sh
 Try:        $PREFIX/bin/python3 -c 'import ssl,sqlite3,zlib; print("OK")'
================================================================================
EOF

exit 0
__ARCHIVE_BELOW__
