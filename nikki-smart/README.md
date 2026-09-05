# OpenWrt-Nikki替换Smart核心
本教程用于将 OpenWrt 上已安装的 **Nikki** 插件，其 Mihomo 核心替换为 **Mihomo Alpha with Smart Group** 版本。
> **前提条件：** OpenWrt 已正常安装并运行 Nikki 插件。



## 一、确认 Nikki 已正常安装
确认 OpenWrt 已成功安装 **Nikki** 插件，并能够正常进入 Nikki 管理界面。
**示例：**
<img width="1525" height="392" alt="image" src="https://github.com/user-attachments/assets/6c3e41c6-39d7-4a9b-aee2-e4eef4e5ff6f" />



## 二、替换 Mihomo Smart 核心  
前往 [**Mihomo_Smart**](https://github.com/vernesong/mihomo/releases/)  Release 页面，根据当前 OpenWrt 的 CPU 架构下载对应的核心。

### 1. 确认 OpenWrt 系统架构
在 OpenWrt 终端中执行以下命令：

```
uname -m
```

例如：**x86_64** ,表示当前系统架构为 **x86_64** ,可下载通用的核心文件为： **mihomo-linux-amd64-compatible-alpha-smart-*******.gz**  
<img width="1097" height="698" alt="image" src="https://github.com/user-attachments/assets/e8371da9-52ac-4aaa-9076-3d4658b63c02" />


### 2. 解压并重命名核心文件，上传 Mihomo 核心至 OpenWrt
下载完成后，解压 `.gz` 文件，得到核心文件： **mihomo-linux-amd64-xxxx**
将其重命名为：**mihomo**，然后上传至 OpenWrt：**/usr/bin/** ,修改文件权限为：**755**
<img width="1212" height="526" alt="image" src="https://github.com/user-attachments/assets/f8c3205b-1a66-45ad-8c2a-1005e826ceef" />


### 3. 在 Nikki 中确认核心是否替换成功
完成以上操作后，返回 **Nikki 插件管理界面**，查看当前使用的 Mihomo 核心。  
确认核心版本已经变更为刚刚上传的 **Mihomo Alpha Smart** 版本。  
<img width="1537" height="317" alt="image" src="https://github.com/user-attachments/assets/cd6ce5f0-e8c7-4a20-b156-2454595ee8f9" />



## 三、LightGBM Model （Ai模型）
1.当前 Release 页面，下载 LightGBM Model  
<img width="1160" height="611" alt="image" src="https://github.com/user-attachments/assets/fbfce0e4-856b-40b4-9158-dd01bbf4c3f6" />

2.上传 Model.bin 至 OpenWrt：**/etc/nikki/run/**  
<img width="317" height="348" alt="image" src="https://github.com/user-attachments/assets/4234cfe3-fe56-47f6-a8dc-bb5270a647d4" />



## 四、OpenWrt / Nikki Smart核心、LightGBM Model一键更新脚本






