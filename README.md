<!-- 项目介绍 -->
<div align="left">

## 一、项目介绍

<!-- 官方徽标 -->
<p>
  <a href="https://t.me/Seven1gogogo" target="_blank">
    <img src="https://img.shields.io/badge/Telegram-Channel-26A5E4?logo=telegram&logoColor=white" />
  </a>
  &nbsp;
  <a href="https://youtube.com/@seven1echo?si=jcyS94OnTAqYKuiy" target="_blank">
    <img src="https://img.shields.io/badge/YouTube-@seven1echo-FF0000?logo=youtube&logoColor=white" />
  </a>
</p>

### 💭 配置随笔
- 本项目以 **自用** 为主，同时也欢迎大家体验。  
- 本项目的配置文件适用于 **Mihomo 核心** 的工具使用，如：**OpenWrt（Clash / Nikki 插件）、Clashmi、FlClash、Clash Meta ……**。
- 使用请完善 **订阅链接** 与 **机场名**。 **⚠️OpenWrt**用户可删除 `default-nameserver` ，将 `nameserver` 改为运营商分配的DNS，以提升解析速度。

### 🗂️ 配置区分

| 类型 | **Geo** | **Rule-Set** | **Overwrite** |
|:--:|:--:|:--:|:--:|
| 说明 | 使用**GeoSite / GeoIP** 数据库分流 | 使用**Rule-Set** 规则集分流 | 指定软件覆写配置文件 |

### 🎬 视频教程

- ▶️ [OpenWrt 使用教程_Nikki插件 | Yaml配置 | Zashboard分流面板](https://youtu.be/5yD_q382YSQ)

- ▶️ [Clash Mi 使用教程_YAML文件 | 多端同步](https://youtu.be/qINXLkfVJck)

- ▶️ [Clash Mi 使用教程_自定义覆写小技巧](https://youtu.be/YLYXv1xryA0)

</div>

---

<!-- 策略模式 -->
<div align="left">

## 二、运行模式

本项目中的配置文件统一采用 **故障转移（Fallback）** 运行模式，其核心理念为 **「稳定优先」**：  
当前节点可用时继续使用；当节点不可用或连接失败时，系统将 **自动切换至同一策略组内的下一个可用节点**，在保证网络**持续性**的同时，避免出现 **“跳区”** 问题。

### ✅ 故障转移的优势
- **稳定性高**：节点异常时自动切换，最大程度减少人工干预。
- **容错性强**：单个节点失效不会影响整体网络连接的可用性。

### 🧭 策略组示例说明
以「**日本 · 故障转移**」为例，其下方通常包含两个子策略组：
- **日本手动**：用于手动指定日本地区的具体节点。
- **日本自动**：由系统根据延迟自动选择最优节点。

在实际使用中：
- 日常使用建议以 **「故障转移」** 作为主要出站。
- 当需要指定线路或进行问题排查时，可切换至 **手动 / 自动** 子策略组进行调整。

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/3acbba42-0211-4f58-b28b-8d9297a7a7b2" />

</div>

---

<!-- Zashboard 界面 -->
<div align="left">

## 三、Zashboard 界面

<img
  src="https://github.com/user-attachments/assets/c6535370-0fd5-43d5-ad60-c1b5bfa6d802"
  alt="Zashboard 界面预览"
  width="1156"
/>

</div>
