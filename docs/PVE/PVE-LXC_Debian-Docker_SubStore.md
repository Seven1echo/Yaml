## 一、PVE宿主机LXC容器部署Debian
### 1. 下载 Debian 的 LXC 容器模板到本地（版本看个人喜欢，一般选最新的）
<img width="1919" height="817" alt="image" src="https://github.com/user-attachments/assets/f2908ff5-e9a1-4d90-b326-e715bfb18523" />  

### 2. 创建 LXC 容器  
2.1 点击 “创建 CT” 按钮，开始创建新的 LXC 容器 (**CTID**可以不改、**主机名**随意、设置好**密码**、建议取消勾选**无特权的容器**)  
<img width="1917" height="438" alt="image" src="https://github.com/user-attachments/assets/28c645ee-d6f4-4744-b0b6-c916d5f0acb3" />
2.2 模板选取刚下载的 Debian  
<img width="1919" height="316" alt="image" src="https://github.com/user-attachments/assets/03d7b0e8-4012-428b-a2f5-de11b68d8cea" />  
2.3 磁盘、CPU、内存大小根据自己的实际需要给就行  
<img width="1906" height="307" alt="image" src="https://github.com/user-attachments/assets/ec0a1b61-8408-4ca9-bc86-0f79095e7899" />  
<img width="1917" height="232" alt="image" src="https://github.com/user-attachments/assets/91f0598f-fa4a-4deb-a96b-68c9c4bef470" />  
<img width="1919" height="291" alt="image" src="https://github.com/user-attachments/assets/c52e0da9-f759-4747-8700-3194a8c3a7c1" />  
2.4 网络建议ipv4手动指定ip（根据自己的局域网段来分配）、ipv6可dhcp自动分配ip、建议取消勾选**防火墙**
<img width="1919" height="452" alt="image" src="https://github.com/user-attachments/assets/efb984af-2c44-4bc1-9839-a42491f5e8ae" />  
2.5 DNS 默认即可，
<img width="1918" height="305" alt="image" src="https://github.com/user-attachments/assets/7059d5e6-f20d-461d-b2a3-4b73967a7a83" />
2.6 配置完整后，点击完成即可创建容器
<img width="1915" height="805" alt="image" src="https://github.com/user-attachments/assets/30587d84-f5dc-42e8-b23a-4a7a134ff7bc" />


## 二、开机部署服务
选中创建的容器，点击启动，输入用户名：root 及密码，开始部署服务
<img width="1914" height="361" alt="image" src="https://github.com/user-attachments/assets/8b86c7dd-8755-4390-a492-498ef008f961" />

### （一）一键安装 Docker 服务
在SSH终端，执行如下命令，全程交互式执行，安装docker全家桶。

```
apt-get update
apt-get install -y curl
bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
```
关于报错：https://linuxmirrors.cn/use/#%E5%85%B3%E4%BA%8E%E6%8A%A5%E9%94%99-command-not-found


### （二）一键安装 Docker 图形化管理工具（DPanel）
执行以下安装脚本，根据命令行提示完成安装。

```
docker run -d --name dpanel --restart=always \
 -p 8807:8080 -e APP_NAME=dpanel \
 -v /var/run/docker.sock:/var/run/docker.sock -v dpanel:/dpanel \
 dpanel/dpanel:lite
```
发布地：https://github.com/donknap/dpanel


### （三）一键开启 SSH 服务 （不开启三方SSH工具无法连接）
用于快速配置 Debian 系统的 SSH 服务，自动安装、启用 root 登录和密码认证，并开放防火墙端口。
```markdown
bash -c "$(echo 'OS_TYPE=$([ -f /etc/os-release ] && . /etc/os-release && echo $ID || echo unknown); [ "$(id -u)" -ne 0 ] && echo "请使用root权限运行" && exit 1; echo "正在配置SSH..."; if command -v apt &>/dev/null; then apt update && apt install -y openssh-server; elif command -v yum &>/dev/null; then yum install -y openssh-server; fi; CONF="/etc/ssh/sshd_config"; sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" $CONF; sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" $CONF; if command -v systemctl &>/dev/null; then systemctl restart sshd || systemctl restart ssh; elif command -v service &>/dev/null; then service sshd restart || service ssh restart; fi; if [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "NP" ] || [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "L" ]; then echo "设置root密码:"; passwd root; fi; if command -v ufw &>/dev/null && ufw status | grep -q "active"; then ufw allow 22/tcp; fi; IP=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1 || ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1); echo "SSH已配置! 连接命令: ssh root@${IP:-<主机IP>}"')"
```


### （四）一键安装部署 Sub-Store（订阅管理工具）
Sub-Store 是一款用于管理和转换网络订阅的工具，支持定时更新、多格式转换等功能。

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
<img width="1919" height="393" alt="image" src="https://github.com/user-attachments/assets/00d422c9-65cf-4330-ad4e-dc1339d6c265" />
