# 🚀 Clashmi_Yaml 使用教程

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
| TUN    | ❌ 关闭     | 无需开启，Yaml已有参数                |
| 覆写     | 内置-不覆写   | 避免配置冲突                |

![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/pics/Clashmi_Yaml/1.%E8%AE%BE%E7%BD%AE.jpg)



## 🧩 三、制作配置文件（Yaml）

### 📥 下载模板

  👉 [Rule-Set【规则集分流】](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Rule-Set.yaml)


### ✏️ 修改内容

请编辑下载的 Yaml 文件：

* 🔑 填写 **订阅链接** ，修改 **机场名称**
* 🌐 修改 **nameserver**（可选） !!建议替换为运营商 DNS（不修改也可正常使用）
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/pics/Clashmi_Yaml/2.%E8%AE%A2%E9%98%85.jpg)  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/pics/Clashmi_Yaml/3.DNS.png)

### 🛠 Windows辅助工具
如果你使用 Windows，可直接使用自动生成工具：
👉 [Seven1_Yaml_生成工具.exe](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/pics/Clashmi_Yaml/4.%E5%B7%A5%E5%85%B7.jpg)



## 📚 四、导入并使用
### 📂 导入配置

1. 进入 **我的配置**
2. 点击右上角 **“+”**
3. 选择 **导入配置文件**
4. 选中刚刚制作的 Yaml 文件
5. 点击右上角 **“√” 保存**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/pics/Clashmi_Yaml/5.%E5%AF%BC%E5%85%A5.jpg)

### ▶️ 启动代理
* 选中刚刚导入的 **Yaml** 配置，将状态从 **未连接** → 打开开关 → **已连接**
* 进入 **面板** ，在 **策略组** 中选择合适节点（按需切换） `一般策略组有图标出现，即代表节点是通的，可分流上网`
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/pics/Clashmi_Yaml/6.%E5%90%AF%E5%8A%A8.jpg)



## 💡 五、使用建议
* 🧪 遇到问题先检查配置文件与日志
