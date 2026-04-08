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

### 📝 配置随笔
- 本项目的配置文件适用于 **Mihomo 核心** 的工具使用，如：**OpenWrt（Clash / Nikki 插件）、Clashmi、FlClash、Clash Meta ……**。
- 使用需完善 **订阅链接** 与 **机场名**，并将 **nameserver** 修改为运营商提供的 DNS 地址，以提升解析速度。

### 🛠️ 配套工具
- Windows端一键生成工具 **（推荐使用）**：[Seven1_Yaml_生成工具.exe](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)
- 流程：模板下载 → 用户输入 → YAML结构替换 → 输出文件

### 🗂️ 配置区分
| 类型 | **Geo** | **Rule-Set** | **Overwrite** |
|:--:|:--:|:--:|:--:|
| 说明 | 使用**GeoSite / GeoIP** 数据库分流 | 使用**Rule-Set** 规则集分流 | 软件覆写文件 |
| 文件 | Seven1_fallback_Geo.yaml | Seven1_fallback_Rule-Set.yaml | ***_Clashmi_Overwrite.yaml |

### 🎬 视频教程
<!-- 缩略图 + 精简标题（横向展示） -->
<table>
  <tr>
    <td align="center">
      <a href="https://youtu.be/5yD_q382YSQ" target="_blank" rel="noopener">
        <img src="https://img.youtube.com/vi/5yD_q382YSQ/hqdefault.jpg" width="235" />
      </a>
      <br/>
      <sub><b>OpenWrt · Nikki 插件配置</b></sub>
    </td>
    <td align="center">
      <a href="https://youtu.be/qINXLkfVJck" target="_blank" rel="noopener">
        <img src="https://img.youtube.com/vi/qINXLkfVJck/hqdefault.jpg" width="235" />
      </a>
      <br/>
      <sub><b>Clash Mi · YAML文件&多端同步</b></sub>
    </td>
    <td align="center">
      <a href="https://youtu.be/YLYXv1xryA0" target="_blank" rel="noopener">
        <img src="https://img.youtube.com/vi/YLYXv1xryA0/hqdefault.jpg" width="235" />
      </a>
      <br/>
      <sub><b>Clash Mi · 自定义覆写技巧</b></sub>
    </td>
  </tr>
</table>

</div>

---

## 二、运行模式

日常使用建议以 **「故障转移」** 作为主要出站，其核心理念为 **「稳定优先」**：  
当前区域节点可用时继续使用；当节点不可用或连接失败时，系统将 **自动切换至同一策略组内的下一个可用节点**，在保证网络**持续性**的同时，避免出现 **“跳区”** 问题。

### 🏆 故障转移的优势
- **稳定性高**：节点异常时自动切换，最大程度减少人工干预。
- **容错性强**：单个节点失效不会影响整体网络连接的可用性。

### 🌟 策略组示例说明
以「**日本故转**」为例，其下方通常包含两个子策略组：
- **日本手动**：用于手动指定日本地区的具体节点。
- **日本自动**：由系统根据延迟自动选择最优节点。

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/3acbba42-0211-4f58-b28b-8d9297a7a7b2" />

</div>

---

## 三、Zashboard 界面

<img
  src="https://github.com/user-attachments/assets/c6535370-0fd5-43d5-ad60-c1b5bfa6d802"
  alt="Zashboard 界面预览"
  width="1156"
/>

</div>
