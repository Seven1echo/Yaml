
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
> [!TIP]
>
>  本项目的配置文件适用于 **[Mihomo](https://github.com/MetaCubeX/mihomo) 核心** 的工具使用，如：**[OpenWrt](https://firmware-selector.immortalwrt.org/)插件（ [OpenClash](https://github.com/vernesong/openclash) / [Nikki](https://github.com/nikkinikki-org/OpenWrt-nikki) ）、[Clashmi](https://github.com/KaringX/clashmi)、[FlClash](https://github.com/chen08209/FlClash)、[Bettbox](https://github.com/appshubcc/Bettbox)  ……**
>
>  使用需完善 **订阅链接** 与 **机场名**，可将 **nameserver** 修改为运营商提供的 DNS 地址，以提升解析速度
>
>  配置文件默认开启 **绕过中国大陆模式**，匹配大陆IP-CIDR（流量不进入代理）
> 

### 🗂️ 配置区分
| 类型 | **Geo**（数据库分流） | **Rule-Set**（规则集分流） |
|:--|:--|:--|
| 说明 | 内存占用较大 | 内存占用较小 |
| 常规核心  （MetaCubeX） | [***_Geo.yaml](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Geo.yaml) | [***_Rule-Set.yaml](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Rule-Set.yaml) |
| Smart核心（Vernesong） | [***_Geo_Smart.yaml](https://github.com/Seven1echo/Yaml/blob/main/smart/Seven1_fallback_Geo_Smart.yaml) |[***_Rule-Set_Smart.yaml](https://github.com/Seven1echo/Yaml/blob/main/smart/Seven1_fallback_Rule-Set_Smart.yaml) |
| Clashmi覆写 | / |  [***_Rule-Set_Clashmi_Overwrite.yaml](https://github.com/Seven1echo/Yaml/blob/main/Seven1_fallback_Rule-Set_Clashmi_Overwrite.yaml) |

### 🛠️ 配套工具
> - 一键生成YAML配置文件 **（Windows端）**：**[Seven1_Yaml_生成工具.exe](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)**
> - 找出掉入漏网之鱼的直连，**（Docker 部署）**：**[RouteCheck](https://github.com/Seven1echo/RouteCheck)**

### 📚 图文教程
> 
> **‌Proxmox VE** (PVE)
> > - 📂 [SubStore 部署教程](https://github.com/Seven1echo/Yaml/blob/main/docs/PVE/PVE-LXC_Debian-Docker_SubStore.md)
> 
> **OpenWrt**
> > - 【常规核心】
> > - 📂 [Nikki_Yaml “仅核心”使用教程](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/Nikki_Yaml.md)   
> > - 【Smart核心】
> > - 📂 [Nikki_Yaml “Smart核心”使用教程](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/Nikki_Smart.md)
> > - 📂 [Mihomo_Smart_AI模型训练教程](https://github.com/Seven1echo/Yaml/blob/main/docs/Nikki/Mihomo_Smart_AI%E6%A8%A1%E5%9E%8B%E8%AE%AD%E7%BB%83%E6%B5%81%E7%A8%8B.md)
> 
> **ClashMi**（Android ｜ iOS ｜ Windows ｜ macOS ｜ Linux）
> > - 📂 [Yaml 使用教程](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/Clashmi_Yaml.md) 
> > - 📂 [Overwrite 覆写使用教程](https://github.com/Seven1echo/Yaml/blob/main/docs/Clashmi/Clashmi_Overwrite.md)
> 
> **Flclash**（Android ｜ ~iOS~ ｜ Windows ｜ macOS ｜ Linux）
> > - 📂 [Yaml 使用教程（示例：windows端）](https://github.com/Seven1echo/Yaml/blob/main/docs/Flclash/Flclash_Windows_Yaml.md)

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



## 二、策略组简介

> [!IMPORTANT]
>
> **⚠️ 以日本区域为例**
> > **日本-故转**：手动选择的节点不可用时，自动切换至日本-自动，以保证连接可用性  
> > 
> > **日本-自动**：自动从日本节点中选择延迟较低、连接较优的节点，适合日常使用  
> > 
> > **日本-手动**：手动指定具体日本节点，适合需要固定 IP、节点或线路的场景  
> > 
> > **日本-智选**：根据用户使用习惯和节点质量自动选择符合您的最优节点  
> >   



## 三、Zashboard 界面
<img width="1179" height="2012" alt="7 Zashboard" src="https://github.com/user-attachments/assets/45c9e5e9-1a08-4d54-ab43-cf123e86b55b" />

