<!-- 项目介绍 -->
<div align="left">

### 📌 项目介绍

- 本项目以 **自用** 为主，也欢迎大家体验
- 基于多位前辈大佬的成果并结合自身实际需求做了部分调整与优化，算是在 **「巨人肩膀」** 之上补充了更贴合个人使用的场景

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

</div>

---

<!-- 配置文件区分 -->
<div align="left">

### 🗂️ 配置文件区分

| 类型 | 说明 | 内存 | DNS 泄露 | 推荐平台 |
|:--:|:--:|:--:|:--:|:--:|
| **Geo** | **GeoSite / GeoIP** 数据库分流 | 高 | ✅ | ✅Openwrt ✅Windows ✅Android ✅Mac ❌IOS ✅Linux |
| **Rule-Set** | **Rule-Set** 规则集分流 | 低 | ✅ | ✅Openwrt ✅Windows ✅Android ✅Mac ✅IOS ✅Linux |
| **Overwrite** | 覆写文件 | - | ✅ | 用于指定软件自定义覆写使用 |

</div>

---

<!-- 使用说明 -->
<div align="left">

### 📖 使用说明

1. 本项目文件适用于 **Mihomo 核心** 的工具使用，如：**OpenWrt（Clash / Nikki 插件）、Clashmi、FlClash、Clash Meta ……**
2. 本项目运行策略为「故障转移」，使用时手动选择对应地区节点即可；其中 **「故障转移」**、**「延迟自选」** 两个策略组 **默认隐藏**
3. 使用前需补充完整 **订阅链接** 与 **机场名**

**⚠️ 注意（OpenWrt 用户）：** 可删除 `default-nameserver` 参数，将 `nameserver` 改为运营商分配的 DNS，以提升解析速度

</div>

---

<!-- 策略模式 -->
<div align="left">

### 🔁 策略模式

本项目中的配置文件统一采用 **故障转移（Fallback）** 运行模式，其核心理念为 **「稳定优先」**：  
当前节点可用时继续使用；当节点不可用或连接失败时，系统将 **自动切换至同一策略组内的下一个可用节点**，在保证网络**持续性**的同时，避免出现 **“跳区”** 问题。

#### 故障转移的优势
- **稳定性高**：节点异常时自动切换，最大程度减少人工干预  
- **容错性强**：单个节点失效不会影响整体网络连接的可用性  

#### 策略组示例说明
以「**日本 · 故障转移**」为例，其下方通常包含两个子策略组：
- **日本手动**：用于手动指定日本地区的具体节点  
- **日本自动**：由系统根据延迟自动选择最优节点

在实际使用中：
- 日常使用建议以 **「故障转移」** 作为主入口  
- 当需要指定线路或进行问题排查时，可切换至 **手动 / 自动** 子策略组进行调整  

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/3acbba42-0211-4f58-b28b-8d9297a7a7b2" />

</div>

---

<!-- Zashboard 界面 -->
<div align="left">

### 🖥️ Zashboard 界面

<img
  src="https://github.com/user-attachments/assets/c6535370-0fd5-43d5-ad60-c1b5bfa6d802"
  alt="Zashboard 界面预览"
  width="1156"
/>

</div>
