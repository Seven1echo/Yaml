# 🚀 Nikki_Yaml 使用教程（仅内核）

<!-- 官方徽标 -->
<p align="center">
  <a href="https://t.me/Seven1gogogo" target="_blank">
    <img src="https://img.shields.io/badge/Telegram-Channel-26A5E4?logo=telegram&logoColor=white" />
  </a>
  &nbsp;
  <a href="https://youtube.com/@seven1echo?si=jcyS94OnTAqYKuiy" target="_blank">
    <img src="https://img.shields.io/badge/YouTube-@seven1echo-FF0000?logo=youtube&logoColor=white" />
  </a>
  &nbsp;
  <a href="https://github.com/Seven1echo/Yaml" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-Yaml-181717?logo=github&logoColor=white" />
  </a>
</p>


## 📦 一、插件相关

### 🔗 项目地址：[Nikki Project](https://github.com/nikkinikki-org/OpenWrt-nikki)

### 💻 环境要求：
- OpenWrt >= 24.10
- firewall4

### 📌 安装更新：[视频演示](https://youtu.be/5yD_q382YSQ)
1. 使用ssh工具添加源
```
# 只需运行一次
wget -O - https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh | ash
```

2. 安装
你可以从 `shell` 执行命令安装（需区分系统底层管理体系）或者从 LuCI 的`软件包`菜单安装 
```
# OpenWrt≤24.10 可执行下方命令
opkg install nikki
opkg install luci-app-nikki
opkg install luci-i18n-nikki-zh-cn
```

```
# OpenWrt≥25.12 可执行下方命令
apk add nikki
apk add luci-app-nikki
apk add luci-i18n-nikki-zh-cn
```
3. 卸载并重置
```
wget -O - https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/uninstall.sh | ash
```

<br>

## 🧩 二、制作配置文件（Yaml）

### 📥 下载模板

* 【数据库】分流方案（内存占用较“**高**”）
  👉 [Geo【数据库分流】](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Geo.yaml)

* 【规则集】分流方案（内存占用较“**低**”）
  👉 [Rule-Set【规则集分流】](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Rule-Set.yaml)

### ✏️ 修改内容
请编辑下载的 Yaml 文件：
* 🔑 填写 **订阅链接** ，修改 **机场名称**
* 🌐 修改 **nameserver**（可选） !!建议替换为运营商 DNS（不修改也可正常使用）
<img width="600" height="96" alt="订阅链接" src="https://github.com/user-attachments/assets/c344e832-bdcd-4ab0-9948-e7dd9c50f44f" />
<br>
<img width="600" height="172" alt="BaiduShurufa_2026-4-29_20-54-11" src="https://github.com/user-attachments/assets/45dd19cd-b782-4474-9faf-bb1b497ce55f" />

### 🛠 Windows辅助工具
如果你使用 Windows，可直接使用自动生成工具：
👉 [Seven1_Yaml_生成工具.exe](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)
<img width="600" height="457" alt="image" src="https://github.com/user-attachments/assets/6926f761-ae0a-444b-9036-9dcd2ae8cc9e" />

<br>

## 📚 三、导入并使用

### 📂 导入配置
1. 进入Nikki插件，点击**配置文件** ，上传修改好的Yaml文件
<img width="600" height="391" alt="image" src="https://github.com/user-attachments/assets/77ed2168-8bbb-4f56-bfd8-f5ef0c14f08a" />

2. 点击 **插件配置** ，勾选 **启用** ，选中上传的 **配置文件** ， 勾选 **仅核心** ，点击右下角 **保存并应用** 
<img width="600" height="508" alt="image" src="https://github.com/user-attachments/assets/2e40065f-0b37-4e76-a3db-31640f82a9e8" />

### ▶️ 开始使用
* 在 **插件配置** ，点击 **打开面板**
<img width="600" height="193" alt="image" src="https://github.com/user-attachments/assets/1d9f4dae-c973-477b-8ebd-37b1c752277b" />

* 进入 **面板** ，在 **策略组** 中选择合适节点（按需切换） `一般策略组有图标出现，即代表节点是通的，可分流上网`
<img width="600" height="671" alt="zashboard" src="https://github.com/user-attachments/assets/cd5c4d3a-92e5-4253-a8f1-0eae41e0dca7" />
