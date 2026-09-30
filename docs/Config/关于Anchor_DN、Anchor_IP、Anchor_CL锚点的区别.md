# Anchor_DN、Anchor_IP、Anchor_CL 区别

这三个其实是 **Mihomo/Clash Meta 规则集（rule-provider）的三种匹配类型**，核心区别在 `behavior` 和 `format`。

| 锚点          | `behavior`  | `format` | 主要匹配内容       | 常见用途                                     |
| ----------- | ----------- | -------- | ------------ | ---------------------------------------- |
| `Anchor_DN` | `domain`    | `mrs`    | 域名           | 广告域名、AI 服务、流媒体域名                         |
| `Anchor_IP` | `ipcidr`    | `mrs`    | IP / CIDR 网段 | 国内外 IP 段、局域网、特定服务 IP                     |
| `Anchor_CL` | `classical` | `yaml`   | Clash 传统规则   | 混合规则：DOMAIN、IP-CIDR、GEOIP、PROCESS-NAME 等 |

---

## 1. `Anchor_DN`

```yaml
Anchor_DN: &Anchor_DN
  {type: http, interval: 86400, behavior: domain, format: mrs}
```

对应：

```yaml
behavior: domain
```

规则集里面应该是**域名规则**，例如：

```text
google.com
youtube.com
+.google.com
```

适合：

```yaml
rule-providers:
  Google:
    <<: *Anchor_DN
    url: ...
```

然后：

```yaml
- RULE-SET,Google,Proxy
```

它主要解决的是：

> **“访问这个域名时走什么策略？”**

---

## 2. `Anchor_IP`

```yaml
Anchor_IP: &Anchor_IP
  {type: http, interval: 86400, behavior: ipcidr, format: mrs}
```

对应：

```yaml
behavior: ipcidr
```

规则集里面放的是 **IP/CIDR 网段**，例如：

```text
1.1.1.1/32
8.8.8.0/24
10.0.0.0/8
```

适合根据**目标 IP**进行匹配。

例如：

```yaml
- RULE-SET,SomeIPList,Proxy
```

它主要解决：

> **“目标服务器的 IP 属于哪个网段？”**

这种规则通常用于 IP 库、地区 IP、特定服务的 IP 段等。

---

## 3. `Anchor_CL`

```yaml
Anchor_CL: &Anchor_CL
  {type: http, interval: 86400, behavior: classical, format: yaml}
```

对应：

```yaml
behavior: classical
```

这个最灵活。

可以包含 Clash/Mihomo 传统规则，例如：

```text
DOMAIN,google.com
DOMAIN-SUFFIX,youtube.com
DOMAIN-KEYWORD,google
IP-CIDR,1.1.1.0/24
IP-CIDR6,2606:4700::/32
GEOIP,CN
PROCESS-NAME,chrome.exe
MATCH
```

所以 `classical` 可以理解成：

> **“规则集本身带有完整的 Clash 规则类型。”**

例如：

```yaml
Anchor_CL: &Anchor_CL
  {type: http, interval: 86400, behavior: classical, format: yaml}

rule-providers:
  MyRules:
    <<: *Anchor_CL
    url: https://example.com/rules.yaml
```

---

## `mrs` 和 `yaml` 又是什么？

这里容易混淆。

### `behavior`

`behavior` 决定**规则是什么类型**：

```text
domain
ipcidr
classical
```

### `format`

`format` 决定**规则集文件是什么格式**：

```text
mrs
yaml
```

所以：

```yaml
behavior: domain
format: mrs
```

意思是：

> 这是一个 **MRS 格式的域名规则集**。

而：

```yaml
behavior: classical
format: yaml
```

意思是：

> 这是一个 **文本格式的 Clash classical 规则集**。

---

## 一句话记忆

```text
Anchor_DN  → 只放域名
Anchor_IP  → 只放 IP/CIDR
Anchor_CL  → 放完整 Clash 规则
```

例如同一个 `google.com`：

### `Anchor_DN`

```text
google.com
```

### `Anchor_CL`

```text
DOMAIN-SUFFIX,google.com
```

甚至可以写：

```text
DOMAIN,google.com
IP-CIDR,8.8.8.8/32
GEOIP,google
```

---

## 总结

如果配置同时定义这三个 Anchor，通常是在**根据不同规则集的实际内容选择对应的模板**，而不是三种“代理模式”。

| 场景                | 使用          |
| ----------------- | ----------- |
| 规则列表只有域名          | `Anchor_DN` |
| 规则列表只有 IP/CIDR    | `Anchor_IP` |
| 规则列表包含多种 Clash 规则 | `Anchor_CL` |
