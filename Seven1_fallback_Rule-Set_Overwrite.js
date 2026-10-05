// 名称： Seven1_fallback_Rule-Set_Overwrite
// 版本： V2026.10.4
// 频道： https://t.me/Seven1gogogo
// 地址： https://github.com/Seven1echo/Yaml
// 说明： 本脚本对标 Seven1_fallback_Rule-Set.yaml 进行转换，并额外添加 default-nameserver，用于为 nameserver 加密 DNS 提供解析。



// ███████████████████████████ 锚点区域 ███████████████████████████
function main(config) {
// ══ 订阅锚点 ══
  const Anchor_PR = {type: "http", interval: 86400, proxy: "DIRECT", "health-check": {enable: true, url: "https://www.gstatic.com/generate_204", interval: 300}, filter: "^(?!.*(到期|过期|剩余|网址|官网|邮箱|订阅|套餐|流量|说明|重置)).*$"};
// ══ 出站锚点 ══
  const Anchor_PG = {type: "select", proxies: ["香港-故转","台湾-故转","日本-故转","新加坡-故转","韩国-故转","美国-故转","欧洲-故转","香港-自动","台湾-自动","日本-自动","新加坡-自动","韩国-自动","美国-自动","欧洲-自动","香港-手动","台湾-手动","日本-手动","新加坡-手动","韩国-手动","美国-手动","欧洲-手动","其他-手动","国内直连"]};
  const Anchor_OP = {type: "select", proxies: ["一键代理","香港-故转","台湾-故转","日本-故转","新加坡-故转","韩国-故转","美国-故转","欧洲-故转","香港-自动","台湾-自动","日本-自动","新加坡-自动","韩国-自动","美国-自动","欧洲-自动","香港-手动","台湾-手动","日本-手动","新加坡-手动","韩国-手动","美国-手动","欧洲-手动","其他-手动","国内直连"]};
  const Anchor_LD = {type: "select", proxies: ["国内直连","一键代理","香港-故转","台湾-故转","日本-故转","新加坡-故转","韩国-故转","美国-故转","欧洲-故转","香港-自动","台湾-自动","日本-自动","新加坡-自动","韩国-自动","美国-自动","欧洲-自动","香港-手动","台湾-手动","日本-手动","新加坡-手动","韩国-手动","美国-手动","欧洲-手动","其他-手动"]};
  const Anchor_DR = {type: "select", proxies: ["DIRECT"], hidden: true};
// ══ 策略锚点 ══
  const Anchor_HS = {type: "select", "empty-fallback": "REJECT", "include-all": true};
  const Anchor_FB = {type: "fallback", "empty-fallback": "REJECT", interval: 300, lazy: false, timeout: 3000, "max-failed-times": 2, hidden: true, url: "https://www.gstatic.com/generate_204"};
  const Anchor_UT = {type: "url-test", "empty-fallback": "REJECT", interval: 300, lazy: false, timeout: 3000, "max-failed-times": 2, hidden: true, url: "https://www.gstatic.com/generate_204", tolerance: 50, "include-all": true};
// ══ 规则锚点 ══
  const Anchor_DN = {type: "http", interval: 86400, behavior: "domain", format: "mrs"};
  const Anchor_IP = {type: "http", interval: 86400, behavior: "ipcidr", format: "mrs"};
  const Anchor_CL = {type: "http", interval: 86400, behavior: "classical", format: "yaml"};
// ══ 区域锚点 ══
  const Anchor_HK = "(?i)^(?=.*(香港|(?<![a-zA-Z])(hk|hkg)(?![a-zA-Z])|hongkong|hong kong|🇭🇰)).*$";
  const Anchor_TW = "(?i)^(?=.*(台湾|(?<![a-zA-Z])(tw|tpe|khh|tsa)(?![a-zA-Z])|taiwan|taipei|🇹🇼)).*$";
  const Anchor_JP = "(?i)^(?=.*(日本|(?<![a-zA-Z])(jp|nrt|hnd|kix|cts|fuk)(?![a-zA-Z])|japan|tokyo|🇯🇵)).*$";
  const Anchor_SG = "(?i)^(?=.*(新加坡|(?<![a-zA-Z])(sg|sin|xsp)(?![a-zA-Z])|singapore|🇸🇬)).*$";
  const Anchor_KR = "(?i)^(?=.*(韩国|(?<![a-zA-Z])(kr|icn|gmp|pus)(?![a-zA-Z])|korea|seoul|🇰🇷)).*$";
  const Anchor_US = "(?i)^(?=.*(美国|(?<![a-zA-Z])(us|usa|lax|sfo|jfk|sjc)(?![a-zA-Z])|america|united states|🇺🇸)).*$";
  const Anchor_EU = "(?i)^(?=.*(奥地利|奥地利共和国|比利时|保加利亚|克罗地亚|塞浦路斯|捷克|丹麦|爱沙尼亚|芬兰|法国|德国|希腊|匈牙利|爱尔兰|意大利|拉脱维亚|立陶宛|卢森堡|荷兰|波兰|葡萄牙|罗马尼亚|斯洛伐克|斯洛文尼亚|西班牙|瑞典|英国|🇧🇪|🇨🇿|🇩🇰|🇫🇮|🇫🇷|🇩🇪|🇮🇪|🇮🇹|🇱🇹|🇱🇺|🇳🇱|🇵🇱|🇸🇪|🇬🇧|CDG|FRA|AMS|MAD|BCN|FCO|MUC|BRU)).*$";
  const Anchor_OT = "^(?!.*(DIRECT|香港|台湾|日本|新加坡|韩国|美国|奥地利|奥地利共和国|比利时|保加利亚|克罗地亚|塞浦路斯|捷克|丹麦|爱沙尼亚|芬兰|法国|德国|希腊|匈牙利|爱尔兰|意大利|拉脱维亚|立陶宛|卢森堡|荷兰|波兰|葡萄牙|罗马尼亚|斯洛伐克|斯洛文尼亚|西班牙|瑞典|英国|🇭🇰|🇹🇼|🇸🇬|🇯🇵|🇰🇷|🇺🇸|🇬🇧|HK|TW|SG|JP|KR|US|GB|CDG|FRA|AMS|MAD|BCN|FCO|MUC|BRU|HKG|TPE|TSA|KHH|SIN|XSP|NRT|HND|KIX|CTS|FUK|JFK|LAX|ORD|ATL|DFW|SFO|MIA|SEA|IAD|LHR|LGW)).*$";



// ███████████████████████████ 节点订阅 ███████████████████████████
  config["proxy-providers"] = {
    "机场名": {...Anchor_PR, url: "订阅链接", override: {"additional-prefix": "[机场名] "}}
  };



// ███████████████████████████ 核心配置 ███████████████████████████
// ══ 基础配置 ══
  config.mode = "rule";
  config.ipv6 = true;
  config["mixed-port"] = 7893;
  config["allow-lan"] = true;
  config["bind-address"] = "*";
  config["log-level"] = "warning";
  config["unified-delay"] = true;
  config["tcp-concurrent"] = true;
  config["global-ua"] = "clash.meta";
  config.profile = {"store-selected": true, "store-fake-ip": true};
// ══ 管理面板 ══
  config["external-ui-url"] = "https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip";
  config["external-controller"] = "0.0.0.0:9090";
  config["external-ui-name"] = "zashboard";
  config["external-ui"] = "ui";
  config.secret = "";
// ══ TUN配置 ══
  config.tun = {
    enable: true,
    stack: "mixed",
    "dns-hijack": ["udp://any:53","tcp://any:53"],
    "auto-detect-interface": true,
    "auto-route": true,
    "auto-redirect": true,
    "strict-route": false,
    "endpoint-independent-nat": true,
    "route-exclude-address-set": ["bps_cn_ip"]
  };
// ══ 嗅探功能 ══
  config.sniffer = {
    enable: true,
    "parse-pure-ip": true,
    "force-dns-mapping": true,
    "override-destination": false,
    sniff: {QUIC: {ports: [443]}, TLS: {ports: [443,8443]}, HTTP: {ports: [80,"8080-8880"], "override-destination": true}},
    "force-domain": ["+.netflix.com","+.nflxvideo.net","+.amazonaws.com","+.media.dssott.com","+.tiktok.com"],
    "skip-domain": ["dlg.io.mi.com","+.mi.com","+.xiaomi.com","+.miwifi.com","+.oray.com","+.sunlogin.net","+.push.apple.com"]};
// ══ hosts配置 ══
  config.hosts = {"services.googleapis.cn": ["services.googleapis.com"]};
// ══ DNS配置 ══
  config.dns = {
    enable: true,
    ipv6: true,
    "use-hosts": true,
    "use-system-hosts": true,
    "cache-algorithm": "arc",
    listen: "0.0.0.0:7874",
    "enhanced-mode": "fake-ip",
    "fake-ip-range": "198.18.0.1/16",
    "fake-ip-range6": "2001:2::1/48",
    "fake-ip-filter-mode": "blacklist",
    "respect-rules": false,
    "fake-ip-filter": ["+.lan","+.local","rule-set:add_cn_domain","rule-set:cn_domain"],
    "default-nameserver": ["114.114.114.114","223.5.5.5"],
    nameserver: ["https://dns.alidns.com/dns-query","https://doh.pub/dns-query"]
  };



// ███████████████████████████ 策略分组 ███████████████████████████
// ══ 服务组 ══
  const I = "https://github.com/Seven1echo/Yaml/raw/main/icons/";
  config["proxy-groups"] = [
    {name: "一键代理",     ...Anchor_PG, icon: I+"Rocket.png"},
    {name: "AI",          ...Anchor_OP, icon: I+"Ai.png"},
    {name: "YouTube",     ...Anchor_OP, icon: I+"YouTube.png"},
    {name: "Google",      ...Anchor_OP, icon: I+"Google.png"},
    {name: "GitHub",      ...Anchor_OP, icon: I+"GitHub.png"},
    {name: "OneDrive",    ...Anchor_LD, icon: I+"OneDrive.png"},
    {name: "Microsoft",   ...Anchor_LD, icon: I+"Microsoft.png"},
    {name: "Apple",       ...Anchor_LD, icon: I+"Apple.png"},
    {name: "Steam",       ...Anchor_OP, icon: I+"Steam.png"},
    {name: "TikTok",      ...Anchor_OP, icon: I+"TikTok.png"},
    {name: "Twitter(X)",  ...Anchor_OP, icon: I+"Twitter.png"},
    {name: "Telegram",    ...Anchor_OP, icon: I+"Telegram.png"},
    {name: "Netflix",     ...Anchor_OP, icon: I+"Netflix.png"},
    {name: "Disney",      ...Anchor_OP, icon: I+"Disney.png"},
    {name: "Spotify",     ...Anchor_OP, icon: I+"Spotify.png"},
    {name: "PayPal",      ...Anchor_OP, icon: I+"PayPal.png"},
    {name: "Speedtest",   ...Anchor_OP, icon: I+"Speedtest.png"},
    {name: "漏网之鱼",     ...Anchor_OP, icon: I+"MATCH.png"},
    {name: "国内直连",     ...Anchor_DR, icon: I+"China.png"},
// ══ 故转组 ══
    {name: "香港-故转",    ...Anchor_FB, proxies: ["香港-手动","香港-自动"], icon: I+"HK.png"},
    {name: "台湾-故转",    ...Anchor_FB, proxies: ["台湾-手动","台湾-自动"], icon: I+"TW.png"},
    {name: "日本-故转",    ...Anchor_FB, proxies: ["日本-手动","日本-自动"], icon: I+"JP.png"},
    {name: "新加坡-故转",  ...Anchor_FB, proxies: ["新加坡-手动","新加坡-自动"], icon: I+"SG.png"},
    {name: "韩国-故转",    ...Anchor_FB, proxies: ["韩国-手动","韩国-自动"], icon: I+"KR.png"},
    {name: "美国-故转",    ...Anchor_FB, proxies: ["美国-手动","美国-自动"], icon: I+"US.png"},
    {name: "欧洲-故转",    ...Anchor_FB, proxies: ["欧洲-手动","欧洲-自动"], icon: I+"EU.png"},
// ══ 手动组 ══
    {name: "香港-手动",    ...Anchor_HS, filter: Anchor_HK, icon: I+"HK.png"},
    {name: "台湾-手动",    ...Anchor_HS, filter: Anchor_TW, icon: I+"TW.png"},
    {name: "日本-手动",    ...Anchor_HS, filter: Anchor_JP, icon: I+"JP.png"},
    {name: "新加坡-手动",  ...Anchor_HS, filter: Anchor_SG, icon: I+"SG.png"},
    {name: "韩国-手动",    ...Anchor_HS, filter: Anchor_KR, icon: I+"KR.png"},
    {name: "美国-手动",    ...Anchor_HS, filter: Anchor_US, icon: I+"US.png"},
    {name: "欧洲-手动",    ...Anchor_HS, filter: Anchor_EU, icon: I+"EU.png"},
    {name: "其他-手动",    ...Anchor_HS, filter: Anchor_OT, icon: I+"OT.png"},
// ══ 自动组 ══
    {name: "香港-自动",    ...Anchor_UT, filter: Anchor_HK, icon: I+"HK.png"},
    {name: "台湾-自动",    ...Anchor_UT, filter: Anchor_TW, icon: I+"TW.png"},
    {name: "日本-自动",    ...Anchor_UT, filter: Anchor_JP, icon: I+"JP.png"},
    {name: "新加坡-自动",  ...Anchor_UT, filter: Anchor_SG, icon: I+"SG.png"},
    {name: "韩国-自动",    ...Anchor_UT, filter: Anchor_KR, icon: I+"KR.png"},
    {name: "美国-自动",    ...Anchor_UT, filter: Anchor_US, icon: I+"US.png"},
    {name: "欧洲-自动",    ...Anchor_UT, filter: Anchor_EU, icon: I+"EU.png"}
  ];



// ███████████████████████████ 规则匹配 ███████████████████████████
  config.rules = [
    "AND,((NETWORK,UDP),(DST-PORT,443),(NOT,((OR,((RULE-SET,cn_domain),(RULE-SET,cn_ip,no-resolve)))))),REJECT",
    "RULE-SET,private_domain,国内直连",
    "RULE-SET,private_ip,国内直连,no-resolve",
    "RULE-SET,games@cn_domain,国内直连",
    "RULE-SET,ai-!cn_domain,AI",
    "RULE-SET,youtube_domain,YouTube",
    "RULE-SET,google_domain,Google",
    "RULE-SET,github_domain,GitHub",
    "RULE-SET,onedrive_domain,OneDrive",
    "RULE-SET,microsoft_domain,Microsoft",
    "RULE-SET,apple_domain,Apple",
    "RULE-SET,steam_domain,Steam",
    "RULE-SET,tiktok_domain,TikTok",
    "RULE-SET,twitter_domain,Twitter(X)",
    "RULE-SET,telegram_domain,Telegram",
    "RULE-SET,netflix_domain,Netflix",
    "RULE-SET,disney_domain,Disney",
    "RULE-SET,spotify_domain,Spotify",
    "RULE-SET,paypal_domain,PayPal",
    "RULE-SET,speedtest_domain,Speedtest",
    "RULE-SET,google_ip,Google,no-resolve",
    "RULE-SET,telegram_ip,Telegram,no-resolve",
    "RULE-SET,twitter_ip,Twitter(X),no-resolve",
    "RULE-SET,netflix_ip,Netflix,no-resolve",
    "RULE-SET,geolocation-!cn,一键代理",
    "RULE-SET,add_cn_domain,国内直连",
    "RULE-SET,cn_domain,国内直连",
    "RULE-SET,cn_ip,国内直连,no-resolve",
    "MATCH,漏网之鱼"
  ];



// ███████████████████████████ 规则来源 ███████████████████████████
  config["rule-providers"] = {
// ══ 域名规则 ══
    "private_domain":     {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/private.mrs"},
    "games@cn_domain":    {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/category-games@cn.mrs"},
    "ai-!cn_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/category-ai-!cn.mrs"},
    "youtube_domain":     {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/youtube.mrs"},
    "google_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/google.mrs"},
    "github_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/github.mrs"},
    "onedrive_domain":    {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/onedrive.mrs"},
    "microsoft_domain":   {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/microsoft.mrs"},
    "apple_domain":       {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/apple.mrs"},
    "steam_domain":       {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/steam.mrs"},
    "tiktok_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/tiktok.mrs"},
    "twitter_domain":     {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/twitter.mrs"},
    "telegram_domain":    {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/telegram.mrs"},
    "netflix_domain":     {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/netflix.mrs"},
    "disney_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/disney.mrs"},
    "spotify_domain":     {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/spotify.mrs"},
    "paypal_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/paypal.mrs"},
    "speedtest_domain":   {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/category-speedtest.mrs"},
    "geolocation-!cn":    {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/geolocation-!cn.mrs"},
    "cn_domain":          {...Anchor_DN, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/cn.mrs"},
    "add_cn_domain":      {...Anchor_DN, url: "https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/rules/Seven1_Direct_Domain.mrs"},
// ══ IP规则 ══
    "private_ip":         {...Anchor_IP, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/private.mrs"},
    "google_ip":          {...Anchor_IP, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/google.mrs"},
    "telegram_ip":        {...Anchor_IP, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/telegram.mrs"},
    "twitter_ip":         {...Anchor_IP, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/twitter.mrs"},
    "netflix_ip":         {...Anchor_IP, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/netflix.mrs"},
    "cn_ip":              {...Anchor_IP, url: "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/cn.mrs"},
    "bps_cn_ip":          {...Anchor_IP, url: "https://raw.githubusercontent.com/Seven1echo/Yaml/refs/heads/main/rules/Seven1_Bypass_China.mrs"}
  };

  return config;
}