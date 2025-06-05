FROM ubuntu:20.04
# 设置非交互式安装模式
ENV DEBIAN_FRONTEND=noninteractive
# 使用更可靠的镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/ports.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# 安装基础工具
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    wget \
    apt-transport-https \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装Web服务器
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装Node.js 22.x (LTS版本)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x |  bash - && \
    apt-get install -y nodejs && \
    npm config set registry https://registry.npmmirror.com && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装全局工具
RUN npm install -g nodemon pnpm

# 安装VNC相关组件
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    novnc \
    websockify \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    net-tools \
    lsof \
    procps \
    x11-utils \
    dbus-x11 \
    xvfb \
    x11vnc\
    x11-apps

# 安装Playwright
RUN  npx playwright install && \
    npx playwright install-deps; 

# 安装Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 创建日志目录
RUN mkdir -p /var/log/supervisor

# 设置VNC
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 777 /root/.vnc/passwd

# 创建启动脚本
RUN mkdir -p /scripts
COPY entrypoint.sh /scripts/
RUN chmod +x /scripts/entrypoint.sh

# 创建supervisor配置文件
COPY supervisord.conf /etc/supervisor/conf.d/

# 复制服务器文件
#COPY server  /server

# 设置工作目录
WORKDIR /server

# 复制package.json并安装依赖
COPY server/package.json /server/
RUN npm install

# 暴露VNC和NoVNC端口
EXPOSE 5901
EXPOSE 6080
EXPOSE 3000
