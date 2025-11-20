
## 一、一键开启 SSH 服务

用于快速配置 Debian 系系统的 SSH 服务，自动安装、启用 root 登录和密码认证，并开放防火墙端口。
```markdown
bash -c "$(echo 'OS_TYPE=$([ -f /etc/os-release ] && . /etc/os-release && echo $ID || echo unknown); [ "$(id -u)" -ne 0 ] && echo "请使用root权限运行" && exit 1; echo "正在配置SSH..."; if command -v apt &>/dev/null; then apt update && apt install -y openssh-server; elif command -v yum &>/dev/null; then yum install -y openssh-server; fi; CONF="/etc/ssh/sshd_config"; sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" $CONF; sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" $CONF; if command -v systemctl &>/dev/null; then systemctl restart sshd || systemctl restart ssh; elif command -v service &>/dev/null; then service sshd restart || service ssh restart; fi; if [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "NP" ] || [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "L" ]; then echo "设置root密码:"; passwd root; fi; if command -v ufw &>/dev/null && ufw status | grep -q "active"; then ufw allow 22/tcp; fi; IP=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1 || ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1); echo "SSH已配置! 连接命令: ssh root@${IP:-<主机IP>}"')"
```

---

## 二、一键安装 Docker 服务

以下是适用于 Debian 系统（Debian 10+）的 Docker 一键安装命令，整合了官方推荐的安装流程，可直接复制执行：。

```bash
#!/bin/bash
set -e

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行此脚本" >&2
    exit 1
fi

# 更新系统包索引
echo "正在更新系统包索引..."
apt update -y

# 安装必要的依赖包，用于通过 HTTPS 访问仓库
echo "安装依赖包..."
apt install -y apt-transport-https ca-certificates curl software-properties-common

# 添加 Docker 官方 GPG 密钥
echo "添加 Docker 官方 GPG 密钥..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 设置 Docker 稳定版仓库
echo "设置 Docker 仓库..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 再次更新包索引，使 Docker 仓库生效
echo "再次更新系统包索引..."
apt update -y

# 安装 Docker Engine、containerd 和 Docker Compose
echo "安装 Docker Engine..."
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动 Docker 服务并设置开机自启
echo "启动 Docker 服务并设置开机自启..."
systemctl start docker
systemctl enable docker

# 验证 Docker 安装是否成功
echo "验证 Docker 安装..."
if command -v docker &> /dev/null && docker --version &> /dev/null; then
    echo "Docker 安装成功！版本：$(docker --version)"
    echo "Docker Compose 版本：$(docker compose version)"
else
    echo "Docker 安装失败！" >&2
    exit 1
fi

# 可选：将当前用户添加到 docker 组（避免每次使用 docker 都需要 sudo）
read -p "是否将当前用户添加到 docker 组？(y/n，默认 n): " add_user
if [ "$add_user" = "y" ] || [ "$add_user" = "Y" ]; then
    current_user=$(logname)
    usermod -aG docker "$current_user"
    echo "已将用户 $current_user 添加到 docker 组，请注销并重新登录后生效！"
fi

echo "Docker 一键安装脚本执行完成！"
```

---

## 三、一键安装 Docker 图形化管理工具（Portainer-CE 汉化版）

Portainer 是一款轻量级的 Docker 可视化管理工具，支持容器、镜像、网络、数据卷等全方位管理。

```bash
docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data 6053537/portainer-ce
```

---

## 四、一键安装部署 Sub-Store（订阅管理工具）

Sub-Store 是一款用于管理和转换网络订阅的工具，支持定时更新、多格式转换等功能。

```bash
docker run -it -d --restart=always \
  -e "SUB_STORE_CRON=50 23 *" \
  -e SUB_STORE_FRONTEND_BACKEND_PATH=/T3B9dgzBzdRbBF8Aqx7P \
  -p 3008:3001 \
  -v /etc/sub-store:/opt/app/data \
  --name Sub2Store \
  xream/sub-store:latest
```

**说明：**
- 访问地址：`http://<主机IP>:3008/?api=http://<主机IP>:3008/T3B9dgzBzdRbBF8Aqx7P`（替换 `<主机IP>` 为实际 IP）
```
