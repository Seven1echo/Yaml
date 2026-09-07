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



## 四、 一键更新Smart核心、LightGBM Model 脚本（x86_64）
```
wget -O - https://raw.githubusercontent.com/Seven1echo/Yaml/main/config/smart/nikki-update-smart-model_x86_64.sh | ash
```



## 五、 制作配置文件（Yaml）
### 📥 下载模板

* 【数据库】分流方案（内存占用较“**高**”）
  👉 [Geo_Smart【数据库分流】](https://github.com/Seven1echo/Yaml/blob/main/config/smart/Seven1_fallback_Geo_Smart.yaml)

* 【规则集】分流方案（内存占用较“**低**”）
  👉 [Rule-Set_Smart【规则集分流】](https://github.com/Seven1echo/Yaml/blob/main/config/smart/Seven1_fallback_Rule-Set_Smart.yaml)

### ✏️ 修改内容
请编辑下载的 Yaml 文件：
* 🔑 填写 **订阅链接** ，修改 **机场名称**
* 🌐 修改 **nameserver**（可选） !!建议替换为运营商 DNS（不修改也可正常使用）
<img width="600" height="96" alt="585427163-c344e832-bdcd-4ab0-9948-e7dd9c50f44f" src="https://github.com/user-attachments/assets/24e70e8c-9b3b-4cb8-86ee-4c0cf6e07611" />  

<img width="600" height="172" alt="585427221-45dd19cd-b782-4474-9faf-bb1b497ce55f" src="https://github.com/user-attachments/assets/07834dd5-383f-4b14-9bb5-09323c61b022" />



## 六、 导入并使用
### 📂 导入配置
1. 进入Nikki插件，点击**配置文件** ，上传修改好的Yaml文件
<img width="600" height="391" alt="image" src="https://github.com/user-attachments/assets/77ed2168-8bbb-4f56-bfd8-f5ef0c14f08a" />

2. 点击 **插件配置** ，勾选 **启用** ，选中上传的 **配置文件** ， 勾选 **仅核心** ，点击右下角 **保存并应用** 
<img width="600" height="508" alt="image" src="https://github.com/user-attachments/assets/2e40065f-0b37-4e76-a3db-31640f82a9e8" />

### ▶️ 开始使用
* 在 **插件配置** ，点击 **打开面板**
<img width="600" height="193" alt="image" src="https://github.com/user-attachments/assets/1d9f4dae-c973-477b-8ebd-37b1c752277b" />

* 进入 **面板** ，在 **策略组** 中选择合适节点（按需切换） `一般策略组有图标出现，即代表节点是通的，可分流上网`
<img width="600" height="1011" alt="photo_2026-05-17_23-49-25" src="https://github.com/user-attachments/assets/c9fec238-e1c8-47c0-a2f5-2c56171c52b3" />
