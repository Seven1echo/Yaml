# 名称： nikki-tools
# 版本： V2026.10.23
# 频道： https://t.me/Seven1gogogo
# 地址： https://github.com/Seven1echo/Yaml



# ============================================================
# Nikki Mihomo Core Updater
#
# ImmortalWrt / OpenWrt / BusyBox ash
#
# 主菜单包含 Nikki 安装/卸载、核心更新、Zashboard 与 Geo 数据下载。
# 核心更新子菜单：MetaCubeX Alpha / Stable / Vernesong Smart。
# Nikki 配置子菜单：下载/编辑配置文件、启动/关闭 Nikki、查看/删除配置。
#
# Core:
#   /usr/bin/mihomo
#
# Nikki:
#   /etc/init.d/nikki
#
# Smart Model:
#   /etc/nikki/run/Model.bin
#
# 备份：
#   Core      → 只保留 1 个最新备份
#   Model.bin → 只保留 1 个最新备份
# ============================================================


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

MODEL_PATH="/etc/nikki/run/Model.bin"

META_REPO="MetaCubeX/mihomo"

SMART_REPO="vernesong/mihomo"

META_ALPHA_TAG="Prerelease-Alpha"

SMART_TAG="Prerelease-Alpha"

GITHUB_API="https://api.github.com"

KEEP_BACKUPS=1

KEEP_LOG_DAYS=15

YAML_PROFILES_DIR="/etc/nikki/profiles"
YAML_RAW_BASE_URL='https://raw.githubusercontent.com/Seven1echo/Yaml/main'
YAML_CDN_BASE_URL='https://cdn.jsdelivr.net/gh/Seven1echo/Yaml@main'
YAML_GEO_FILE='Seven1_fallback_Geo.yaml'
YAML_RULE_FILE='Seven1_fallback_Rule-Set.yaml'
YAML_GEO_SMART_FILE='Seven1_fallback_Geo_Smart.yaml'
YAML_RULE_SMART_FILE='Seven1_fallback_Rule-Set_Smart.yaml'


# ============================================================
# Nikki 官方安装/卸载
# ============================================================

# ============================================================
# 初始化
# ============================================================

rm -rf "$TMP_DIR"

mkdir -p "$TMP_DIR"

mkdir -p "$LOG_DIR"

mkdir -p "/etc/nikki/run"

active_download_pid_file=''
active_download_monitor_pid=''

interrupt_download() {
    if [ -n "$active_download_pid_file" ] && [ -f "$active_download_pid_file" ]; then
        _active_child_pid=$(cat "$active_download_pid_file" 2>/dev/null)
        case "$_active_child_pid" in
            ''|*[!0-9]*) ;;
            *) kill -KILL "$_active_child_pid" 2>/dev/null ;;
        esac
    fi
    if [ -n "$active_download_monitor_pid" ]; then
        wait "$active_download_monitor_pid" 2>/dev/null
    fi
    printf '\n%s下载已被 Ctrl+C 中断。%s\n' "$C_YELLOW" "$C_RESET"
    exit 130
}

trap 'rm -rf "$TMP_DIR"' EXIT
trap 'interrupt_download' INT TERM

# 仅在交互式终端启用颜色；NO_COLOR 可关闭颜色输出。
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    C_RESET=$(printf '\033[0m')
    C_CYAN=$(printf '\033[36m')
    C_BLUE=$(printf '\033[34m')
    C_GREEN=$(printf '\033[32m')
    C_YELLOW=$(printf '\033[33m')
    C_RED=$(printf '\033[31m')
    C_BOLD=$(printf '\033[1m')
else
    C_RESET=''
    C_CYAN=''
    C_BLUE=''
    C_GREEN=''
    C_YELLOW=''
    C_RED=''
    C_BOLD=''
fi


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

    printf '下载链接：%s\n' "$URL"


    # --------------------------------------------------------
    # uclient-fetch
    # --------------------------------------------------------

    if command -v uclient-fetch >/dev/null 2>&1; then

        if uclient-fetch -O "$OUTPUT" "$URL"; then

            if [ -s "$OUTPUT" ]; then
                return 0
            fi

        fi

    fi


    # --------------------------------------------------------
    # wget
    # --------------------------------------------------------

    if command -v wget >/dev/null 2>&1; then

        if wget --no-check-certificate \
            -O "$OUTPUT" "$URL"; then

            if [ -s "$OUTPUT" ]; then
                return 0
            fi

        fi


        rm -f "$OUTPUT"


        if wget \
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

        if curl -fL --progress-bar \
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
    printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
    printf '%s          安装 / 更新 Nikki%s\n' "$C_BOLD$C_CYAN" "$C_RESET"
    printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
    echo
    printf '%s  1. Feed（推荐）%s\n' "$C_BLUE" "$C_RESET"
    printf '%s  2. Release %s\n' "$C_BLUE" "$C_RESET"
    echo


    while true; do

        printf '%s请选择安装方式 [1-2]（直接回车返回上一级）：%s' "$C_BOLD$C_GREEN" "$C_RESET"

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


            '')

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


        if ! run_nikki_script 'Nikki Feed' "$NIKKI_FEED_URLS" feed.sh; then

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


        if ! run_nikki_script 'Nikki Feed' "$NIKKI_FEED_URLS" feed.sh; then

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


    echo "执行官方 install.sh..."
    echo


    if run_nikki_script 'Nikki install.sh' "$NIKKI_INSTALL_URLS" install.sh; then

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


    printf "确认卸载？输入 y/Y 继续，直接回车返回上一级: "

    read -r CONFIRM


    case "$CONFIRM" in
        y|Y) ;;
        *)

        echo "已取消卸载"

        return 0
        ;;
    esac


    echo
    echo "执行官方 uninstall.sh..."
    echo


    if run_nikki_script 'Nikki uninstall.sh' "$NIKKI_UNINSTALL_URLS" uninstall.sh; then

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

    printf '\n%s注意：下载新的 Smart Model.bin 会覆盖当前模型。请注意备份！！！。%s\n' "$C_BOLD$C_YELLOW" "$C_RESET"
    printf '如需继续下载请输入 y/Y；直接回车取消：'
    IFS= read -r _model_download_confirm
    case "$_model_download_confirm" in
        y|Y) ;;
        *)
            log "已取消 Smart Model.bin 下载"
            return 2
            ;;
    esac

    log "下载 Smart Model.bin..."


    if ! download_with_fallbacks \
        'Smart Model.bin' \
        "$TMP_DIR/Model.bin" \
        "$MODEL_URLS" \
        valid_nonempty; then

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

    if [ "$MODEL_UPDATE" = "1" ]; then
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
    else
        log "保留当前 Model.bin，跳过模型覆盖"
    fi


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

    MODEL_UPDATE=0
    if [ "$CHANNEL" = "smart" ]; then
        download_model
        MODEL_DOWNLOAD_STATUS=$?
        case "$MODEL_DOWNLOAD_STATUS" in
            0)
                MODEL_UPDATE=1
                ;;
            2)
                log "跳过 Smart Model.bin 下载，继续更新核心"
                ;;
            *)
                return 1
                ;;
        esac

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


    if [ "$CHANNEL" = "smart" ] && [ "$MODEL_UPDATE" = "1" ]; then

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


RUN_DIR="/etc/nikki/run"
UI_DIR="$RUN_DIR/ui"

NIKKI_FEED_URLS='
https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh
https://cdn.jsdelivr.net/gh/nikkinikki-org/OpenWrt-nikki@refs/heads/main/feed.sh
https://gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh
https://v4.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh
https://v6.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh
https://cdn.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh
https://axisnow.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh
'
NIKKI_INSTALL_URLS='
https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh
https://cdn.jsdelivr.net/gh/nikkinikki-org/OpenWrt-nikki@refs/heads/main/install.sh
https://gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh
https://v4.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh
https://v6.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh
https://cdn.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh
https://axisnow.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/install.sh
'
NIKKI_UNINSTALL_URLS='
https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh
https://cdn.jsdelivr.net/gh/nikkinikki-org/OpenWrt-nikki@refs/heads/main/uninstall.sh
https://gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh
https://v4.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh
https://v6.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh
https://cdn.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh
https://axisnow.gh-proxy.org/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh
'
MODEL_URLS='
https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin
https://cdn.jsdelivr.net/gh/vernesong/mihomo@releases/download/LightGBM-Model/Model.bin
https://gh-proxy.org/https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin
https://v4.gh-proxy.org/https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin
https://v6.gh-proxy.org/https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin
https://cdn.gh-proxy.org/https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin
https://axisnow.gh-proxy.org/https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin
'

GEOSITE_URLS='
https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat
https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@releases/download/latest/geosite.dat
https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geosite.dat
https://gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
https://v4.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
https://v6.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
https://cdn.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
https://axisnow.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
'
GEOIP_URLS='
https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat
https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@releases/download/latest/geoip.dat
https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/geoip.dat
https://gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
https://v4.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
https://v6.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
https://cdn.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
https://axisnow.gh-proxy.org/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat
'
UI_URLS='
https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip
https://cdn.jsdelivr.net/gh/Zephyruso/zashboard@releases/latest/download/dist.zip
https://gh-proxy.org/https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip
https://v4.gh-proxy.org/https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip
https://v6.gh-proxy.org/https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip
https://cdn.gh-proxy.org/https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip
https://axisnow.gh-proxy.org/https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip
'

cleanup_files=''
download_serial=0

# 下载运行期间每 1 分钟询问一次。输入 y/Y 终止当前链接并继续备用链接；
# 直接回车则继续等待当前下载。
download_with_prompt() {
	output_file=$2
	header_file=$3
	shift 3
	download_serial=$((download_serial + 1))
	status_file="$TMP_DIR/download-status-$$-$download_serial"
	pid_file="$TMP_DIR/download-pid-$$-$download_serial"
	progress_file="$TMP_DIR/download-progress-$$-$download_serial"
	active_download_pid_file=$pid_file
	rm -f "$status_file" "$pid_file" "$progress_file"
	(
		"$@" > "$progress_file" 2>&1 &
		child_pid=$!
		printf '%s\n' "$child_pid" > "$pid_file"
		wait "$child_pid"
		result=$?
		printf '%s\n' "$result" > "$status_file"
		exit "$result"
	) &
	monitor_pid=$!
	active_download_monitor_pid=$monitor_pid
	elapsed=0
	progress_bar='------------------------------'
	progress_status='0.00%'
	printf '%s倒计时：01:00 | 下载进度：%s %s                    %s' "$C_YELLOW" "$progress_bar" "$progress_status" "$C_RESET"
	while [ ! -f "$status_file" ]; do
		sleep 1
		if [ -f "$status_file" ]; then
			printf '\r下载已结束，倒计时停止。%100s%s\n' '' "$C_RESET"
			break
		fi
		elapsed=$((elapsed + 1))
		remaining=$((60 - elapsed))
		if [ "$remaining" -ge 0 ]; then
			if [ -f "$output_file" ]; then
				current_bytes=$(wc -c < "$output_file" 2>/dev/null | tr -d '[:space:]')
			else
				current_bytes=0
			fi
			case "$current_bytes" in ''|*[!0-9]*) current_bytes=0 ;; esac
			total_bytes=$(awk 'tolower($1) == "content-length:" || tolower($1) == "length:" { gsub(/\r/, "", $2); if ($2 ~ /^[0-9]+$/) total = $2 } END { print total }' "$header_file" "$progress_file" 2>/dev/null)
			case "$total_bytes" in
				''|*[!0-9]*|0)
					progress_status="$current_bytes B"
					filled=0
					;;
				*)
					progress_status=$(awk -v got="$current_bytes" -v total="$total_bytes" 'BEGIN { p = got * 100 / total; if (p > 100) p = 100; printf "%.2f%%", p }')
					filled=$(awk -v got="$current_bytes" -v total="$total_bytes" 'BEGIN { n = int(got * 30 / total); if (n > 30) n = 30; printf "%d", n }')
					;;
			esac
			progress_bar=''
			bar_index=0
			while [ "$bar_index" -lt "$filled" ]; do
				progress_bar="${progress_bar}#"
				bar_index=$((bar_index + 1))
			done
			while [ "$bar_index" -lt 30 ]; do
				progress_bar="${progress_bar}."
				bar_index=$((bar_index + 1))
			done
			printf '\r%s倒计时：%02d:%02d | 下载进度：%s %s                    %s' "$C_YELLOW" "$((remaining / 60))" "$((remaining % 60))" "$progress_bar" "$progress_status" "$C_RESET"
		fi
		if [ "$elapsed" -ge 60 ]; then
			child_pid=$(cat "$pid_file" 2>/dev/null)
			case "$child_pid" in
				''|*[!0-9]*) ;;
				*) kill -STOP "$child_pid" 2>/dev/null ;;
			esac
			printf '\n%s当前链接已下载 1 分钟，仍未完成。回车继续等待，输入 y/Y 切换到下一条链接：%s' "$C_YELLOW" "$C_RESET"
			read -r answer
			case "$answer" in
				y|Y)
					if [ -f "$status_file" ]; then
						break
					fi
					case "$child_pid" in
						''|*[!0-9]*) ;;
						*) kill -KILL "$child_pid" 2>/dev/null ;;
					esac
					wait "$monitor_pid" 2>/dev/null
					result=$(cat "$status_file" 2>/dev/null)
					rm -f "$status_file" "$pid_file" "$progress_file"
					active_download_pid_file=''
					active_download_monitor_pid=''
					[ "$result" = 0 ] && return 0
					return 2
					;;
				*)
					case "$child_pid" in
						''|*[!0-9]*) ;;
						*) kill -CONT "$child_pid" 2>/dev/null ;;
					esac
					download_user_continued=1
					if [ -f "$status_file" ]; then
						break
					fi
					elapsed=0
					printf '%s继续等待，下一次询问倒计时 01:00%s' "$C_YELLOW" "$C_RESET"
					;;
			esac
		fi
	done
	wait "$monitor_pid" 2>/dev/null
	result=$(cat "$status_file" 2>/dev/null)
	if [ "$result" != 0 ] && [ -s "$progress_file" ]; then
		tr '\r' '\n' < "$progress_file" | tail -n 5 >&2
	fi
	rm -f "$status_file" "$pid_file" "$progress_file"
	active_download_pid_file=''
	active_download_monitor_pid=''
	[ "$result" = 0 ]
}

fetch() {
	url=$1
	out=$2
	header_file="$TMP_DIR/download-headers-$$-$download_serial"
	rm -f "$out"
	: > "$header_file"
	printf '%s当前下载链接：%s%s\n' "$C_CYAN" "$url" "$C_RESET"
	if command -v curl >/dev/null 2>&1; then
		download_with_prompt "$url" "$out" "$header_file" curl -fL --progress-bar --connect-timeout 15 --max-time 0 --retry 0 -D "$header_file" -o "$out" "$url"
		result=$?
	elif command -v wget >/dev/null 2>&1; then
		download_with_prompt "$url" "$out" "$header_file" wget -O "$out" "$url"
		result=$?
	else
		echo '错误：需要安装 curl 或 wget。' >&2
		return 127
	fi
	rm -f "$header_file"
	[ "$result" -eq 0 ] || return "$result"
	[ -s "$out" ]
}

test_download_url() {
	_test_url=$1
	if command -v curl >/dev/null 2>&1; then
		_test_elapsed=$(curl -fsSIL --connect-timeout 5 --max-time 8 -o /dev/null -w '%{time_total}' "$_test_url" 2>/dev/null)
		_test_status=$?
		[ "$_test_status" -eq 0 ] || return 1
		awk -v elapsed="$_test_elapsed" 'BEGIN { printf "%.3f", elapsed }'
	elif command -v wget >/dev/null 2>&1; then
		_test_started=$(date +%s)
		wget -q --spider -T 8 "$_test_url" >/dev/null 2>&1
		_test_status=$?
		[ "$_test_status" -eq 0 ] || return 1
		_test_finished=$(date +%s)
		printf '%s' "$((_test_finished - _test_started))"
	else
		return 127
	fi
}

download_with_fallbacks() {
	_fallback_label=$1
	_fallback_destination=$2
	_fallback_urls=$3
	_fallback_validator=$4
	_fallback_count=0
	_fallback_primary=''
	for _fallback_url in $_fallback_urls; do
		_fallback_count=$((_fallback_count + 1))
		[ "$_fallback_count" -eq 1 ] && _fallback_primary=$_fallback_url
	done
	[ -n "$_fallback_primary" ] || return 1
	_fallback_tmp="$TMP_DIR/nikki-$(basename "$_fallback_destination").$$.part"
	cleanup_files="$cleanup_files $_fallback_tmp"

	printf '\n%s>>> 正在下载：%s <<<%s\n' "$C_BOLD$C_YELLOW" "$_fallback_label" "$C_RESET"
	printf '%s主链接下载中。%s\n' "$C_CYAN" "$C_RESET"
	download_user_continued=0
	if fetch "$_fallback_primary" "$_fallback_tmp"; then
		if "$_fallback_validator" "$_fallback_tmp"; then
			mkdir -p "$(dirname "$_fallback_destination")" || return 1
			mv -f "$_fallback_tmp" "$_fallback_destination" || return 1
			printf '%s%s：已保存到 %s%s\n' "$C_GREEN" "$_fallback_label" "$_fallback_destination" "$C_RESET"
			return 0
		fi
		printf '%s主链接下载完成，但文件校验失败。%s\n' "$C_RED" "$C_RESET" >&2
	else
		printf '%s主链接下载失败。%s\n' "$C_RED" "$C_RESET" >&2
	fi

	printf '\n%s正在测试 %s 的全部 %s 条链接：%s\n' "$C_BOLD$C_CYAN" "$_fallback_label" "$_fallback_count" "$C_RESET"
	_fallback_index=0
	for _fallback_url in $_fallback_urls; do
		_fallback_index=$((_fallback_index + 1))
		_fallback_latency=$(test_download_url "$_fallback_url")
		if [ "$?" -eq 0 ]; then
			printf '  [%s] %s延迟：%s 秒%s | %s\n' "$_fallback_index" "$C_GREEN" "$_fallback_latency" "$C_RESET" "$_fallback_url"
		else
			printf '  [%s] %s不可用（请求失败或超时）%s | %s\n' "$_fallback_index" "$C_RED" "$C_RESET" "$_fallback_url"
		fi
	done

	while true; do
		printf '\n输入要使用的链接编号 [1-%s]，直接回车取消并返回上一级：' "$_fallback_count"
		read -r _fallback_choice
		case "$_fallback_choice" in
			'') return 1 ;;
			*[!0-9]*) printf '%s请输入有效编号，或直接回车返回。%s\n' "$C_RED" "$C_RESET"; continue ;;
		esac
		if [ "$_fallback_choice" -lt 1 ] || [ "$_fallback_choice" -gt "$_fallback_count" ]; then
			printf '%s编号超出范围。%s\n' "$C_RED" "$C_RESET"
			continue
		fi

		_fallback_index=0
		_fallback_selected=''
		for _fallback_url in $_fallback_urls; do
			_fallback_index=$((_fallback_index + 1))
			if [ "$_fallback_index" -eq "$_fallback_choice" ]; then
				_fallback_selected=$_fallback_url
				break
			fi
		done
		printf '\n%s选择链接 [%s]：%s%s\n' "$C_CYAN" "$_fallback_choice" "$_fallback_selected" "$C_RESET"
		download_user_continued=0
		if fetch "$_fallback_selected" "$_fallback_tmp"; then
			if "$_fallback_validator" "$_fallback_tmp"; then
				mkdir -p "$(dirname "$_fallback_destination")" || return 1
				mv -f "$_fallback_tmp" "$_fallback_destination" || return 1
				printf '%s%s：已保存到 %s%s\n' "$C_GREEN" "$_fallback_label" "$_fallback_destination" "$C_RESET"
				return 0
			fi
			printf '%s下载完成，但文件校验失败，请选择其他链接。%s\n' "$C_RED" "$C_RESET" >&2
		else
			printf '%s该链接下载失败，请选择其他链接。%s\n' "$C_RED" "$C_RESET" >&2
		fi
	done
}

run_nikki_script() {
	_nikki_script_label=$1
	_nikki_script_urls=$2
	_nikki_script_file="$TMP_DIR/$3"
	if ! download_with_fallbacks "$_nikki_script_label" "$_nikki_script_file" "$_nikki_script_urls" valid_nonempty; then
		return 1
	fi
	ash "$_nikki_script_file"
}

valid_nonempty() { [ -s "$1" ]; }

# Nikki profile management. Reuses this script's download helpers and temp area.
yaml_quote() {
	_yaml_quote_value=$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g')
	printf '"%s"' "$_yaml_quote_value"
}

yaml_download_template() {
	printf '%s请选择要下载的配置模板：%s\n' "$C_CYAN" "$C_RESET"
	printf '%s  1) 常规核心：%s%s\n' "$C_BLUE" "$YAML_GEO_FILE" "$C_RESET"
	printf '%s  2) 常规核心：%s%s\n' "$C_BLUE" "$YAML_RULE_FILE" "$C_RESET"
	printf '%s  3) Smart核心：%s%s\n' "$C_BLUE" "$YAML_GEO_SMART_FILE" "$C_RESET"
	printf '%s  4) Smart核心：%s%s\n' "$C_BLUE" "$YAML_RULE_SMART_FILE" "$C_RESET"
	while true; do
		printf '%s请输入编号 [1-4]（直接回车返回上一级）：%s' "$C_BOLD$C_GREEN" "$C_RESET"
		read -r yaml_template_choice
		case "$yaml_template_choice" in
			1) YAML_TEMPLATE=$YAML_GEO_FILE; YAML_REMOTE_PATH=$YAML_TEMPLATE; break ;;
			2) YAML_TEMPLATE=$YAML_RULE_FILE; YAML_REMOTE_PATH=$YAML_TEMPLATE; break ;;
			3) YAML_TEMPLATE=$YAML_GEO_SMART_FILE; YAML_REMOTE_PATH="smart/$YAML_TEMPLATE"; break ;;
			4) YAML_TEMPLATE=$YAML_RULE_SMART_FILE; YAML_REMOTE_PATH="smart/$YAML_TEMPLATE"; break ;;
			'') return 0 ;;
			*) printf '%s无效选择，请输入 1-4，或直接回车返回。%s\n' "$C_RED" "$C_RESET" ;;
		esac
	done

	YAML_SOURCE="$YAML_WORK_DIR/$YAML_TEMPLATE"
	YAML_URLS="$YAML_RAW_BASE_URL/$YAML_REMOTE_PATH
$YAML_CDN_BASE_URL/$YAML_REMOTE_PATH"
	if ! download_with_fallbacks "Nikki 配置模板 $YAML_TEMPLATE" "$YAML_SOURCE" "$YAML_URLS" valid_nonempty; then
		return 1
	fi

	YAML_PROVIDERS="$YAML_WORK_DIR/providers"
	YAML_NAMES="$YAML_WORK_DIR/provider_names"
	: > "$YAML_PROVIDERS"
	: > "$YAML_NAMES"
	YAML_PROVIDER_COUNT=0
	YAML_EXIT_ADD=0
	while true; do
		printf '请输入机场名：'
		read -r YAML_AIRPORT
		if [ -z "$YAML_AIRPORT" ]; then
			printf '%s机场名不能为空。%s\n' "$C_RED" "$C_RESET"
			continue
		fi
		if grep -F -x -q -- "$YAML_AIRPORT" "$YAML_NAMES"; then
			printf '%s机场名重复，请输入一个未使用的名称。%s\n' "$C_RED" "$C_RESET"
			continue
		fi
		printf '请输入订阅链接（http/https）：'
		read -r YAML_SUBSCRIPTION_URL
		case "$YAML_SUBSCRIPTION_URL" in
			https://*|http://*) ;;
			*) printf '%s订阅链接必须以 http:// 或 https:// 开头。%s\n' "$C_RED" "$C_RESET"; continue ;;
		esac
		printf '请输入节点前缀（可选，留空则不添加）：'
		read -r YAML_NODE_PREFIX
		YAML_QUOTED_AIRPORT=$(yaml_quote "$YAML_AIRPORT")
		YAML_QUOTED_URL=$(yaml_quote "$YAML_SUBSCRIPTION_URL")
		if [ -n "$YAML_NODE_PREFIX" ]; then
			YAML_QUOTED_PREFIX=$(yaml_quote "[$YAML_NODE_PREFIX] ")
			printf '  %s: {<<: *Anchor_PR, url: %s, override: {additional-prefix: %s}}\n' \
				"$YAML_QUOTED_AIRPORT" "$YAML_QUOTED_URL" "$YAML_QUOTED_PREFIX" >> "$YAML_PROVIDERS"
		else
			printf '  %s: {<<: *Anchor_PR, url: %s}\n' \
				"$YAML_QUOTED_AIRPORT" "$YAML_QUOTED_URL" >> "$YAML_PROVIDERS"
		fi
		printf '%s\n' "$YAML_AIRPORT" >> "$YAML_NAMES"
		YAML_PROVIDER_COUNT=$((YAML_PROVIDER_COUNT + 1))
		while true; do
			printf '是否继续添加订阅？输入 y/Y 继续，直接回车跳到下一步：'
			read -r YAML_ADD_MORE
			case "$YAML_ADD_MORE" in
				y|Y) break ;;
				'') YAML_EXIT_ADD=1; break ;;
				*) printf '请输入 y/Y 继续，或直接回车跳到下一步。\n' ;;
			esac
		done
		[ "$YAML_EXIT_ADD" -eq 1 ] && break
	done

	YAML_DNS_FILE="$YAML_WORK_DIR/dns"
	: > "$YAML_DNS_FILE"
	YAML_DNS_COUNT=0
	YAML_EXIT_DNS=0
	printf '请输入 DNS IPv4 地址；直接回车使用推荐地址 114.114.114.114 和 223.5.5.5。\n'
	while true; do
		printf 'DNS IPv4：'
		read -r YAML_DNS
		if [ -z "$YAML_DNS" ]; then
			if [ "$YAML_DNS_COUNT" -eq 0 ]; then
				printf '    - 114.114.114.114\n    - 223.5.5.5\n' > "$YAML_DNS_FILE"
			else
				printf '已保留之前输入的 DNS。\n'
			fi
			break
		fi
		case "$YAML_DNS" in *[!0-9.]*|.*|*.|*..*) printf '格式错误：只能输入数字和点，且须为有效 IPv4。\n'; continue ;; esac
		YAML_OLD_IFS=$IFS
		IFS=.
		set -- $YAML_DNS
		IFS=$YAML_OLD_IFS
		YAML_VALID=1
		[ "$#" -eq 4 ] || YAML_VALID=0
		if [ "$YAML_VALID" -eq 1 ]; then
			for YAML_OCTET in "$@"; do
				[ "${#YAML_OCTET}" -le 3 ] || YAML_VALID=0
				[ "$YAML_OCTET" -ge 0 ] 2>/dev/null && [ "$YAML_OCTET" -le 255 ] 2>/dev/null || YAML_VALID=0
			done
		fi
		if [ "$YAML_VALID" -ne 1 ]; then printf '格式错误：请输入有效 IPv4 地址，例如 114.114.114.114。\n'; continue; fi
		printf '    - %s\n' "$YAML_DNS" >> "$YAML_DNS_FILE"
		YAML_DNS_COUNT=$((YAML_DNS_COUNT + 1))
		while true; do
			printf '还要添加一个 DNS？输入 y/Y 继续，直接回车跳到下一步：'
			read -r YAML_ADD_DNS
			case "$YAML_ADD_DNS" in
				y|Y) break ;;
				'') YAML_EXIT_DNS=1; break ;;
				*) printf '请输入 y/Y 继续，或直接回车跳到下一步。\n' ;;
			esac
		done
		[ "$YAML_EXIT_DNS" -eq 1 ] && break
	done

	YAML_OUTPUT="$YAML_WORK_DIR/output.yaml"
	if ! awk -v providers="$YAML_PROVIDERS" -v dnsfile="$YAML_DNS_FILE" '
	function emit_file(file, line) { while ((getline line < file) > 0) print line; close(file) }
	BEGIN { in_providers=0; in_dns=0; providers_done=0; dns_done=0; core_boundary=0; strategy_boundary=0 }
	{
		if (in_providers) {
			if ($0 ~ /核心配置/) { print ""; print ""; print ""; print; in_providers=0; core_boundary=1; next }
			if ($0 ~ /^[A-Za-z0-9_-]+:/) in_providers=0
			else next
		}
		if (in_dns) {
			if ($0 ~ /策略分组/) { print ""; print ""; print ""; print; in_dns=0; strategy_boundary=1; next }
			if ($0 ~ /^  [A-Za-z0-9_-]+:/ || $0 ~ /^[A-Za-z0-9_-]+:/) in_dns=0
			else next
		}
		if ($0 ~ /^proxy-providers:[[:space:]]*$/) { print; emit_file(providers); providers_done=1; in_providers=1; next }
		if ($0 ~ /^  nameserver:[[:space:]]*(#.*)?$/) { print; emit_file(dnsfile); dns_done=1; in_dns=1; next }
		print
	}
	END { if (!providers_done || !dns_done || !core_boundary || !strategy_boundary) exit 2 }
	' "$YAML_SOURCE" > "$YAML_OUTPUT"; then
		printf '%s未找到预期的订阅、DNS 或分隔标题，未保存配置。%s\n' "$C_RED" "$C_RESET" >&2
		return 1
	fi

	if ! mkdir -p "$YAML_PROFILES_DIR"; then
		printf '%s无法创建配置目录：%s%s\n' "$C_RED" "$YAML_PROFILES_DIR" "$C_RESET" >&2
		return 1
	fi
	YAML_DEST="$YAML_PROFILES_DIR/$YAML_TEMPLATE"
	if [ -e "$YAML_DEST" ]; then
		while true; do
			printf '%s 已存在，覆盖吗？输入 y/Y 覆盖，直接回车取消：' "$YAML_DEST"
			read -r YAML_OVERWRITE
			case "$YAML_OVERWRITE" in
				y|Y) break ;;
				'') printf '已取消，原文件未修改。\n'; return 0 ;;
				*) printf '请输入 y/Y 覆盖，或直接回车取消。\n' ;;
			esac
		done
	fi
	if ! cp "$YAML_OUTPUT" "$YAML_DEST.tmp.$$" || ! mv -f "$YAML_DEST.tmp.$$" "$YAML_DEST"; then
		rm -f "$YAML_DEST.tmp.$$"
		printf '%s保存配置失败：%s%s\n' "$C_RED" "$YAML_DEST" "$C_RESET" >&2
		return 1
	fi
	printf '%s配置已保存：%s（添加 %s 个订阅）%s\n' "$C_GREEN" "$YAML_DEST" "$YAML_PROVIDER_COUNT" "$C_RESET"
}

yaml_start_nikki() {
	YAML_PROFILE_LIST="$YAML_WORK_DIR/profile_files"
	find "$YAML_PROFILES_DIR" -maxdepth 1 -type f \( -name '*.yaml' -o -name '*.yml' \) -print 2>/dev/null | sort > "$YAML_PROFILE_LIST"
	if [ ! -s "$YAML_PROFILE_LIST" ]; then
		printf '%s配置目录中没有 YAML 配置文件。%s\n' "$C_RED" "$C_RESET" >&2
		return 1
	fi
	printf '%sNikki 插件当前可选的配置文件：%s\n' "$C_CYAN" "$C_RESET"
	YAML_INDEX=0
	while IFS= read -r YAML_PATH; do
		YAML_INDEX=$((YAML_INDEX + 1))
		printf '  %s) %s\n' "$YAML_INDEX" "${YAML_PATH##*/}"
	done < "$YAML_PROFILE_LIST"
	while true; do
		printf '请输入要使用的配置文件编号（直接回车返回上一级）：'
		read -r YAML_SELECTION
		case "$YAML_SELECTION" in '') return 0 ;; *[!0-9]*) printf '请输入列表中的数字编号，或直接回车返回。\n'; continue ;; esac
		if [ "$YAML_SELECTION" -ge 1 ] 2>/dev/null && [ "$YAML_SELECTION" -le "$YAML_INDEX" ] 2>/dev/null; then break; fi
		printf '编号超出范围，请重试。\n'
	done
	YAML_SELECTED_FILE=$(sed -n "${YAML_SELECTION}p" "$YAML_PROFILE_LIST")
	YAML_SELECTED_NAME=${YAML_SELECTED_FILE##*/}
	while true; do
		printf '启用并启动 Nikki？直接回车启动，输入 n/N 返回上一级：'
		read -r YAML_START_CHOICE
		case "$YAML_START_CHOICE" in
			'') YAML_ENABLED=1; break ;;
			n|N) printf '已取消启动。\n'; return 0 ;;
			*) printf '请输入 n/N 返回上一级，或直接回车启动。\n' ;;
		esac
	done
	printf '“仅核心”模式默认启用。\n'
	uci set "nikki.config.profile=file:$YAML_SELECTED_NAME" || return 1
	uci set "nikki.config.enabled=$YAML_ENABLED" || return 1
	uci set 'nikki.config.core_only=1' || return 1
	uci commit nikki || return 1
	if "$SERVICE" start; then
		printf '%sNikki 已启动，当前配置：%s（仅核心）%s\n' "$C_GREEN" "$YAML_SELECTED_NAME" "$C_RESET"
	else
		printf '%sNikki 启动失败，请检查 Nikki 日志和配置文件。%s\n' "$C_RED" "$C_RESET" >&2
		return 1
	fi
}

yaml_stop_nikki() {
	while true; do
		printf '确认关闭 Nikki？输入 y/Y 确认，直接回车返回上一级：'
		read -r YAML_STOP_CHOICE
		case "$YAML_STOP_CHOICE" in
			y|Y) break ;;
			'') printf '已取消关闭。\n'; return 0 ;;
			*) printf '请输入 y/Y 确认，或直接回车返回上一级。\n' ;;
		esac
	done
	uci set 'nikki.config.enabled=0' || return 1
	uci commit nikki || return 1
	if "$SERVICE" stop; then
		printf '%sNikki 已关闭，并已设为禁用。%s\n' "$C_GREEN" "$C_RESET"
	else
		printf '%s已设为禁用，但停止服务命令失败；请检查 Nikki 状态。%s\n' "$C_RED" "$C_RESET" >&2
		return 1
	fi
}

yaml_view_profiles() {
	YAML_PROFILE_LIST="$YAML_WORK_DIR/view_profile_list"
	find "$YAML_PROFILES_DIR" -maxdepth 1 -type f \( -name '*.yaml' -o -name '*.yml' \) -print 2>/dev/null | sort > "$YAML_PROFILE_LIST"
	if [ ! -s "$YAML_PROFILE_LIST" ]; then
		printf '%s配置目录中没有 YAML 配置文件。%s\n' "$C_RED" "$C_RESET" >&2
		return 1
	fi
	printf '%s当前已有配置文件：%s\n' "$C_CYAN" "$C_RESET"
	YAML_INDEX=0
	while IFS= read -r YAML_PATH; do
		YAML_INDEX=$((YAML_INDEX + 1))
		printf '  %s) %s\n' "$YAML_INDEX" "${YAML_PATH##*/}"
	done < "$YAML_PROFILE_LIST"
	while true; do
		printf '请输入要删除的配置编号（直接回车返回上一级）：'
		read -r YAML_SELECTION
		case "$YAML_SELECTION" in '') return 0 ;; esac
		case "$YAML_SELECTION" in *[!0-9]*) printf '请输入列表中的数字编号。\n'; continue ;; esac
		if [ "$YAML_SELECTION" -ge 1 ] 2>/dev/null && [ "$YAML_SELECTION" -le "$YAML_INDEX" ] 2>/dev/null; then break; fi
		printf '编号超出范围，请重试。\n'
	done
	YAML_SELECTED_FILE=$(sed -n "${YAML_SELECTION}p" "$YAML_PROFILE_LIST")
	YAML_SELECTED_NAME=${YAML_SELECTED_FILE##*/}
	while true; do
		printf '确定删除 %s？输入 y/Y 确认，直接回车返回上一级：' "$YAML_SELECTED_NAME"
		read -r YAML_CONFIRM
		case "$YAML_CONFIRM" in
			y|Y) break ;;
			'') printf '已取消删除。\n'; return 0 ;;
			*) printf '请输入 y/Y 确认，或直接回车返回上一级。\n' ;;
		esac
	done
	if rm -f "$YAML_SELECTED_FILE"; then
		printf '%s已删除配置：%s%s\n' "$C_GREEN" "$YAML_SELECTED_NAME" "$C_RESET"
	else
		printf '%s删除失败：%s%s\n' "$C_RED" "$YAML_SELECTED_NAME" "$C_RESET" >&2
		return 1
	fi
}

profile_management_menu() {
	if ! command -v uci >/dev/null 2>&1 || [ ! -x "$SERVICE" ]; then
		printf '%s未找到 Nikki 插件（需要 uci 和 %s）。%s\n' "$C_RED" "$SERVICE" "$C_RESET" >&2
		return 1
	fi
	YAML_WORK_DIR="$TMP_DIR/yaml-profile-$$"
	(umask 077; mkdir -p "$YAML_WORK_DIR") || { printf '无法创建临时目录。\n' >&2; return 1; }
	while true; do
		echo
		printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
		printf '%s          Nikki 配置管理%s\n' "$C_BOLD$C_CYAN" "$C_RESET"
		printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
		printf '%s  1. 下载模板%s\n' "$C_BLUE" "$C_RESET"
		printf '%s  2. 启动 Nikki%s\n' "$C_BLUE" "$C_RESET"
		printf '%s  3. 关闭 Nikki%s\n' "$C_BLUE" "$C_RESET"
		printf '%s  4. 查看配置%s\n' "$C_BLUE" "$C_RESET"
		printf '%s请选择操作 [1-4]（直接回车返回上一级）：%s' "$C_BOLD$C_GREEN" "$C_RESET"
		read -r YAML_MENU_CHOICE
		case "$YAML_MENU_CHOICE" in
			1) yaml_download_template ;;
			2) yaml_start_nikki ;;
			3) yaml_stop_nikki ;;
			4) yaml_view_profiles ;;
			'') rm -rf "$YAML_WORK_DIR"; return 0 ;;
			*) printf '%s无效选择，请输入 1-4，或直接回车返回上一级。%s\n' "$C_RED" "$C_RESET" ;;
		esac
	done
}

extract_zip() {
	_zip_archive=$1
	_zip_destination=$2
	if command -v unzip >/dev/null 2>&1; then
		unzip -oq "$_zip_archive" -d "$_zip_destination"
		return $?
	fi
	if command -v busybox >/dev/null 2>&1 && busybox --list 2>/dev/null | grep -qx 'unzip'; then
		# BusyBox's unzip applet extracts into the current directory and may
		# not support -d, so run it from the staging directory.
		(cd "$_zip_destination" && busybox unzip -oq "$_zip_archive")
		return $?
	fi
	echo 'Zashboard：系统没有 unzip，且 BusyBox 未提供 unzip applet；请先运行 opkg install unzip / apk add unzip。' >&2
	return 127
}

download_ui() {
	archive="$TMP_DIR/zashboard-$$.zip"
	stage="$TMP_DIR/zashboard-stage-$$"
	cleanup_files="$cleanup_files $archive $stage"

	if ! download_with_fallbacks 'Zashboard 控制面板' "$archive" "$UI_URLS" valid_nonempty; then
		return 1
	fi
	if ! mkdir -p "$stage" "$UI_DIR"; then
		echo 'Zashboard：无法创建临时解压目录。' >&2
		return 1
	fi
	if ! extract_zip "$archive" "$stage"; then
		echo 'Zashboard：解压失败。' >&2
		return 1
	fi
	# dist.zip may contain the built site at its root or inside a dist/ directory.
	if [ -d "$stage/dist" ]; then
		stage="$stage/dist"
	fi
	mkdir -p "$UI_DIR/zashboard" || return 1
	if cp -a "$stage/." "$UI_DIR/zashboard/"; then
		printf 'Zashboard：已安装到 %s/zashboard\n' "$UI_DIR"
	else
		echo 'Zashboard：安装失败。' >&2
		return 1
	fi
}


# ============================================================
# Nikki Tools menu
# ============================================================

core_menu() {
    while true; do
        echo
        printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
        printf '%s             更新核心%s\n' "$C_BOLD$C_CYAN" "$C_RESET"
        printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
        printf '%s  1. 更新核心 MetaCubeX Alpha%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  2. 更新核心 MetaCubeX Stable%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  3. 更新核心 Vernesong Smart%s\n' "$C_BLUE" "$C_RESET"
        printf '%s请选择操作 [1-3]（直接回车返回上一级）：%s' "$C_BOLD$C_GREEN" "$C_RESET"
        read -r CORE_CHOICE
        case "$CORE_CHOICE" in
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
                CORE_NAME="Vernesong Smart"
                update_core
                ;;
            '') return 0 ;;
            *) printf '%s无效选择，请输入 1、2 或 3，或直接回车返回上一级%s\n' "$C_RED" "$C_RESET" ;;
        esac
    done
}

geo_menu() {
    while true; do
        echo
        printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
        printf '%s        下载规则 Geo 数据库%s\n' "$C_BOLD$C_CYAN" "$C_RESET"
        printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
        printf '%s  1. 下载 GeoSite 数据库%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  2. 下载 GeoIP   数据库%s\n' "$C_BLUE" "$C_RESET"
        printf '%s请选择操作 [1-2]（直接回车返回上一级）：%s' "$C_BOLD$C_GREEN" "$C_RESET"
        read -r GEO_CHOICE
        case "$GEO_CHOICE" in
            1) download_with_fallbacks 'GeoSite 数据库' "$RUN_DIR/GeoSite.dat" "$GEOSITE_URLS" valid_nonempty ;;
            2) download_with_fallbacks 'GeoIP   数据库' "$RUN_DIR/GeoIP.dat" "$GEOIP_URLS" valid_nonempty ;;
            '') return 0 ;;
            *) printf '%s无效选择，请输入 1 或 2，或直接回车返回上一级%s\n' "$C_RED" "$C_RESET" ;;
        esac
    done
}

main_menu() {
    while true; do
        echo
        printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
        printf '%s               Nikki Tools%s\n' "$C_BOLD$C_CYAN" "$C_RESET"
        printf '%s========================================%s\n' "$C_CYAN" "$C_RESET"
        printf '%s  1. 安装更新 Nikki%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  2. 卸载清空 Nikki%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  3. 更新核心 Mihomo%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  4. 安装面板 Zashboard%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  5. 下载规则 Geo数据库%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  6. 运行插件 管理配置%s\n' "$C_BLUE" "$C_RESET"
        printf '%s  0. 退出%s\n' "$C_BLUE" "$C_RESET"
        printf '%s请选择操作 [0-6]: %s' "$C_BOLD$C_GREEN" "$C_RESET"
        read -r MENU_CHOICE
        case "$MENU_CHOICE" in
            1) install_nikki ;;
            2) uninstall_nikki ;;
            3) core_menu ;;
            4) download_ui ;;
            5) geo_menu ;;
            6) profile_management_menu ;;
            0) printf '%s已退出%s\n' "$C_YELLOW" "$C_RESET"; exit 0 ;;
            *) printf '%s无效选择，请输入 0-6%s\n' "$C_RED" "$C_RESET" ;;
        esac
    done
}

main_menu
