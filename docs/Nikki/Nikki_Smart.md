# OpenWrt-Nikki替换Smart核心及安装LightGBM 模型
本教程用于将 OpenWrt 上已安装的 **Nikki** 插件，其 Mihomo 核心替换为 **Mihomo Alpha with Smart Group** 版本
> **前提条件：** OpenWrt 已正常安装并运行 Nikki 插件



## 一、确认 Nikki 已正常安装
确认 OpenWrt 已成功安装 **Nikki** 插件，并能够正常进入 Nikki 管理界面
**示例：**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/1.%E7%A1%AE%E8%AE%A4%E5%AE%89%E8%A3%85.jpg)



## 二、替换 Mihomo Smart 核心  
前往 [**Mihomo_Smart**](https://github.com/vernesong/mihomo/releases/)  Release 页面，根据当前 OpenWrt 的 CPU 架构下载对应的核心

### 1. 确认 OpenWrt 系统架构
在 OpenWrt 终端中执行以下命令：

```
uname -m
```

例如：**x86_64** ,表示当前系统架构为 **x86_64** ,可下载通用的核心文件为： **mihomo-linux-amd64-compatible-alpha-smart-*******.gz**  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/2.1%E4%B8%8B%E8%BD%BD.jpg)

### 2. 解压并重命名核心文件，上传 Mihomo 核心至 OpenWrt
下载完成后，解压 `.gz` 文件，得到核心文件： **mihomo-linux-amd64-xxxx**
将其重命名为：**mihomo**，然后上传至 OpenWrt：**/usr/bin/** ,修改文件权限为：**755**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/2.2%E6%9B%BF%E6%8D%A2.jpg)  

### 3. 在 Nikki 中确认核心是否替换成功
完成以上操作后，返回 **Nikki 插件管理界面**，查看当前使用的 Mihomo 核心  
确认核心版本已经变更为刚刚上传的 **Mihomo Alpha Smart** 版本    
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/2.3%E6%A3%80%E6%9F%A5.jpg)  

### 4. LightGBM Model （Ai模型）
1.当前 Release 页面，下载 LightGBM Model  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/3.1%E4%B8%8B%E8%BD%BD.jpg)  

2.上传 Model.bin 至 OpenWrt：**/etc/nikki/run/**  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/3.2%E4%B8%8A%E4%BC%A0.jpg)

> 下方为 Nikki-Tools 脚本（支持安装、更新、卸载Nikki插件，更新替换MetaCubeX：Alpha、Stable 及 Vernesong：Smart核心）**，若以上步骤已手动做完，可跳过下方脚本**
> ```
> wget -q -O /tmp/nikki-tools.sh https://raw.githubusercontent.com/Seven1echo/Yaml/main/smart/nikki-tools.sh && ash /tmp/nikki-tools.sh
> ```



## 三、 制作配置文件（Yaml）
### 📥 下载模板

* 【数据库】分流方案（内存占用较“**高**”）
  👉 [Geo_Smart【数据库分流】](https://github.com/Seven1echo/Yaml/blob/main/smart/Seven1_fallback_Geo_Smart.yaml)

* 【规则集】分流方案（内存占用较“**低**”）
  👉 [Rule-Set_Smart【规则集分流】](https://github.com/Seven1echo/Yaml/blob/main/smart/Seven1_fallback_Rule-Set_Smart.yaml)

### ✏️ 修改内容
请编辑下载的 Yaml 文件：
* 🔑 填写 **订阅链接** ，修改 **机场名称**
* 🌐 修改 **nameserver**（可选） !!建议替换为运营商 DNS（不修改也可正常使用）
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/4.%E8%AE%A2%E9%98%85.jpg)   
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/5.DNS.jpg)  



## 四、 导入并使用
### 📂 导入配置
1. 进入Nikki插件，点击**配置文件** ，上传修改好的Yaml文件
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/6.%E4%B8%8A%E4%BC%A0.jpg) 

2. 点击 **插件配置** ，勾选 **启用** ，选中上传的 **配置文件** ， 勾选 **仅核心** ，点击右下角 **保存并应用** 
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/7.%E5%90%AF%E7%94%A8.jpg) 

### ▶️ 开始使用
* 在 **插件配置** ，点击 **打开面板**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/8.%E6%89%93%E5%BC%80%E9%9D%A2%E6%9D%BF.jpg)  

* 进入 **面板** ，在 **策略组** 中选择合适节点（按需切换） `一般策略组有图标出现，即代表节点是通的，可分流上网`
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/pics/Nikki_Smart/9.Zashboard.jpg)  
