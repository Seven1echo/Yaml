### 📦 一、下载安装

* 前往官方发布页面下载最新版本 [**Clashmi Project**](https://clashmi.app/download) / [**Github**](https://github.com/KaringX/clashmi/releases)
* 根据你的操作系统选择对应安装包（Android / ios / Windows / macOS / Linux）


### ⚙️ 二、简单配置

> 初次使用 **核心设置** 建议完成基础设置（Yaml已配置相关参数，避免被软件覆盖）

* **分应用代理** ==> 开启后，勾选上一些不想走代理的软件（Android特有功能）  
* **进程匹配模式** ==> always（移动设备推荐使用 ）  
* **IPV6** ==> 不覆写   
* **TUN** ==> 关闭选项  
* **覆写** ==> 内置-不覆写  


## 🧩 三、制作文件
* 下载本项目Yaml模板 ==> [**Geo【数据库分流】**_内存占用较“高”](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Geo.yaml) / [**Rule-Set【规则集分流】**_内存占用较“低”](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_fallback_Rule-Set.yaml)
* 补充完整 **“订阅链接”** 与 **“机场名”**
* 将 **“nameserver”** 修改为运营商提供的 DNS 地址 （当前提供的是公共 DNS 地址，不改也行）

若使用的是windows平台，可使用：[**Seven1_Yaml_生成工具.exe**](https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/Seven1_Yaml_%E7%94%9F%E6%88%90%E5%B7%A5%E5%85%B7.exe)


## 📚 四、导入使用

> 各终端软件的界面大同小异，这里以 Windows 平台作为演示

* **我的配置** ==> 右上角“**+**” ==> **导入配置文件** ==> **选择文件** ==>  选中上方**制作好的Yaml** ==> 右上角“**√**”
* **未连接**  ==> 打开**开关**
* **面板** ==> 策略组（按需选择节点）

