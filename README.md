
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

---

## 一、项目介绍

### 📝 配置随笔
- 本项目的配置文件适用于 **[Mihomo](https://github.com/MetaCubeX/mihomo) 核心** 的工具使用，如：**[OpenWrt](https://firmware-selector.immortalwrt.org/)插件（ [OpenClash](https://github.com/vernesong/openclash) / [Nikki](https://github.com/nikkinikki-org/OpenWrt-nikki) ）、[Clashmi](https://github.com/KaringX/clashmi)、[FlClash](https://github.com/chen08209/FlClash)、[Bettbox](https://github.com/appshubcc/Bettbox)  ……**
- 使用需完善 **订阅链接** 与 **机场名**，可将 **nameserver** 修改为运营商提供的 DNS 地址，以提升解析速度。
- 配置文件默认开启 **绕过中国大陆模式**，匹配大陆IP-CIDR（流量不进入代理）。

### 🛠️ 配套工具
- Windows端一键生成工具 **（推荐使用）**：**[Seven1_Yaml_生成工具.exe](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)**
- 流程：用户输入 → 模板下载 → YAML结构替换 → 输出文件

### 🗂️ 配置区分
| 类型 | **Geo** | **Rule-Set** | **Overwrite** |
|:--:|:--:|:--:|:--:|
| 说明 | 使用**GeoSite / GeoIP** 数据库分流 | 使用**Rule-Set** 规则集分流 | 软件覆写文件 |
| 文件 | [Seven1_fallback_Geo.yaml](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Geo.yaml) | [Seven1_fallback_Rule-Set.yaml](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Rule-Set.yaml) | ***_Overwrite.yaml |

### 📚 图文教程
<p>
  👉 <a href="https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/Nikki_Yaml.md">Nikki_Yaml 使用教程</a>
  &nbsp;&nbsp;&nbsp;｜&nbsp;&nbsp;&nbsp;
  👉 <a href="https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/Clashmi_Yaml.md">Clashmi_Yaml 使用教程</a>
  &nbsp;&nbsp;&nbsp;｜&nbsp;&nbsp;&nbsp;
  👉 <a href="https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/Clashmi_Overwrite.md">Clashmi_Overwrite 使用教程</a>
</p>

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



## 二、策略组简介 （以日本为例）

> [!IMPORTANT]
>
> **日本-故转**：手动选择的节点不可用时，自动切换至日本-自动，以保证连接可用性。  
> **日本-自动**：自动从日本节点中选择延迟较低、连接较优的节点，适合日常使用。  
> **日本-手动**：手动指定具体日本节点，适合需要固定 IP、节点或线路的场景。 
>



## 三、Zashboard 界面
<img width="1000" height="1418" alt="zashboard" src="https://github.com/user-attachments/assets/707fd6f4-0e76-4a0e-99e2-ce049d00221e" />
