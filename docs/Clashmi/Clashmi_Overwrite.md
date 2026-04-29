# 🚀 Clashmi_Overwrite 使用教程
<!-- 官方徽标 -->

<p>
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

<br>

## ⚙️ 二、简单配置（核心设置）

> ⚠️ 初次使用建议完成以下设置（避免 Yaml 参数被覆盖）

| 配置项    | 推荐设置     | 说明                    |
| ------ | -------- | --------------------- |
| 分应用代理  | ✅ 开启     | Android 专属，可排除不走代理的应用 |
| 进程匹配模式 | `always` | 移动设备推荐                |
| IPv6   | 不覆写      | 保持默认更稳定               |
| TUN    | ❌ 关闭     | 无需开启，Yaml已有参数                |
<img width="600" height="640" alt="Core_Settings2" src="https://github.com/user-attachments/assets/47fc3c5d-a546-48fe-901d-1f627bde93a6" />

<br>

## 🧩 三、添加覆写配置

【数据库】分流方案（内存占用较“**高**”）
```bash
https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Geo_Clashmi_Overwrite.yaml
```
【规则集】分流方案（内存占用较“**低**”）
```bash
https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Rule-Set%20_Clashmi_Overwrite.yaml
```

* 将上方 **覆写链接** （二选一），复制粘贴到 **核心设置** 〉**覆写** 〉右上角“**+**”  〉**添加配置连接** 〉右上角“**√**”
* **覆写**  〉 选中刚刚添加的 **覆写文件**
<img width="600" height="320" alt="Overwrite" src="https://github.com/user-attachments/assets/6ad0d141-07d0-4fc3-b222-bcc9622ef256" />


<br>

## 📚 四、添加机场订阅
### 📂 添加订阅

1. 进入 **我的配置**
2. 点击右上角 **“+”**
3. 选择 **添加配置连接**
4. 添加 **机场订阅信息** 
5. 点击右上角 **“√” 保存**
<img width="600" height="430" alt="添加机场订阅" src="https://github.com/user-attachments/assets/79631f84-8587-4d06-ac94-6789bc333fb9" />


### ▶️ 启动代理
* 选中刚刚添加的 **机场** ，将状态从 **未连接** → 打开开关 → **已连接**
* 进入 **面板** ，在 **策略组** 中选择合适节点（按需切换） `一般策略组有图标出现，即代表节点是通的，可分流上网`
<img width="600" height="638" alt="覆写启动代理" src="https://github.com/user-attachments/assets/2f747868-b11b-4e2a-be25-ee9a6ff2e2dd" />

<br>

## 💡 五、使用建议

* 📌 优先使用 Rule-Set（更省资源）
* 🧪 遇到问题先检查配置文件与日志
* ✔️ ios苹果用户，若配置覆写后，策略组无图标（即代理不通），可去 **核心设置** 打开 **TUN** 或灵活开关下 **DNS劫持** 或 **附加HTTP代理到VPN**
<img width="600" height="1298" alt="苹果" src="https://github.com/user-attachments/assets/2892fd95-e0c6-4b1d-8d91-ff5ef830582e" />
