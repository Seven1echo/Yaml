## 一、一键安装 Docker 服务

在SSH终端，执行如下命令，全程交互式执行，安装docker全家桶。

```
bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
```
关于报错：https://linuxmirrors.cn/use/#%E5%85%B3%E4%BA%8E%E6%8A%A5%E9%94%99-command-not-found

---

## 二、一键安装 Docker 图形化管理工具（1panel）

执行以下安装脚本，根据命令行提示完成安装。

```
bash -c "$(curl -sSL https://resource.fit2cloud.com/1panel/package/v2/quick_start.sh)"
```
关于报错：https://1panel.cn/docs/v2/installation/online_installation/#1

---

## 三、一键开启 SSH 服务

用于快速配置 Debian 系系统的 SSH 服务，自动安装、启用 root 登录和密码认证，并开放防火墙端口。
```markdown
bash -c "$(echo 'OS_TYPE=$([ -f /etc/os-release ] && . /etc/os-release && echo $ID || echo unknown); [ "$(id -u)" -ne 0 ] && echo "请使用root权限运行" && exit 1; echo "正在配置SSH..."; if command -v apt &>/dev/null; then apt update && apt install -y openssh-server; elif command -v yum &>/dev/null; then yum install -y openssh-server; fi; CONF="/etc/ssh/sshd_config"; sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" $CONF; sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" $CONF; if command -v systemctl &>/dev/null; then systemctl restart sshd || systemctl restart ssh; elif command -v service &>/dev/null; then service sshd restart || service ssh restart; fi; if [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "NP" ] || [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "L" ]; then echo "设置root密码:"; passwd root; fi; if command -v ufw &>/dev/null && ufw status | grep -q "active"; then ufw allow 22/tcp; fi; IP=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1 || ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1); echo "SSH已配置! 连接命令: ssh root@${IP:-<主机IP>}"')"
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
说明：
- 访问地址：`http://<主机IP>:3008/?api=http://<主机IP>:3008/T3B9dgzBzdRbBF8Aqx7P`（替换 `<主机IP>` 为实际 IP）
