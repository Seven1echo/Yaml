#!/bin/sh

# 名称： Nikki-Tools
# 版本： V2026.9.18
# 频道： https://t.me/Seven1gogogo
# 地址： https://github.com/Seven1echo/Yaml



# ============================================================
# 基础配置
# ============================================================

TMP_DIR="/tmp/nikki_mihomo_update"

LOG_DIR="/var/log/nikki_update"

LOG_FILE="$LOG_DIR/update_$(date '+%Y-%m-%d_%H-%M-%S').log"

INSTALL_PATH="/usr/bin/mihomo"

SERVICE="/etc/init.d/nikki"

BACKUP_DIR="/usr/bin"

BACKUP_PREFIX="mihomo.backup"

MODEL_URL="https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin"

MODEL_PATH="/etc/nikki/run/Model.bin"

META_REPO="MetaCubeX/mihomo"

SMART_REPO="vernesong/mihomo"

META_ALPHA_TAG="Prerelease-Alpha"

SMART_TAG="Prerelease-Alpha"

GITHUB_API="https://api.github.com"

KEEP_BACKUPS=1

KEEP_LOG_DAYS=15


# ============================================================
# Nikki 官方安装/卸载
# ============================================================

NIKKI_FEED_SCRIPT="https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh"

NIKKI_INSTALL_SCRIPT="https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh"

NIKKI_UNINSTALL_SCRIPT="https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh"


# ============================================================
# 初始化
# ============================================================

rm -rf "$TMP_DIR"

mkdir -p "$TMP_DIR"

mkdir -p "$LOG_DIR"

mkdir -p "/etc/nikki/run"

trap 'rm -rf "$TMP_DIR"' EXIT


# ============================================================
# 日志
# ============================================================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}


# ============================================================
# 普通下载
# ============================================================

download_file() {

    URL="$1"

    OUTPUT="$2"

    rm -f "$OUTPUT"


    # --------------------------------------------------------
    # uclient-fetch
    # --------------------------------------------------------

    if command -v uclient-fetch >/dev/null 2>&1; then

        if uclient-fetch -O "$OUTPUT" "$URL" >/dev/null 2>&1; then

            if [ -s "$OUTPUT" ]; then
                return 0
            fi

        fi

    fi


    # --------------------------------------------------------
    # wget
    # --------------------------------------------------------

    if command -v wget >/dev/null 2>&1; then

        if wget --no-check-certificate -q \
            -O "$OUTPUT" "$URL"; then

            if [ -s "$OUTPUT" ]; then
                return 0
            fi

        fi


        rm -f "$OUTPUT"


        if wget -q \
            -O "$OUTPUT" "$URL"; then

            if [ -s "$OUTPUT" ]; then
                return 0
            fi

        fi

    fi


    # --------------------------------------------------------
    # curl
    # --------------------------------------------------------

    if command -v curl >/dev/null 2>&1; then

        if curl -fL \
            --connect-timeout 20 \
            --retry 2 \
            -o "$OUTPUT" \
            "$URL"; then

            if [ -s "$OUTPUT" ]; then
                return 0
            fi

        fi

    fi


    rm -f "$OUTPUT"

    return 1
}


# ============================================================
# GitHub API
# ============================================================

github_api_get() {

    URL="$1"

    OUTPUT="$2"

    rm -f "$OUTPUT"


    if command -v curl >/dev/null 2>&1; then

        if [ -n "${GITHUB_TOKEN:-}" ]; then

            if curl -fsSL \
                --connect-timeout 20 \
                --retry 2 \
                -H "Accept: application/vnd.github+json" \
                -H "Authorization: Bearer $GITHUB_TOKEN" \
                -o "$OUTPUT" \
                "$URL"; then

                [ -s "$OUTPUT" ] && return 0

            fi

        else

            if curl -fsSL \
                --connect-timeout 20 \
                --retry 2 \
                -H "Accept: application/vnd.github+json" \
                -o "$OUTPUT" \
                "$URL"; then

                [ -s "$OUTPUT" ] && return 0

            fi

        fi

    fi


    if command -v wget >/dev/null 2>&1; then

        if [ -n "${GITHUB_TOKEN:-}" ]; then

            if wget --no-check-certificate -q \
                --header="Accept: application/vnd.github+json" \
                --header="Authorization: Bearer $GITHUB_TOKEN" \
                -O "$OUTPUT" \
                "$URL"; then

                [ -s "$OUTPUT" ] && return 0

            fi

        else

            if wget --no-check-certificate -q \
                --header="Accept: application/vnd.github+json" \
                -O "$OUTPUT" \
                "$URL"; then

                [ -s "$OUTPUT" ] && return 0

            fi

        fi

    fi


    rm -f "$OUTPUT"

    return 1
}


# ============================================================
# 检查 Nikki
# ============================================================

check_nikki_installed() {

    if [ -x "$SERVICE" ] || [ -x "/etc/init.d/nikki" ]; then
        return 0
    fi

    if command -v opkg >/dev/null 2>&1; then

        if opkg status nikki 2>/dev/null | grep -q '^Status:.* installed'; then
            return 0
        fi

    fi


    if command -v apk >/dev/null 2>&1; then

        if apk info -e nikki >/dev/null 2>&1; then
            return 0
        fi

    fi


    return 1
}


# ============================================================
# Nikki 安装
# ============================================================

install_nikki() {

    echo
    echo "========================================"
    echo "          安装 / 更新 Nikki"
    echo "========================================"
    echo
    echo "  1. Feed 安装（推荐）"
    echo "  2. Release 安装"
    echo "  0. 返回"
    echo


    while true; do

        printf "请选择安装方式 [0-2]: "

        read -r INSTALL_METHOD


        case "$INSTALL_METHOD" in

            1)

                install_nikki_feed

                return $?
                ;;


            2)

                install_nikki_release

                return $?
                ;;


            0)

                return 0
                ;;


            *)

                echo "❌ 无效选择"

                ;;

        esac

    done
}


# ============================================================
# Nikki Feed 安装
#
# 官方流程：
#
# wget feed.sh | ash
#
# 然后：
#
# opkg:
#   nikki
#   luci-app-nikki
#   luci-i18n-nikki-zh-cn
#
# apk:
#   nikki
#   luci-app-nikki
#   luci-i18n-nikki-zh-cn
# ============================================================

install_nikki_feed() {

    echo
    echo "========================================"
    echo "      Nikki Feed 安装 / 更新"
    echo "========================================"
    echo


    if [ -x "/bin/opkg" ]; then

        echo "检测到 opkg"

        echo
        echo "添加 / 更新 Nikki Feed..."
        echo


        if ! wget -O - "$NIKKI_FEED_SCRIPT" | ash; then

            echo "❌ Nikki Feed 添加失败"

            return 1
        fi


        echo
        echo "安装 nikki..."
        opkg install nikki || return 1


        echo
        echo "安装 luci-app-nikki..."
        opkg install luci-app-nikki || return 1


        echo
        echo "安装中文语言包..."
        opkg install luci-i18n-nikki-zh-cn || true


        echo
        echo "✅ Nikki Feed 安装完成"


    elif [ -x "/usr/bin/apk" ]; then

        echo "检测到 apk"

        echo
        echo "添加 / 更新 Nikki Feed..."
        echo


        if ! wget -O - "$NIKKI_FEED_SCRIPT" | ash; then

            echo "❌ Nikki Feed 添加失败"

            return 1
        fi


        echo
        echo "安装 nikki..."
        apk add nikki || return 1


        echo
        echo "安装 luci-app-nikki..."
        apk add luci-app-nikki || return 1


        echo
        echo "安装中文语言包..."
        apk add luci-i18n-nikki-zh-cn || true


        echo
        echo "✅ Nikki Feed 安装完成"


    else

        echo "❌ 未检测到 opkg 或 apk"

        return 1

    fi


    return 0
}


# ============================================================
# Nikki Release 安装
# ============================================================

install_nikki_release() {

    echo
    echo "========================================"
    echo "        Nikki Release 安装"
    echo "========================================"
    echo


    if ! command -v wget >/dev/null 2>&1; then

        echo "❌ 系统没有 wget"

        return 1
    fi


    echo "执行官方 install.sh..."
    echo


    if wget -O - "$NIKKI_INSTALL_SCRIPT" | ash; then

        echo
        echo "✅ Nikki Release 安装完成"

        return 0

    else

        echo
        echo "❌ Nikki Release 安装失败"

        return 1
    fi
}


# ============================================================
# Nikki 卸载
#
# 使用官方 uninstall.sh
# ============================================================

uninstall_nikki() {

    echo
    echo "========================================"
    echo "             卸载 Nikki"
    echo "========================================"
    echo
    echo "⚠️ 此操作会按照 Nikki 官方卸载脚本执行。"
    echo
    echo "官方卸载脚本会处理："
    echo "  - nikki"
    echo "  - luci-app-nikki"
    echo "  - Nikki 语言包"
    echo "  - /etc/config/nikki"
    echo "  - /etc/nikki"
    echo "  - Nikki 日志"
    echo "  - Nikki 运行目录"
    echo "  - Nikki Feed"
    echo
    echo "请确认是否继续。"
    echo


    printf "确认卸载？输入 YES 继续: "

    read -r CONFIRM


    if [ "$CONFIRM" != "YES" ]; then

        echo "已取消卸载"

        return 0
    fi


    if ! command -v wget >/dev/null 2>&1; then

        echo "❌ 系统没有 wget"

        return 1
    fi


    echo
    echo "执行官方 uninstall.sh..."
    echo


    if wget -O - "$NIKKI_UNINSTALL_SCRIPT" | ash; then

        echo
        echo "✅ Nikki 卸载完成"

        return 0

    else

        echo
        echo "❌ Nikki 卸载失败"

        return 1

    fi
}


# ============================================================
# JSON Asset 名称提取
# ============================================================

extract_asset_names() {

    INPUT="$1"

    OUTPUT="$2"


    grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' \
        "$INPUT" 2>/dev/null \
        | sed 's/^.*"name"[[:space:]]*:[[:space:]]*"//; s/"[[:space:]]*$//' \
        | grep '\.gz$' \
        > "$OUTPUT" || true
}


# ============================================================
# Asset 匹配
# ============================================================

find_first_asset() {

    ASSET_LIST="$1"

    shift


    for PREFIX in "$@"; do

        FOUND="$(
            grep "^$PREFIX" "$ASSET_LIST" \
            | head -n 1
        )"


        if [ -n "$FOUND" ]; then

            echo "$FOUND"

            return 0

        fi

    done


    return 1
}


# ============================================================
# 架构检测
# ============================================================

detect_x86_level() {

    FLAGS=""


    if [ -r /proc/cpuinfo ]; then

        FLAGS="$(
            grep -m1 '^flags[[:space:]]*:' \
            /proc/cpuinfo 2>/dev/null
        )"

    fi


    if echo "$FLAGS" | grep -qw "avx2" &&
       echo "$FLAGS" | grep -qw "bmi2" &&
       echo "$FLAGS" | grep -qw "fma" &&
       echo "$FLAGS" | grep -qw "movbe"; then

        echo "v3"

        return
    fi


    if echo "$FLAGS" | grep -qw "sse4_2" &&
       echo "$FLAGS" | grep -qw "sse4_1" &&
       echo "$FLAGS" | grep -qw "ssse3"; then

        echo "v2"

        return
    fi


    echo "v1"
}


# ============================================================
# MIPS FPU
# ============================================================

detect_mips_float() {

    CPUINFO=""


    if [ -r /proc/cpuinfo ]; then

        CPUINFO="$(cat /proc/cpuinfo 2>/dev/null)"

    fi


    if echo "$CPUINFO" | grep -Eiq \
        '(^|[[:space:]])fpu([[:space:]]|:)|fpu[[:space:]]*:'; then

        echo "hardfloat"

        return
    fi


    echo "softfloat"
}


# ============================================================
# 架构
# ============================================================

detect_arch() {

    RAW_ARCH="$(uname -m)"


    case "$RAW_ARCH" in

        x86_64|amd64)
            BIN_ARCH="amd64"
            ;;

        i386|i486|i586|i686)
            BIN_ARCH="386"
            ;;

        aarch64|arm64)
            BIN_ARCH="arm64"
            ;;

        armv7l|armv7)
            BIN_ARCH="armv7"
            ;;

        armv6l|armv6)
            BIN_ARCH="armv6"
            ;;

        armv5*)
            BIN_ARCH="armv5"
            ;;

        mips)
            BIN_ARCH="mips"
            ;;

        mipsel|mipsle)
            BIN_ARCH="mipsle"
            ;;

        mips64)
            BIN_ARCH="mips64"
            ;;

        mips64el|mips64le)
            BIN_ARCH="mips64le"
            ;;

        riscv64)
            BIN_ARCH="riscv64"
            ;;

        s390x)
            BIN_ARCH="s390x"
            ;;

        loongarch64|loong64)
            BIN_ARCH="loong64"
            ;;

        *)
            log "❌ 不支持的系统架构: $RAW_ARCH"

            exit 1
            ;;

    esac


    CPU_LEVEL=""

    if [ "$BIN_ARCH" = "amd64" ]; then
        CPU_LEVEL="$(detect_x86_level)"
    fi


    MIPS_FLOAT=""

    if [ "$BIN_ARCH" = "mips" ] ||
       [ "$BIN_ARCH" = "mipsle" ]; then

        MIPS_FLOAT="$(detect_mips_float)"

    fi
}


# ============================================================
# 获取 MetaCubeX Release
# ============================================================

get_meta_release() {

    RELEASE_FILE="$TMP_DIR/meta_release.json"


    if [ "$CHANNEL" = "alpha" ]; then

        log "获取 MetaCubeX Alpha Release..."

        RELEASE_API="$GITHUB_API/repos/$META_REPO/releases/tags/$META_ALPHA_TAG"

    else

        log "获取 MetaCubeX Stable Release..."

        RELEASE_API="$GITHUB_API/repos/$META_REPO/releases/latest"

    fi


    if ! github_api_get "$RELEASE_API" "$RELEASE_FILE"; then

        log "❌ 获取 MetaCubeX Release 失败"

        log "API: $RELEASE_API"

        exit 1

    fi


    if grep -q '"message"[[:space:]]*:[[:space:]]*"Not Found"' \
        "$RELEASE_FILE"; then

        log "❌ GitHub 返回 Not Found"

        exit 1
    fi


    if [ "$CHANNEL" = "alpha" ]; then

        META_TAG="$META_ALPHA_TAG"

    else

        META_TAG="$(
            grep -m1 '"tag_name"[[:space:]]*:' "$RELEASE_FILE" \
            | sed 's/^.*"tag_name"[[:space:]]*:[[:space:]]*"//; s/".*$//'
        )"

    fi


    if [ -z "$META_TAG" ]; then

        log "❌ 无法获取 MetaCubeX Release Tag"

        exit 1
    fi


    META_RELEASE_FILE="$RELEASE_FILE"


    log "MetaCubeX Release: $META_TAG"
}


# ============================================================
# MetaCubeX Asset
# ============================================================

match_meta_asset() {

    ASSET_LIST="$TMP_DIR/meta_assets.txt"


    extract_asset_names \
        "$META_RELEASE_FILE" \
        "$ASSET_LIST"


    if [ ! -s "$ASSET_LIST" ]; then

        log "❌ MetaCubeX Release 没有 .gz Asset"

        exit 1
    fi


    META_ASSET=""


    case "$BIN_ARCH" in

        amd64)

            if [ "$CPU_LEVEL" = "v3" ]; then

                META_ASSET="$(
                    find_first_asset "$ASSET_LIST" \
                        "mihomo-linux-amd64-v3-" \
                        "mihomo-linux-amd64-v2-" \
                        "mihomo-linux-amd64-v1-" \
                        "mihomo-linux-amd64-compatible-" \
                        "mihomo-linux-amd64-"
                )"

            elif [ "$CPU_LEVEL" = "v2" ]; then

                META_ASSET="$(
                    find_first_asset "$ASSET_LIST" \
                        "mihomo-linux-amd64-v2-" \
                        "mihomo-linux-amd64-v1-" \
                        "mihomo-linux-amd64-compatible-" \
                        "mihomo-linux-amd64-"
                )"

            else

                META_ASSET="$(
                    find_first_asset "$ASSET_LIST" \
                        "mihomo-linux-amd64-v1-" \
                        "mihomo-linux-amd64-compatible-" \
                        "mihomo-linux-amd64-"
                )"

            fi
            ;;


        386)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-386-"
            )"
            ;;


        arm64)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-arm64-"
            )"
            ;;


        armv7)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-armv7-" \
                    "mihomo-linux-arm32v7-"
            )"
            ;;


        armv6)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-armv6-"
            )"
            ;;


        armv5)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-armv5-"
            )"
            ;;


        mips)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mips-$MIPS_FLOAT-"
            )"
            ;;


        mipsle)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mipsle-$MIPS_FLOAT-"
            )"
            ;;


        mips64)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mips64-"
            )"
            ;;


        mips64le)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mips64le-"
            )"
            ;;


        riscv64)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-riscv64-"
            )"
            ;;


        s390x)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-s390x-"
            )"
            ;;


        loong64)

            META_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-loong64-"
            )"
            ;;

    esac


    if [ -z "$META_ASSET" ]; then

        log "❌ MetaCubeX Release 没有匹配的内核"

        log "架构: $BIN_ARCH"


        if [ "$BIN_ARCH" = "amd64" ]; then
            log "CPU: $CPU_LEVEL"
        fi


        if [ "$BIN_ARCH" = "mips" ] ||
           [ "$BIN_ARCH" = "mipsle" ]; then

            log "FPU: $MIPS_FLOAT"

        fi


        log "当前 Release 可用 Asset:"

        grep '^mihomo-linux-' "$ASSET_LIST" \
            | tee -a "$LOG_FILE"


        exit 1
    fi
}


# ============================================================
# Smart Release
# ============================================================

get_smart_release() {

    RELEASE_FILE="$TMP_DIR/smart_release.json"


    log "获取 Smart Release..."


    RELEASE_API="$GITHUB_API/repos/$SMART_REPO/releases/tags/$SMART_TAG"


    if ! github_api_get "$RELEASE_API" "$RELEASE_FILE"; then

        log "❌ 获取 Smart Release 失败"

        log "API: $RELEASE_API"

        exit 1

    fi


    if grep -q '"message"[[:space:]]*:[[:space:]]*"Not Found"' \
        "$RELEASE_FILE"; then

        log "❌ Smart Release 返回 Not Found"

        exit 1

    fi


    SMART_TAG_ACTUAL="$(
        grep -m1 '"tag_name"[[:space:]]*:' "$RELEASE_FILE" \
        | sed 's/^.*"tag_name"[[:space:]]*:[[:space:]]*"//; s/".*$//'
    )"


    if [ -z "$SMART_TAG_ACTUAL" ]; then

        log "❌ 无法获取 Smart Release Tag"

        exit 1

    fi


    SMART_RELEASE_FILE="$RELEASE_FILE"


    log "Smart Release: $SMART_TAG_ACTUAL"
}


# ============================================================
# Smart Asset
# ============================================================

match_smart_asset() {

    ASSET_LIST="$TMP_DIR/smart_assets.txt"


    extract_asset_names \
        "$SMART_RELEASE_FILE" \
        "$ASSET_LIST"


    if [ ! -s "$ASSET_LIST" ]; then

        log "❌ Smart Release 没有 .gz Asset"

        exit 1

    fi


    SMART_ASSET=""


    case "$BIN_ARCH" in

        amd64)

            if [ "$CPU_LEVEL" = "v3" ]; then

                SMART_ASSET="$(
                    find_first_asset "$ASSET_LIST" \
                        "mihomo-linux-amd64-v3-" \
                        "mihomo-linux-amd64-v2-" \
                        "mihomo-linux-amd64-v1-" \
                        "mihomo-linux-amd64-compatible-" \
                        "mihomo-linux-amd64-"
                )"

            elif [ "$CPU_LEVEL" = "v2" ]; then

                SMART_ASSET="$(
                    find_first_asset "$ASSET_LIST" \
                        "mihomo-linux-amd64-v2-" \
                        "mihomo-linux-amd64-v1-" \
                        "mihomo-linux-amd64-compatible-" \
                        "mihomo-linux-amd64-"
                )"

            else

                SMART_ASSET="$(
                    find_first_asset "$ASSET_LIST" \
                        "mihomo-linux-amd64-v1-" \
                        "mihomo-linux-amd64-compatible-" \
                        "mihomo-linux-amd64-"
                )"

            fi
            ;;


        386)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-386-"
            )"
            ;;


        arm64)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-arm64-"
            )"
            ;;


        armv7)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-armv7-" \
                    "mihomo-linux-arm32v7-"
            )"
            ;;


        armv6)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-armv6-"
            )"
            ;;


        armv5)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-armv5-"
            )"
            ;;


        mips)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mips-$MIPS_FLOAT-"
            )"
            ;;


        mipsle)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mipsle-$MIPS_FLOAT-"
            )"
            ;;


        mips64)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mips64-"
            )"
            ;;


        mips64le)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-mips64le-"
            )"
            ;;


        riscv64)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-riscv64-"
            )"
            ;;


        s390x)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-s390x-"
            )"
            ;;


        loong64)

            SMART_ASSET="$(
                find_first_asset "$ASSET_LIST" \
                    "mihomo-linux-loong64-abi2-" \
                    "mihomo-linux-loong64-abi1-" \
                    "mihomo-linux-loong64-"
            )"
            ;;

    esac


    if [ -z "$SMART_ASSET" ]; then

        log "❌ Smart Release 没有匹配的内核"

        log "架构: $BIN_ARCH"


        if [ "$BIN_ARCH" = "amd64" ]; then
            log "CPU: $CPU_LEVEL"
        fi


        if [ "$BIN_ARCH" = "mips" ] ||
           [ "$BIN_ARCH" = "mipsle" ]; then

            log "FPU: $MIPS_FLOAT"

        fi


        log "当前 Smart Release 可用 Asset:"

        grep '^mihomo-linux-' "$ASSET_LIST" \
            | tee -a "$LOG_FILE"


        exit 1
    fi
}


# ============================================================
# 当前 Core 版本
# ============================================================

get_installed_version() {

    if [ -x "$INSTALL_PATH" ]; then

        VERSION="$(
            "$INSTALL_PATH" -v 2>/dev/null || true
        )"


        if [ -n "$VERSION" ]; then

            echo "$VERSION"

            return

        fi

    fi


    echo "未安装或无法读取版本"
}


# ============================================================
# gzip 校验
# ============================================================

validate_gzip() {

    FILE="$1"


    if ! gzip -t "$FILE" >/dev/null 2>&1; then

        log "❌ gzip 校验失败: $(basename "$FILE")"

        return 1

    fi


    return 0
}


# ============================================================
# 解压 + Core 执行验证
# ============================================================

prepare_core() {

    ARCHIVE="$1"

    NEW_CORE="$TMP_DIR/mihomo.new"


    rm -f "$NEW_CORE"


    log "解压内核..."


    if ! gzip -dc "$ARCHIVE" > "$NEW_CORE"; then

        log "❌ 内核解压失败"

        return 1

    fi


    if [ ! -s "$NEW_CORE" ]; then

        log "❌ 解压后的内核为空"

        return 1

    fi


    chmod +x "$NEW_CORE"


    log "验证新内核..."


    if ! "$NEW_CORE" -v >/dev/null 2>&1; then

        log "❌ 新内核无法在当前设备执行"

        return 1

    fi


    return 0
}


# ============================================================
# Core 备份
#
# 只保留 1 个最新备份
# ============================================================

backup_core() {

    if [ ! -f "$INSTALL_PATH" ]; then

        log "当前不存在旧 Core，跳过备份"

        return 0
    fi


    BACKUP_FILE="$BACKUP_DIR/${BACKUP_PREFIX}_$(date '+%Y-%m-%d_%H-%M-%S')"


    log "备份旧 Core:"
    log "$BACKUP_FILE"


    if ! cp -f "$INSTALL_PATH" "$BACKUP_FILE"; then

        log "❌ Core 备份失败"

        return 1
    fi


    chmod +x "$BACKUP_FILE"


    # --------------------------------------------------------
    # 只保留 1 个最新 Core 备份
    # --------------------------------------------------------

    FIRST=0


    for FILE in \
        "$BACKUP_DIR"/${BACKUP_PREFIX}_*; do

        [ -f "$FILE" ] || continue


        if [ "$FILE" = "$BACKUP_FILE" ]; then
            continue
        fi


        if [ "$FIRST" -eq 0 ]; then

            FIRST=1

        else

            rm -f "$FILE"

        fi

    done


    # 上面按 glob 不一定保证顺序，因此再次使用 ls 排序
    COUNT=0


    for FILE in $(
        ls -1t "$BACKUP_DIR"/${BACKUP_PREFIX}_* 2>/dev/null
    ); do

        [ -f "$FILE" ] || continue


        COUNT=$((COUNT + 1))


        if [ "$COUNT" -gt "$KEEP_BACKUPS" ]; then
            rm -f "$FILE"
        fi

    done


    return 0
}


# ============================================================
# Model.bin 备份
#
# 只保留 1 个最新备份
# ============================================================

backup_model() {

    if [ ! -f "$MODEL_PATH" ]; then
        return 0
    fi


    MODEL_BACKUP="/etc/nikki/run/Model.bin.backup_$(date '+%Y-%m-%d_%H-%M-%S')"


    log "备份旧 Model.bin:"
    log "$MODEL_BACKUP"


    if ! cp -f "$MODEL_PATH" "$MODEL_BACKUP"; then

        log "❌ Model.bin 备份失败"

        return 1

    fi


    chmod 644 "$MODEL_BACKUP"


    COUNT=0


    for FILE in $(
        ls -1t /etc/nikki/run/Model.bin.backup_* 2>/dev/null
    ); do

        [ -f "$FILE" ] || continue


        COUNT=$((COUNT + 1))


        if [ "$COUNT" -gt "$KEEP_BACKUPS" ]; then
            rm -f "$FILE"
        fi

    done


    return 0
}


# ============================================================
# Smart Model 下载
# ============================================================

download_model() {

    log "下载 Smart Model.bin..."


    if ! download_file \
        "$MODEL_URL" \
        "$TMP_DIR/Model.bin"; then

        log "❌ Model.bin 下载失败"

        return 1

    fi


    if [ ! -s "$TMP_DIR/Model.bin" ]; then

        log "❌ Model.bin 文件为空"

        return 1

    fi


    chmod 644 "$TMP_DIR/Model.bin"


    return 0
}


# ============================================================
# 普通 Core 安装
# ============================================================

install_core() {

    OLD_CORE="$TMP_DIR/mihomo.old"


    if [ -f "$INSTALL_PATH" ]; then
        cp -f "$INSTALL_PATH" "$OLD_CORE"
    fi


    log "停止 Nikki..."


    "$SERVICE" stop >/dev/null 2>&1 || true


    log "安装新 Core..."


    if ! cp -f "$NEW_CORE" "$INSTALL_PATH"; then

        log "❌ Core 安装失败"


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    chmod +x "$INSTALL_PATH"


    log "启动 Nikki..."


    if ! "$SERVICE" start >/dev/null 2>&1; then

        log "❌ Nikki 启动失败，执行回滚"


        "$SERVICE" stop >/dev/null 2>&1 || true


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    sleep 2


    if ! "$INSTALL_PATH" -v >/dev/null 2>&1; then

        log "❌ 新 Core 安装后无法执行，执行回滚"


        "$SERVICE" stop >/dev/null 2>&1 || true


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    return 0
}


# ============================================================
# Smart Core + Model 安装
# ============================================================

install_smart() {

    OLD_CORE="$TMP_DIR/mihomo.old"

    OLD_MODEL="$TMP_DIR/Model.old"


    if [ -f "$INSTALL_PATH" ]; then
        cp -f "$INSTALL_PATH" "$OLD_CORE"
    fi


    if [ -f "$MODEL_PATH" ]; then
        cp -f "$MODEL_PATH" "$OLD_MODEL"
    fi


    log "停止 Nikki..."


    "$SERVICE" stop >/dev/null 2>&1 || true


    # --------------------------------------------------------
    # Core
    # --------------------------------------------------------

    log "安装 Smart Core..."


    if ! cp -f "$NEW_CORE" "$INSTALL_PATH"; then

        log "❌ Smart Core 安装失败"


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    chmod +x "$INSTALL_PATH"


    # --------------------------------------------------------
    # Model
    # --------------------------------------------------------

    log "安装 Model.bin..."


    if ! cp -f "$TMP_DIR/Model.bin" "$MODEL_PATH"; then

        log "❌ Model.bin 安装失败"


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        if [ -f "$OLD_MODEL" ]; then

            cp -f "$OLD_MODEL" "$MODEL_PATH"

            chmod 644 "$MODEL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    chmod 644 "$MODEL_PATH"


    # --------------------------------------------------------
    # 启动
    # --------------------------------------------------------

    log "启动 Nikki..."


    if ! "$SERVICE" start >/dev/null 2>&1; then

        log "❌ Nikki 启动失败，执行回滚"


        "$SERVICE" stop >/dev/null 2>&1 || true


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        if [ -f "$OLD_MODEL" ]; then

            cp -f "$OLD_MODEL" "$MODEL_PATH"

            chmod 644 "$MODEL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    sleep 2


    if ! "$INSTALL_PATH" -v >/dev/null 2>&1; then

        log "❌ Smart Core 安装后无法执行，执行回滚"


        "$SERVICE" stop >/dev/null 2>&1 || true


        if [ -f "$OLD_CORE" ]; then

            cp -f "$OLD_CORE" "$INSTALL_PATH"

            chmod +x "$INSTALL_PATH"

        fi


        if [ -f "$OLD_MODEL" ]; then

            cp -f "$OLD_MODEL" "$MODEL_PATH"

            chmod 644 "$MODEL_PATH"

        fi


        "$SERVICE" start >/dev/null 2>&1 || true


        return 1
    fi


    return 0
}


# ============================================================
# 清理旧日志
# ============================================================

cleanup_logs() {

    find "$LOG_DIR" \
        -type f \
        -name "update_*.log" \
        -mtime +"$KEEP_LOG_DAYS" \
        -exec rm -f {} \; \
        2>/dev/null || true
}


# ============================================================
# 清理旧备份
#
# Core:
#   /usr/bin/mihomo.backup_*
#
# Model:
#   /etc/nikki/run/Model.bin.backup_*
#
# 最终均只保留 1 个最新。
# ============================================================

cleanup_backups() {

    log "清理旧 Core 备份..."


    COUNT=0


    for FILE in $(
        ls -1t "$BACKUP_DIR"/${BACKUP_PREFIX}_* 2>/dev/null
    ); do

        [ -f "$FILE" ] || continue


        COUNT=$((COUNT + 1))


        if [ "$COUNT" -gt "$KEEP_BACKUPS" ]; then

            rm -f "$FILE"

            log "删除旧 Core 备份: $FILE"

        fi

    done


    log "清理旧 Model.bin 备份..."


    COUNT=0


    for FILE in $(
        ls -1t /etc/nikki/run/Model.bin.backup_* 2>/dev/null
    ); do

        [ -f "$FILE" ] || continue


        COUNT=$((COUNT + 1))


        if [ "$COUNT" -gt "$KEEP_BACKUPS" ]; then

            rm -f "$FILE"

            log "删除旧 Model.bin 备份: $FILE"

        fi

    done
}


# ============================================================
# Core 更新
# ============================================================

update_core() {

    log "========================================"
    log "开始 Nikki Mihomo Core 更新"
    log "内核类型: $CORE_NAME"
    log "========================================"


    # --------------------------------------------------------
    # 检测架构
    # --------------------------------------------------------

    detect_arch


    log "----------------------------------------"
    log "系统架构: $RAW_ARCH"
    log "目标架构: $BIN_ARCH"


    if [ "$BIN_ARCH" = "amd64" ]; then
        log "CPU 指令集: $CPU_LEVEL"
    fi


    if [ "$BIN_ARCH" = "mips" ] ||
       [ "$BIN_ARCH" = "mipsle" ]; then

        log "MIPS FPU: $MIPS_FLOAT"

    fi


    log "----------------------------------------"


    # --------------------------------------------------------
    # 获取 Release
    # --------------------------------------------------------

    if [ "$CHANNEL" = "smart" ]; then

        get_smart_release

        match_smart_asset

        ASSET="$SMART_ASSET"


        DOWNLOAD_URL="https://github.com/$SMART_REPO/releases/download/$SMART_TAG_ACTUAL/$ASSET"


    else

        get_meta_release

        match_meta_asset

        ASSET="$META_ASSET"


        DOWNLOAD_URL="https://github.com/$META_REPO/releases/download/$META_TAG/$ASSET"

    fi


    # --------------------------------------------------------
    # 匹配结果
    # --------------------------------------------------------

    log "========================================"
    log "匹配成功"


    if [ "$CHANNEL" = "smart" ]; then

        log "Release: $SMART_TAG_ACTUAL"

    else

        log "Release: $META_TAG"

    fi


    log "Asset:   $ASSET"

    log "URL:     $DOWNLOAD_URL"

    log "========================================"


    # --------------------------------------------------------
    # 当前版本
    # --------------------------------------------------------

    log "当前 Core:"
    get_installed_version | tee -a "$LOG_FILE"


    # --------------------------------------------------------
    # 下载 Core
    # --------------------------------------------------------

    log "下载 Core..."


    if ! download_file \
        "$DOWNLOAD_URL" \
        "$TMP_DIR/$ASSET"; then

        log "❌ Core 下载失败"

        return 1
    fi


    # --------------------------------------------------------
    # gzip
    # --------------------------------------------------------

    log "验证 gzip..."


    if ! validate_gzip "$TMP_DIR/$ASSET"; then

        return 1

    fi


    # --------------------------------------------------------
    # Smart Model
    # --------------------------------------------------------

    if [ "$CHANNEL" = "smart" ]; then

        if ! download_model; then

            return 1

        fi

    fi


    # --------------------------------------------------------
    # 解压 + 验证
    # --------------------------------------------------------

    if ! prepare_core "$TMP_DIR/$ASSET"; then

        return 1

    fi


    log "新 Core 版本:"

    "$NEW_CORE" -v 2>&1 | tee -a "$LOG_FILE" || true


    # --------------------------------------------------------
    # 备份
    # --------------------------------------------------------

    if ! backup_core; then

        return 1

    fi


    if [ "$CHANNEL" = "smart" ]; then

        if ! backup_model; then

            return 1

        fi

    fi


    # --------------------------------------------------------
    # 安装
    # --------------------------------------------------------

    if [ "$CHANNEL" = "smart" ]; then

        if ! install_smart; then

            log "❌ Smart 更新失败"

            return 1

        fi

    else

        if ! install_core; then

            log "❌ Core 更新失败"

            return 1

        fi

    fi


    # --------------------------------------------------------
    # 任务完成后自动清理备份
    #
    # 最终只保留：
    #
    #   1 个 Core 备份
    #   1 个 Model.bin 备份
    # --------------------------------------------------------

    cleanup_backups


    # --------------------------------------------------------
    # 最终验证
    # --------------------------------------------------------

    log "========================================"
    log "✅ Core 更新完成"
    log "========================================"


    log "当前 Core:"

    "$INSTALL_PATH" -v 2>&1 | tee -a "$LOG_FILE" || true


    if [ "$CHANNEL" = "smart" ]; then

        if [ -f "$MODEL_PATH" ]; then

            log "Model.bin:"

            ls -lh "$MODEL_PATH" | tee -a "$LOG_FILE"

        else

            log "⚠️ Model.bin 不存在"

        fi

    fi


    cleanup_logs


    log "日志: $LOG_FILE"


    return 0
}


# ============================================================
# 主菜单
# ============================================================

main_menu() {

    while true; do

        echo
        echo "========================================"
        echo "        Nikki Mihomo 管理工具"
        echo "========================================"
        echo
        echo "  1. 更新核心 MetaCubeX Alpha"
        echo "  2. 更新核心 MetaCubeX Stable"
        echo "  3. 更新核心 Vernesong Smart"
        echo "  4. 安装 / 更新 Nikki"
        echo "  5. 卸载 Nikki"
        echo "  0. 退出"
        echo


        printf "请选择操作 [0-5]: "

        read -r MENU_CHOICE


        case "$MENU_CHOICE" in

            1)

                CHANNEL="alpha"

                CORE_NAME="MetaCubeX Alpha"

                update_core

                ;;


            2)

                CHANNEL="stable"

                CORE_NAME="MetaCubeX Stable"

                update_core

                ;;


            3)

                CHANNEL="smart"

                CORE_NAME="Smart"

                update_core

                ;;


            4)

                install_nikki

                ;;


            5)

                uninstall_nikki

                ;;


            0)

                echo "已退出"

                exit 0

                ;;


            *)

                echo "❌ 无效选择，请输入 0-5"

                ;;

        esac

    done
}


# ============================================================
# 启动
# ============================================================

main_menu