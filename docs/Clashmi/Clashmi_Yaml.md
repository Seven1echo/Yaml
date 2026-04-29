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


## ⚙️ 二、简单配置（核心设置）

> ⚠️ 初次使用建议完成以下设置（避免 Yaml 参数被覆盖）

| 配置项    | 推荐设置     | 说明                    |
| ------ | -------- | --------------------- |
| 分应用代理  | ✅ 开启     | Android 专属，可排除不走代理的应用 |
| 进程匹配模式 | `always` | 移动设备推荐                |
| IPv6   | 不覆写      | 保持默认更稳定               |
| TUN    | ❌ 关闭     | 一般无需开启                |
| 覆写     | 内置-不覆写   | 避免配置冲突                |


## 🧩 三、制作配置文件（Yaml）

### 📥 下载模板

* 【数据库】分流方案（内存占用较“**高**”）
  👉 [Geo【数据库分流】](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Geo.yaml)

* 【规则集】分流方案（内存占用较“**低**”）
  👉 [Rule-Set【规则集分流】](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Rule-Set.yaml)


### ✏️ 修改内容

请编辑下载的 Yaml 文件：

* 🔑 填写 **订阅链接**
* 🏷 修改 **机场名称**
* 🌐 修改 `nameserver`（可选）

  > 建议替换为运营商 DNS（不修改也可正常使用）


### 🛠 Windows辅助工具

如果你使用 Windows，可直接使用自动生成工具：

👉 [Seven1_Yaml_生成工具.exe](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)


## 📚 四、导入并使用

> 🖥 以下以 Windows 客户端为例（其他平台流程类似）

### 📂 导入配置

1. 进入 **我的配置**
2. 点击右上角 **“+”**
3. 选择 **导入配置文件**
4. 选中刚刚制作的 Yaml 文件
5. 点击右上角 **“√” 保存**


### ▶️ 启动代理

* 将状态从 **未连接** → 打开开关


### 🎛 选择节点

* 进入 **面板**
* 在 **策略组** 中选择合适节点（按需切换）


## 💡 五、使用建议

* 📌 优先使用 Rule-Set（更省资源）
* 🧪 遇到问题先检查配置文件与日志
