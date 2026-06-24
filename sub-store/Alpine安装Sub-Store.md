## 一、安装 Docker 服务

在终端，执行如下命令，安装docker。

```
apk update
apk add docker
service docker start
```
最后可以运行 ```docker version```，查看程序版本。

---

## 二、一键安装 Docker 图形化管理工具（DPanel）

执行以下安装脚本，根据命令行提示完成安装。

```
docker run -d --name dpanel --restart=always \
 -p 8807:8080 -e APP_NAME=dpanel \
 -v /var/run/docker.sock:/var/run/docker.sock -v dpanel:/dpanel \
 dpanel/dpanel:lite
```
发布地：https://github.com/donknap/dpanel

---

## 三、开启 SSH 服务

```
apk add openssh-server
apk add vim
rc-update add sshd
service sshd start
vim /etc/ssh/sshd_config
```
将相关行数修改为如下方图示：
<img width="842" height="676" alt="BaiduShurufa_2026-6-24_18-5-41" src="https://github.com/user-attachments/assets/1c57388d-597f-4952-bb13-2e5b063d574a" />

```
service sshd restart
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
