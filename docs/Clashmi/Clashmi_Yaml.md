# 🚀 Clashmi_Yaml 使用教程



## 📦 一、下载安装

* 🔗 下载地址：
  [Clashmi Project](https://clashmi.app/download) ｜ [Github Releases](https://github.com/KaringX/clashmi/releases)

* 💻 支持平台：
  `Android` ｜ `iOS` ｜ `Windows` ｜ `macOS` ｜ `Linux`

* 📌 操作说明：

  1. 根据系统选择对应安装包
  2. 下载并安装
  3. 启动软件，进入主界面

<br>

## ⚙️ 二、简单配置（核心设置）

> ⚠️ 初次使用建议完成以下设置（避免 Yaml 参数被覆盖）

| 配置项    | 推荐设置     | 说明                    |
| ------ | -------- | --------------------- |
| 分应用代理  | ✅ 开启     | Android 专属，可排除不走代理的应用 |
| 进程匹配模式 | `always` | 移动设备推荐                |
| IPv6   | 不覆写      | 保持默认更稳定               |
| TUN    | ❌ 关闭     | 无需开启，Yaml已有参数                |
| 覆写     | 内置-不覆写   | 避免配置冲突                |
<img width="600" height="640" alt="Core_Settings" src="https://github.com/user-attachments/assets/ec0bd01d-8d7f-4d7f-a966-cdbef5d440c7" />

<br>

## 🧩 三、制作配置文件（Yaml）

### 📥 下载模板

* 【数据库】分流方案（内存占用较“**高**”）
  👉 [Geo【数据库分流】](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Geo.yaml)

* 【规则集】分流方案（内存占用较“**低**”）
  👉 [Rule-Set【规则集分流】](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Rule-Set.yaml)


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

## 📚 四、导入并使用
### 📂 导入配置

1. 进入 **我的配置**
2. 点击右上角 **“+”**
3. 选择 **导入配置文件**
4. 选中刚刚制作的 Yaml 文件
5. 点击右上角 **“√” 保存**
<img width="600" height="430" alt="导入配置" src="https://github.com/user-attachments/assets/ff42a49d-e0ab-4137-bb45-48505c6dfc0d" />

### ▶️ 启动代理
* 选中刚刚导入的 **Yaml** 配置，将状态从 **未连接** → 打开开关 → **已连接**
* 进入 **面板** ，在 **策略组** 中选择合适节点（按需切换） `一般策略组有图标出现，即代表节点是通的，可分流上网`
<img width="600" height="638" alt="启动代理" src="https://github.com/user-attachments/assets/3a55ea83-ab8e-4704-b3ba-91134cba4e35" />

<br>

## 💡 五、使用建议

* 📌 优先使用 Rule-Set（更省资源）
* 🧪 遇到问题先检查配置文件与日志
