## 一、在 [Github](https://github.com/) 快速创建一个仓库
**1.1 处于 `Repositories` 页面下，点击 `New`**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/1.1new.png)

**1.2 仓库名随意，比如仓库名：`my-rules`（名字中间尽量不用空格）,点击 `Create repository`**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/1.2name.png)

**1.3 点击 `creating a new file` 创建新文件**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/1.3creating.png)

**1.4 输入规则集文件名称，比如仓库名：`test.yaml`，在正文中间输入各种自定义规则后，点击 `Commit changes` ，弹出要求提交信息页面，可保持默认，继续点击 `Commit changes` ，即可**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/1.4ruleset.png)

>自定义规则集写法：
> | 类型 | 写法 | 说明 |
> | :-- | :-- | :-- |
> | DOMAIN 域名 |  `DOMAIN,www.apple.com` | 控制 www.apple.co 走向 |
> | DOMAIN-SUFFIX 域名后缀 | `DOMAIN-SUFFIX,apple.com` | 控制 任何以 apple.com 结尾的域名 走向 |
> | DOMAIN-KEYWORD 域名关键字 | `DOMAIN-KEYWORD,apple` | 控制 任何包含 apple 关键字的域名 走向 |
> | 目标 IPv4 地址路由数据包 | `IP-CIDR,192.168.1.9/32` | 控制 任何目标 IP 地址为 192.168.1.9/32 的数据包 走向 |
> | 源 IPv4 地址路由数据包 | `SRC-IP-CIDR,192.168.1.9/32` | 控制 任何源 IP 地址为 192.168.1.9/32 的数据包 走向 |
> | 源端口 | `SRC-PORT,80` | 控制 任何源端口为 80 的数据包 走向 |
> | 目标端口 | `DST-PORT,80` | 控制 任何目标端口为 80 的数据包 走向 |
>

**1.5 进入新创的规则集文件，点击`Raw`后复制网址栏地址、或右键 `Raw` 点击 `复制链接` ，即可获得规则集的原始文件链接**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/1.5raw.png)
```
# 示例：https://github.com/用户名/仓库名/raw/refs/heads/main/规则集名称
https://github.com/Seven1echo/my-rules/raw/refs/heads/main/test.yaml
```



## 二、将自定义规则集应用至 Yaml
**2.1 在 `rule-providers: `适当位置添加上规则提供者，注意使用锚点时，需保持对应规则锚点的文件类型 `format` 内容一致**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/2.1-1rule-providers.png)
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/2.1-2.anchor.png)

对于锚点应用方式有疑问可见：[关于Anchor_DN、Anchor_IP、Anchor_CL锚点的区别.md](https://github.com/Seven1echo/Yaml/blob/main/docs/Config/关于Anchor_DN、Anchor_IP、Anchor_CL锚点的区别.md)

**2.2 在 `rules:` 添加上规则路由走向  **
    **注意：规则读取顺序自上而下，越靠前优先级越高，匹配到即停止**，后方 `一键代理` ，为路由出口，可填 `策略组名称` 或 `节点名称`  
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/2.2rules.png)
> `add_rules` 可根据个人喜好命名，但在 `rule-providers: ` 、  `rules:` 需保持一致



## 三、检查规则是否生效
**3.1 将 Yaml 上传至 `Nikki` ,打开 `面板` ，切换至 `规则` - `规则提供商` ，检查自定义规则集是否获取成功**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/3.1board.png)

**3.2 验证 自定义规则是否生效，切换至 `连接` ，观察规则走向是否正确**
![image](https://github.com/Seven1echo/Yaml/blob/main/docs/Github/pics/GitHub创建自定义规则集流程/3.2link.png)


