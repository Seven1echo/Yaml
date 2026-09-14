## 一、PVE宿主机LXC容器部署Debian
### 1. 下载 Debian 的 LXC 容器模板到本地（版本看个人喜欢，一般选最新的）
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/1.%E4%B8%8B%E8%BD%BDDebian%E6%A8%A1%E6%9D%BF.jpg)


### 2. 创建 LXC 容器  
2.1 点击 “创建 CT” 按钮，开始创建新的 LXC 容器 (**CTID**可以不改、**主机名**随意、设置好**密码**、建议取消勾选**无特权的容器**)  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.1%E5%88%9B%E5%BB%BACT.jpg)
2.2 模板选取刚下载的 Debian  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.2%E9%80%89%E5%8F%96%E6%A8%A1%E6%9D%BF.jpg)
2.3 磁盘、CPU、内存大小根据自己的实际需要给就行  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.3.1%E7%A3%81%E7%9B%98.jpg)
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.3.2CPU.jpg)
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.3.3%E5%86%85%E5%AD%98.jpg)
2.4 网络建议ipv4手动指定ip（根据自己的局域网段来分配）、ipv6可dhcp自动分配ip、建议取消勾选**防火墙**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.4%E7%BD%91%E7%BB%9C.jpg)
2.5 DNS 默认即可
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.5NDS.jpg)
2.6 配置完整后，点击完成即可创建容器
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/2.6%E7%A1%AE%E8%AE%A4.jpg)


## 二、开机部署服务
选中创建的容器，点击启动，输入用户名：root 及密码，开始部署服务
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/3.%E5%BC%80%E6%9C%BA%E9%83%A8%E7%BD%B2.jpg)


### （一）一键开启 SSH 服务 （不开启三方SSH工具无法连接）
用于快速配置 Debian 系统的 SSH 服务，自动安装、启用 root 登录和密码认证，并开放防火墙端口
```markdown
bash -c "$(echo 'OS_TYPE=$([ -f /etc/os-release ] && . /etc/os-release && echo $ID || echo unknown); [ "$(id -u)" -ne 0 ] && echo "请使用root权限运行" && exit 1; echo "正在配置SSH..."; if command -v apt &>/dev/null; then apt update && apt install -y openssh-server; elif command -v yum &>/dev/null; then yum install -y openssh-server; fi; CONF="/etc/ssh/sshd_config"; sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" $CONF; sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" $CONF; if command -v systemctl &>/dev/null; then systemctl restart sshd || systemctl restart ssh; elif command -v service &>/dev/null; then service sshd restart || service ssh restart; fi; if [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "NP" ] || [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "L" ]; then echo "设置root密码:"; passwd root; fi; if command -v ufw &>/dev/null && ufw status | grep -q "active"; then ufw allow 22/tcp; fi; IP=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1 || ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1); echo "SSH已配置! 连接命令: ssh root@${IP:-<主机IP>}"')"
```


### （二）一键安装 Docker 服务
在SSH终端，执行如下命令，全程交互式执行，安装docker全家桶

```
apt-get update
apt-get install -y curl
bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
```
关于报错：https://linuxmirrors.cn/use/#%E5%85%B3%E4%BA%8E%E6%8A%A5%E9%94%99-command-not-found


### （三）一键安装 Docker 图形化管理工具（DPanel）
执行以下安装脚本，根据命令行提示完成安装

```
docker run -d --name dpanel --restart=always \
 -p 8807:8080 -e APP_NAME=dpanel \
 -v /var/run/docker.sock:/var/run/docker.sock -v dpanel:/dpanel \
 dpanel/dpanel:lite
```
发布地：https://github.com/donknap/dpanel


### （四）一键安装部署 Sub-Store（订阅管理工具）
Sub-Store 是一款用于管理和转换网络订阅的工具，支持定时更新、多格式转换等功能

```bash
docker run -it -d --restart=always \
  -e SUB_STORE_CORS_ALLOWED_ORIGINS=* \
  -e "SUB_STORE_CRON=50 23 *" \
  -e SUB_STORE_FRONTEND_BACKEND_PATH=/Seven1echoSubStore \
  -p 3008:3001 \
  -v /etc/sub-store:/opt/app/data \
  --name Sub2Store \
  xream/sub-store:latest
```
说明：
- 访问地址：`http://<主机IP>:3008/?api=http://<主机IP>:3008/Seven1echoSubStore`（替换 `<主机IP>` 为实际 IP）



# 三、使用提示
当你全部配置完成、正常使用了，记得将 Debian 设置为开机自启
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/pics/4.%E8%AE%BE%E7%BD%AE%E5%BC%80%E6%9C%BA%E8%87%AA%E5%90%AF.jpg)
