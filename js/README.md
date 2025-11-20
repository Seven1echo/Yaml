```markdown
## 一、一键开启 SSH 服务（Debian/Ubuntu 适用）

用于快速配置 Debian 系系统的 SSH 服务，自动安装、启用 root 登录和密码认证，并开放防火墙端口。

```bash
bash -c "$(echo 'OS_TYPE=$([ -f /etc/os-release ] && . /etc/os-release && echo $ID || echo unknown); [ "$(id -u)" -ne 0 ] && echo "请使用root权限运行" && exit 1; echo "正在配置SSH..."; if command -v apt &>/dev/null; then apt update && apt install -y openssh-server; elif command -v yum &>/dev/null; then yum install -y openssh-server; fi; CONF="/etc/ssh/sshd_config"; sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" $CONF; sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" $CONF; if command -v systemctl &>/dev/null; then systemctl restart sshd || systemctl restart ssh; elif command -v service &>/dev/null; then service sshd restart || service ssh restart; fi; if [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "NP" ] || [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "L" ]; then echo "设置root密码:"; passwd root; fi; if command -v ufw &>/dev/null && ufw status | grep -q "active"; then ufw allow 22/tcp; fi; IP=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1 || ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1); echo "SSH已配置! 连接命令: ssh root@${IP:-<主机IP>}"')"
```

**说明：**
- 自动检测系统包管理器（apt/yum），安装 openssh-server
- 启用 root 用户 SSH 登录和密码认证
- 自动重启 SSH 服务
- 若 root 无密码/锁定，提示设置密码
- 开放 UFW 防火墙 22 端口（若 UFW 已启用）
- 输出最终连接命令（含主机 IP）

---

## 二、Docker 图形化管理工具（Portainer-CE 汉化版）

Portainer 是一款轻量级的 Docker 可视化管理工具，支持容器、镜像、网络、数据卷等全方位管理。

```bash
docker run -d --restart=always --name="portainer" \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  6053537/portainer-ce
```

**说明：**
- 映射端口：宿主机 9000 → 容器 9000（访问端口）
- 数据持久化：`portainer_data` 卷存储配置数据
- 权限：通过 `/var/run/docker.sock` 获得 Docker 管理权限
- 访问地址：`http://<主机IP>:9000`（首次登录需设置管理员密码）

---

## 三、Docker 部署 Sub-Store（订阅管理工具）

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
- 定时任务：每天 23:50 自动更新订阅（通过 `SUB_STORE_CRON` 环境变量配置）
- 端口映射：宿主机 3008 → 容器 3001
- 数据持久化：`/etc/sub-store` 目录存储订阅配置和数据
- 访问地址：`http://<主机IP>:3008/?api=http://<主机IP>:3008/T3B9dgzBzdRbBF8Aqx7P`（替换 `<主机IP>` 为实际 IP）
```
