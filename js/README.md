<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>技术工具脚本集合</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <!-- Prism.js 代码高亮 -->
    <link href="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/prism.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-bash.min.js"></script>
    
    <!-- 自定义配置 -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#165DFF',
                        secondary: '#36CFFB',
                        dark: '#1E293B',
                        light: '#F8FAFC'
                    },
                    fontFamily: {
                        sans: ['Inter', 'system-ui', 'sans-serif'],
                        mono: ['Fira Code', 'monospace']
                    }
                }
            }
        }
    </script>
    
    <style type="text/tailwindcss">
        @layer utilities {
            .code-block {
                @apply relative rounded-lg bg-dark text-light p-4 overflow-x-auto my-4;
            }
            .copy-btn {
                @apply absolute top-3 right-3 bg-primary/80 hover:bg-primary text-white px-3 py-1 rounded text-sm transition-all duration-200;
            }
            .card {
                @apply bg-white rounded-xl shadow-md p-6 mb-8 transition-all duration-300 hover:shadow-lg;
            }
            .section-title {
                @apply text-2xl font-bold text-dark mb-4 flex items-center;
            }
            .section-title i {
                @apply mr-2 text-primary;
            }
        }
    </style>
</head>
<body class="bg-gray-50 font-sans text-gray-800">
    <!-- 顶部导航 -->
    <header class="bg-white shadow-sm sticky top-0 z-10">
        <div class="container mx-auto px-4 py-4 flex justify-between items-center">
            <h1 class="text-2xl font-bold text-primary">
                <i class="fa fa-code mr-2"></i>技术工具脚本集合
            </h1>
            <div class="text-gray-500">
                <i class="fa fa-calendar-o mr-1"></i>更新于 2025-11-07
            </div>
        </div>
    </header>

    <!-- 主要内容 -->
    <main class="container mx-auto px-4 py-8">
        <!-- 简介 -->
        <div class="card mb-8">
            <h2 class="section-title">
                <i class="fa fa-info-circle"></i>使用说明
            </h2>
            <p class="text-gray-600 mb-4">
                本页面收集了常用的技术工具部署脚本，点击代码块右上角的复制按钮可快速复制脚本，直接在终端执行。
            </p>
            <div class="flex flex-wrap gap-3">
                <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                    <i class="fa fa-linux mr-1"></i>Linux
                </span>
                <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                    <i class="fa fa-docker mr-1"></i>Docker
                </span>
                <span class="bg-purple-100 text-purple-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                    <i class="fa fa-terminal mr-1"></i>Shell
                </span>
                <span class="bg-orange-100 text-orange-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                    <i class="fa fa-server mr-1"></i>服务器
                </span>
            </div>
        </div>

        <!-- SSH 脚本 -->
        <div class="card">
            <h2 class="section-title">
                <i class="fa fa-plug"></i>一键开启 SSH 脚本（Debian 系统）
            </h2>
            <p class="text-gray-600 mb-4">
                适用于 Debian/Ubuntu 系统，自动安装并配置 SSH 服务，允许 root 密码登录，设置 root 密码（如需），开放 22 端口。
            </p>
            <div class="code-block">
                <button class="copy-btn" data-target="ssh-script">
                    <i class="fa fa-copy mr-1"></i>复制
                </button>
                <pre><code class="language-bash">bash -c "$(echo 'OS_TYPE=$([ -f /etc/os-release ] && . /etc/os-release && echo $ID || echo unknown); [ "$(id -u)" -ne 0 ] && echo "请使用root权限运行" && exit 1; echo "正在配置SSH..."; if command -v apt &>/dev/null; then apt update && apt install -y openssh-server; elif command -v yum &>/dev/null; then yum install -y openssh-server; fi; CONF="/etc/ssh/sshd_config"; sed -i "s/^#\\?PermitRootLogin.*/PermitRootLogin yes/g" $CONF; sed -i "s/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/g" $CONF; if command -v systemctl &>/dev/null; then systemctl restart sshd || systemctl restart ssh; elif command -v service &>/dev/null; then service sshd restart || service ssh restart; fi; if [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "NP" ] || [ "$(passwd -S root 2>/dev/null | awk "{print \$2}")" = "L" ]; then echo "设置root密码:"; passwd root; fi; if command -v ufw &>/dev/null && ufw status | grep -q "active"; then ufw allow 22/tcp; fi; IP=$(ip -4 addr show scope global | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1 || ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1" | head -n 1); echo "SSH已配置! 连接命令: ssh root@${IP:-<主机IP>}"')"</code></pre>
            </div>
            <div class="bg-blue-50 border-l-4 border-primary p-4 mt-4">
                <h4 class="font-semibold text-primary mb-1">注意事项：</h4>
                <ul class="list-disc list-inside text-gray-700 text-sm">
                    <li>必须使用 root 权限运行（sudo -i 切换）</li>
                    <li>自动适配 Debian/Ubuntu 和 CentOS/RHEL 系统</li>
                    <li>如果 root 无密码或被锁定，会提示设置密码</li>
                    <li>自动开放 UFW 防火墙的 22 端口（如启用）</li>
                </ul>
            </div>
        </div>

        <!-- Portainer 部署 -->
        <div class="card">
            <h2 class="section-title">
                <i class="fa fa-cubes"></i>Docker 图形化管理工具 Portainer-CE 汉化版
            </h2>
            <p class="text-gray-600 mb-4">
                部署 Portainer-CE 汉化版，提供 Docker 图形化管理界面，默认端口 9000。
            </p>
            <div class="code-block">
                <button class="copy-btn" data-target="portainer-script">
                    <i class="fa fa-copy mr-1"></i>复制
                </button>
                <pre><code class="language-bash">docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data 6053537/portainer-ce</code></pre>
            </div>
            <div class="bg-green-50 border-l-4 border-green-500 p-4 mt-4">
                <h4 class="font-semibold text-green-700 mb-1">访问方式：</h4>
                <p class="text-gray-700">
                    <i class="fa fa-globe mr-1"></i> http://服务器IP:9000
                </p>
                <h4 class="font-semibold text-green-700 mb-1 mt-2">初始设置：</h4>
                <ul class="list-disc list-inside text-gray-700 text-sm">
                    <li>首次访问需设置管理员密码</li>
                    <li>选择 "Local" 环境即可管理本地 Docker</li>
                </ul>
            </div>
        </div>

        <!-- Sub-Store 部署 -->
        <div class="card">
            <h2 class="section-title">
                <i class="fa fa-exchange"></i>Docker 部署 Sub-Store
            </h2>
            <p class="text-gray-600 mb-4">
                部署 Sub-Store 订阅管理工具，默认端口 3008，支持定时更新订阅。
            </p>
            <div class="code-block">
                <button class="copy-btn" data-target="substore-script">
                    <i class="fa fa-copy mr-1"></i>复制
                </button>
                <pre><code class="language-bash">docker run -it -d --restart=always -e "SUB_STORE_CRON=50 23 *" -e SUB_STORE_FRONTEND_BACKEND_PATH=/T3B9dgzBzdRbBF8Aqx7P -p 3008:3001 -v /etc/sub-store:/opt/app/data --name Sub2Store xream/sub-store:latest</code></pre>
            </div>
            <div class="bg-purple-50 border-l-4 border-purple-500 p-4 mt-4">
                <h4 class="font-semibold text-purple-700 mb-1">访问地址：</h4>
                <p class="text-gray-700 mb-2">
                    <i class="fa fa-globe mr-1"></i> <a href="http://10.0.0.3:3008/?api=http://10.0.0.3:3008/T3B9dgzBzdRbBF8Aqx7P" class="text-primary hover:underline" target="_blank">http://10.0.0.3:3008/?api=http://10.0.0.3:3008/T3B9dgzBzdRbBF8Aqx7P</a>
                </p>
                <h4 class="font-semibold text-purple-700 mb-1">配置说明：</h4>
                <ul class="list-disc list-inside text-gray-700 text-sm">
                    <li>定时更新：每天 23:50 自动更新订阅（可修改 SUB_STORE_CRON 参数）</li>
                    <li>数据持久化：配置文件存储在 /etc/sub-store 目录</li>
                    <li>端口映射：主机端口 3008 映射到容器端口 3001</li>
                    <li>后端路径：/T3B9dgzBzdRbBF8Aqx7P（与环境变量保持一致）</li>
                </ul>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-6">
        <div class="container mx-auto px-4 text-center">
            <p class="mb-2">
                <i class="fa fa-code-fork mr-1"></i>技术工具脚本集合
            </p>
            <p class="text-gray-400 text-sm">
                © 2025 版权所有 | 持续更新中
            </p>
        </div>
    </footer>

    <!-- 复制功能脚本 -->
    <script>
        // 复制按钮功能
        document.querySelectorAll('.copy-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const targetId = this.getAttribute('data-target');
                const codeBlock = this.nextElementSibling;
                const code = codeBlock.textContent.trim();
                
                // 复制到剪贴板
                navigator.clipboard.writeText(code).then(() => {
                    // 按钮状态变化
                    const originalText = this.innerHTML;
                    this.innerHTML = '<i class="fa fa-check mr-1"></i>已复制';
                    this.classList.remove('bg-primary/80', 'hover:bg-primary');
                    this.classList.add('bg-green-600');
                    
                    // 恢复原始状态
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.classList.remove('bg-green-600');
                        this.classList.add('bg-primary/80', 'hover:bg-primary');
                    }, 2000);
                }).catch(err => {
                    console.error('复制失败:', err);
                    this.innerHTML = '<i class="fa fa-exclamation-circle mr-1"></i>复制失败';
                    this.classList.remove('bg-primary/80', 'hover:bg-primary');
                    this.classList.add('bg-red-600');
                    
                    setTimeout(() => {
                        this.innerHTML = '<i class="fa fa-copy mr-1"></i>复制';
                        this.classList.remove('bg-red-600');
                        this.classList.add('bg-primary/80', 'hover:bg-primary');
                    }, 2000);
                });
            });
        });

        // 代码高亮初始化
        document.addEventListener('DOMContentLoaded', function() {
            Prism.highlightAll();
        });
    </script>
</body>
</html>
