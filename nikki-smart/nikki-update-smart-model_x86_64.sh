#!/usr/bin/env bash
set -euo pipefail

TMP_DIR="/tmp/nikki_update"
LOG_DIR="/var/log/nikki_update"
LOG_FILE="$LOG_DIR/update_$(date '+%Y-%m-%d_%H-%M-%S').log"

REPO="vernesong/mihomo"
TAG="Prerelease-Alpha"
ARCH="amd64"                # x86_64 -> amd64
BUILD_SUFFIX="compatible"   # 如需非 compatible 版本，改为空字符串
BIN_NAME="mihomo"
INSTALL_PATH="/usr/bin/$BIN_NAME"
MODEL_URL="https://github.com/vernesong/mihomo/releases/download/LightGBM-Model/Model.bin"
MODEL_PATH="/etc/nikki/run/Model.bin"

mkdir -p "$TMP_DIR" "$LOG_DIR" /etc/nikki/run
trap 'rm -rf "$TMP_DIR"' EXIT

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

download_file() {
  local url="$1"
  local output="$2"

  if command -v uclient-fetch >/dev/null 2>&1; then
    if uclient-fetch -O "$output" "$url"; then
      return 0
    fi
  fi

  if command -v wget >/dev/null 2>&1; then
    if wget --no-check-certificate -O "$output" "$url"; then
      return 0
    fi
    if wget -O "$output" "$url"; then
      return 0
    fi
  fi

  if command -v curl >/dev/null 2>&1; then
    if curl -fL -o "$output" "$url"; then
      return 0
    fi
  fi

  return 1
}

log "开始 Nikki Smart 内核更新流程"

log "获取内核版本号..."
if ! download_file "https://github.com/$REPO/releases/download/$TAG/version.txt" "$TMP_DIR/version.txt"; then
  version=""
else
  version="$(tr -d '\r\n' < "$TMP_DIR/version.txt")"
fi

if [ -z "$version" ]; then
  log "❌ 获取版本号失败，终止更新"
  exit 1
fi

log "获取的版本号为 $version"

if [ -n "$BUILD_SUFFIX" ]; then
  asset="mihomo-linux-${ARCH}-${BUILD_SUFFIX}-${version}.gz"
else
  asset="mihomo-linux-${ARCH}-${version}.gz"
fi

log "下载内核..."
if ! download_file "https://github.com/$REPO/releases/download/$TAG/$asset" "$TMP_DIR/$asset"; then
  log "❌ 内核下载失败，终止更新"
  exit 1
fi

log "下载 Model.bin..."
if ! download_file "$MODEL_URL" "$TMP_DIR/Model.bin"; then
  log "❌ Model.bin 下载失败，终止更新"
  exit 1
fi

log "解压内核..."
if ! gzip -d "$TMP_DIR/$asset"; then
  log "❌ 解压失败，终止更新"
  exit 1
fi

log "替换旧内核..."
mv -f "$TMP_DIR/${asset%.gz}" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

log "安装 Model.bin..."
mv -f "$TMP_DIR/Model.bin" "$MODEL_PATH"
chmod 644 "$MODEL_PATH"

log "重启 nikki 服务..."
if service nikki restart; then
  log "✅ Nikki 服务重启成功"
else
  log "⚠️ Nikki 服务重启失败，请手动检查"
fi

log "清理 15 天前的日志文件..."
find "$LOG_DIR" -type f -name "update_*.log" -mtime +15 -exec rm -f {} \;

log "🎉 内核更新流程完成"
